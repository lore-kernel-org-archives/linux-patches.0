Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F057335580F
	for <patches@lists.linux.dev>; Tue, 21 Oct 2025 17:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761067527; cv=none; b=OMAXCjXZRiSjRGEtMBEgIS2flx0hV/dNn2wu/lBGEUpiA0SBh3piM8BbezI39X2LVPiJjO+dVBZfZOJXSJ3NVS7PyY4oaMG6rzNNGGF+XLeBKLz/LUjymHgPgsNbv/PRj0MSVHrAqQISNBmQFZ2AecuC+H/fdcKjIItW3Dohd9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761067527; c=relaxed/simple;
	bh=Ibl9ipy62JVcPBrthO993ocd5vWDT0JLzxK8s7HQuv4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rjKtWy5L5kQG8W80an3DKDOuEeLf9wwHRnusa5e7fLDR5P6hJa3pe/ZtNXtmYRaWTi+WCyT8m+zGM4P5Vtg6acQpjfKrsmJC56GjvAX36yvMCpsOcywkWz3IihpNcUJ4m/v1ignLOY2DlZIRHfG6URdDfrPoukMt0k6f7WAAxgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OLi/o2rA; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OLi/o2rA"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-28d18e933a9so9363635ad.3
        for <patches@lists.linux.dev>; Tue, 21 Oct 2025 10:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761067524; x=1761672324; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RAf3KsXjFc/zQP1AJm1wtfxbLUgTjyr2ky6pgjmz4cM=;
        b=OLi/o2rAXHB4Sbt/ZLkh9TCSIClRIoqlSGL0sSI2wHbfZPzID0ou3JvNg78cd8k3tL
         BRzhztzdAWmACoWtsMY7C/QgkOi6eggYUBAGgTwg2jcJiqRIT7IfsTh96g3PR4iyueUp
         Hjg1+xIgI10FRIP/P3CN2yo5Wyvwyk3F2zLc7xfBs52MzzLzYw2vtUJ6ekWqnFOWUowg
         fyakeK6y8s7+FNm4E7LcW9aOSfQJifxjaauP761nXlgNq+TSrB+cktsYigKwMqmWBJGZ
         r1X5BWC9lEZw3egTa28Ef9YUlsgCIFdpHtPWtsFn50YtoZQwltEAGsrREp7z19Dx/xY9
         9aCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761067524; x=1761672324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RAf3KsXjFc/zQP1AJm1wtfxbLUgTjyr2ky6pgjmz4cM=;
        b=a9bPIH7XIJMcr4oeDjctigsXqfJgJMpkK3/7dci8xaQkghTW88NKsNNVx8wrCkewFi
         hXGIv6crqULlw6ZtV3+N85GH6W6OL1h3wDKJV5Kc5g00iKBISsqmr2b0apZ8ubw8cSc0
         uDGyn1hqgoJCpheb98BrUV0aYTI0ZFdK6ixokhEGn7ePPlbbi838CLrfYOOK/z8qkF+W
         HUZaqki95QVMDyMBboLwEmfDaft6H3SZtRbqgPmmDXfVQ3n/vUlSiiWFRjMS2BuT31Xv
         UNVtavi0pWI8Crr3DTrj3hDvWrJjIaTFmnlUBDJzN2NWG6P+/lDd0d0XWiOrwzRPPHrN
         7LFw==
X-Forwarded-Encrypted: i=1; AJvYcCUcPdkH7S6Jj9TJ5UbOPkJiZi7H3eOWr+D/VZhtnBwtpAAWcVjGziUmAy77kVTWDgUHPkvOVHVS@lists.linux.dev
X-Gm-Message-State: AOJu0YxW5vxQuzMlxDgZMCBcygMk/8q8O3Mtt0UmTFLt6KVVSaWGWjs9
	bngO9Pi9CHn+BBJC2dfzfxyzwiT6u1ZWMrdPLAmD8+v/nMLXJ/wNa/e+4n5EVGXHpub1ecPdMmm
	hujBouDCoid5EhHL2gDQGOVOidXq45hw=
X-Gm-Gg: ASbGnct2HgUsDiVJSu7bmuiwxPuOkLRVzSwgh6AVg9gy/IrBF5VRLQPQ4SW2uaRMZIA
	4gT6M1WS0VgwJelkZDSlu1led5F6j3Les5RM59E4YOjTUCuExrHZXp2B3AqITytJKubLf9EoKwc
	+E2HGhhhV7aQbIkNNdTvv1ePf6kcldHRjlR63HVU8sGWDSKHsnlHbAGYaBXYU/VujYf1hnvgYAo
	KkUCQSjDrE8iwC1FAgC94RbRjNMPVtQOX8rMTB3G/paPg6Z1qdLfADuvRFC8bzdmV8CgceQgITl
	ICRdhrosaN4PPyu2qdVseyoDFY3vPPQfsxFCpnEs/D7kvhFTbwFjl7C2URgF3qQ+DSwvzIXoc2P
	Yvn8B+5DEqS8cmQ==
X-Google-Smtp-Source: AGHT+IEWfCg0E0bwVttDNG0lql3yRpvV7id4seM/oa5UH+1sTXW5x3SO7M6tk+NNwv6wlch2bqa+yfg2OXtAPVMMHAk=
X-Received: by 2002:a17:902:dace:b0:267:bd8d:1b6 with SMTP id
 d9443c01a7336-292d3fbc72cmr30865725ad.6.1761067523987; Tue, 21 Oct 2025
 10:25:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251020020714.2511718-1-ojeda@kernel.org> <20251020105154.GR3419281@noisy.programming.kicks-ass.net>
In-Reply-To: <20251020105154.GR3419281@noisy.programming.kicks-ass.net>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 21 Oct 2025 19:25:11 +0200
X-Gm-Features: AS18NWCYSZSyVH4h_NBns8SoCWBqHms6Y7SdEmcHUYKM5xtVUbbF7ERZLvXjKs4
Message-ID: <CANiq72n_AnCJYw6R2XecapW9wZqs_Saa4t8BNgrPub2u9=9_xA@mail.gmail.com>
Subject: Re: [PATCH] objtool/rust: add one more `noreturn` Rust function
To: Peter Zijlstra <peterz@infradead.org>, Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 7:19=E2=80=AFPM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> I'll go stick it in tip/objtool/core; but I gotta ask, where are we with
> the toolchain support for noreturn?

Thanks Peter!

We discussed it with upstream Rust, and they understood the need, so
we may get something like `--emit=3Dnoreturn` or similar, but it is
still open (and not too high in the priority list since we can survive
with this for now and we have other things that we really need them to
get stabilized etc. But if you feel it should be prioritized more,
please let me know).

I have the status under "Export (somehow) a list of all noreturn symbols." =
at:

    https://github.com/Rust-for-Linux/linux/issues/355

In particular, Gary proposed an alternative during those discussions:

    "Gary proposed reading DWARF instead and wrote a quick Rust script
for it via object and gimli, though DWARF would need to be available
or generated on the fly just for that (and we cannot commit a fixed
list since the kernel config may change and we support several Rust
versions and so on):
https://gist.github.com/nbdd0121/449692570622c2f46a29ad9f47c3379a."

Cheers,
Miguel
