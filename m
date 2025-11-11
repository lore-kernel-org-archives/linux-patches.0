Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE223659F0
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 15:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762874725; cv=none; b=p8oAg6cHZAOxh9Jdm2aB3nCMdwDb6B6i9+Snbvv/dxgvPr3cjmt4Xvv0oxcfJZ9qZY2rFkNxVDVYmKO0XtPJYDKgNIwAz5Z/rTv8D/THy6l9ntfK9AbUQBHjq8V/OAydbbtOAAvY6VSzm9hZxlSmYFTqsaqqD/5Ij/hC4Sb+3c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762874725; c=relaxed/simple;
	bh=kH2n8iyTfgAxz6xqhPaYcBszdchDNAlkl6wsHl2bXLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p/Zb+Lmrwpr7EN2S7Y4w7Se4wIqFdHRuSrVbjq9gUz4eIjfTNObkj1VozW0g1zbVsVBc7Z6+KCkjPVrSvCj2q/J/V8mkkmTTOhk3qNcRndPQLpx+ogwXdvDKvryHnqsGoIKvK/QtxN/VNwTarCzuA026d7j2Kx0c9Ww9TxiFZ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CKOHfnP2; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CKOHfnP2"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-378d6fa5aebso37797101fa.2
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 07:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762874722; x=1763479522; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kH2n8iyTfgAxz6xqhPaYcBszdchDNAlkl6wsHl2bXLA=;
        b=CKOHfnP2IJoS/z/R/4CRamJnvyrL6QUbCOaoEcDnRUdMMm6v3wO/0fcPKGVqbvqlky
         rsxz3NtD90yidfEoJGClkjrY/o9Weq4jOdtpjcLii0ReEweGQwh6E9/l0IdByXKGSsZ4
         2ywpoLQEg4y23wK2xV+A9NJiXDp9RVJo24zqws9LXPfICPd+E1+SAV2lxnSA9WJlgdq6
         jVgS2QEPYMViM7hdrE832bwN8ijbmjDYEdQS277lehdQw+PI4CBYhB5PoZwLIzRP6tN9
         e4Og1aasxmYW/BVh8RMitGbh1yycaHq3DQo4BYX5Kzwyk9WTNAeGxnM4Jlc8i58j3pIh
         3SXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762874722; x=1763479522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kH2n8iyTfgAxz6xqhPaYcBszdchDNAlkl6wsHl2bXLA=;
        b=XaNGeIYNnnu5uUsJ4OtLCvelui7Mb1cG5VRwSIxWkyArUOsiWXwxD51/6+KLC9HS01
         bQ3YLN2jKT99AZbQau9eKw22gdYU5eZa6SJ/C0Ioo4IxFfqFL3096NkptYUi8gW/MgC/
         UeQUnFcQOg1pS8AD73giaf89DOk2fFc2H17GiujJ/SsijePI1yWEQzxCbEwYbdwP6oA9
         N/woIPC76ltf0SHmPvhFnRMt+/Ism+XwmgLEbiWh0PLGEZmzV3SUpnEw8hFQQL34ul5f
         JlTemyu2MTtuY6OYVEWZIU2bipA9UZet4FmLbKe3w009LCFkWBRM5m+HE/CT5oom0QvQ
         TVDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDoULrWx5yXCzzKd7xzEFE5HndMDCF5EdkhRHZqaIMzm4p4Bkz0bdfr1q7U826YrLJTQNqgQHC@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1Is+UILKoOeV0cWDOyayhdmS96j1a+I5ANfUd3jaPc6BpuOWD
	PViMAcCdUZYaUGI8CY6DqykJsQDmyhuD07SXWKvAFprFB73kLYd8zBQQQWlCe/VlijBBWXyayVJ
	LaFN+ndrtKJ1Gd5kXGftr0MCoj9SO70s=
X-Gm-Gg: ASbGnctIfDIQEzMeP0WuyKod8kbeHh4nbDZOnU0PuAVTl90W1TSKdzmHhnuKf3hceNF
	u61sB8RIlpVsXcMthB4InqpJAsohgMh4/oRM9Ef8V1Eou8qg0oxyFEeKRMVvoVmVn5vwH+5UPwv
	+mhB0dmUZeF5lLGAwJ5zCyMb+2I/uc2N1IXFkdE1+a3+hVmMdaRN2bUTS81eV+o/T1zaJxHSqh7
	rYetEWB80Cmc3oySqyuCtBN1UWqfLJqetXa36eSjrzRtGUOZCcpYU7Acdxl5tqgWSwfBpTssg==
X-Google-Smtp-Source: AGHT+IELN2Wzp2bTqYWDhcQjlFtX9DA00ce12BJNW8cO2c8JdiyexJqlAubB4Ie5Gjviyerq6QZ+GfCfwjPRPrxTi4A=
X-Received: by 2002:a05:651c:f06:b0:37a:7c41:79e with SMTP id
 38308e7fff4ca-37a7c410bf5mr32947351fa.13.1762874721655; Tue, 11 Nov 2025
 07:25:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110131913.1789896-1-ojeda@kernel.org> <CANiq72mjFobjfQEtNvk9aA+757RkLpcfmCCEJAH69ZYsr67GdA@mail.gmail.com>
In-Reply-To: <CANiq72mjFobjfQEtNvk9aA+757RkLpcfmCCEJAH69ZYsr67GdA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Tue, 11 Nov 2025 16:24:45 +0100
X-Gm-Features: AWmQ_bl70oXfEo-1yQ9VfgUdYtwxWC_v2530llNoS_lks6MxxMHeFjNTi0L0Vkg
Message-ID: <CA+icZUVcHfLru9SRfhNGToiRmyOY+fLw-ASEvQakZYfU1Kxq4g@mail.gmail.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, linux-modules@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 2:58=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
...
>
> I will send a couple other fixes to Linus this week, so if nobody
> shouts, I will be picking this one.
>

Hi Miguel, Hi Sami,

I switched over to gendwarfksyms in the very early testing days.
Faster builds. DWARFv5 fan.

And was using v5 of Sami's patchset against Linux v6.12 as it cleanly appli=
ed.

Last week, I jumped over to Linux v6.17.6 and the next testing will be
Linux v6.18-rc5+ (upcoming next LTS kernel-version).

I will try this patch - might be you will get a Tested-by.

Best regards,
-Sedat-
