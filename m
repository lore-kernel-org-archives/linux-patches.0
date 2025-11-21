Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D90C33E350
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 09:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763716094; cv=none; b=RiIEsSkWFN4hKsbsHry/M7KnWnS7v7GxGCXKzqqYipUROnot5qBL812pxGxRcGqocIYEqylMsJzFinsD8Z9gCFtiTE7exfm6nadwYtG08SB6n0Ke0Rr4gGYCDn7J5e6cg4eKj+78/HYsj3uuVqeWbWyaeHvN9MvCg/hPg/yMb8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763716094; c=relaxed/simple;
	bh=/VgZi4aX+4bGSV/xhVlE1Vq10NnhANLOSDD25ABY3d8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pThxxR6xdemjr8Z9RsP04jEfLarcuvYDM9eiNrj2eEaTyzZRTpV8HpXjh3kzy4H2o23J4uhpyObQnLZdaT4kAkX9OAvD1JVQZA+iT9F/AAQAkbt6izTML8pZS5I9i45zNVaelD0dScixMUXXmv8SKUW9s13xGMzrbaAYkDpC7AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ICc8L6Hb; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ICc8L6Hb"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-4336f8e97c3so8399545ab.3
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 01:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763716091; x=1764320891; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ETrr3JCzkruiiBfVI5YFLmlwzMZJrfA36kDNRDzkq0c=;
        b=ICc8L6HbY4ck5VgODea25Ok2l3q6QfedMMvMySyRts9mKyZBhujD6mvItYUcJxOFDT
         T9brBNR0+MDrzGSuj4BTU37iadbBd2R24Y9ke9/cg67hKZucK2MLruqZEqbHUQ8sMyz8
         Nhp1a77RVYmEdPcLczw50a2QO52DEZNO31rKSX0L72JxJtX5Djr8VjkISHM06kLIgUyi
         F6micrisWuOm7+YWfwTBK36aQQOXMRgZ7gtRbX0hd2bvatiUVBM2yheGgmKKyzMRiGJq
         jhotTcC+8Yyg0Q7sFLKjMslsw8xtHLwS2zHHS+y3kuRdyCMaygz980NK9dF7HxByS2gC
         eHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763716091; x=1764320891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ETrr3JCzkruiiBfVI5YFLmlwzMZJrfA36kDNRDzkq0c=;
        b=UGaY2r3AjYw+0UVpyaGix8uECvZQdUnz8wq/xlwoqgrqCxcWXgDZ1r/b1aIo2w4krI
         VKPwu/ZAovQfY1rQqecroH16F/Rcsd0GlRbw1+vBdGloh+FnEDupN7oA8JhjcH5NzzNk
         f2hU+dF0FMFwPsZIbylUG9gwGnup7prFr6sfwYtG8G5p5W10QylxbHV5bgTiWSAs1nY8
         YAZ8hjDIpV3Va58pTW1rmTQhX1y6lUSnj7Ku0r9y8MT/DluRrUCs1V78COoN5pzf+DIB
         4/mO6HwO7cBtU2cCJjuWQFfuV1SGLpxp6yERPsfGpTK07wILWvbBqomGSqzE8jFr64DF
         KZLg==
X-Forwarded-Encrypted: i=1; AJvYcCX19klq74Qy+45RtRjrdAT6/ywpJzM9VMsockyPQHrOhVcnDpEaVolSSJypD0gCaiXabPpX7jGu@lists.linux.dev
X-Gm-Message-State: AOJu0Yxn56GYuN2xSVNhB2xKDbWH+pGTM6KCjFnFoM9j41JexR00y/8x
	na5BNQRmKDW23j54XhDQzXgha40TeH0n32Wghnob3c3AstSwHdSFZENagWFzpXMrmq5nAEuCLE6
	d/NISFa21OaqgZvd/6tNuCG1ck9GMQrM=
X-Gm-Gg: ASbGncsbeoj7n80gUI3KOim8IGbzap0FW5h5xgrjgi8TJpqaEfx526ot1aYju1WuCPg
	CfMTXY891UFuZsXYMix0a8oWuJ/JCH4AdxlT8ySUppXcIImlfETdGpQbeifd/E7qtVM9wsH3a4k
	4Bixe/GmdaaamP5Sj2FNnUrNlUOvddzSEqso5RB1FvNqoEfA0rYYrsNH2BryJt6hRmEjVVghlca
	u2bWESSKnp7ot1ggCyNOD0qbqy9CDbzYOU6cwNNa0IRpAp8jilToDvBkfwKbT5rgkqfvgAwzWm+
	S/+9pyEk32JReg==
X-Google-Smtp-Source: AGHT+IG/3To+AMr2oK2HFxlz92e3h2/vQsBM/+3FjkkwwtK3YTD77aA+5Xb7tvgJBid47+5SozvZZbOCBcUhC9NITZU=
X-Received: by 2002:a05:6e02:3499:b0:433:2a9b:165c with SMTP id
 e9e14a558f8ab-435b8e51411mr12950455ab.27.1763716091414; Fri, 21 Nov 2025
 01:08:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121043750.298843-1-y.j3ms.n@gmail.com> <20251121053633.1594703-1-ojeda@kernel.org>
In-Reply-To: <20251121053633.1594703-1-ojeda@kernel.org>
From: Jesung Yang <y.j3ms.n@gmail.com>
Date: Fri, 21 Nov 2025 18:08:00 +0900
X-Gm-Features: AWmQ_bkKRpQOmfQwxZhx7gcZHJiLyZriJu20U1pwBRC8eMsopftfFbaK_bzrDgM
Message-ID: <CA+tqQ4LX2ihwY11VJk3LNNE-STsONJWF0rdDa0Pq09oA7YRXEw@mail.gmail.com>
Subject: Re: [PATCH 00/18] `syn` support
To: Miguel Ojeda <ojeda@kernel.org>
Cc: a.hindborg@kernel.org, alex.gaynor@gmail.com, aliceryhl@google.com, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, dakr@kernel.org, 
	gary@garyguo.net, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lossin@kernel.org, nathan@kernel.org, nicolas@fjasle.eu, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tmgross@umich.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 2:36=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
> For using (all of) them from `macros`, you would need [1].

Now everything compiles. Thanks!

By the way, I needed to make a small change to
`generate_rust_analyzer.py` for rust-analyzer to correctly reference
symbols from the vendored crates:

diff --git a/scripts/generate_rust_analyzer.py
b/scripts/generate_rust_analyzer.py
index 5b6f7b8d6918..147d0cc94068 100755
--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -110,7 +110,7 @@ def generate_crates(srctree, objtree, sysroot_src,
external_src, cfgs, core_edit
     append_crate(
         "macros",
         srctree / "rust" / "macros" / "lib.rs",
-        ["std", "proc_macro"],
+        ["std", "proc_macro", "proc_macro2", "quote", "syn"],
         is_proc_macro=3DTrue,
     )

This might already be covered somewhere else, but I'm bringing it up
just in case.

Best Regards,
Jesung
