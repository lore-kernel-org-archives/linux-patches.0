Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593E63D0BF
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 10:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708513053; cv=none; b=SeHJ6+wb7sB/3o59KYEuoTuoYE5Wru8fxuWZDTkf1mXoeiYXAwNsdKbeDOfnGMy7q8GpcFqSXytBJBMKbfAzhToNw4awQRKef2n/lOq40T013DU3b2WdzxVzhBe8F+CehYQjtFdrDsRHpshbeLyexzF6/JwPk+UJHxeaJYvnI9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708513053; c=relaxed/simple;
	bh=12eHUbAjggF8yM7NgbCREXkzqk9dNvGWjPUhot5ICm4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P8vwsMcFBsYqztAMMAH51KrEMjW4/OVKYa8ed6ceIjVxKLtwqLsNg328uPI9RHtTKhdfZWCwt8ocBUyj3lBR8/779HQzrdmJVKor7Uaapw83edG6kZkkvwTKXNA83VuO0xj5/8wwdyis37/Je3imuINrnS6NHHmEZyVh4xlnmuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=2CNQf5o0; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="2CNQf5o0"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4127706e48cso2656395e9.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 02:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1708513049; x=1709117849; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mXS0v4k2QIM4BKra2esPdMnm5lJf7ZlcPGjCl+7IYY0=;
        b=2CNQf5o0hSkjXvLX6bn7e8bcrbJo5Nv1coFKin6DnStH6LticXUGpq+412ANRAKH/m
         lxWfkUN1YozaIkFVsGyihZykWuGOZO4MpDSUD8KGOCV5TOIl4wfuZWu1RAVrHssoq8pP
         DLBF8sI+QRkgalkQFfhBnFWYDQf8lvXNxrGwpotT4KpuOkXK9SFIbQv7G6w7lSPxEBS3
         ndPz5niS++LKhNwW0tJCrQ+Bkz17RDb82091pYd+xju3+x+3922+gCQFQIur2C+w1vA3
         SGBLiWSXA3iLtn5dEIBmypN90Se3CYpOBGDkkS2lAHOPh2inUz6fQKGA8F87ee96XleX
         PCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708513049; x=1709117849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mXS0v4k2QIM4BKra2esPdMnm5lJf7ZlcPGjCl+7IYY0=;
        b=g9/EeeGZl+A9S26T2IbqsSFeoTL91pSGoDPAShTyn1CD7TCQQSwJt/VVruqI9dodes
         gVYKkKuLqACZvl9CJGP4Pgh0aTLYSIYZNpLCErwYG59aeRq541T/nUMlKOPOdwGWjtZ3
         1CRUzzFhkPVBavZoJtY/CkZVCFl1qEgMoEVzt23GKodSlHfaxOO9tnxBhaW7GIkn6eAk
         SEDa52olEy8RJZOcrZJJYf6o/z033VFHUM4pF67YzLO0s2Lf0BbPHvcvYCYJRZDzPyD+
         0fTBhJu4baTQcZhR9VakuEHiqm0ECTJ4nJv3jAJmWmMKeR2jxMIenlg0PN0XLJRu5w+2
         py1g==
X-Forwarded-Encrypted: i=1; AJvYcCXsFUtr05K3tiE7uwxc13Ca8m2TzRd4nLDEAm6QI+rzAnYdVtDRJOyRhhAKhWZi4uyKapW2Ub5BMK9Dm1tm2Ic0gEOry6AbKw==
X-Gm-Message-State: AOJu0YxThIDKXTsydSYJRRfsWjbtFMjpACwrVwNkMmSiiKor+JhSvDs+
	45QlaYyR+0FAVMAhYQQlRBX1vE4trA3toR3NeYVDU4Dprt08pfsSHPsgYLFd84ngq9M9mzm8wMB
	OFZivN8BRnN5mb4dikMwsim40vtraLYvMsWE6ow==
X-Google-Smtp-Source: AGHT+IGuvBYOPybU+JlLxiW/kVCWLOvI2+PYz2s5jpQmusjJ3soy+dVF8/NFDj1SlG1DcCy9YtEo+OfpQSAULDF7mLk=
X-Received: by 2002:adf:f742:0:b0:33d:7ea3:5b90 with SMTP id
 z2-20020adff742000000b0033d7ea35b90mr829829wrp.65.1708513049204; Wed, 21 Feb
 2024 02:57:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220205637.572693592@linuxfoundation.org>
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 21 Feb 2024 19:57:18 +0900
Message-ID: <CAKL4bV6j90+tQVoAVUaxkFUuCT05sK8OrjuBZntesw=UyOVaAg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/331] 6.6.18-rc1 review
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

On Wed, Feb 21, 2024 at 6:09=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.18 release.
> There are 331 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 Feb 2024 20:55:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.18-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.18-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed Feb 21 19:34:18 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
