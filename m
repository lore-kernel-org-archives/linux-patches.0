Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC08D1AD411
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 11:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723809382; cv=none; b=cs7Rw1B6RHwM2A7N/JdArNEuOk7n6h4NvN6Jc2BNcr26bMN9V5igh0iisL/iNqw0HghHSE24JILuXy/c1Qk1+N8UIr9fJW0+2dVpXGvhZfVssr/H3WTF+QcPgvy4gz4iFYip63I7nYa9KO1zEGLCcb1kPuxhHhPGFJPS7eGImNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723809382; c=relaxed/simple;
	bh=D4nKS/yjD2pHvtewgQqkHUg/tkdKA3kStDkmEStwIWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MFvNXKzWOVb/kvQpGSH3hJyDszZxBgvPp2S6tnvwJHkGlcrl8Q3qjGzNBOiEvJmKJX+vCUaekWFaiSeGRrLmUxcam5o16834vvQeIkE0npb3jFNhO8DrpyE3Ih2cuzxQtcfSGCnft8Jm5luYriCxeaikmpgpVh2pyxCMtHIAdaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=DD1qznTJ; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="DD1qznTJ"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3718706cf8aso1080555f8f.3
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 04:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1723809378; x=1724414178; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9suHjmHKgK99ZzlX9eSnvMS4iKAMzmcKW3ySCj8XS8=;
        b=DD1qznTJ4AQ5CNB9FX9cD+usIw38KNYE4OnTyJJQG475VZL2PSA/8DKi8D6TrKywk7
         9Js6HeQ6p8XdXAeVN9ShaI7fZ0K07zzZ8Q4ELSioP4/l0Y1VgTgwVuC8V3lizX9awklg
         OSDykdxWyd9Y6MpOdU4qOqSq1NrkGHhkscakyIdxB1eITrbvo/cAyTeAjHitKFaMiNHl
         jq1WU4jptAz786e/tngtuQzVcyhx4/oPxHEULeGanRVHIPCiHDUvQee54HusMkb5cUcr
         HW2g7Kixoh5GoqF9LLJeanYRxBq3ulIEQYd3cZynGl9n1cKhPl5lAkEEV0TLjGdEa3o7
         ExIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723809378; x=1724414178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z9suHjmHKgK99ZzlX9eSnvMS4iKAMzmcKW3ySCj8XS8=;
        b=MumYextnnZ+JROxyXkSjh0rOFXKknNzTVQ4hQ8b6X6j229HcVgKaB7pvEBTWU9sjnw
         S4donB28k5CP/7wMS/mB8St1w0gVYfwSguiOY0XrA2/u7Njya2HV9vTfVIj+TdXs5qkR
         GB1mBj9u8tZPZ5OoQ9fWfLjmAiGgice21bH0LX6zy8BwbPo77lTfpAOytA88xhbAh1We
         vFj87j1dfqJquOzEnfn6YK0TUtik0TtiZTfSmVlRrUEhZ1vRbCfuNzC8nLnQcRsS3yWW
         KLJ4U+00ex/RyTfyG+aukUm+4oPV/YVqbEAtlNRrMAnWozUYsKrPjDtQBJVm38NUkC9R
         s63Q==
X-Forwarded-Encrypted: i=1; AJvYcCUGRHzLuZXrhWQg404obo7yMk5i+AZgPH1yAlzNRl4Ng0TN25LKvWXEidhl0ntaFvX+GHeKAL/J@lists.linux.dev
X-Gm-Message-State: AOJu0YyKr+CVI2/fImIRcHaUQMa93WsdAnbz+hZBdZcoaLxM/pQVQfgq
	yYDls8Wm1nR+FyF2DPNgGFPiQADK21G7jM/irX28WXfvfmS+WU/QOdPJnwVRSVZCVOQU69OFRZ7
	wIwToKQffXApfQ4AqcKCpkxAxPa1kSU4VerPkO7f8soMsKPYCBAx4bA==
X-Google-Smtp-Source: AGHT+IHPDhhIr/7vN8snqpMY5o0ZtPpSGQ7K70xweLfVNy26r4EgEucpC8K/BV94ZejpCF7uxoOQQluLQX1kcd4qVEs=
X-Received: by 2002:a5d:694a:0:b0:368:31c7:19d3 with SMTP id
 ffacd0b85a97d-3719431e723mr1668359f8f.9.1723809377805; Fri, 16 Aug 2024
 04:56:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240815131838.311442229@linuxfoundation.org>
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 16 Aug 2024 20:56:06 +0900
Message-ID: <CAKL4bV4f72Fb06ToaahCNKPk7ep2cPOCBPbmLvbgtBE6mz3JCA@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/67] 6.6.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Aug 15, 2024 at 11:11=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.47 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.47-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.47-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.47-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240805, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Fri Aug 16 19:48:25 JST 2024

Thanks
