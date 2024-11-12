Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340DC20ADC6;
	Tue, 12 Nov 2024 23:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731455275; cv=none; b=NW3xfeb1MR0lP+95LeCmtES+f9u/gEW8AIS8zA+Zwdg3LLgb3+jVHvsv/8zGrmDDYKV+Vg0HZaV/v+7Ju8ZMsrvNTmK/VQcbfZL6htpVsgaau/cf8EywR4z6G5XadtWIvdPjCwrN392jbEXTF9rxAPpxbpTb/TN0hqCexIaNzrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731455275; c=relaxed/simple;
	bh=6PatZ+Sf9io9a3r7pViBb9WFUEFsWg8CxDrxx4WGMYg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z2g9N9+J8LRVe1nYQm36UqX+XbDlHSaWXzcz/cZczbx+LZtTEzN3APSH1pm5TMCrUusIOPGSu/K0UGzQbPZDRFfS1gG4W7SMkVpRum2obtNUGt7alMzR/OAjh6CvQ+dYmrXdLIAkAIW7rc/OIDfh0BfhlkhrHpGobYVEffrf+ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EAjtyjPF; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EAjtyjPF"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2e2d83f15f3so156086a91.0;
        Tue, 12 Nov 2024 15:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731455273; x=1732060073; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6PatZ+Sf9io9a3r7pViBb9WFUEFsWg8CxDrxx4WGMYg=;
        b=EAjtyjPFMvEsIGgD1QXIpeo5LADHd/JRsqSlF2F89SBjKSt7rYkxPQf/4Eny+Dve+U
         liCGhbPPLF4fhFPdhalBral6k6tHV+hMaGsOguDfz0Y9dt0Fm9rqaWhh2Cg+mvl+sDFn
         EO6J5EbI/wURGgmsiYHElRShu8Lc0CX1V4VplD5zKUvRKL5HuDDRvdUHC5u6tX1ePRjx
         4G5McX/AwSwwco+xLGfkaTRgXsNHWeyUYNEjZ/wwv/430Azo3+z+EgtIIh214vVkBxxf
         0zg3Blj78luP1pPxUhMFO0uQiuSwER+OnnOI43fC2NH7ErtJLGB0R4+LoB6YW4c4Ui1D
         z3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731455273; x=1732060073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6PatZ+Sf9io9a3r7pViBb9WFUEFsWg8CxDrxx4WGMYg=;
        b=oi8asNVfE4hpBKKgPDyTnRYSxnP6g+3xWRO76U7KbirR/P7aJiErsp7vU3a7HfQB1l
         U14qwEl5nyS5NqNo3OVOv6IQoZEmpkat8pNCsWbGsCYgcv2r3LGEBziT2daxVKhj3gSl
         VHWkNw9cNfIi9NYpL6HKluSwSbLgWevqZ/9yZYO1XZhAGAqAvQyUqUFNqUqJVYLjgIOx
         qoGDZWDSsvshOH24jpUYhUD7KNbTiIj1h/LgZ96lsaedKQv+RDd2f8JRlPIIdFx7oigP
         falqnc97pOA0hHonkkbxbhFZYaW0vpcC2HtBg49SxEodcN1WwVC6ZtMv7Zl5LVCQxajL
         yvcw==
X-Forwarded-Encrypted: i=1; AJvYcCU3EgjoH0WDhIz4g1ucPg8yy2Ik64ALUWemlw2QXo9JWu79rh/EjIRoPH2NyNYCxBdQb5ZZ@lists.linux.dev, AJvYcCXLZf4U06+EkEn9gvLDgOfm1OtES7bPRGixrnu0P3c957MJlU54sgugtTmp0Qsg4lCo1R2ZXj6bVg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwWtbYIl78Q8+vm/K6pkTwNwnK+aU47RGkNz1E9NIrpR0/SZMX7
	LdqX2C5NeX9s9o5O2hOFWf4vW4FwDFg/9AaU+iO7vSy0cTn4Sy1QTVx/UlWNoJ3BaCEhK7/gnrK
	fR28xI3FmhdqOzM55Zp5RtRHw6xE=
X-Google-Smtp-Source: AGHT+IHt4zpo/VBRqQpkngufkrIlPmpL19n7RePvvPWIV425p6qC3p2QZEdY38kGPV9MQ/jFliQjsJvM7Z+x4V9/uQE=
X-Received: by 2002:a17:90b:33c9:b0:2e2:b20b:59de with SMTP id
 98e67ed59e1d1-2e9b16aa2cdmr10229180a91.3.1731455273486; Tue, 12 Nov 2024
 15:47:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241111201607.653149-1-ojeda@kernel.org>
In-Reply-To: <20241111201607.653149-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 13 Nov 2024 00:47:41 +0100
Message-ID: <CANiq72nPdcU=E98pE=WM_e=0HPDY7Evg_pto87kf6N58uYbYtQ@mail.gmail.com>
Subject: Re: [PATCH v2] rust: warn on bindgen < 0.69.5 and libclang >= 19.1
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Ben Beasley <code@musicinmybrain.net>, 
	NoisyCoil <noisycoil@tutanota.com>, Matthias Geiger <werdahias@riseup.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 9:16=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> We would like to put this into the merge window, or ideally very soon aft=
er as a
> "fix" (it is not really a fix, but it is very convenient for people wonde=
ring
> why their toolchain may not work, especially if tracepoints land in the m=
erge
> window as expected).

Applied to `rust-next` (tentatively) -- thanks everyone!

I will wait a few days, and if no one objects, I will include it in the
PR. Otherwise, I will remove it (it is the last commit for
`rust-next`).

Cheers,
Miguel
