Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E9E156253
	for <patches@lists.linux.dev>; Wed, 15 May 2024 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715790070; cv=none; b=rGiHxPqUk/vRd739HI/Wcmdn0NfhY+dQqWY192etUkY6fW2V3c89m8CKx3ScUlf27Rbv/H+tIeWE98NviHyUskSyPvRw3p/1Wuf713Iq0entbmVSR0RsOci374iccsAupZrRX+AmhIxWUcSELDiJQI1aPzUW6rlcI3gyWy+bDwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715790070; c=relaxed/simple;
	bh=VTAKupd41+vwdD2+AAdWUtgNtPv+N5S8/ZucUcvM7XI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EWvj3qCO1rn5C8lzNzqhuwwoKOKxBWIL8YSerLh8rg4TPyVbOQh23c3Lr25Q+VXcxlky8aNlxxDzYkSg62eIqQv9y69JOHOK5zsRUl/ng+4zHfSuQpRxKCIEP3kN8xGhXAQZkn6dsv+OmylWcve0OpdQlR/YW+UQZJr2j0tPgmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IcMhzKzL; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IcMhzKzL"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2e576057c2bso73528941fa.1
        for <patches@lists.linux.dev>; Wed, 15 May 2024 09:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715790067; x=1716394867; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VZ4/RopXS5f2WiCBIMNF7eOCyIDKJ+KDv3FhPq2DLoA=;
        b=IcMhzKzL1NAUFKECb9jIS7hrT4V6ClgygAVRFjjWFB8dRS/IJXIdLJCeJvCjf2x6P7
         6ZRK1yXxqxWHfeZrMXHQD2LX1c83D9a5h4GQfnaVvKosNVTKfiMeUsRGgR7ELOqDk/sH
         MXVp999C7w9RxqlZExzzBLioeITwb6EayW2SA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715790067; x=1716394867;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VZ4/RopXS5f2WiCBIMNF7eOCyIDKJ+KDv3FhPq2DLoA=;
        b=VyfiUUfprHO3QYQGeqTZn2DKdbZ6JxluVp2mFmOpFZRChv3RGbpBR+s5QIMvu7t4Rp
         Z3qjFJhxo4J2xriD2wdfXfWBtFmbrIhq2+ZIJQkmEbe12CU8CurdgMbOPHAk/Zz9Lpaj
         Z9oC2gqK9w4zNznGdqSDHPy070wX226gY5NZJnU9qpgNWSmBQ/BY9shfpx+F8VgmBfxb
         yG/WjYsam8pZdSFJkJCG5ITjUA2bW/FAAEG7kVJuvXtz7icNhxx3vBs1HJ66Ioi05Igy
         4x2JzTkwgqU0A+SOPn0iH5e1A7bwPhEHuCicEM0BgajiTjI6NQpOzb3GbRcA6utxBn93
         mDog==
X-Forwarded-Encrypted: i=1; AJvYcCX6NHzfgKo9ZpMws5yoqkN/PONVnm7bMu4aHBOr0ySsO9qWQuRYPqbXQbAcyMzWZ2N6ZAdOtWz434O/6ZX4gFsDIBqLj27Hww==
X-Gm-Message-State: AOJu0YxNI4cbgtKf8+5N1Qs3lmKN819ScONiO88WUbnMRNY1I3GatrNi
	NoVv7uhKoNuT3+KqudnCzzRTp0+f/WonqR+9WAhGItweRGvDQnYcuAJo4cYQ289I7SbjnZHdXqi
	ywUflbQ==
X-Google-Smtp-Source: AGHT+IHA4zBSyQKKipXhI+Dwur7+zKGvaB+CIQ44iut6S9Rxu4zj3xdzntvS+ilsNx1/54T0gbENHw==
X-Received: by 2002:a2e:b002:0:b0:2db:a9c9:4c5e with SMTP id 38308e7fff4ca-2e51fd47edfmr162731581fa.21.1715790066823;
        Wed, 15 May 2024 09:21:06 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2e4d0ce3241sm20642011fa.39.2024.05.15.09.21.05
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 09:21:05 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-523b017a5c6so214986e87.1
        for <patches@lists.linux.dev>; Wed, 15 May 2024 09:21:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWvODAaEID+RN25XwD/B5OHZoCcS62Cp5TH+iZvpWnToSOzGlfbd1iEwObYIBv42QEE6WqQuAC2qcKKQzYSb0DBfyqO6jqU3g==
X-Received: by 2002:ac2:5f59:0:b0:521:92f6:3d34 with SMTP id
 2adb3069b0e04-5220fd7c838mr12720657e87.22.1715790065107; Wed, 15 May 2024
 09:21:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240515082456.986812732@linuxfoundation.org> <39483cfc-4345-4fbd-87c2-9d618c6fdbc6@sirena.org.uk>
In-Reply-To: <39483cfc-4345-4fbd-87c2-9d618c6fdbc6@sirena.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 May 2024 09:20:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjntFiQ=mM-zDHTMnrqki3MN3+6aSXhjnJozBaKqLLUDQ@mail.gmail.com>
Message-ID: <CAHk-=wjntFiQ=mM-zDHTMnrqki3MN3+6aSXhjnJozBaKqLLUDQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/243] 6.1.91-rc2 review
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	Florian Fainelli <florian.fainelli@broadcom.com>, Doug Berger <opendmb@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 15 May 2024 at 09:17, Mark Brown <broonie@kernel.org> wrote:
>
>     A bisect claims that "net: bcmgenet:
> synchronize EXT_RGMII_OOB_CTRL access" is the first commit that breaks,
> I'm not seeing issues with other stables.

That's d85cf67a3396 ("net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL
access") upstream. Is upstream ok?

                 Linus
