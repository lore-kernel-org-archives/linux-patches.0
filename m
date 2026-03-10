Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EA7381AF8
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 11:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140999; cv=pass; b=ElzJ6XNcOAAE6csZy3hFDX/LlDT1FlgsLuStpdMXOHzhiK0R4+FDJ+XTeitzFm92yfzpl8iwYg94gGJpHZFfU/sXmEgb7ioA9CtO9CoID2HIikqc/d+1Kbaiu2q4fOOADNa1KWLzCqBxaNhtNshrOtU0Z69u9egmktzY3foj1pY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140999; c=relaxed/simple;
	bh=Aem47PhvPdP/iyuqplBe3P+A+LjmiDgpbIH/qJLSI+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gH23DsKR2HAMNjj6ymVpXhug9/woyMGhtOkiITVKJK3rYYZU54n8RqqV1Vza/UfYp981LOjB70YA+LSmU9q7D3V4kPUl8CIXYdC2UAwaOpdvr2meKFe/lEQ8tN6w7ZnybqMKR7Wi1KMVdubQ1gB/e4NGMMrznZs8OtFyJ//8uaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bBbQrH0Z; arc=pass smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bBbQrH0Z"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2be851b8ef1so3948eec.3
        for <patches@lists.linux.dev>; Tue, 10 Mar 2026 04:09:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773140997; cv=none;
        d=google.com; s=arc-20240605;
        b=GMW62nFdTmrFDkaNuo5OeZNqbKS3BQRA2W0sBL4cEC1/VMZp/giKDImt63jz8/N/Hn
         jqCN7EMGoxNEtY/GRM21Q8t+iMtdX2mBnEsaafkIltcEGc5mmu/B33XDhIWgX4uIKEsb
         jI6PNLIeC+ceetguefEaPbfH9OSBg5w8SKJrDLyqWZ1b/q0OyIk/diD8Bx9VNY4rVWG2
         RSJz0D1DWi5AqIdZ4FogbMLffdld/wx9FdvWK1VtFNOSShXXdBi5Q59SG5OmMcoRR1P7
         DV0fFZr0X+T+jXzIffAOSrP1TDKt8aEnSJ5IR2SoqdmxhtQMbfngw5LYxFAHjO9ZPlAO
         6DMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Aem47PhvPdP/iyuqplBe3P+A+LjmiDgpbIH/qJLSI+A=;
        fh=BKNhPh3qJODy6wxWSChvalXWC1dNDJwTa25IOvxAttQ=;
        b=eIvry50tR9C9EweCNZV3Uaw9FW7d8rsTlRCNO/gJDvZcWfEAibaxAsCWr28MQduIby
         AzZWEMUJSbljmLl1WlDIBrrzqtQL3bUt1WU7vkB3Q/0Nb9DqT2zcTvMCowccsASSpGM8
         KJ9nIJ+oaU+lzIdEwQqzm8hrDb1GlHIBRKJyb4ZXRmHrSY4blg3ropyYg2DV8gUcoSoB
         OTzNFOikjQXo6d8K59maRR6s4eX/Ixh615ySrjFr2PHMUuegVJ8vkaz4lbvQr3Erq6Dg
         zo+ownopO6jPVCX72pyIQ791dg1gJjZPOSOnb1WwNWN4n91qz3xNnEM2Dbp+i7bnbzt/
         3ysQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773140997; x=1773745797; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aem47PhvPdP/iyuqplBe3P+A+LjmiDgpbIH/qJLSI+A=;
        b=bBbQrH0ZprIJWw95ptHHYmqc4II+00ur2XZGoZThfUW3epB7P+E2cl5i0yK0Mk9MMA
         JojH6reTWkQlIniOY3iPDL/4NNqwd5n2+YpA2K6qK0y7CfGeHdx1snyvIlScguxYGOJn
         VyYXcuWwEvWDrd0I4a32zXL7uxgzsf9y2+GPL9cJjMbYjzCxzIOUjn3zcnMMNqfwcklh
         RtE8MJToE5WxCujNBLr/Qxp7XWpDF4brk63J/kF7hXiWJnyMkDjWCYE88ldgoTYvkGgI
         IXPaf6YHPqnzTDNrTm/D5X1XN6nnQUd8fEkT3hApA5gGABDySgbvvBltdkocu2HpIsZP
         0Aig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773140997; x=1773745797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Aem47PhvPdP/iyuqplBe3P+A+LjmiDgpbIH/qJLSI+A=;
        b=MoC7MAtoQDZni1fQLLfXBy/kii0E2DouhIRY4rJbbvWzpuJlCqIGp19vkqiuroR7vc
         o7j4sfoY93kvnTuYqjuaAmlMPzG+c3E256PcOHcBHTzquo/KWCYI5EwHyLI0lxtMvFtN
         2mNF5Xbj1FBqWlzvOC+J8GxgvvONbKHG2mHl5jZ3RzPh2PmsvbROQm2rQkK/lHzj4CTL
         7pDblrNqE/bDJZyJjOQxAMZ0isukVfil4qPy4Vz/JI0jp9XGxzuxGSjDij6zWFFdz5pL
         px5q8I+KAHchRJ44iWXELTSmSc6b6vk2Fh3dkkZLCX7/skDEAq+4Yu6dd5qXekP8HL6x
         Kutg==
