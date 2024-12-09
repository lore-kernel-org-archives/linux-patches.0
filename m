Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6521F63F1
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 23:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733788674; cv=none; b=gRhAbw37hwL2mN5G0IMY1w1yfGCFnmG2nX23UGLy0w9GLYhWePwXY+lefaFZ1thnAiSdFKX4Uad0pH8GZANExtfikAj11G7ib+jm5ya8EZKUhnywYg9qv/M6wrqp/eRvHS7NrfMw++Vy4L4sLI59a2cjsQQx5SNSlI4D9Qr7t1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733788674; c=relaxed/simple;
	bh=hpjEp/oF11sseU/xRny9xwf0vbjS/bPeeP7YWy3KZTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IHNX7wmgpMsNRx+LF7+dYV5NEwJQhsUKXU9feoJlcLwWr9uLOYgx3ehOOVceC/SS69/mb9yKpEX3jYMqkMGMXSkBmda3wqWky7JmmnCB2LseMJhcCqG1IJ0Lm54iK6V06lp5x46nfnc16ViVgMSqZ64lwxZ1sr8l2n8oqBx03Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UyYE3vR3; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UyYE3vR3"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ef79243680so608826a91.2
        for <patches@lists.linux.dev>; Mon, 09 Dec 2024 15:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733788672; x=1734393472; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rHPxJ7hPLFpQidTl4ZL+eTNzMYzt1IS2TVSHXzTpC5c=;
        b=UyYE3vR3rleXb6HiQQ8biREDhW1iThXtzok7N3hkqNAMXRKdLejW0HtJWZ821UjzvT
         Lmy651M6+aTCGI8Tn70E6fGxkdscD5fmQU0f4BYl0PZDAPGvS67PCKd5benef4Yxdiul
         BhQzl4xNNrMEwQjcksTS7PNRpBllrwRUxl+sney59GRCbNrNgvLY8WfIenCTbLFODoYt
         HUKRC+3mEyLoP3RioTGFrXWVGOZm+LBs5vO+i0JEsJw975aDK4mdIDZJbMulYUB4+M6D
         RNpFx1VqsLxEMoInDQ4o+znOoX4mjYqe9MIAtDYyXXb0m2kug+iWOf6+WW+HbEWY80U3
         XEJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733788672; x=1734393472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rHPxJ7hPLFpQidTl4ZL+eTNzMYzt1IS2TVSHXzTpC5c=;
        b=DcrRavgfud01+4DDsLgDR126ErlIqyk3bwtCFF7opibOjqCNv8pBYYUdizYqa6gW8O
         YelPKFEmifhJ+s8PXBO99X7Vt/XoJcdyH904wzadoa8TIxORpC2l3mLG7wcL31oXbB7n
         WeDwYfo6jLPLL1+XsfbF58daJkHBE1zPXS+F7TU805cAwvJyxKJBpdl1g0xmlle4gW7Z
         /m2she4G0/UnP5hvfXkk997kp5LSasC803q3YV1E8+EPici1e5L1Xz5DZjB4jl9iTNyd
         //71t8dx173BgqwXlRy46PL2m/2w2Ws3Z0LqSG9RHxx5DjV09T5naoo/5JHN32fbu+K6
         QtxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXc6jMPnJLobVF1bA0O3revqLhPmLFkXTC1+5NLSiIhJh0YsVvtFgpDTO3Dpdxn3wI3IKS1DGip@lists.linux.dev
X-Gm-Message-State: AOJu0YxHXv7yZ2RUDf+MZyONHf2v7s4Vazudd1HenDrikfeJkFbC3aVa
	+jxC/W3nB8sYr4LCRfxglCBTYYPlzIriENdlfpuAOOf65tZAvCtjqpJs+IGTmf/8XqAEunkBCc7
	Ck2H4tDqrLm+72uypIw2krATaf0Y=
X-Gm-Gg: ASbGncs/3Hcu/F/mjohXDp23NePZ9/1zdRCqSqALF1Yy98bol6+RHmjNqJtkwPurq/M
	ooMC8/PmKlYACr/xjbyWmLy9n+mm571IL0Bc=
X-Google-Smtp-Source: AGHT+IFA3lV2vvANGAr/q1J0rO42UgmCv9jlCFJWKSe4+sKE0L6emUcGAjynzPESeucKuAY0Wly56Rz8xKK+eETDnTw=
X-Received: by 2002:a17:90b:1a88:b0:2ee:b665:12c2 with SMTP id
 98e67ed59e1d1-2efd472eba2mr848875a91.2.1733788671803; Mon, 09 Dec 2024
 15:57:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241125233332.697497-1-ojeda@kernel.org>
In-Reply-To: <20241125233332.697497-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 10 Dec 2024 00:57:39 +0100
Message-ID: <CANiq72=gRDr658wi=PbEcwTM7oEdmBU2Fr=wKw9eq2kEbrjWHQ@mail.gmail.com>
Subject: Re: [PATCH] drm/panic: remove spurious empty line to clean warning
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jocelyn Falempe <jfalempe@redhat.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2024 at 12:33=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Clippy in the upcoming Rust 1.83.0 spots a spurious empty line since the
> `clippy::empty_line_after_doc_comments` warning is now enabled by default
> given it is part of the `suspicious` group [1]:
>
>     error: empty line after doc comment
>        --> drivers/gpu/drm/drm_panic_qr.rs:931:1
>         |
>     931 | / /// They must remain valid for the duration of the function c=
all.
>     932 | |
>         | |_
>     933 |   #[no_mangle]
>     934 | / pub unsafe extern "C" fn drm_panic_qr_generate(
>     935 | |     url: *const i8,
>     936 | |     data: *mut u8,
>     937 | |     data_len: usize,
>     ...   |
>     940 | |     tmp_size: usize,
>     941 | | ) -> u8 {
>         | |_______- the comment documents this function
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#empty_line_after_doc_comments
>         =3D note: `-D clippy::empty-line-after-doc-comments` implied by `=
-D warnings`
>         =3D help: to override `-D warnings` add `#[allow(clippy::empty_li=
ne_after_doc_comments)]`
>         =3D help: if the empty line is unintentional remove it
>
> Thus remove the empty line.
>
> Cc: stable@vger.kernel.org
> Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
> Link: https://github.com/rust-lang/rust-clippy/pull/13091 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks!

Cheers,
Miguel
