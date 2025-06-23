Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566B11E521E
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 21:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713839; cv=none; b=gFOjZOGDoz0PJtXpYkEu5v60YpkylzDAV3FvuAqltLdVjW4VJpidWGlWigAYvoux98zST7ZtLlnDCcYTgYrW3tM8+jgWB/x7J9NAXHxsne067IAjJnyVp79w03UtjmzNcqFOPVkcBg/N0WRvOJ4/1gJL9r/hgGUaaqq2H9Ytqlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713839; c=relaxed/simple;
	bh=/Kg0WRXw5VKnsXhRWYSpnatlSaD/D8BnYoR5CRjJ7wQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=thd7p7L9BdWfijBCrmXB/LME7GcY5peEGIn9UXIUleLaMhDjZp5FRtaSKuVt0vrLUHEIc/o0AUL5UF4p0mOLMJm7X/SBnos4ja1EeX99BWXKJgjuf1RVZtLQ1j+XHl+382v9ddcLZ3pSlprhS88L998Ey0YbcShGdzrkRDcJ0zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RNBip7ki; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RNBip7ki"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b31d578e774so3289097a12.1
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 14:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750713836; x=1751318636; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=By+WfrXAyPyITn9F5TDk+hwemNBoK/rCwALmacNE1Jk=;
        b=RNBip7ki/xcQUB1awnbcfp5d7WktSraeqNplzQedqH0mA1MzDW5CITXFoFoSVx/k+1
         C/5tdYW1AuuZys5s/ENOXCiOcSyALNvl7c+CEXb7ji5BIW4fH6vP2MOwPdb5uPXLRsQI
         37UcpIc7HL2QqmJ4ya5aQUGv/HNrnQUMXt2Gejt2BFY4dhMWIH1jYtIOpR05EDESM9tS
         iwC+8m4uXNeBrrvwkMZsGKQeayFr/amzFcs49Ngz3b62cgi0TScgm0zM7Yf+rPZ8/kd0
         OX/dFYxKLsvmNMFm+ybwZrNQsyosQyHCqxRbC2cgxARnTLwr1m1ZlQrRLplx4gsAHlpx
         GUpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750713837; x=1751318637;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=By+WfrXAyPyITn9F5TDk+hwemNBoK/rCwALmacNE1Jk=;
        b=uKqNh4eexA5EO1n3Fubj+SJxEO3UbRkSJIi3wjFxLGEZc/YATAxWoVMZe4dMxfoTh3
         zygQCo5RpO9uYmQUtl3kynUUyjG9DL7WK03P4HAbgLrqnYZc+/HntowCo+gwCMFR+lra
         cYFhSdd8+Mmc+fAzqyv7UwH750E3Imv9gR5a6tdOYi+IzLsXmIgp/1aLVAYcUjA7aNR9
         j72RRP4EDQt19bHl9fastL0njGG3mpEaK8EWDTyLzCvEl3879UHO9cH7LNuQhBKFfQxQ
         svzlF6gv1E4hJFd4K4mpb9xIqrGwXFIa+385FmkcYS5xGlT8YO0W2aVP30Gq55qkylLA
         v36g==
X-Forwarded-Encrypted: i=1; AJvYcCWHsgNLbdv+eA4jAvMErU0WUv/gAE8g4n6jYk/v0TQuc/s6uxX0Qsxh8UqUI48XVOXF3zOhp05M@lists.linux.dev
X-Gm-Message-State: AOJu0YzjfE30zk9BV5okCbfiGIRHQ4Gc/iMLerCg50Gm5VwHRAerJJGG
	7PuDYSCab4DIwKY7Q3nTlt9s+y+Efqh4XlUX6HzVEfMYdBKeYoi9l2GHyV9B8tGDDyaOQvtDwzo
	43A3/qK1u3RjVa/b3z+Gol1wOBAefY4X1gODBP05utQ==
X-Gm-Gg: ASbGncuCzSZURwBE3ZuIQt7xylIxvEMSX7pLUHuLC6gCMyzA08mC85y7ambwTubP68s
	m5KKPkCit6h9zeLGENopqrhJl5Tr5/PEKJ9c62DOLyigpz99U2i82UHT+R56UYDICUAQT5Y8Ymq
	gPzuhtKcDeExhvqWH3Dx5yahIDqfgq9rk6XiyzmQFJfvzLifiLzrh+FUzK13StRh7mMogEgJ0rf
	Bwl
X-Google-Smtp-Source: AGHT+IHJlRRLWWoQ6yh3AeFZC83NODh6v6Ss+DAN43JkjEBbpOfz48bjecKNoDN25759ZXlyzX8KWTWbCxW22IU+1EE=
X-Received: by 2002:a17:90b:38c9:b0:313:f995:91cc with SMTP id
 98e67ed59e1d1-315ccc32116mr1516367a91.2.1750713835691; Mon, 23 Jun 2025
 14:23:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250623130626.910356556@linuxfoundation.org>
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 24 Jun 2025 02:53:43 +0530
X-Gm-Features: Ac12FXzeAzIXRWJ7lKN4j0ifqWtMYFRuT9M7G2PFqIjYGj7Dh1wwE6lAMfMxRVY
Message-ID: <CA+G9fYtROQg1rpX_6uG-AYktDOHqaEzEPVvL9Fxi9mQfLy6zBQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/290] 6.6.95-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Jun 2025 at 18:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.95 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jun 2025 13:05:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.95-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on parisc, s390 allmodconfig builds with gcc-13 and gcc-11 failed on
the Linux stable-rc 6.6.95-rc1.

Regressions found on s390
* parisc, build
  - gcc-11-allmodconfig

* s390, build
  - gcc-13-allmodconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: stable-rc 6.6.95-rc1 s390 parisc allmodconfig
sdhci-esdhc-imx.c 'sdhc_esdhc_tuning_restore' defined but not used

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build errors
drivers/mmc/host/sdhci-esdhc-imx.c:1571:13: error:
'sdhc_esdhc_tuning_restore' defined but not used
[-Werror=unused-function]
 1571 | static void sdhc_esdhc_tuning_restore(struct sdhci_host *host)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~
drivers/mmc/host/sdhci-esdhc-imx.c:1549:13: error:
'sdhc_esdhc_tuning_save' defined but not used
[-Werror=unused-function]
 1549 | static void sdhc_esdhc_tuning_save(struct sdhci_host *host)
      |             ^~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

## Source
* Kernel version: 6.6.95-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: 44f41e69469d0de714a6e7e56848c3e423ac2bb9
* Git describe: v6.6.94-291-g44f41e69469d
* Project details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.6.y/v6.6.94-291-g44f41e69469d/
* Architectures: parisc, s390
* Toolchains: gcc-11, gcc-13
* Kconfigs: allmodconfig

## Build s390
* Build log: https://qa-reports.linaro.org/api/testruns/28839625/log_file/
* Build details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.6.y/v6.6.94-291-g44f41e69469d/build/gcc-13-allmodconfig/
* Build link:  https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYHPJ5UcFEMxXVXUOIqaCBQWP/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYHPJ5UcFEMxXVXUOIqaCBQWP/config

## Steps to reproduce
  - tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
--kconfig allmodconfig

--
Linaro LKFT
https://lkft.linaro.org
