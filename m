Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CB5308F32
	for <patches@lists.linux.dev>; Tue,  6 Jan 2026 09:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767692786; cv=none; b=AW4Xjw1O+KZG3gyVml1nTj/xspO1bs/7sSk/VnoQZHWXsNbJk0ljJKaYQBx1+0qc1ec0QrJkP3fiDOX8+4/xYsPf9DvHKpicPs0hev4Cj0LJEczWsXHL2e7Bdq4Pg+1pWu0Yo3Vqyu2AAEWYO3sDf4GccU/ckiWjRPBTl8XSCJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767692786; c=relaxed/simple;
	bh=a4pCkGrO8NHaFUsy0JV7PE7ELAOTbmXkWYg7O8l4NKc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BtYmmgebo+DPaoasxS90/CPWPtEcr7X4k2KDOYFCZwQrdWDUKBLHiyecTYaHXIs1t+43OF21jRVHswP8A884pmItnqnjvkiwmHlq/chXMjxUt/Lw58Gl9rFaS1rQf99fFX8dmAgiwh7sTvf/igiccRA49pNZZMXu7nAK3MZq4wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GzQBG29b; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GzQBG29b"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a08ced9a36so1452135ad.2
        for <patches@lists.linux.dev>; Tue, 06 Jan 2026 01:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767692784; x=1768297584; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IWHtzRLOB0gsaHyHpcyCg2Z+qiKJnnvo9pUwckRF/cQ=;
        b=GzQBG29btwO1LCzAc6dBgM0bs1WK5xFYnWJDFz7x+cdYcu0kHQHaWT8KTUJJl4ROjm
         43N34UcSDZsrOpI8etvUnYbwxOk21XdvoPt+Crc49aiWq2ErfIZMI5AajDmHqWbIKDYM
         jwqsmPyY9xQUlyCtOFiI+MQtaGs2Yo5eQgFLlqys17bQEPINuJ3QtIC9hTBHmQoiXmsS
         SlRpFJMgrCci0LlR/Qe6nNKcAEbDlgMedC84A8wtbfvPmJDb4gnFWWT5Xby3wbhe0VY5
         tgdDovIkSzyOoq/QnI3x4f96IOkp7q/zgSUj6yON5GuM5d9Zjv1a2YBCM8OihtSvInwJ
         1ZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767692784; x=1768297584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IWHtzRLOB0gsaHyHpcyCg2Z+qiKJnnvo9pUwckRF/cQ=;
        b=UMp6KD6xo4f0mK5GsNoSdSTqwt8ylHmqH1DYmXwDzJnRtpgpr229P0oRyLjNFu3kE0
         2W0X4Lu/DaK67eXiFt5ASxAlDvta49fc8yJqEkDXIr1q8aELzD0wxuR+viSPWU8gbmX5
         hXqTIpWpkLgxa47k6wBeNxDtQdgxy36hbEw1dzgXtfryvxCJ3F8dCx9yJsg6zKmoLfZo
         AvBr7gQe4n2Qr69TPKkRhUEuYTZDwKdHT6qHCDh/gw6e31IHlhIbjLmxTQZCl9HmLhVH
         HblgY4eZtwbh0gwnxP+tepywbTexkZYoLZOSU20vxcYHdX/XW3X++HMXb7guh3QgVygI
         LYgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl4YZO8jwku0ZwEyTOEWz7D0DR9RWQjr01CQEooXklU+BEtsoB8wp1mOi+D/QSb4MeM8FmLm8G@lists.linux.dev
X-Gm-Message-State: AOJu0YyP+BZzy2kBlAp0AavaVfsarb939GwBU8IsAVs82eeUPl4D1IHb
	7M5x2x2ePPtDzNA/aJ23y8ymBhvVTLEhaFLx8RQRllLUDfWGN/E5+3k2YM64nf6sUNCAfjHSiK6
	+Lsnd8pQp8p7p89iMveANLAHoRYHrEkI=
