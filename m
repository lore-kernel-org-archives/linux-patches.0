Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7A22DFA23
	for <patches@lists.linux.dev>; Mon, 14 Apr 2025 20:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744662188; cv=none; b=oCe2rozZQjmrcOZ91CjOyDjPVfDiCoJxBGLI6hxmhQh6ZjqIsRQta4p41K0e+NEQIw9X3bLXgTnFjYOpk//59LZrqcWXnAPCrAj9hlz5FRnuPaQY2Cd1N5Y0bfNQ6lu+o3VbzqcToYLdGTamTcn+NxzpIC4hTbU2uBHvprVvIXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744662188; c=relaxed/simple;
	bh=pgwH9G9Z5XgUOKl+P79Q5KZCCe2yrjR8tSQ/gnwaIgI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lggPXOGQ5U+sFG6X/kVjQVpLyHcyycBb1eifo15YniuAGduBGx82kCW6RDNgopbx7usZ8Ul710NcKrq/FWwz2RVG8005JsvpLIYAfnCfPEn3iMC/kt2S8DimuiMli+W3OWv8Gy0xRE0oQqTmRbEK22ztdu9YCN2TcyFB27z64m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HLStEU7r; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HLStEU7r"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-af51b57ea41so464171a12.2
        for <patches@lists.linux.dev>; Mon, 14 Apr 2025 13:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744662187; x=1745266987; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pgwH9G9Z5XgUOKl+P79Q5KZCCe2yrjR8tSQ/gnwaIgI=;
        b=HLStEU7rHVY8dYhlf8+WdANdpceke7ZwoKfqr+zFokM4M5UBPWU/fR+1WiERZMua0h
         5z/gwkNNHrwwtSxs9hQ4eJQyl2TirarRN9GH5IxtQi14gbzDC48oR1nPrUJskhBh3kIg
         QTwxboVfRz80rxzd+IT3Yf66/1cb4ybncl4xfvb89RFKlB6nHUrLVRJWeD8EViW64f1P
         B0n5L+lOlEFa/AWusVC9yMHvqNJs5oq0jdnAaQ2/6INfQ09DE1cBeaMSpbeB7VfgtfKR
         cCRBRSH1ctnX+85ZaBqIIxKddOwRtKGEU/00Z/kbMrocV7EUbshh24AJwp4M8RKwUV4V
         du9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744662187; x=1745266987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pgwH9G9Z5XgUOKl+P79Q5KZCCe2yrjR8tSQ/gnwaIgI=;
        b=ARdfEf6vnHg/Loin3mky+Rr44EfcgFmjf33h40zBMH1Rp8Tay9RfNoa5TpD0WbbD+i
         kBN7bQXXbrjrXSwI2VnopmfPL4q6AaxFaekFIP9pvZqp4hH7uQW2lZXcvHzPqDTQAf2D
         OCRDDbtclvaSe0NjK7VymKNxJkhkYyXBPLwOdcKEwjXinjT1Fj7WWU9praRvSGUHBZ5J
         KJ5eylySmNlhsAioC78yBXqHlaCCKv8A9imPOv50TWhG4Nb22fE5CBTzis9j0MEujGKN
         z57IsNBSsQYUWp2QzJiM/t1De6EH5HjO6akhk4U7vt6nFKVZNMtUKIZK1D/gSxeOj8Yt
         XbFg==
X-Forwarded-Encrypted: i=1; AJvYcCW9JjAbypoWxtN+SpEhCH4AOwoNcgQdskY4YJBKY+a/2imzUIfsH0V0MJVOZDnccK3Bh/z/rB0k@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0i5XIkhT1F7a0PlyNB0tFmWuqCYdc62RmGRG3mTYNpl48mfxq
	bKY4l0Auw6AfpIlhtSLLANp81nm8nKOPzslWbXBf6eVP7q+qdP6C4cPmlLNZ4DzbhNVIvi8JSX7
	AuuxFhuq4PqgZOYMfEf1mpfCfSuk=
X-Gm-Gg: ASbGncsQFgATTRlZ+1AlaUI8uwrmanNjzvVmZQ3ZhQLk0xIRLlStBGMcRQusWQ8gLns
	CaJg21CfxRS63JHEYuEyHGXjAS5FhJTn0/3e9K+yaa8i0mBXp3ADujQF6aSsbaRBHchOz2RC+L7
	PlenvEc+FcNfgnIISHNQWzM3ZKx1r7vVvY
X-Google-Smtp-Source: AGHT+IE8lDVhXfx4QpCOlSPx0TEX0rr/XZDgXqRTo1W6pH6GeNLdFPig1QevSP2mJMRR4WS0tWFlOT00RW9nujyQbbo=
X-Received: by 2002:a17:90b:1651:b0:2ff:5540:bb48 with SMTP id
 98e67ed59e1d1-308237e291fmr7719166a91.8.1744662186769; Mon, 14 Apr 2025
 13:23:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250414171241.2126137-1-ojeda@kernel.org>
In-Reply-To: <20250414171241.2126137-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 14 Apr 2025 22:22:54 +0200
X-Gm-Features: ATxdqUG7GLyRN3-AU_RPemLfMtwDRsoWtduWsQR0UuCp1mItMnHU5tGCPliq59U
Message-ID: <CANiq72kkXVLg8qaDmQj26Gi0jPZvqTad=qry5p5LnaOFnnWUkA@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: use `pound` to support GNU Make < 4.3
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2025 at 7:13=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Reported-by: moyi geek

moyi told me it is OK to add the email from Zulip, so:

Reported-by: moyi geek <1441339168@qq.com>

Cheers,
Miguel
