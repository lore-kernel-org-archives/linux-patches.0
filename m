Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1817D3CBE61
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 16:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773160900; cv=pass; b=k4ff/h5hMG3pvJZUzQz7/fgx5Y5CV+8WoGwck+77ACGnDT6sjxAYdYxPKbCVOH9DOkJ1b0QzkJ2Pt4nxZdLceh0ayvmTBLbVxgiUkGYBM0YKS7bLqnPyPAnk/KgrD2sc9R5xXss1+jbAqmgl0SMqgtX7GPXSMrS27KYvbpFDvdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773160900; c=relaxed/simple;
	bh=vixX6Dc3Q9WP7tV+fEqTxw8jj8V6gNxpqt7wigSUBhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RaHiVFQ3dPSkt5nfz9VrbHQdj6pwZ7nigSXBzfB7vL+RFdanqH8gqykpyoLmNtuuWCICZfOQWeNV15toDzTDHwXb8Wq3YDAMR+3pO1uwk/JdfZPV15qb8Zh17wFGcZMyc96xSvDOxtU64FFjASgNtpYaWveZX2K+2waI5sc08ro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CHBDR/gm; arc=pass smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CHBDR/gm"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-38a32d36396so893241fa.0
        for <patches@lists.linux.dev>; Tue, 10 Mar 2026 09:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773160896; cv=none;
        d=google.com; s=arc-20240605;
        b=PsDk1brvLd5wHzjb1mvsjNJXNIvs/qLTywRrLKaEAQU6IHwKqgrFo6MSRov6E9v+8u
         dCcRYWVasCj12VktLmpPxvZZWvhe0YouyhFAYSm1obQ2ftQPaLQTR5y+Tc0g6Nd8CkIm
         Xhq+ZorFhpaKhW7np85M68DcNwpvgrDuktlXfE/ADXf/XmkkoRcsAswb/XyABdlNYudW
         icE3YYe35QvI52GsP4P15vsKrf9+70O64Ds08rRwW/+1K/GzLeSsOxMK4VO4jC1NDcyZ
         tco8r7unmLIT0nRbMMFk1ev21Y4nJjWbwgVW9qSkmEkd7p1jN2081nP/yfq1AuVkVJVH
         UEqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QG7J9WrHoi2w0LhiwMhBEiBaEQuED+1kWKvjB3SLjzQ=;
        fh=C7qSXFeg3p36KrVl4ZuEPDqxAdfLLIsGN9PqRhjxKV0=;
        b=NpOnL1Koe56e4L9k35bF5cyX3dYlOA/CCqJzHt0HJcBQcJY9UaIOpYwweXNqRrKtlS
         YJlFGufqw0wLFhMnZs6TS4g0pa1I8VzsY6d4rtVoio6n2R8zrBqHqgxsx/kz7OBCR0fY
         ryItrL9yyVvrfFG87hfcpyMnAApNr2oIxPSkUdoMCNlYeOCMof2HQIaINiayjDdj3KCl
         b+DursrU+PmYavgL3AEfG8jgiMso8YxWyB8sndSFUnpS6eZE6gkvZaIowkLtWe5b2xtE
         Ig9I/8gl4xIUw4SIjvXV3kC44Fr58YeDJiLUF1DsJhvCQOJPVp/cZD8OTllHQd61miYp
         /2Eg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773160896; x=1773765696; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QG7J9WrHoi2w0LhiwMhBEiBaEQuED+1kWKvjB3SLjzQ=;
        b=CHBDR/gmDOwaMLxP7ALXWKEmI4O/Kl0gbViJGTCDzyd5EH9RoxIqFj3ca+axl/Ighg
         2kXjRNoD260mekkBpwwsSOYoR7k/9W/bctQXPNlfVvoGlewYNXok2AojGT97eQE/GoPA
         ZbTs++IqgrlYPh167PWUpTT4plpUL4oOf06OvYM8EcGLOF4l2wZdUixGN6HNtiFYLvV2
         LUOpFR/VtTSQmbIlASNVKYQ/+KAhDz0zzAFSk5xgLmThgk5JqFcw6TqHCqRYtE02n2YI
         /gDapjkagTbmYU5hklpJnXKkq5kcXKw1SLoqphWuZnEg8aHK5H9TEonMBcazpPnA+A0h
         eWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773160896; x=1773765696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QG7J9WrHoi2w0LhiwMhBEiBaEQuED+1kWKvjB3SLjzQ=;
        b=ILImGblU60jo5+PrHOiLJibcTbFgPh77FYkZxDjtNqpCaUhZxjek94glY0DocqXJZz
         1PuS1XQgoQuH2fLZumMaWJexNKPfS1XlyJwCViq+bBRPtt63LeIzGrLio7cpu664ocz1
         xwCCt8duNuf1MakFKC/C7CpJfEcNQ71o0h4s7FI/clZRDbcR7DKi75g2oTU2cmBCI+kn
         dIh99R2am30n4nK5Ql0rpneq1ZUWaJQ3qvrb2Gqws/oQDAEKmXYdNPn0CrhEJaijTwQp
         yUFbPbp9J+DOdOMXLzhYwk56N3TJQiWgXldyidstb9MGmXgsAhUFofXB0DoDxWPxBEjE
         E4/A==
