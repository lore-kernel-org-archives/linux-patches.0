Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3A51ACDF3
	for <patches@lists.linux.dev>; Thu, 26 Sep 2024 10:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727346863; cv=none; b=eqSd8jP1nmvWt8aUSQZCpLWpFS2JRAXUp10nf/myaVs/uRYPHbsIwCu+KrVOal4IbK2K0i6rHG3W3T+tnAayUqZb6hpkjo1UWE5jZaJPhiaqpis7RawbB3p/mNwQuoyPbwE8GpLtyQeQcI/lqbV886ceoN+/mJfvuAZHMJmjpEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727346863; c=relaxed/simple;
	bh=FvK9bOmpHob78lnfVZY4lnbnpriICJ+yitRchRcmfOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EznpRl34HGKvPEvOHMPsJTfb4jTjW1P9A9LRAW5E4Zy29YN8raQESgUizfqaxbqu/ZTyaCC8iIwrJf572elI25IJNfmB5pznScdmg8FhcFtZarssVUfxKYE4SbbJkB0WCY9AeUflvwoXtmPnmD6zOztux34lek48VQdyejp65oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oqa99spk; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oqa99spk"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-718e55bca81so75277b3a.2
        for <patches@lists.linux.dev>; Thu, 26 Sep 2024 03:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727346861; x=1727951661; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FvK9bOmpHob78lnfVZY4lnbnpriICJ+yitRchRcmfOA=;
        b=Oqa99spkZCF8k95BhLdeSg3jhQditNuZOHIpSlqiH8s6q+uOopVLUaN7oNsl4s4qYq
         nWyrI4ZrtIN87ytCaYFM0s3+aK0VISnlbK6HUSU0aTyttp/EJDWQTzSHNhhzGIvpQ8Rq
         omTtimUKldqLyYqixSgvg1sflbATeblGxhzI6JINwaroSL0fKTYwXunq+2SPCX2sLVoV
         mst8DfzB4usAoFqw6Qai22uLMoIP7n2KcrvNkPmvUFOys4KPhKE4730EQdO4Txtm2yqd
         HdYs0Wx7AaV2rB98fXiFKWQG3qjSvdwu576v3bol1I+elXNDJKLO6Iwoyus/7ymvyvOI
         qclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727346861; x=1727951661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FvK9bOmpHob78lnfVZY4lnbnpriICJ+yitRchRcmfOA=;
        b=emGykh9Ze9vpgt87JRLNjlZEYfmSEJPSlw+oqle/iF3eW6RXh+9R1lALmOgyGxY5Hz
         DHdlZWWLKCDPnX5miq2rYq2a87ZHtUdvcwOK+UF1UY+GPhrtwkqFTfjq0bKxr4nei6UQ
         7J9VPJ1NNcj3bKkoUpF/tX7sfIi5o4lgegFFp7ZSEGxW5E8t52+osruMwExBAGYrhPX0
         ybFjnpv/4NXYH252eXt/6wUfPfWxNRIwdluz+gryfHpqVC31n9Y19pDNhydAOZe9USq4
         ZA2y4D+H24uKxLb7JIkt1qhqideNP8pKCJ9cN8OhXtfLh2p8YobqO9DBI5A9UYAZ2DtS
         8PFw==
X-Forwarded-Encrypted: i=1; AJvYcCXhKuA5n8C+rymHEtYwVbRQNHuaOJaue+HJL/zBoF6zKVyBrX1QaDIhntzYR8QRub+Ht5gd0fms@lists.linux.dev
X-Gm-Message-State: AOJu0YxD7uXz85CDWHM27HzPykp4G7riCldhiRqiMS8evYr2sqQx8hlz
	cXxfwMpm1iFnV1ETsFOQqsyDfR0qlOQQ2hcVKDxczN1RSDdussqTsPtL+Cy5V1FV/4XNDkRvypP
	xd3qOZH+Hj3BxB0uogptbccPpv1A=
X-Google-Smtp-Source: AGHT+IFYST7+3bz848eQMnGBwxKA6843dw8fjWPNfnAQ7+K8F2PTQLVQOR9ByqppG/f1A5mi3kwJcf61gyy/DZtuy8Y=
X-Received: by 2002:a05:6a20:1595:b0:1cf:3be6:9f89 with SMTP id
 adf61e73a8af0-1d4bed207ecmr4315211637.0.1727346861317; Thu, 26 Sep 2024
 03:34:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240926093849.1192264-1-aliceryhl@google.com>
In-Reply-To: <20240926093849.1192264-1-aliceryhl@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 26 Sep 2024 12:34:08 +0200
Message-ID: <CANiq72mGsevNqECufBo6EP8cxFd=vwcXDpVdsgts-Ve0+mPkrg@mail.gmail.com>
Subject: Re: [PATCH] rust: KASAN+RETHUNK requires rustc 1.83.0
To: Alice Ryhl <aliceryhl@google.com>
Cc: ojeda@kernel.org, a.hindborg@samsung.com, alex.gaynor@gmail.com, 
	benno.lossin@proton.me, bjorn3_gh@protonmail.com, boqun.feng@gmail.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, gary@garyguo.net, hpa@zytor.com, 
	jpoimboe@kernel.org, linux-kernel@vger.kernel.org, masahiroy@kernel.org, 
	mingo@redhat.com, nathan@kernel.org, nicolas@fjasle.eu, 
	patches@lists.linux.dev, peterz@infradead.org, rust-for-linux@vger.kernel.org, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2024 at 11:39=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> This is caused by the -Zfunction-return=3Dthunk-extern flag in rustc not
> properly informing LLVM about the mitigation, which means that the KASAN

"...not informing LLVM about the mitigation at the module level (it
does so at the function level only currently, which covers most cases,
but both are required)" or similar?

> This is being fixed for rustc 1.83.0, so update Kconfig to reject this
> configuration on older compilers.

Yeah, let's go with 1.83.0 as we said -- we can modify it if needed
later on. I think the PR is fairly straightforward so it should
probably land in that version unless there is an unknown unknown.

Thanks Alice, looks good to me.

I will take this one soon.

Cheers,
Miguel
