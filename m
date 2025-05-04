Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04A2290F
	for <patches@lists.linux.dev>; Sun,  4 May 2025 18:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746383992; cv=none; b=Xjmgq2/7JzzrqK5pA8+IzlRE7nDQalP804cm7x96AuinWg1p3d/fiCtHxT9kbCCY3Hi3fUMzthke9nWLPJ59gr9kvEjAW+cw3LHjKoogtDF6lHf7UV8cIyO3exbeURCexB5qCbS7rSGgdHUPuH47uwXe6TBQ8W5T9v7YaVLq6yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746383992; c=relaxed/simple;
	bh=fSmJoF223a3Dtn5gS6dQbZAefH3Jw/yNUXcDpZtV9lg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YDRIwgN931u0foyk8h4GPNi6vq76IzM12Wo519b5wWqgolGx7il3at5Johx50WXfn2AogHHiMtrAiMa8qI6N/FWIjn+i0MjqIo0E+G382Zkxkz6SblyMiRzQ0KMHSj450pb6/rbxOXvyyhq4DmtDVxbvlrOJl3HfOqf7KgDqnHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LGfkgAVo; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LGfkgAVo"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-54d65cb6e8aso4776318e87.1
        for <patches@lists.linux.dev>; Sun, 04 May 2025 11:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746383988; x=1746988788; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSmJoF223a3Dtn5gS6dQbZAefH3Jw/yNUXcDpZtV9lg=;
        b=LGfkgAVoDDpqHEaw4qAleBaiuuY2HyTPpriUIvKoCEw+mKrAbB/g2i7VD5zBSvCrBX
         kOqk+b+hbDdAB6DkqZ2cOI/ZUFatdxvybOfgrZr5YTMdXINr2jdMZje+yzXWkCt/+pTi
         unYwtGb/gBCcKjObzL7kotTqbghhHU7ZjFIkT+qUrCj/khf8UelfMr7SsRgvBTeBM+l8
         6/QiX60T8UI/BdgrvDM5voIyYldnSQKmBOCbXVzuhbFZkiRQYGCAWDk/U6n0+n2NorEZ
         yGD/fkr8dqmjF2WnKrGNm8Ylp3cjfS5tSGt26fIYM6HcnTWPMn7eoOSvUP8DANiuOyme
         03Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746383988; x=1746988788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fSmJoF223a3Dtn5gS6dQbZAefH3Jw/yNUXcDpZtV9lg=;
        b=ZZFMUOSTm+OcaVpupUCDx3HrR1O8CDlgIHQ7/MGmJgs9pAePu2kt+4H8VrghvXPkG4
         eScNVW+EktbDqqv3NLlv+TBAw5pns7xqQASh8HHGSRlDXO3XfAp0p+YFv9mGR3he66Q4
         bxx/6ThdvsA/rnIetggQrux+Aa5gQ9q2lWdWodGItvbDespckKwz2fBOSbfi5/QcEv5R
         8zDkxIgpjWh+OK0SnDmKJ36vmBbJybiERPU18vcXwMSSu3xsJqQBqTF0JJkqoLSiiGQ4
         CeKs54+XVR0Gbj76WbPAXondvgukcCOi8Hneqaei92MY7htWDE1A86dMCODBcXayNoNU
         ynCw==
X-Forwarded-Encrypted: i=1; AJvYcCU0djUNUWyVfBqM/nKBafXypM+LVtIe/jfFuEd3AaHeik1dqR31jARGszS4qXQD8HWh8s138ycf@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2XzjAFbRVvSCV1UI5smcFMawu0Hp3RpCx/78hiZvPdAArAAyF
	ORMwlh1EgbKBpexam6Iz7O5kYMTNTy18edZT7nIJGM7+UHljM1FLLWN3hkXC5Ke3LtESodeTDte
	4hbeYEbrNdimWjCv8kvvfK3cvXLQ=
X-Gm-Gg: ASbGncveN3whEEtRk22sZKeiJFau6HRzJpP5+dZ8necVzlHez5AThEAWNIwwa34oakZ
	74nQgFg0do+TiJnuzsiadY2tpUMsZq4bTik0W4UY9QWKPp3LORYWDYpoS1wqiTYdBgzuI4/aSFR
	PwQNUonKZS36SjpY2Gv2ykBMHMbKlnp9OMQ1cRCQjp4CzvENikBU/spso=
X-Google-Smtp-Source: AGHT+IF4M252xpX64YiVVcGHS9b+FT406Ul4BsQtwfMEvjsaMrNFKI3eMF3kQqHHsd1qjhEeBhwQr83pT5kbhQTpBlg=
X-Received: by 2002:a2e:be29:0:b0:30b:d4a9:947c with SMTP id
 38308e7fff4ca-321db78d465mr15329091fa.24.1746383988320; Sun, 04 May 2025
 11:39:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-5-ojeda@kernel.org>
 <CAJ-ks9k=uxxumgEU84-54u8OxxJVBsUprGk7Ht31ndoumHB95w@mail.gmail.com> <CANiq72=Q_Vbfh6YhDsNeCBDPZ-q1d2HNfaTj4azAsd2Q-zPfEw@mail.gmail.com>
In-Reply-To: <CANiq72=Q_Vbfh6YhDsNeCBDPZ-q1d2HNfaTj4azAsd2Q-zPfEw@mail.gmail.com>
From: Tamir Duberstein <tamird@gmail.com>
Date: Sun, 4 May 2025 14:39:12 -0400
X-Gm-Features: ATxdqUFE1jEFBjmHs0_RQkTHweg7qOHsrW6y-33PA37grM4akOLYLMlMBtRrJbo
Message-ID: <CAJ-ks9mAgR3N+cxL6H5XhAN-iWM=T66vuWr=LEozj8bqofBf6g@mail.gmail.com>
Subject: Re: [PATCH 4/7] rust: str: convert `rusttest` tests into KUnit
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 4, 2025 at 2:31=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sun, May 4, 2025 at 7:31=E2=80=AFPM Tamir Duberstein <tamird@gmail.com=
> wrote:
> >
> > Is that true? The build host is often easier to work with. There's a
> > number of host tests on the C side that exist precisely for this
> > reason.
>
> Even for tests that could run in the host (pure functions), if you
> test in the host, then you are not testing the actual kernel code, in
> the sense of same compile flags, target, etc.
>
> Moreover, you have UML, which gives you access to other APIs.
>
> As for "easier to work with", I am not sure what you mean -- KUnit
> does not really require anything special w.r.t. building the kernel
> normally. In a way, these restricted host tests actually are an extra
> hassle, in that you have to deal with yet another test environment and
> special restrictions.

All good points.

> But which host tests are you referring to?

One example is https://github.com/torvalds/linux/blob/59c9ab3e8cc7f56cd6560=
8f6e938b5ae96eb9cd2/tools/testing/radix-tree/xarray.c.

It might be that these are necessary because the xarray tests don't
use kunit, and so are pretty inconvenient to run. As you might have
guessed, I discovered these host tests when my patch porting the
xarray tests to kunit broke the host-side build :(
