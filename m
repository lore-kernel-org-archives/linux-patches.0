Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAEC18859F
	for <patches@lists.linux.dev>; Thu, 26 Sep 2024 21:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727385560; cv=none; b=d8t5XRSt2BvqBSTQVSb3aSYdsqIIUO9EAYEM3u5UZrYuzOPkqTBoxWa8BE5uORhx5BK7IsO8wyvwtg+Yvf2BF0SKrY2JKY7Lz9tkatrlbZBWrJzOoUNC90KgCKSqMe0LkVXtOpxGsBu/sUucMKEIWFtybdwW980xcj1+On+njDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727385560; c=relaxed/simple;
	bh=kDsArXBf6a8j6EERJV+eipbquN7VuWFS+lqT9h5+qQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MeAx7yQqx957TF/5Fm9dLD5pe2NtdTWDYrisVDfoRdsVRxe4LzTo5e/mbIr3Zo3G6moSpGkG0hT8EKRKCFZq3Om3GLvWERzgNc51Rq48sKex8Vqc2eHDt4IvNhIbvZbsLtk14FGtWdsfXtH/kBRJTJSMq/sSaNy0I7XxOaI3yAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UgY2cLwK; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UgY2cLwK"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7191f1875d3so186143b3a.0
        for <patches@lists.linux.dev>; Thu, 26 Sep 2024 14:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727385558; x=1727990358; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZT6vThl0w6DW/3vNhpd4p3yZrCiKGVkkePEpwNafr6M=;
        b=UgY2cLwK0joM/Ju9kVlwp4T+Zmrx1o2ml/rUhLtr1HEm+/56lvcPIyRa6Wb1wHNGW3
         zFd+Bm/VmI597qlH0PZ20wawfXGBYcgffEWqK01rMdtG0Pg89qxsK/zLRSUXlC4EtsMF
         2DFwMKM+D7JaLzAULMOlbbGT3xN6RGX9NIXiLm88YeMu+WfNlY7GYSGpup8S2whbufIO
         YADopiyKlKnNOve5YD0PudmWR7TirThg+MnvPLZHJFJxh9TuW7wTF0H37kWx91S6BKfx
         O5YXdlPrII6ivDJedjVit6G2Hhiu1veSjpw9wQ6DJEGag3QyHKVAEqrkTAKa059VZAr0
         enKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727385558; x=1727990358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZT6vThl0w6DW/3vNhpd4p3yZrCiKGVkkePEpwNafr6M=;
        b=T7qEmMOOatX49VWLfR6+dNLFomG2x3LRw9pKrU7Cr5+Qbh7Z5JzDKBMeulW8TDaEq9
         +aimbndCh7XFFJg2IYRXL1yho0eci644/KMSqFZY8f59r5OZTKX7qQ2FTVXNDkoB2d4/
         l0kFW0Iq7/zKgb1wP2+2wgPSs9x5cCE4u3Tlis8o2AbDTqSXVVTUEEqurCHURnVrE6NG
         hp6jisuAKg2bvVOH8O8Dq/dT0h6+QaHgGyT1tPN2/K3YiR2XDa4V3bAFUnXaXwVEb1Fp
         vo2SWVnKz200Nd9OiCxE9QOXW5OjRZ5nIFebSyU1GHW/dQxtv2H28ORl35w0iiI1eAIo
         9znQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3juBqw7HgkhNQqgcvjPIjcdQyBlP5Y9L0EcgxZiWri9z8njvnjJQinqk7vZf7ihvlLFB2s3iJ@lists.linux.dev
X-Gm-Message-State: AOJu0YyBvA53YcBKODbDBGUKOzJDXoPQV1/KiQLlaTdtjaVDlKu1CnoM
	AksmP271e2EFKzn892Udfjycxq3YRu8L/n/FTuqy/EIYSbQwDVOLyUI3fFC/jC1cBmtGd560kBP
	RAQFWgh4+UpjfTT6VDbnti7jBtNo=
X-Google-Smtp-Source: AGHT+IE4+BdZ3LfDobLEZiEw+lXACKHY9OjSMU9qsH6bL5zXt19ZyY2VBI87QSoBXPl6FJAr1a79Q74C+/jwv3zPANU=
X-Received: by 2002:a05:6a20:6a20:b0:1cf:672e:cf08 with SMTP id
 adf61e73a8af0-1d4fa78e967mr800601637.8.1727385558266; Thu, 26 Sep 2024
 14:19:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240926093849.1192264-1-aliceryhl@google.com>
In-Reply-To: <20240926093849.1192264-1-aliceryhl@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 26 Sep 2024 23:19:06 +0200
Message-ID: <CANiq72k9ihcNNRkiGW4us1F_cQuotRFA9_8iJuCMUJnEjbKzrw@mail.gmail.com>
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
> When enabling both KASAN and RETHUNK, objtool emits the following
> warnings:
>
>     rust/core.o: warning: objtool: asan.module_ctor+0x13: 'naked' return =
found in MITIGATION_RETHUNK build
>     rust/core.o: warning: objtool: asan.module_dtor+0x13: 'naked' return =
found in MITIGATION_RETHUNK build
>
> This is caused by the -Zfunction-return=3Dthunk-extern flag in rustc not
> properly informing LLVM about the mitigation, which means that the KASAN
> functions asan.module_ctor and asan.module_dtor are generated without
> the rethunk mitigation.
>
> The other mitigations that we enabled for Rust (SLS, RETPOLINE) do not
> have the same bug, as they're being applied through the target-feature
> functionality instead.
>
> This is being fixed for rustc 1.83.0, so update Kconfig to reject this
> configuration on older compilers.
>
> Link: https://github.com/rust-lang/rust/pull/130824
> Fixes: d7868550d573 ("x86/rust: support MITIGATION_RETHUNK")
> Reported-by: Miguel Ojeda <ojeda@kernel.org>
> Closes: https://lore.kernel.org/all/CANiq72myZL4_poCMuNFevtpYYc0V0embjSuK=
b7y=3DC+m3vVA_8g@mail.gmail.com/
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Applied to `rust-fixes` -- thanks!

Cheers,
Miguel
