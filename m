Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078C25C8E8
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 12:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="ZCuiR87h"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-286e05d9408so439482a91.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 04:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1701779598; x=1702384398; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEIoNxF1mrTxn6HSnGvsWW6Lj8x4H49yQ7QLKLr4Log=;
        b=ZCuiR87hjtaDB/tzhqP4Jhw6I8g/PfRGKW8HXajqXkXKeqxkr/HFNBtqzEPEqN+51k
         vqR4zXU3OrgHBm1Il1NYUh8MQWWrL9Wa4bzjtkhNiPzRI8jIcNlfbt9iBkPMBiGF4Jfh
         ZYaUVY/jDI/pLHfjAZnX3/Rq6nUXA11g38STLQ0Hlrrw49+qgeYxhdEkiYVb6bbH9edI
         M0AlGnd1PxGITCO/+AaYioCfgXI9QA66zVBd3KHa5gKRrx/yerDfjFGiEeueBnXa3YaV
         EStg4edSKFSvXLvKW6oyvp6P3TIFsj6I6TwxLh6X5H71dspPGEkxfLJklOlln9M68m8Y
         1wsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701779598; x=1702384398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BEIoNxF1mrTxn6HSnGvsWW6Lj8x4H49yQ7QLKLr4Log=;
        b=ehG+5Z5rzZMpQ0Qsyg4IavmWx33ZtLdYrF5nXMYAqXmwHMkLUYGOMj+qdaH3FxSJvZ
         qnO7rxJp+M0HKPjy5HofGUuCvJF6Efww+2gdNt+O5g5Sf/S4z2j8oaARyOgQE88N5Zed
         Iut4Odne6GM3Z9g7cDBBTb5p/F/5bgvXVFN4dRRbkC5KzzyKpNp3X/07Si2B/2Hplx4S
         jzO/dCI8Jb2YGbIucVs7QHKeY+KUqCtztpYuNqfPPbs85CfU++ZeWQSj3nx5b2elAZ1G
         4nq47fiQm66xZdZ9h4jtvSBPmzpfJual/rGaUzsq86NnFY8d6vrBZmCsbti8HTLJzr2H
         esHA==
X-Gm-Message-State: AOJu0YwJzHHve0PEEnXO4ama6poAliXmgE02nAP+bY2djM1Mh8MVPD1Y
	yz135fm2Z9hnfRU1/V87vWcMisq0LCvTw77uoPk/jw==
X-Google-Smtp-Source: AGHT+IFmxCGot2OM6nlx0JyueWaxvb9J9j2G+CNFzUEiV92bxkdPmAFtiCPtGPO2TgeTJq20Tc7gU4GzYbn/pv7Fc7o=
X-Received: by 2002:a17:90b:3ec5:b0:286:6cc0:62a2 with SMTP id
 rm5-20020a17090b3ec500b002866cc062a2mr1346799pjb.33.1701779598021; Tue, 05
 Dec 2023 04:33:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205031535.163661217@linuxfoundation.org>
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 5 Dec 2023 21:33:06 +0900
Message-ID: <CAKL4bV4WEwo8bnVJcvAQEOx4yF5kcDtm_apaX6gwtRHPgM6J1Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/134] 6.6.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Dec 5, 2023 at 12:21=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.5 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.5-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
