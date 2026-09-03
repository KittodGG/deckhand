# Humanize pass

Run this over the finished copy, before it goes into the HTML. It is a pass, not
a mood: read each line and check it against the list.

If the `humanizer` skill is installed in this session (Anthropic's
`anthropic-skills:humanizer`, from blader/humanizer), invoke it on the deck copy
and then apply the deck-specific rules below on top. If it is not installed, the
rules here stand on their own.

## Why this matters more on a slide

Slop in a paragraph is boring. Slop on a slide is projected at 3 metres wide
while twelve people read it in silence. Every empty phrase gets four seconds of
undivided attention.

## Cut on sight — English

Vocabulary: delve, leverage (as a verb), robust, seamless, comprehensive,
holistic, unlock, elevate, streamline, empower, harness, foster, navigate (as a
metaphor), landscape (as a metaphor), realm, tapestry, pivotal, crucial, vital,
game-changing, cutting-edge, state-of-the-art, best-in-class, testament to.

Openers: "In today's fast-paced world", "In the ever-evolving landscape of",
"It's important to note that", "It's worth mentioning", "Let's dive in", "At its
core", "Simply put".

Closers: "In conclusion", "To sum up", "Moving forward" (as filler), "The
possibilities are endless", "Watch this space".

Constructions:
- "Not just X, but Y" and "It's not about X, it's about Y". Say the thing.
- The rule of three when only two things are real. Three parallel items in a row
  is the strongest AI tell there is.
- "This isn't merely a [noun]. It's a [bigger noun]."
- Hedge stacks: "may potentially help to somewhat improve".
- Sentences that start with a participle to sound smooth: "Leveraging the new
  index, queries now..."
- Em dashes used as a rhythm crutch. Two per deck, hard limit. A comma, a full
  stop, or a rewrite beats a third one.
- Horizontal rules (`---`) as a decorative separator between every idea.

## Cut on sight — Indonesian

Vocabulary and phrases: "di era digital yang serba cepat ini", "seiring
berkembangnya teknologi", "sangat penting untuk", "tidak hanya X, tetapi juga
Y", "mari kita telusuri", "dengan demikian" as filler, "hal ini bertujuan
untuk", "merupakan sebuah terobosan", "solusi yang komprehensif", "pengalaman
yang seamless", "meningkatkan efisiensi secara signifikan" with no number
attached, "kesimpulannya" as a closing header.

Syntax tells: "yang mana" used as a relative pronoun, "dimana" used as "where"
in a non-place sentence, every sentence opening with "Dengan", stacked passives
("dilakukan pengembangan terhadap fitur yang telah dibangun").

Prefer the direct verb: "kami perbaiki" over "telah dilakukan perbaikan
terhadap".

## Rhythm

Uniform sentence length is the second-strongest tell. Real writing lurches: a
long sentence that carries a full thought and its qualification, then a short
one. Like that.

Same for paragraphs and for slides. If every slide has a title, a lead, and
exactly three bullets, the deck reads as generated no matter how good the
sentences are. Vary the shape instead: one slide a dense change list, another a
diagram with one caption, another two numbers and a sentence.

Vary the shape, not the substance. A slide that is one big sentence and nothing
else is a typographic exercise, so keep it to one per deck at most, and give
even that one a real fact to stand on. Everything else carries information
someone could repeat back afterwards.

## Specificity

Vague claims are what slop is made of. Every abstraction on a slide should be
replaceable with a fact from the repo.

| Slop | Real |
|---|---|
| significantly improved performance | 13.3s to 175ms on the knowledge query |
| enhanced the user experience | the form keeps your input when validation fails |
| various bug fixes | 6 fixes, 4 of them in the approval flow |
| streamlined the workflow | two approval steps merged into one screen |
| robust error handling | uploads that fail now retry twice, then surface the reason |

If you cannot find the fact, cut the claim. Do not soften it into something
vaguer.

## Voice

Write like a competent engineer briefing their manager, not like a product
launch. Confident, plain, occasionally dry. Contractions in English are fine.
An admission is fine. A joke is fine when it is actually funny and does not cost
clarity.

What that sounds like:

> The migration ran clean on staging. Production is still on the old schema
> because it needs a maintenance window, and nobody has picked a date.

What it does not sound like:

> We are excited to announce that our comprehensive migration strategy has been
> successfully validated in the staging environment, paving the way for a
> seamless production rollout.

## Final checklist

Before the copy goes in:

1. Any sentence that survives being deleted, delete.
2. Every number traceable to a commit, a diff, or a measurement.
3. No three-item parallel list unless there are genuinely three things.
4. At most two em dashes in the entire deck.
5. Slide lengths uneven on purpose.
6. Read the title slide and the closing slide out loud. If either sounds like a
   press release, rewrite it.