X-Gm-Gg: AY/fxX76ZN9GbxjHmsyAm4F9cz5FKnvNeAm5Chb9lrOi5/JnOJRmqmkuKisx+NF90jz
	Jx24L46NjvFDOlES3vTSLgLL5AXOFP+IiB3HHzy7X4tsLAl8XRQz2FBTmEwhSCSezpxRWJPMEEB
	xNe6zRRyuU5dAFBORZEhCAu/9nOipiGJcE64PLdnmPBTaON1Ya2aHIQnVCLEZkyKheObWpM7LMl
	tXJcQpsqJRQ8YAfwMdt9k+h5TTGKDYnFrBkUC1q1vc7wHEFxivVEpUVueoQ5H43UkVLFFWJD61O
	0tlkjqfkWT07OZMfevm8p4btKQknB+bwRHF/SPoxJFjTXIZZOREPF2Bq9g0qTyW3pnuNB1NJxw3
	J8nSCJ1OIuw4JqIpFWcYgFa4=
X-Google-Smtp-Source: AGHT+IGZErVvI2lseGufu+xoWWNjTS0IFbizNSmxMqu9oLAFKR3RnErmOEmLfl72C07T7Y1HDw+wgqib0Cgql4LAiO8=
X-Received: by 2002:a05:7301:168d:b0:2ae:5a24:249 with SMTP id
 5a478bee46e88-2b16f6f82c7mr1043614eec.0.1767692783667; Tue, 06 Jan 2026
 01:46:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251201000949.1626363-1-ojeda@kernel.org> <aS3seTNRum3ZXMom@yury>
 <CANiq72=1ipov2pV9pSQwGh9WMA4NvQRV_cBCO0hhChVg=c-Njw@mail.gmail.com>
 <aS7aHIJbi3DlaUcc@google.com> <aS8w4FHhIVQUFTEY@yury>
In-Reply-To: <aS8w4FHhIVQUFTEY@yury>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 6 Jan 2026 10:46:11 +0100
X-Gm-Features: AQt7F2psBYaPyhcfhcRa6tt3cVf1oYBAyJ1lA0eLnUOSmBK-lRIafwteRgzLfLI
Message-ID: <CANiq72m9fQ=W4yjrAQWE5j+eBpPY7xetPjsHRdXfjYmmohj8FQ@mail.gmail.com>
Subject: Re: [PATCH] rust: id_pool: fix example
To: Yury Norov <yury.norov@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, Burak Emir <bqe@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 7:33=E2=80=AFPM Yury Norov <yury.norov@gmail.com> wr=
ote:
>
> No. Maintainers are not handy testers at your convenience.

It definitely is your responsibility to test your tree. This is basic stuff=
.

And I am not sure what you are trying to imply here with your words in
your reply, but I personally find your message and its tone borderline
unacceptable. I was actually trying to help you, so it is doubly
annoying to get such a reply, to be honest.

I will reply to a few things below to keep the record straight now
that LPC is over and I had the chance to talk about this to a few
people.

> Don't be sorry, it's not your fault. The problem is that bearing
> tests smeared among comments is a terrible idea, and now you reap
> the benefits of someone else's bad design.
>
> (Did I warn about it? Yes I did.)

They are not comments: they are _documentation_, which is different,
not just conceptually, but also technically. From that idea, the rest
follows quite easily.

They are also not tests in the sense of "we write tests like this" --
they are primarily *examples*,  which are a fundamental part of the
documentation. They are not supposed to replace tests.

And it is important to understand that those examples would be there
*anyway* whether we compiled them or not. The fact that we actually
can not just build but runtime test them within KUnit is a very good
thing, because it ensures that the examples that developers wrote are
actually true *and remain true* even across refactoring/time.

That is, the examples will always reflect the reality of the API, the
asserts will always represent the true return values of the API, there
will be no typos of all kinds when typing the examples, and so on and
so forth.

Regardless of all that, other (non-Rust) maintainers do want to have doctes=
ts.

So, no, doctests are staying, and we are writing more of them, not
less. In fact, new APIs should come with examples unless there is a
good reason not to.

> The other problem is that Miguel replied in great details about how
> well rust process is designed,

The point was not to tell you about how "well designed" anything is
"in great detail", and I am not sure if you are sarcastically saying
this.

