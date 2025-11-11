Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B418F326923
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 21:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762894961; cv=none; b=SqZFmEpJU1egALxpsSoAQbvBEgWdaUWjtX7aP/bd7oIn4Pcj9MLc4A1CnpZGOcEJci5e2dq5mgTa7J4M82w+LH02nDl0vEIA3/oFgViB3vyTY8+yIAFuzOpPwREwN8Ksz+yPlosuDGWM06L0CYgDDEJyFpIJaE39ohFTOqHMBJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762894961; c=relaxed/simple;
	bh=oON1JhPqjwjhg7G9S0lDlzyPRkRNc3w2DTMTGVj9WQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JmTVOV+GXVc9ii3zjqTcAsXhYptAHxNAxTAeEs52t1gYrH0k0alJTxbFsZCSQo2GI46du1ZIKA/vrNGA/SBYvWKlNtmwdPGAT01bYklt3Jvm8Gpt02FKTH6VieMs55njyTt9JSMLOzFDxMcZmd3T8qjAt9838Dw/7xaaS86Ave4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E4+AY01k; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E4+AY01k"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7a271fc7e6bso17295b3a.2
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 13:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762894959; x=1763499759; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QwP6Mm7gy1ZK8oeG4x4mgYN5Qt7fbG4Gah1TecksR98=;
        b=E4+AY01kExIjtk3NvBIvgOaKjIUKM8PDncYwowv5kWctc/6P8gN+0NnjrdBnK5DcId
         WLLgfpajpKOj2Zcpz7a27gu+3j7omds8za0A5pERVJVjsVIVPMD8rK31sQ0i1Dksni3F
         8oh7gTOSnmSp3wMU8s24v1JMIQJbUuu0Rc8Hyx0Z5XAlfmA6XGrYY5vkardMymLKCt22
         yH3S8SR135PbMAK0in4clWn9/S3g+/lhrEpaxvVw9vHWizCrekdpJ0lk9zmSSJ0mMpO8
         RUFe+s6VDycI5do/PCOD2xePP33XyjWnsF8O59hSL2Zn23ubM/XlifjhsJyOTaEg7a3C
         HezQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762894959; x=1763499759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QwP6Mm7gy1ZK8oeG4x4mgYN5Qt7fbG4Gah1TecksR98=;
        b=e3+c/Q5NIaMQYqyUWb708Ay5cpE8Okl0Q0r4CV4ha0K7Cn/d7uK4hrShlYJ0ILYXLz
         fLd4AUzzC7bqU25TecBRWr2G+XEJRRLQKC4KLhs9OhZ2bsuKo1Z00NUuE4u+oKGs/H6k
         AzHoTgyohvVcLsp25zZqzJbeCMe0iUmqXVHhhqZvRrNkn+8HLQcilYSmiW9ZUNTs+Adn
         +TOkjT3nzb4rmhMlaMn33xeLfbFhd1X9Zf0UYGXrksjAW7qz++YOgSEG710xg9q7hwgY
         MA3ecVZoCYiAiPB9H5h2KXo+MRFzii4jrkVoUYNR53Fjh71hkw9hPAB7bz2MbtrJEbUC
         wiqg==
X-Forwarded-Encrypted: i=1; AJvYcCWN58FayrLGkNFjcEKHtm6PC98LRMQt2A682QoRwbcs2/s+gpmLLu1/AkqSlbyZMztbJTusnO0e@lists.linux.dev
X-Gm-Message-State: AOJu0YwUfSpmIbjlbOd8shgG8s1qCKD4Nx+6sMeZAojQ2Jnmm97dyMAW
	vGmEBQbmOESdTIAOB5iJHYzmVAyMi5pLJmBPcza1rOTNBuhJoeYBEm7f96+t4xuqFmxrGNl08O4
	O2+OHrhOX2PapWYt6szRCmsmL6GjxFNanjuXzaJ8=
X-Gm-Gg: ASbGncutbja7V4nu5fFfdU2+aj93MhW5a72pIzVry/jvWVVGzaBklX4bpxCgXiN82r6
	F1mBSCw1yL2ycxdvwUgqypAmj6f5aa5KD9nh44IK1mnlUVxOWrilxz3LMSjuR1kNiIAxHF92Wgy
	6cnhyn18yTkNRDOcqfeyfZwm57VZIxgWW7m4Q+ht2ZxGH+2lymri8HuaW3s4gZgeIJf58XtrI7N
	YN+s96foHIPPT2thkTS+Hr2Z+30S1pQwc9nyjDQS0fHxepIcE5iV4kGUHKFlFWU96kRZXrL3Xfr
	1ICqiFbyrO8O8r+ZS12W1PA/FVGJxVlVQ0LyJ3jBv+uXTsva88P3Yt0Z4ATFQLtrKvU/TFy1k8U
	SWtk=
X-Google-Smtp-Source: AGHT+IFsOytGgnt1U92UtoUky/1wulIEh+Pmaa8W6gEGOIHALbiKUTckaUZPy8kghTMbfkFxlO7xNvj5AdbhpE8EjaQ=
X-Received: by 2002:a17:902:f551:b0:297:d825:bf22 with SMTP id
 d9443c01a7336-2984eda386emr4468665ad.5.1762894958907; Tue, 11 Nov 2025
 13:02:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110122223.1677654-1-ojeda@kernel.org> <20251110122223.1677654-2-ojeda@kernel.org>
 <20251111.083413.2270464617525340597.fujita.tomonori@gmail.com>
In-Reply-To: <20251111.083413.2270464617525340597.fujita.tomonori@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 11 Nov 2025 22:02:26 +0100
X-Gm-Features: AWmQ_bm-YuisXj51ok0HAEEwIhVZdnLtQdiqb_sOWGEJwZXB-OjiypMxPqOmm74
Message-ID: <CANiq72=_KAgUZ9u5YY-iw7kyA9R1Nv6eNzZqMLSwOLQk6sR7kw@mail.gmail.com>
Subject: Re: [PATCH 2/3] rust: net: phy: make example buildable
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: ojeda@kernel.org, alex.gaynor@gmail.com, tmgross@umich.edu, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, boqun.feng@gmail.com, 
	gary@garyguo.net, bjorn3_gh@protonmail.com, lossin@kernel.org, 
	a.hindborg@kernel.org, aliceryhl@google.com, dakr@kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Guillaume Gomez <guillaume1.gomez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 12:34=E2=80=AFAM FUJITA Tomonori
<fujita.tomonori@gmail.com> wrote:
>
> I think that some code begin lines with # for use lines in a "#
> Examples" section, while others do not. Which style is recommended?

There is no hard rule for all cases -- we typically hide things that
are not important for the example (e.g. fake `mod bindings` that are
used to support the example but aren't important and would bloat the
example or confuse the reader).

For imports, some people prefer to see them, others don't. Here, for
instance, it may be interesting to show the paths (e.g. that the
`Device` is a `net::phy::` one, or where `C22` is coming from), so we
could unhide it. So up to you!

So I think the rule is really: if it is something that we think people
should see to actually understand the example, then we should show it.

And if it is something that would confuse them more than help, or that
generally should not be used in real code (like the fake bindings),
then we should hide it.

Ideally `rustdoc` could perhaps support showing the hidden parts with
the click of a button or similar -- there was e.g.:

    https://github.com/rust-lang/rust/pull/86892

On the other hand, there is already a "Source" button nearby that one
can click to see it, so it is not too bad. But, yeah, if they need to
do that, it is likely it shouldn't have been hidden to begin with.

Cheers,
Miguel
