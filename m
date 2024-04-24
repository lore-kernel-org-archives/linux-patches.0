Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1222174425
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 19:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713986950; cv=none; b=PwUb7al79QBUMUItPDtuR3u/kiQ4Sc4gmCVTESrSolw/2n0MA3Ot0pd2GaRiLpkIorREX1DXML2BD9vHV8T3DgE9o+WCybzCRKj8jmf0UgyPkTIJmv8zfpJK7QEP2lDbFgRsspGHWZWcroJK+O3ZTKJJYx/IKPQeZISyA4eA4/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713986950; c=relaxed/simple;
	bh=JRgPzzH/fUdn/O1GrRi+kxCDdF4o2Jgz/8RWeLVXu70=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rqhHnsxCaVO5dVzdRNgCBfUEDBvW58xOabYhFWb8NEZLF9hzHYKsVriptaQl+0baEEMIP9AvAOIRG4iAxmK76f6MNEpZQjZwzXpBT4bopmhxZh3ZQF5Ds2Gs+Ze5Y2BaynGzG+71XCHG0WLLVKBesjXBBB24LLRVRYgi8rvSvf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NN5MVWsi; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NN5MVWsi"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-571bddddbc2so178295a12.1
        for <patches@lists.linux.dev>; Wed, 24 Apr 2024 12:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713986946; x=1714591746; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRgPzzH/fUdn/O1GrRi+kxCDdF4o2Jgz/8RWeLVXu70=;
        b=NN5MVWsiTptkFiI/MxHpFnJd2PBQT+jRvdzy9yM3xNQaFIzsnjQmkksgU6pAwjw0Hh
         mYwzxgrPcXVTfLp/788VELxvphIA3EShVdP+6kh0yyj5ovbLYKTiX84BXOvEJhfS00YC
         6mqsgbLSG+Q/pkzlwiHFgEyhb+Pz4v/rWEs2GIdhv8+GgPx1UM4A5Dwsb7fPh61UfGDY
         p8uytxC2Coh6QH4FI+aJ1BkkG5gKiriOwm779S40I+H0yD1MvjeCZoM8fH4co3m3e6s2
         5iHq+RNWVAKTOA0jjAcpwkuysTi1127H490MiHIg8hp0DOzt/UkH7Ag8GOArHaIyHdtT
         4i+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713986946; x=1714591746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JRgPzzH/fUdn/O1GrRi+kxCDdF4o2Jgz/8RWeLVXu70=;
        b=o4O+z0I/CC211qNHVAnutfpFVI/n5ee7tKgK1yut9J8gTqg+GeDwCe7+ozWZxtC4FY
         Q+8edHQqa4DoHCACCTFN4BBnedQDfJr9gRuOD8F1TlFDGxAqzwWnIwbDkRfF7WR17Dcd
         f1ZTn84Viwd9/hrwmvw07CEZ5opWMkeIPgF5dVCExXPZGvPiqCZqP1tr2kHyAHh7ABw9
         2u0D6D25b+Ucx6FAu78PKP14ia3s/KR0h9hYBGgcSN7gP2kp1Zvq2ejzW6ZgadovAjeK
         VxrbOB0Xs/bnIr9oRQmFpLdixI6jyRybwSR1C51jKTb5l0hetGLmhqXac4h0yLuZQghN
         skJw==
X-Forwarded-Encrypted: i=1; AJvYcCV/2MmSVSWXLaxFau/cmBTsQguHOjfPhWzl6V0TvReb4OGv1cSC4Mn1rSDhm2Lm1hI5WE9VGkjEbpGAGjJUjgxWq5a5+IV1IQ==
X-Gm-Message-State: AOJu0Yy/yO/6gH9omK2Do7ZYZwZqqnSTEMQaRwIZ0A/dgrf3JLWglfjC
	0Wy+bX1V07PIZ8eoPrXcj+qrY7FHz0/EpiraaLMSCrORDxiYBAuni7/fFCZySfAHWaDfdH4btlZ
	S64+vwaYFhKchEkQvqROPNz02YmQ=
X-Google-Smtp-Source: AGHT+IG97Op9uh3XQx6nVCuZMD0+FdWgvvNu8K31rLDAtl5o1qOtmACvdr/IrrK+2QolFc1YQAbMP9dA6WkYMxje9mc=
X-Received: by 2002:a17:906:91c8:b0:a52:58a7:11cf with SMTP id
 b8-20020a17090691c800b00a5258a711cfmr2427662ejx.2.1713986946153; Wed, 24 Apr
 2024 12:29:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240424181245.41141-1-tony.luck@intel.com> <20240424181523.42023-1-tony.luck@intel.com>
In-Reply-To: <20240424181523.42023-1-tony.luck@intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 24 Apr 2024 22:28:29 +0300
Message-ID: <CAHp75Vea8OoJ6cb64B1M-2QLCguXNUze=QSjyWKEOKd7VBsAaA@mail.gmail.com>
Subject: Re: [PATCH v4 45/71] x86/platform/intel-mid: Switch to new Intel CPU
 model defines
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2024 at 9:15=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
>
> New CPU #defines encode vendor and family as well as model.

Acked-by: Andy Shevchenko <andy@kernel.org>

--=20
With Best Regards,
Andy Shevchenko