I simply gave you a link to our docs and suggested you could have a
similar field in the `MAINTAINERS` file, because in my experience
(which you can easily check in the mailing list) people actually do
write and test doctests.

As I said, I was just trying to help.

> and even attached an external link,
> but didn't answer my question: how to enable rustdoc by default?

I *did* answer your question, and pretty directly:

  1) I explained it was not a `rustdoc` target issue.

  2) I explained the Kconfig should not be enabled by default.

Now, it is clear that you are still quite confused about what failed
and that you didn't take the time to read into the link I provided, or
the docs, or the Kconfig option I mentioned.

So from your point of view, since you thought this was a different
topic, I guess you could have thought "Miguel is talking to me about
unrelated things". That is fine, but you can always say it politely,
and I would have tried to clear the confusion again.

> I followed this link by the way. It doesn't mention that rustdoc step
> is mandatory. It doesn't provide steps for careful testing.

It does (both) and I quote:

    When submitting changes to tests, including #[test]s, Kselftests
and examples inside Rust code documentation (i.e. "doctests", which
are transformed into KUnit tests), please test them.

You are just confusing the issue. This is about *testing*, not about
`rustdoc`, as I already explained in my previous message, so you read
the wrong bullet point.

It even clarifies what doctests are and even links to the "Testing" in
the kernel tree which is a page dedicated to explain this.

Even if you missed that, I even explicitly told you in my previous
message the Kconfig option you had to enable.

Even if the docs were wrong or may be improved, your message is just
not a productive way to engage.

> Does it sound like:
>
>         Rustdoc is a MANDATORY step! You MUST run rustdoc every single
>         time, otherwise the build will get BROKEN. Even if you don't
>         touch comments!

Yes, it does very explicitly explain the mandatory steps. No, they are
not comments. No, this is not about the `rustdoc` target. See above
for the quotes.

> No, it does not. So, I wasted an hour just to find nothing. But there

Yes, it does. And you didn't have to "find" anything. I *explicitly
told you* the Kconfig you needed in my previous message.

> It's good that I started receiving such a traffic at all. But it's
> especially good because I was on my way to submit a PR to Linus, and
> that hour saved me a broken request. Andrew Morton on the previous
> cycle wasn't that lucky, didn't he?

What do you mean? Where do you want to go with this? Please speak
clearly here -- veiled comments aren't useful nor polite.

> 2. I will stop taking any rust patches unless the author explicitly
>    mentions that he ran rustdoc on them.

Submitters are definitely supposed to test their code, just like for
any other code. And as a maintainer you are the one that decides what
is "good enough" etc.

But everyone misses things from time to time, sometimes authors are
newcomers, sometimes they may not have their full testing setup
nearby, etc., so you as a maintainer still need to test it anyway.

That is the point -- both submitters and maintainers are supposed to
work in tandem and double-check the other side, since anyone can miss
things.

To me, it sounds like just because you don't like doctests, you are
going to ask *everyone else* to do the testing for you, which
personally doesn't sound acceptable to me, to be honest.

I also find it a bit amusing, because you told me "Maintainers are not
handy testers at your convenience": To me, it sounds like *you* are
the one asking others to test your branch for you.

> 3. I encourage rust community to spend this cycle on reviewing the
>    development and submitting process. You guys decided to sprinkle
>    compilable code across the comments, and you advocate it. Now
>    please find a way for everyone to compile your comments (huh)
>    during a routine development. And please make that knowledge
>    very sound.

No. You don't get to blame others here. I am always happy to "review
the process" to improve it, but this issue has nothing to do with
that.

The process is quite clear, has been documented/followed/discussed for
a long time, and other subsystems and maintainers take advantage of
the feature and use it extensively.

It is obviously fine to not know about something (nobody can read
everything), but that doesn't mean you get to pass the buck and to
change how it all works just because you don't like doctests unless
you convince everyone using the feature that they shouldn't use it
anymore.

And it seems you also ignored from my message why the doctests are not
built in every config (which is very much done on purpose), and
instead keep pushing for it, which is not useful and is not going to
go anywhere.

Cheers,
Miguel
