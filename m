Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C44722DFA3
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 16:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756225987; cv=none; b=h3+8/l1HXsanGZ8ApU3ccYAlDeK7BabEdDMVDAv/GamubNMB41l8nARAb1N0Pw7Dxkt8EnxwpMiHwKC3GL0L3IWhqYEAUtraWItesLRYwp3wQ9XsDgxn8NCFbuWJoYZbG4mKFEO630K1Zf3oC2CLNNSRI/Z4cZ8tCRhN43MD1xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756225987; c=relaxed/simple;
	bh=H3Y4RLs11uiIa5i47Ko7Tki/FNZ/WkWqgwFmBSqB9ko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NdblNEAY2wK3pSGwceKwZUX8BnEXv74byHOc6dY3G2h4kgxgBVtucYXlLWPuYRJaHXvfglNVD1W7su6K6dpkYdVwNnnk3FPtbfIQGVYP45dziUuIg+FtesdcH3dShjPbEgtHx3WY1FGepgTD8U7i06ZwUvJau8I56pYOx6j6ZAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d2sk9/Dy; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2sk9/Dy"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3366be380e9so21591541fa.1
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 09:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756225983; x=1756830783; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=td+yL+G/QnImAGiUXt18toN6ra99vbmvbvRznOwe9oE=;
        b=d2sk9/DynMfB6W9MAuTY4YFkQMQUJM5nTXDlP5RB5qayH3dK2ciCdWNjIHjGJCeXMy
         SmojV4CmtgBU9hnD4temdO1G60lsRUSustOzZElWSWFDjQw2Fkp3hffbK3Md09kppLsQ
         42TQizx28L9EQASnsmokWQpXeRUakWyo2RyoM6rm380R6NS9aIX3jf/UZ9PsCYD1OFYH
         MW2XHgqVN2l2BoFAy2J56C/Kkgab3qTHWY3oTH5t4vTlFnKlK6yqiW3p/ywnFEIuBNM7
         1zRSVnhGTT7d1W/wQtoYg7XJ2jwK0weoupu+tw8kQon+O8F9bqA94VRECLYq2Ihk3BuV
         QUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756225983; x=1756830783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=td+yL+G/QnImAGiUXt18toN6ra99vbmvbvRznOwe9oE=;
        b=E1bR20/uT4sOTRW6XX6Ccl9GijgpuwmUY4fH+tysrO/VjmyjU7/wzxzyO9LZHXe15T
         eMSc7VbqlA6ckmyP/CaD90OKazCZ2cskPBynsoYUOs5VPgu3HTK5dOBUtvbMcA4Ag1jL
         prMbMDBUCZY0+40J2WZp5t6gS35LoQsf6vrcAB2nLUaLVVzUo5X+OoGkdRNvGNXBKAKf
         1ZeyTRgLIvCf+CjVWyiYB6P0Wad/kE7L71soa6PMqA/aVA2kctlpo3G+Zht/+rULE07/
         wPchBi4acUrfPPKhDuvjzcM6jNwRJNft5qFQZoQfCfwH9B/T4QMX6Yu3CMLV3onz5Crb
         BwCA==
X-Forwarded-Encrypted: i=1; AJvYcCUB0G7daH+eNf/sLnHrmV9pen/lpNr1+h63GYBekRMTwWBqWH+qGpdzWms54uTBPWE8FMdKAmvS@lists.linux.dev
X-Gm-Message-State: AOJu0YxjiSspIBD/wnMZQ1dB8GaON9th+KtQsd9xjLeB+D06rdIFgfbE
	MAIQxWp4GW50jMkH5DwoVEroKOi9sqG4Z+99LIK5T1UGyNEnguz9dfmG6ku3NGmtxzo+Xg9PyZ8
	Tv5BKpeJWyO/fCpfxoKvvZNPJXxq6yqA=
X-Gm-Gg: ASbGnct7BLxJmgpURRLj1nsgh0+QAzucGcnJGHsSKtf+7TQa1pZ3mQF7wJGRBQcLH68
	DjxCYu3bENeAqWQqarkHcy98fLJOZDCI7Z6LuhYLslUCd9SV8C6aZ4p+nbt+5TNtH1pIClsS9Lm
	NfT21Ne5unWSisE6fDKPbmAJbRRrTmR+xd/CHIxG3Rzd9HECWPFBluEtWBzirW8y5PfDwRmHvhx
	ZuzOI7R+iC63qvpZ2CbxSGta1VwfoKWyRtWzMn1fF45nTxM44eS7xXv5RPwSS7CypzXXRzB
X-Google-Smtp-Source: AGHT+IH7CuzSpIj44VJr0hHFBbY5rjYgaTjZyN5HnnlHP6u47THUmC0DBE97XhgsPwXUTNSqeI9QAA45WIJj8l4vDUo=
X-Received: by 2002:a2e:be92:0:b0:331:f04d:e689 with SMTP id
 38308e7fff4ca-33650fc8436mr45773971fa.41.1756225982681; Tue, 26 Aug 2025
 09:33:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826110937.289866482@linuxfoundation.org>
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Tue, 26 Aug 2025 22:02:51 +0530
X-Gm-Features: Ac12FXzJlB4rzlOVUnLB_NTF-wRXJyVMNP9aIko-gLEuAfsPSsFz00NUtJUhctI
Message-ID: <CAC-m1rqahZ7=BoFcSAoZJdhAHHeen-+ZKUEm+aQsYyqA2ZO8+Q@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 4:44=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.4 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build and boot tested 6.16.4-rc1 using qemu-x86_64. The kernel was
successfully built and booted in a virtualized environment without
issues.

Tested-by: Dileep Malepu <dileep.debian@gmail.com>
