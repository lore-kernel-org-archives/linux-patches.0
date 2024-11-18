Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662C218E1A
	for <patches@lists.linux.dev>; Mon, 18 Nov 2024 09:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731923276; cv=none; b=AaVF3VM+fw/jgApDDc8szy3BJWtWyI0mK+Y609Ax5nIrYS364jX9iNDNU2W9EDyW0OqDC1jcr1BkV4Kwm3FtT09CEUGa38mfDG+NmotOWpz8SeJNqVzPUxGTUhc5ZUZnUOif549AFfPLHL1JIFWTIT/IIHg79Od+b+pVbZ2jncc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731923276; c=relaxed/simple;
	bh=XXsIrjaLPtAbu9sbK4FP88OFsgTuPGUxicrKbpGG+pw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b9KZRkS7i7HqNj7eoMuEFz8ojRhwNjsnNoUvTL8Pk54P/jmuvJvodbTlyR1/5Pq4hgqLL8Anzn1yvuGBkU1akOcVyBVlAIEs647yctEO6EnJRRrwppKq//eolHE0mVC+p64ByFNVBeOlV8nAS74SV3OIAEUczVJ2aLqePJ2OYn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kUn/BmnD; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kUn/BmnD"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4315e62afe0so36412545e9.1
        for <patches@lists.linux.dev>; Mon, 18 Nov 2024 01:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731923273; x=1732528073; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXsIrjaLPtAbu9sbK4FP88OFsgTuPGUxicrKbpGG+pw=;
        b=kUn/BmnDxJRPj7Rl+hTuMudh71mVzBX9nJJ4llofntoVhup95lUv2pO7crrbmaJpNh
         cAhOa2rWuePEtR/sHeY8wAWagB/Lo5DkmBvEErCLybcd/2z0nSuiVWHge1q8NTo5ReTd
         rJAu5FeoCCVUZtLKC8d+HddktpKJgtoeOrP8zgO9DNrURm597agMP9ZgcnfSGZu4r8Tz
         0s97izDC+C6iAHpQYqHKmStibDBspUqn02I33qVD2FBQKSzfnwGUThbp9thQ9sSuwGZL
         efsLznB3dW0T3VXYqQevIPgpGDimJvmgwNCS4NUf24a5NyQ1eJBnyBSkk214ANlN5MXI
         cdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731923273; x=1732528073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XXsIrjaLPtAbu9sbK4FP88OFsgTuPGUxicrKbpGG+pw=;
        b=aFYaG4884mTj8JQ9YSRadL7hSB93T0zdPjp3HObYFjBBKCEEsNBDRAw5J0Gbj7K84I
         iSz4gatTeIeYv5mrI5kfyowQoyou+6XkJtqQ80pDY+tCzMGJDm7gXGiV/or88jBYESIS
         MFL2wR2fyOEbztngLiWne43jBCwcBfP21lOHtwtowjnQ9az4AOswdO9dNAg8qMHlsQ8j
         sRSI5iggSFgTr32z1tuodgLGt7N6DfHd2Fh+Php/1425gCFjqN2nf1iovvwnTE4v7K1G
         pcextrQ/LX7RxDTqF3BPVFL98NvlQBrG54UeHvqq5o71/JtQZzc76KVY6j2RUHf9pwpV
         yB/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX4CiZZ7Ed7GuG0cPPt/IAYd3IhRE93rKdeh7Gn2osts9E2qMaiR5jPs5qn4s1FjSF6DJF6iLFH@lists.linux.dev
X-Gm-Message-State: AOJu0YyeQuIpPEIRHTi5D0WYqBQe9m5c2LGZSu0j8sYF2wW5V2em4Ij/
	XObdHdDpQg1oHkVp4+frH5uRm1LqjgXqih2U3WGm+X0VUdqPT4ep4piHPVXhIJnvA76A0mvW2Z8
	8lb2Obp16ErHuEsWUsYmL8q4CQkWNtK11FOrU
X-Google-Smtp-Source: AGHT+IFW3ZZ2HFelm2woVtQeHr8EXXk1OydjKU40b/QkCRm14XNYCXSKqUggk05fm/ig0XesvILnEgyXAhF6bD1p/U8=
X-Received: by 2002:a5d:47ab:0:b0:382:3789:191c with SMTP id
 ffacd0b85a97d-38237891a14mr5679855f8f.7.1731923272561; Mon, 18 Nov 2024
 01:47:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241117133127.473937-1-ojeda@kernel.org>
In-Reply-To: <20241117133127.473937-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 18 Nov 2024 10:47:40 +0100
Message-ID: <CAH5fLgj2ikduoBOCekGxdStemVR1EAN-fdcQxOVUJuUL5Z2KtQ@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: remove spurious item in `expect` list
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 17, 2024 at 2:31=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This list started as a "when to prefer `expect`" list, but at some point
> during writing I changed it to a "prefer `expect` unless...` one. However=
,
> the first bullet remained, which does not make sense anymore.
>
> Thus remove it. In addition, fix nearby typo.
>
> Fixes: 04866494e936 ("Documentation: rust: discuss `#[expect(...)]` in th=
e guidelines")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
