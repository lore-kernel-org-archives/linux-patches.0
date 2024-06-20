Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3281AC768
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718884047; cv=none; b=mepRSU1p7rqAPtwH2REgal5q3tZIp/JSCSAHKw/39RzhKJ6qUdJTP3yTkScyId9K3JN3DPJBZ2Qoya6fb7Q3166V+Q9PoBwzw6mWI/pTXi3kkJNwGuFZNCK6rQAcUhTMTGZ0gNUP3AqjbAf4OpYF9Qg/N32bjX6b9uk9hbM5h8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718884047; c=relaxed/simple;
	bh=/1HS+rQtTslNAHKJd3uK2CeEl+AXFRv821YL7VlRfKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sUC0A6Z273QcIpGI3je+TjtNNQNV0OQgAUgmUtVij9/L22KoLs2haShnRuyJVurvg0GwgQ6QO3Edo7Iq2e/3QBSRpJrKizaqdLahwMd+7AC+yUEUtIV2VlPfSR3YZ1GPr4BC9sHjAjMrNRX1pDpYnKtbhZ3B/OVtNv2B6JF0DlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=eLhqqRLK; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="eLhqqRLK"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2c2dee9d9cfso686986a91.3
        for <patches@lists.linux.dev>; Thu, 20 Jun 2024 04:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1718884045; x=1719488845; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oDbQvMs5FZ0E2LKJR9+/mbKWM6Cdi78nFokQhVSGaxc=;
        b=eLhqqRLK0EC4dKj9oX8oGHWmbloQsMtkHc+lkUA/bAa71LroUyEesAHOthABxDUZ+A
         8DVkp/fOl1Drj4pCKX9WQpO8BW3OSMscR/MFq12VTVlgGBCAYzqyXjlVWkLKwySffiLL
         em9+D5wZFzvBZzXE0GMYZXoaGMmcVfuKFa/njPsT999n31+4bzpfj1gx1wi0Hy0C1XGH
         uMHNdVzuJssIQZl2wXeUX7X/S+hPyKxEStTYMEy0qucPhpmqwSKGG+PnJbAOek82AMK0
         7YWnjLy0fvn8f91Eh0cKLICPvn4rtEaJEoL3BukYP4Oet5KAM1c5bMsynOVc0hVUG45j
         HEaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718884045; x=1719488845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oDbQvMs5FZ0E2LKJR9+/mbKWM6Cdi78nFokQhVSGaxc=;
        b=UCCaUYuqwhmQAXleIev1FS6Y2HgPhaOBhlsg0fhjgWNbZUHcfbq+ruoJIdyRuaW3Id
         YDAHqL1LpocxgQP3VTUgRIRx35cnR4ich8fo8k4BUtKYBnJ3MPsnfI7Sz/v8uBE1Wgum
         lA5ElDs85ozMmpZgj5AejhZ4NM7bpqii3hz6bwN0hUty17gR2oSZG5f0+fy60qEyW+kG
         eOzj/lH+mPaYJuohQLER8gym9ggTjDpoeyw1v09e17u0Z+UT6ZqwgrIC34OvLmNcj75j
         3YKmb3Xx/irP7BUeOgqzuZnbHFSYtrsK+lHxPOOQOEpL18w0+jiHy67814MIQgA80XlV
         xsGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfFkgdURuwfpp3JH9ANohdzr3j3vEKnhtwYZA/BF7KXWW3W0sZMKJU1JK2MsMaYFIYCMbYynsxEIbL2YE9/Iu9GW+qnl2mfQ==
X-Gm-Message-State: AOJu0YwJiV69/x6Iu+eJ5KntPcgTv9G5y5aFcUn8N1DXhsHrgzsS3LDS
	t0tKeBA4RxXL0yYKs6P9Lbl/WSsJ8SdrEnWLf07hHLUG+5FX1anqhij/guayFYW7FasjdhVEyLD
	us2jTMBPyiROwJddiBVSzupT2Dcmf0ZZL0BYuxA==
X-Google-Smtp-Source: AGHT+IFH9K37gIw/JKx90Qnlyho5R03GHOY6Z/ykjRvo/B5y1YXbTFndIQjJKqj0qsSX4d+stSE44xU0DYi3Wyrzj2Y=
X-Received: by 2002:a17:90a:ff11:b0:2c4:b495:49a2 with SMTP id
 98e67ed59e1d1-2c7b5d97dbemr4859556a91.39.1718884044893; Thu, 20 Jun 2024
 04:47:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240619125606.345939659@linuxfoundation.org>
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 20 Jun 2024 20:47:14 +0900
Message-ID: <CAKL4bV52_bZjWk7_JdaHAzf6eSG4-8V77zj5YzwJH98Mz9P1vA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/267] 6.6.35-rc1 review
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

On Wed, Jun 19, 2024 at 9:59=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.35 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.35-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.35-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.35-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240522, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Thu Jun 20 19:16:30 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
