Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF901DFE26
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496619; cv=none; b=IJjDGhmMvoQRwARGYpC817cMwQmQuaCP2vJLJtI8TwQlLMnBar2B2hKqS+tp5sYisvlL2fyrA4Y8iAwMgPRc8P7vno3747OozFOVlJ8du0DtqfiBF20z5+MHq0tkirWuyMJUfjJgKp4AsuEZmskCAmTbxG1GNxp40QFePbAUFSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496619; c=relaxed/simple;
	bh=4nRNZ/OwQos6PIKG2HVphry94ftYsfgFC/siNRlqeIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rFopohoC0g5eQzEBkG+N8XUBwFs6TXW4UtDKMDyK2mCzGTQZHlG3W450uFBnzBTjMZdJDCrfHZas/tl6fnacwfGtXSumD0db/QPg8cif0b9jom476LxpTZn2b9Mvob5aGQnDEsnn8T9njM2trc1bZQsCoG0F5amzgUU+N6HLC1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c+44fRl3; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c+44fRl3"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-24914277174so1654525ad.2
        for <patches@lists.linux.dev>; Fri, 29 Aug 2025 12:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756496617; x=1757101417; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nRNZ/OwQos6PIKG2HVphry94ftYsfgFC/siNRlqeIw=;
        b=c+44fRl39dlWVvKrKYqfFfvsx2O1kGz+bbXYb22t2N4mVAnbnnBiZAy/n+2rAzypom
         3lqP3QTwp0tISuFVMUVShWEiOvl1a+Vh9LQ+3c0JS3bC3aUe6dmKAOIzEThXiA1h5st0
         zyDrxpL6FGBLPTIGLeNVxUS01mE5+iLQBqlKk5eUegM8OMDOYWjmEukyafsGZcaGPR3N
         rTXeHIHB9w70+eddqiGPcMaG/yvrUBeF02vYNn7OEtxcjY3ugl7qm8WV67uodPjO3YCK
         Sub6e45NZeQRR5cnNaB0rAJQZYA93pJyEhGLVcPR4rTEjj3jOpzRrTI+IxPaOb75Y39t
         qoUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756496617; x=1757101417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4nRNZ/OwQos6PIKG2HVphry94ftYsfgFC/siNRlqeIw=;
        b=oX5dcUVeHLTZ/wXbqIXeTburV0vg0Z5AxMqQBWxORNAjMTS9nt/+AMT291AxZrzFN3
         Hx2YPePrlzyH6WAduOi58TTpcOV1eluzmHlYrnQ33iq5ybCeNTQ68wSY1B1guWbjm/eX
         MlUshyMFOw7E970eJJKPem8MC1zFVyDneu2fva25ZbW1vOBzRCF1RDO+AsS1j0Lnr7jH
         hB9Cx2037NHQym4kOiJctlUdObMudy2kUiZk/Bjko+qvY4WN1GcDN9mZtezx+4Ke8h0H
         Ocy9KVh5NZrKsmSs6/bEbawO+J3r2D8YreA3ohSeM68m+qS4b9s79+6K8GFbkzB+B3MJ
         lPug==
X-Forwarded-Encrypted: i=1; AJvYcCWbzoZ8It++5Y1odiL7DCVzmtebw3LAX6lZLxvwgcSkmXvfimj240BubVC2+Mdt95Wa+7ESWgxd@lists.linux.dev
X-Gm-Message-State: AOJu0YyGML/OtoHjb+PaOVMKY23REXo/RwSx/wEAjE1hKHxr6atxuRNM
	qmWcFEsTzT9lrGJPfPG8zUPfQAAp7sQV79wLtcGlj4uvrrogdQu5xM+zRHWLqnUt9iVfvjVTSGx
	xDLXEKCyM45DvZk5jFYeD9jDa18p7Bf0=
X-Gm-Gg: ASbGncs+3ZehWe0E6FglR6eSuUkTze33LKXUJzldOdL0ESREekblyKh1gDezl1qNX/N
	kw+dO1/OyBzK3eSVZSte7KRIGfb75rDtcf0i3dvcMTfKaMMrrax6/HLRcRrltrUkOiztXBcEOCw
	ATD/8riQE3MrIBVuqAq/A3PM9CsEoByc0iQeGEKUio65xPm+prJrGujk1ATrpEO0UsHHvx/aZ+w
	U9iYtManvreFCPUpt4EZ3ebsVokqJ50nKcK0OyT5O7h6/ORazofjaxdlKP5TPhreGEFl0EnxXZF
	housDE5rIoQqoqNYperzbIDt5w==
X-Google-Smtp-Source: AGHT+IFWZb4xaY7v5s0ylSP5ELEMnxzQujAXKzF//SpCqMfVGSq+8gvW+Xpth3BkeD9kVV8HxQDYlRSXEcjPedhBXTw=
X-Received: by 2002:a17:903:1c7:b0:240:8717:e393 with SMTP id
 d9443c01a7336-2490f7591bdmr25798105ad.5.1756496617089; Fri, 29 Aug 2025
 12:43:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250829192243.678079-1-ojeda@kernel.org> <20250829192243.678079-4-ojeda@kernel.org>
In-Reply-To: <20250829192243.678079-4-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 29 Aug 2025 21:43:24 +0200
X-Gm-Features: Ac12FXxdaqCu4yJ1IdyQ22odRNAFIeLXOSCLMds7lUVCV-3Ct83AvKEf6yXHQx4
Message-ID: <CANiq72k7_GbFwRxW5vikF_SpiNcNm7Ff0oe6jyYX_voDg92QFA@mail.gmail.com>
Subject: Re: [PATCH 3/3] rust: error: replace `WARN_ON_ONCE` comment with `debug_assert!`
To: Miguel Ojeda <ojeda@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025 at 9:23=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Thus, instead, use a debug assertion -- this assumes hitting one of them
> is not going to be considered a CVE (which requires
> `CONFIG_RUST_DEBUG_ASSERTIONS=3Dy`).

Greg: RFC on this -- this is the usual conundrum around `WARN`. I
would like to have an assertion or `WARN`-like entity for developers
that doesn't imply CVEs when hit by user interactions. More generally,
to know that such a config option is OK as long as it is labeled
clearly a debug one like this one (we can document the CVE bit
explicitly if needed).

Thanks!

Cheers,
Miguel
