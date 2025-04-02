Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9213F13AA20
	for <patches@lists.linux.dev>; Wed,  2 Apr 2025 16:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743612108; cv=none; b=mxeVS1S3BnzQOSfirVQqZGZq5W2WCb+ffhbF7jKrQdgIBjvj627W1vtvSslXcshzfDeSWYl0QGvztcJdLmrvRO9sd3h3GP6mT/gPIP75Nn2AVgBYFBE88qv6yIB4VjHRxR0tT25967Nk/mN57U7/4lJK6uTu5hhAnKyZFOhjDbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743612108; c=relaxed/simple;
	bh=iSZjFV4FMkeVCtteZT6YTkC//p4kPDrkkcJ34PwkHrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ST1VgqEtB9cLYyVqrYLDAn3SGiVxCxZ0cQJMvZJTYkmprYffnfc79B8/EB+c7P9Azt7zHaaPBO9mmdOtG48n4pgRlSxDXFrQhm+FR4NC1n55aHGbc+/dTUZLlOkwYUm0qIjYPTiZ1hGEixmmLEBoDOpFslLU5YiEBE2esVacvIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f6LXMkAo; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6LXMkAo"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-549967c72bcso16721e87.3
        for <patches@lists.linux.dev>; Wed, 02 Apr 2025 09:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743612103; x=1744216903; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iSZjFV4FMkeVCtteZT6YTkC//p4kPDrkkcJ34PwkHrM=;
        b=f6LXMkAorgiMYx92qJuFX2GFEKlL7Iks6E/F9SL8ZibtGihQyarRmYHtm9zTenYqLI
         jwV2IinHMZiNVZuXUK1u5FDeXsAB3iM/DdXAgtUAFMQDzUj/63g+p4Afylli4ZRAmpzs
         tuPBXDxlrjTxERQ5X8lxfpdJPguwU6/WYvN/L4ke8rzYlFwxgeL4MmlfU3k6u2mPPP9/
         WpNlE6Ur/6/M7TksaDvxv0+BFjRsjpniOCyKsmmGOCJHke6rOxQHdNyyPWo+lD48WTUH
         jLx7zwdj3lu1jQrgi/G8zeIUoKtVtfmoG5YnNKM0ObP0re4Fj9z4HAWJhcCBipYNvguh
         gOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743612103; x=1744216903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iSZjFV4FMkeVCtteZT6YTkC//p4kPDrkkcJ34PwkHrM=;
        b=ZsdVRRGUJDN4c4dM8oXKEfYm588Ul3Pxf5ntXhPNMekjT+H4NGoJy7eWkDEd9so8g8
         VaK31+V3rNzYqS8bdz4j9p/kifmmB6R+0mNqiGUyjzbICKMRdD1i0zb4RbS6qENGy1CO
         02fvd5V3tuvXijWEbwQFWz/Wf/lOt3vQSMZjhm66p91qhAFuh+7gnaAEwSzIwW9AFgGl
         ClQWnJTF1FRDQCjCdU8ZdiuT8pfLDcq68pwnmFy8T2Nl1L6dJ1qBSrzoU7S5/bHmplCc
         oqvZTR7Fb6lkeXwpPbyLU+2YC46ii6eZDoFZ/ikKqwpbBTOrW8bH00Tnln0vQgscVHjn
         7e6w==
X-Forwarded-Encrypted: i=1; AJvYcCUSdT4UEmC5PvsEoZgwVgcg/bC12flmdetSmi6O5RFAFvgXYL97kvKjY5WhkxkIbqJOrTWoj97X@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4ycN12UYJV/pe7r8T+oWwzh5ipTg08CtoCt+xexoa0aaeZnLs
	Sh/Ug0PxbGDQ+gL0X7l6MI3CWUTHUtfjemhkWXRyDgjCaD6YZn83I4viR/msQGeLYQOPbZGQiIM
	sqNA/KK+3VwMopJ8ctUaR0NImI9s=
X-Gm-Gg: ASbGnctmHdhvQ32IU2rPcr7VYrKvHNacaeBgGSJdLT0xIcG67puovVu31TkwEvddLBe
	LIT7rQtZmMRdKBYiyKCFadY3pfL4+B/3AcXXs0KYAN1AY+3YKxFAdz9VaDVZrKyrK8kFQua2LVB
	0RRNZbb9ZrnTgzLqXDHC2J8ZLoSNuKNpTszcFAGZSDAA==
X-Google-Smtp-Source: AGHT+IE8elyosTdcge4gKh9yer1gFMOPkHrLQdRFSkE8Vt/zBXv7geZvsuea4+ZxrXW5DeT89Anmh1JfpH4cJv9vJiA=
X-Received: by 2002:a05:6512:1597:b0:54b:e9b:db23 with SMTP id
 2adb3069b0e04-54b1110d348mr4845013e87.37.1743612103286; Wed, 02 Apr 2025
 09:41:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250401221205.52381-1-ojeda@kernel.org> <D8VPGBN60E61.1Z48FQW6TL3A@proton.me>
 <CANiq72mdvnHvWbVNQbiXSRxd1xrF+A=v0RdJO74xeY3HyhRmcg@mail.gmail.com>
 <CAJ-ks9nAAcoJoFF+qNPbhsM32kOh9u+LGYUwFN_n9qqudB6YhA@mail.gmail.com> <CANiq72k36Tvwbzkg6nRdxB8VNRHLf8QzLeCXZq7sEPewccsWNw@mail.gmail.com>
In-Reply-To: <CANiq72k36Tvwbzkg6nRdxB8VNRHLf8QzLeCXZq7sEPewccsWNw@mail.gmail.com>
From: Tamir Duberstein <tamird@gmail.com>
Date: Wed, 2 Apr 2025 12:41:06 -0400
X-Gm-Features: AQ5f1JpBg-RQ9FN1Bi9_jh02mPTTG_EQqJu7_lcW5lhfKYW7j632XCXjTVZcM4Q
Message-ID: <CAJ-ks9nfEg=sdn_-q+xOc+k9mU0pdMuumwRb76LXzE3RcOtg6w@mail.gmail.com>
Subject: Re: [PATCH] rust: clean Rust 1.86.0 new `clippy::needless_continue` cases
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Benno Lossin <benno.lossin@proton.me>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 11:27=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Wed, Apr 2, 2025 at 3:59=E2=80=AFPM Tamir Duberstein <tamird@gmail.com=
> wrote:
> >
> > Rather than disabling globally, why not `#[expect]` these instances
> > with a reason?
>
> That is an option sometimes, yeah, but in this case, writing those
> lines is also a burden -- one that is, I would say, worse than just
> using `()`.
>
> It would also need to be `allow` here, not `expect`, because older
> versions do not complain, which makes it even worse...

=F0=9F=91=8D

> So it is all about what a lint gives us in exchange of those false
> positives, and about how much time people would need to spend on it. I
> have always supported adding lints (I think I added this one, long
> ago, in fact), but I don't want that we overdo it either, so I am
> happy disabling it if it is going to be too painful.

The counterfactual is hard to prove - you don't know what true
positives the lint would catch. In my opinion disabling lints is
risking throwing the baby out with the bathwater.
