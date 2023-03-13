import 'package:capitals_quiz/models.dart';
import 'package:flutter/material.dart';

class Headers extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const Headers({
    Key? key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final subtitle = this.subtitle;
    return Column(
      children: [
        if (title != null)
          Text(
            title,
            style: Theme.of(context).textTheme.headline4,
          ),
        if (subtitle != null)
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyText2,
          ),
      ],
    );
  }
}

class Controls extends StatelessWidget {
  final ValueChanged? onAnswer;

  const Controls({
    Key? key,
    this.onAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkResponse(
          onTap: () => onAnswer!.call(true),
          child: Text(
            'False',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        InkResponse(
          onTap: () => onAnswer?.call(false),
          child: Text(
            'True',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ],
    );
  }
}

class CapitalCard extends StatelessWidget {
  final GameItem item;
  const CapitalCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Image(
      frameBuilder: (context, widget, _, __) {
        return Stack(
          children: [
            Positioned.fill(
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: widget,
                ),
              ),
            ),
          ],
        );
      },
      image: item.image,
      fit: BoxFit.cover,
    );
  }
}