X-Forwarded-Encrypted: i=1; AJvYcCWcHcqQWW3lw2CuAAd0uzeaN72Jsf1cIWphh3HeHiYB5zekiO2G3e4cHocht1JP9nQ5GBAFHnNO@lists.linux.dev
X-Gm-Message-State: AOJu0YwFo510ss8g88EtfRE6/5eUGTZZ5QhAKsIVS6HYZfs+PArDuehh
	BEevTRA/4VEJoI+k+XsvBlq6DiEVXhkIWCauNuejp1bwWy+WozMGBR6g0PvAPSCq1Hd3i+Zoq8K
	vuMdopNYt9FFSKKOfohYabPUIzHhMczc=
X-Gm-Gg: ATEYQzw4ZhnaI2qGdRKiG3vmnx7MrBZgRv4tMmAPdOosSI7en/dxoSPGaaXPgckSMGI
	VfdTGfdXyPmXJ1MI13Ri6UUKew8Qqw/xXUlqEbf4UI1d1N0Lox1zMRhsZX/JywdZsDGySqkWrWm
	YSB9AchB2oHOBZy6gFP0B3bBHzE9+ibNRs3F7E8DQX+HIVhTgcmiUIm09ZNe/IAMeM5BnS5T5uz
	OXRTkyniPNUK2U+YzhQR94rXwKTNWI2ItPTDxHNo462Ri/9im7zeEsKU8hZ+zaRwtpM0vIVehzT
	jiSPWBTYtWrRPZ54rS3GT3j9aXq26LkUjZFkGmCF
X-Received: by 2002:a2e:a016:0:10b0:387:5ea:e298 with SMTP id
 38308e7fff4ca-38a5cfb94fcmr11677341fa.8.1773160895956; Tue, 10 Mar 2026
 09:41:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1773141554.git.sashal@kernel.org>
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Tue, 10 Mar 2026 22:11:24 +0530
X-Gm-Features: AaiRm50k5d5AU6rg9D6nREBVFSX-OWPx19IVJ3HYqjnlpdUhqroGZ-2iIL6qBcQ
Message-ID: <CAC-m1roD2ewNjDOAtTEfiWPKtz49D6R0knnQx340npZnsR3itA@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/314] 6.18.17-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 4:49=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:

> This is the start of the stable review cycle for the 6.18.17 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Mar 12 11:19:16 AM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/rawdiff/?id=3Dlinux-6.18.y&id2=3Dv6.18.16
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha
>
> -------------
built and boot-tested the linux-stable-rc 6.18.17  kernel using QEMU.

The kernel built and booted successfully in a virtual environment
on the tested architectures. No issues were observed during boot,
and no regressions were found in the dmesg output.

Build details:
Architectures : arm64, x86_64
Kernel version: 6.18.17-rc1
Configuration : defconfig
Source : https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Commit : c86e53b5f7797099e5c89a0c3f43de859d8ec1ec
