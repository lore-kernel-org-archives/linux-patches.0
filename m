Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E32628A701
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 11:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762946082; cv=none; b=dkbGI6MNTJY0Aix7zwGx4a9V7fB2/yC/3+VJlFbCXenI11u65o2m52uXWqHmOXZDcJksn5uDxessDA92XwJP+UAfKHZEWRoV8UH3VA8J9jUie6k5wds0/+o+Phkrjm0vb+kp1XtJb/lHLVXlbWiQELVYTP/QNqMKcLM/GV+AUmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762946082; c=relaxed/simple;
	bh=h6hMfbhgFDo+gCBofNGaIGR6RdADey1hjtSNOkDpSwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tzQVHfNUQDg0vRfY7pX3cEsUpgCKE6v96LyggPPvsjc19trwOYfZRWWaSbuDZMdaHcAEd+FXzTNzt7sEc2p7xImQ+GL2PenczFlufMgNXgHRk3xCzuFXNU1EKix2wIdDxR7Q3ffJD2EDfAiGjBiez3PT6PUJbPEqV2oQ3GkNxE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KcK1Jrbx; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KcK1Jrbx"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b9a5f4435adso84112a12.3
        for <patches@lists.linux.dev>; Wed, 12 Nov 2025 03:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762946080; x=1763550880; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6hMfbhgFDo+gCBofNGaIGR6RdADey1hjtSNOkDpSwU=;
        b=KcK1JrbxKGxfxkQF9IGkWbuniAgJ9I3DiLUBO+Hc3EOKqv+x/rpSPSE67NPYtjRv/M
         dJJApBPFk8+OoXhGywTJltKXfnvlN3zJ5JVVWO29Ie9vM3amKAsibGA3iYvJJfynP25A
         Qg9y9gdCHMOz6UTW96Ri2OqMBFv1kep7Iv9NLRPfUUrdNci56PWrgcHjuAOLsrrdXZz0
         +79sh6IT+ED44L1/0Z038mhnMnA3eLNfJAKjxG5DZVZedfkld0sfMeEP5tMYh7LLNNiy
         67LAEUyV0CnV51AtuN7jg//7wGVERlN0aa3CYvFElk6dMG7SH/aBEQhm1CweYhCxy9n4
         N3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762946080; x=1763550880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h6hMfbhgFDo+gCBofNGaIGR6RdADey1hjtSNOkDpSwU=;
        b=fv+Z0MCIAIUZjcLesRqwt1TecE1EP7p3TotcfEFYOeG1VIUg1sR8SSB/T+Mh1QQa0q
         6afg0GWiCgViHouplV9SQC1ZobTuVh0T7w38po4l/pSCQF/vCwWLDGIBxcMp2Jx2jz7V
         0atmjxf8f1ZZD+axDygX9ug58teKjyy/9IH9Jf3x5QTWmN37R61ssE2ekbDQiC24VbOJ
         H5le+ZVWKe2baW4ssHdGt+ecaq9blmBNXI7v2pMNpFoYJxj1wDCry3T7FSYVIIXii/QX
         +4KPN3vmB8Iv0EE9Ota/CSTpu/YPIH1cO14i9Nlw/gbwaNPjZF+yTUe5xO/cc2yOHMJx
         UpGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUb/JcPvv5cQwYR8knJL8wsiYCJFnXVMrs4L+bdC2HN8w2lp4yvJFyBB0iuKaPDeUe5rZxnlWyT@lists.linux.dev
X-Gm-Message-State: AOJu0Yyo6H2LhCqAwkSwG3uC+8u8BRsFNHmc6E/+mVNtUpDMA9PPwV8l
	pS+91bevvGjckY/zP+PRaD0u3s7v+1Waq2Gs/Y6A+ZIR+TfzObSCG0bWbTmKpz5S76wzE/ooAIK
	pJXkbkZ83v/U/1SdJbzzFHmxev6Z6Hj0=
X-Gm-Gg: ASbGncsuJSipmsLfCzYeQK9MOtiDC3rxbYqiIauo7NA6b7Rrmy2MpfuZGF12jHBvTQe
	Ovem9bKtg89ljMxmZjfHSnGym7BaxVDyIYYTbsljR9KTJUD7RQaTV7ZFP6W4wMKj0tLFKpWn8v/
	xjiHzt2grIVeTDlA+Ttxgnwlo5lTwu8yZbjgMYZzOrrzzgCxTLELwxdP2wEK4i71LwkVtD0ZEj4
	bbvAtfK0/S0VLlUofDihiuL9CbF4xG+Wj/WGK7zVj9vnoIoq7VEvPmb0rWz8ouYQSMYqnQW+tIZ
	Vi5jKqVsAaUumfrnOtDpvpNQ5Os5aQULxmwWa65/P1X+5mrakzF5sSOuZaEmKCuwdXVtnPszLMB
	rW49qt5Ymg09UzA==
X-Google-Smtp-Source: AGHT+IH+LDSJrK2CxsT+xWZOdZ7gKFmElQbYj/uFX0H6HJGbyKRr591NNlUWdNkrfJ7Nf3ybqLt6vVVhtmriacHHU64=
X-Received: by 2002:a17:902:c409:b0:295:3262:c695 with SMTP id
 d9443c01a7336-2984ed6e08dmr21652545ad.3.1762946079913; Wed, 12 Nov 2025
 03:14:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-10-ojeda@kernel.org>
 <98e549da-b7d5-45bc-8a9c-d05eb06a75e6@nvidia.com>
In-Reply-To: <98e549da-b7d5-45bc-8a9c-d05eb06a75e6@nvidia.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 12 Nov 2025 12:14:26 +0100
X-Gm-Features: AWmQ_bm8KNkpZ7dumhoSEH6BrwUYU-Dw3GKK1Imj_lLMN6rly1tXHJZJQTQ0s2c
Message-ID: <CANiq72mcQJnW-F+nb=Vseoa_amcwwhkC26N9BOs12MVfMVOdVA@mail.gmail.com>
Subject: Re: [PATCH 09/18] rust: proc-macro2: enable support in kbuild
To: John Hubbard <jhubbard@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 8:34=E2=80=AFPM John Hubbard <jhubbard@nvidia.com> =
wrote:
>
> Looks good. But for future code and commit log readers, should
> we leave a small comment, to explain that this was vendored in,
> and therefore excluded from "make rustfmt"?
>
> An alternative approach might be to create a "vendored" subdir,
> to make it clear which parts of the Rust for Linux code are
> special in that way.

Sure, that can help, I will add it.

The subdir makes sense, although it makes it into a different level
than the other crates and I don't see it done with a folder in other
cases either. Hmm... I will think about it.

Thanks for taking a look!

Cheers,
Miguel