X-Forwarded-Encrypted: i=1; AJvYcCUXU0Yrw9SLE6XfWVKjxAv2VVZPCuHZGHk8LBJxFkHuF87TpE/bKg9GePKJtidIqCZ9K9Gk73Xy@lists.linux.dev
X-Gm-Message-State: AOJu0YxWEObVgG43Xz0SLiWnhfbSo4l0CVefh6P0xWrkvv/IvUntSbKO
	lAmJL7btmq0oFp10sdfbz+ZSZhQAi+5PMWdUBnjkij4uH+G8JVTXf6W862c3hyrjgBUph22J2eD
	UUSh06U016x//oUunJ5nBXMOqZGnV1Vo=
X-Gm-Gg: ATEYQzwdVMThG7T0Frr5NkI4mknKSd5srRdxmUFizLXm78J8vHEvQkHfZFmKAQzjMAp
	RmHzvwMxFK1CmB4+Li4v+8b+hjN2TH0Lw6DDNy1ZjYu1h8EF/JcaFnpnKi5cqxf0fX56d+TFzLa
	rh4EZGjiZWNLjNujpunpZcgLnXaqbMUDrLjwmKA/3CGNEk2jfrsCg4+D37flFoqTBIJLyUaX017
	UQJHRhT4zMwMwpGzUeY2IouSxq5kqabY0I3X98MD8Wl7Gp1rKIsfadrQBrQ6Ly/+VO5OOQTBVMP
	IMhdYMvSzjdkWr++lqptobp9jCFRu4QNyOnGWdeQQ81mc7A21wncA4MVDS+k65TcOcrVNwOQPp5
	EYsDMRR6ZOeDFX6x9sPmhrc0=
X-Received: by 2002:a05:7300:cd90:b0:2be:1544:5c34 with SMTP id
 5a478bee46e88-2be4e09a273mr2605685eec.8.1773140996803; Tue, 10 Mar 2026
 04:09:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241119185747.862544-1-ojeda@kernel.org> <202512092319.ECBB8613@keescook>
In-Reply-To: <202512092319.ECBB8613@keescook>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 10 Mar 2026 12:09:43 +0100
X-Gm-Features: AaiRm52yrnYpKu_LCuEGwaXBkN9qVVDwx_oBsyi0FYUy2OUcPt08sBsrY2wvdKg
Message-ID: <CANiq72n=hgH4bqJjp8MsMHAaxaAo75GSBcHGTvFT3NTSaVPGWg@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: allow Clang-native `RANDSTRUCT` configs
To: Kees Cook <kees@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Aaron Ballman <aaron@aaronballman.com>, 
	Bill Wendling <isanbard@gmail.com>, Cole Nixon <nixontcole@gmail.com>, 
	Connor Kuehl <cipkuehl@gmail.com>, Fangrui Song <i@maskray.me>, James Foster <jafosterja@gmail.com>, 
	Jeff Takahashi <jeffrey.takahashi@gmail.com>, Jordan Cantrell <jordan.cantrell@mail.com>, 
	Matthew Maurer <mmaurer@google.com>, Nikk Forbus <nicholas.forbus@gmail.com>, 
	Qing Zhao <qing.zhao@oracle.com>, Sami Tolvanen <samitolvanen@google.com>, 
	Tim Pugh <nwtpugh@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 8:21=E2=80=AFAM Kees Cook <kees@kernel.org> wrote:
>
> I played with this again, and yes it appears to be working. I think,
> however, I would like to make the anon struct universal. What do you
> think of this?

Revisiting this... If that is acceptable, even easier for the Rust side, ye=
ah.

Perhaps as a patch on top instead of doing both at once? (even if it
means cleaning up)

Thanks!

Cheers,
Miguel
