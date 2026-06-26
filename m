Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD723F20E3
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 12:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782477344; cv=pass; b=Gr32/idtytlbLohAqrce5JA5jk4o9MFiLj4yPT8suga0oVPFBD4ggWXkS5am2u874LSxbwqUIzcjgVjtvEYUb2kgkoEjzgVhxzON5dcAPz7LAJE8nVTk14T926Cxm+hWU6SqvxSVMfd6TfAuVIz0JMT2kQa5p7js07dOLDueo4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782477344; c=relaxed/simple;
	bh=3fJVQ4hYkFu5L5b945wwzNUsQFPabfYbMhAcKfbJfNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YVoPOOrlrTpB4fEP1EjdLItxEq51c5G7CeLnRVtE3ohi5A03KqDHaWukpqldbt0HSAH1Lu6T1KFMN/LgalSyMvlMWsAvpH4UONAfC4KmDH9DMqAVaf9KI60OBM2Phojd4bvN26KwDhx/QCVzL4D+4qyCaEat2e1oQW8mKqLO414=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=F+zx7ChN; arc=pass smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="F+zx7ChN"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-139aff562e1so1355599c88.1
        for <patches@lists.linux.dev>; Fri, 26 Jun 2026 05:35:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782477341; cv=none;
        d=google.com; s=arc-20260327;
        b=nipdME+0s8+0a8fRRLxRRWakpl/ShMpTYioTbezzX0RUdsnSptH1gaNPUY3pr+A5Gw
         KbU99l62KGe2STyIamSpUIHneOkxNApt6IQR764GNguX1oQJJVvliX92Tb+QvrdXr2JY
         6+Swa4Seie2w9av3TXV0cL3ISbpVnJCQBp6oG3PFlsTaNPszeAMaAdkKelxSdn5o+ySG
         fXecYZwvf2y9mxQa69RMqTvi6On4jxl3KGURaOC/WvI2YneIZuLTG81a+sWVg2M96T9h
         phVEtRdSeOfY1xVXMhDBd3p0kKuXNZX5mLkBQohW8ZilUeK8x4uJrwClR/+QzeWOoczY
         nd9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sauy/FC8sN43A8h45utURrQh4BHMaX663sXIYi1uAOs=;
        fh=nKBeqjAiYmdSDuj8t3NhtcdrEY37lWKLSO15aGqPohY=;
        b=aVSCFloDj/Rf6qLgUBNloYvrZRa9FAc+BV4uMCed3Vr8R4q84SrgOJ1wFohP77lGYy
         jfQxlQAW/xwpEnxb6xx35pGjC1DrikhXM53mKoqtodYFBTmwgvXQ7BuAr1tDmIjkO1ES
         JPXMP1dRTd4L+1Gy4N0nI8GHY+GwKS96YjZ1tGWjustwHUm0zCmZ2yx9zpX8bbx1oJKA
         0StgP7dkAP9cxRqQFM4JCVA0sxIsjFiRzTq+CQMidZgXAsJE6ME9WtkfgGJsmyUlk3HH
         CU/Fp+pKc6/w1JUPM1GQh0Nbl5T3/NVxhOh6Jo+o+WtI+moNCoNTngvkq76g3QhA9BfX
         3ZKg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1782477341; x=1783082141; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sauy/FC8sN43A8h45utURrQh4BHMaX663sXIYi1uAOs=;
        b=F+zx7ChN1OsatDLIS+CwejMFZCaf4b7BgEQQyxxgagnV3sj4S3q6ESOgE/xouWrJFD
         hQ0HKpGIbM/vlBrcqhNzSALe61lCSE8jSdi8+rCxO3BEe4+OJYjlSCqGkBEMZd8e7zbo
         WvAdaAYa4HwWWBSlMtDUQCCz/1V+rzYnmw8s8PxF+ILObhXMjp+zbI92IP1AzSTL2uB1
         xBn/MyzaA4ggNFlxzM27sZxqr6yEhYk/5oBYqbnlbkTH4PUjr3Niy3vqr7GqG+Z58aG9
         rFwIdeGJPt2gADCrEcqikChSaJlBy0pZT0oxw8p/CUe0krJv0dhe/btG7ccxOPT1deO2
         GHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782477341; x=1783082141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sauy/FC8sN43A8h45utURrQh4BHMaX663sXIYi1uAOs=;
        b=ipuwPO2tOaI5B/a41hYjL035HywGLrTzK2ipBlTrpFtSGgU836ZXPAUG0o3ehfdTo2
         8EdTblVZqtBasUqBtdbfck2E2IiPdU7tiHS7q3dHBiah3NAJTqKI6/rJtPWUcs0vj20b
         TYt1CX+gOwTti7XseIBES3BP0phfB5MkszGGkhV1cuHIUC2mThBRIL0MCLc/mKVUnRoY
         Q2AGYx7fQQScJ9o55GkB5Q48fntlu6nabgqmhzzDt7q5S2+k2sLQcO6rUfTzLnfxneNB
         kJgg6oHx7eeErmnnjXs146Ggyhf0ftNQFsnrOfMIRWd3CWw7yh6MiJEq6hqHtOK19l6r
         PsfA==
X-Forwarded-Encrypted: i=1; AFNElJ+bmJBcgGX0+68IdXlder3qMuvLjRh42Xm4XMyQTFYi4fVWkip35aoZ8KhvGwK8DRyU2tmqNNpW@lists.linux.dev
X-Gm-Message-State: AOJu0YwpUQfwFCr39DAPOncwIrD25ZqKm/nQ8Pu8rWYavfBNxCAywn3s
	RUtMViQw1DNbFPeLsmsghiAv/i/+qlety798K2QmH+my4m2ouGXF32osJ1rlKVCmPh9eavrT76Y
	LHjlQINzuwi6DUswcTcc+kfjcROWtayRKbjBTG8CySA==
X-Gm-Gg: AfdE7ckJurxBeHWXwrLeqanLPTuovaepQkQXVBlW9GHMjFcd6GVRz1oT9TrROXJeQj7
	CeY93XjrdlKrwkSawT8lNKPamx++75lemPn8+r3tQqs/8/KMqF1yDfNla9HYViCBDAkWFbfVueV
	a2Nhd+8KVMvzFnf5CqjDrFdxu8mhrDDr0goHmQm40t86OEfxq4YeqQjLMso4BaRF6MtR/FP2LWD
	n3QpSuW00rEHkw0eXIJ74EkFlWObuf2XNrKxSGIwz2PqUdEeQw7BFVpyZsA6BWQ1sDnRM5yFg==
X-Received: by 2002:a05:7022:fa4:b0:138:3d7:e8b1 with SMTP id
 a92af1059eb24-139dba109camr6933862c88.10.1782477341059; Fri, 26 Jun 2026
 05:35:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260625125613.243729608@linuxfoundation.org>
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 26 Jun 2026 21:35:23 +0900
X-Gm-Features: AVVi8Cf6RN527hwRseWGpkGeRx863oAedheFSfxwak-FDDbXyPxrsCxB8-Tep7A
Message-ID: <CAKL4bV5NEHdEEGXyTCO73QMOnQyJfNoKk2pPb3Cg5zJJ9gKZ3w@mail.gmail.com>
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Jun 25, 2026 at 10:15=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.1.2-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.2-rc1rv-gecd7772bf738
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260430, GNU ld (GNU
Binutils) 2.46.0) #1 SMP PREEMPT_DYNAMIC Fri Jun 26 20:21:58 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
