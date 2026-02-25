Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BD32F25E4
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 21:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772054477; cv=pass; b=Yk41hedrd2Z3tNWQGNq0bfjeFnct/4mQO9T2dcHMZbrfjiQBN+28HgcRa1ddZvm/fmjy6O6by5/Z9sKUXwJ9J4CpeDSku7GCrlBVRzYRWm5B/96P/uB5wDkTC2tBWZWd30atEVYPFJ3Xmh7EotX431mI7wJnt+o9MYdBUAeGPLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772054477; c=relaxed/simple;
	bh=r/whAqMLJHQRVvo7VfNz+0QkCZS17SRsP6ThO1PzPJQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VA90evbEpo83qPkx80Y0j3AphitaDGc7RqksSIDfXdR1IrA2gVLB8Za1ok/VSlwHE0PRXNQlE4LSZiGFASrXsXnNkwsyLcZ+INh9uztFzVgM/JpiTF3kaE0wt60ezV86zzM8q0nDMUOe02hYBQCZ2Om48hcMuN2QGb1kxHxkXeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nR2VfIzh; arc=pass smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nR2VfIzh"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2bd3b0bc201so282849eec.1
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 13:21:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772054474; cv=none;
        d=google.com; s=arc-20240605;
        b=boasvDPKdAKfq8q9OqHpuIT0tdNF3KM9glh4pWtGAfPU1H35gswBoN5TRKDES8zQPI
         4fKtYWhF3jcPOHDGRhXQmfk7zge7kQg8mP+RSfQpzm/zPhuu5Rl27Y4CwpPcYnDKstLz
         AKZ0S6tsXuLzKNoPfK16X+DMCorlvWWWJDl7ABKvwdOHCC62qxGdkbDXa/YVscgiEJZP
         Dfi+OmlbXMoE1ei9tWdKPhL4MXzbrS8Ilbcz2yZpEfpaJEmHXFnff/TS2anB1wB4XWEI
         vuVkFszUGt3KoWA3AoDWFCIT/nxZ0ARhjle77yTtDpJwJaS+vW6hIE6kbS6QvQrDQxMN
         y5wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=r/whAqMLJHQRVvo7VfNz+0QkCZS17SRsP6ThO1PzPJQ=;
        fh=XNeW5dbPpZU5XYJoEoIJeft2NukGzPmZ6wSKkvMCYhg=;
        b=PjxDLGwaQSp0LU7ZXBiZ5avrgyexKzAy7+daCsOYOJtmcmVG5LTIQe0Q0559xxd8Nk
         yhfOcrtQ0vV4FYUQwDBP8cU/Wae7vPCdktKAn8YRVsKMyGgg703VAMGG+okhcteR12c7
         7PNWIdUG1VIX7fhf3WZxzyY21uEijXjTf2/Xbo8ooPQ7RZron2X2MVcrjhcfqu5Kyhlo
         A0SZOw4p2UIPu/HK09f3898bOA6udlbwBf/+BFWvzzT2GuJRKH+BLZaQdigld+LnBzc7
         XNbvV/VsHcndM8rZaPHvGHtYrcX58fC7/dHPCCvxcN1A2m4a9o/S7giCYfuq/LODiGgC
         NXLQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772054474; x=1772659274; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r/whAqMLJHQRVvo7VfNz+0QkCZS17SRsP6ThO1PzPJQ=;
        b=nR2VfIzhYNEzh0AzpJH2nHz8h2BVxeO6TrAB6p8Z4CtXAzSl7VyRAncr3hUSBMrEcZ
         b4uHUam0suHA9t8exvqQ8w9Jc7cPDb7RGuX5Bb3pKoEfBtobeIe4N6Pddl5biQNunneX
         h88vy7Es75wyl4ngqAp0xJpDw3rKHydBa4aNpyIDje3J2yiFMmKeS3PEjGb9chKRSkxE
         iihcbTXTRlRXzkUrMkPZg58MW/fYHlZll4JmNwx8yaisW/pIFK7WCi1Wa/xqjNGAWblC
         seb2yKr60YyIUNSzHwc5p0mnk361GLPMTxY01x/4ML9RUDFHz74ITjuZgji7ev7YtVO5
         DXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772054474; x=1772659274;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/whAqMLJHQRVvo7VfNz+0QkCZS17SRsP6ThO1PzPJQ=;
        b=qNWyZDyAL68WBhPowk8N3EKkasRhcPkhhvY+NuFp7YwHgsZKenJWRdHStakrVVmlNM
         CsQEORK/qR1BaUSB3wolTsEbQ/NiqmPG+ma/Q4CZUdEADKYGeZuDjaScjxop/jlSLJ4k
         apexAVFBVQWebPfmTSmJL8Z+pd27rkvGLE/D3pb4xU8vOfyHZoBy2RAcNxT1d1Z+c9e5
         p2jK3uqzersOJe+UqAtWqksxwU19YWO933kK6ygCqbT7xhTvtV9ZFur3g85DUhObloka
         lOXyKz5FSbgzqLSl6gnaGTvxgY9BOaA/p/PtMOsNP8oFNIfBiAyGVIUclAS8F9ZqlT6m
         e3MA==
X-Forwarded-Encrypted: i=1; AJvYcCXP0d7IaLuBeucMboA8zy7buJCAkSWCt+ODT3b13MWboHGTmw5r/B7LKjIrIJfgm+A/QZPSaLRu@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/j4dUv68FzyTMzJhE+5inSfmEnJNsfbBLaGRZC3sA7DybWNlK
	0GVp0XzcHWPeETZ1MEVzuEmSKuepdM2UAdBQH2SDdiKZ4Zeq8Rn9rytb+2Y27lZeqnFXWgDSI6O
	lTUe6UjJXFP5+aAmnu7fykXukMXbuVoI=
X-Gm-Gg: ATEYQzyN6nzzv5ei87DUEbH6J6nSf52j+1GfJP1zyaKKH4RN9v24tcPEtpgKP9sOA1E
	q7nrMDbqdVhcVcBmO8gLfbvJvFAljNVQocR+GnjiEAmzFE92YNgDUXamSVMN2GfDsSd2SUCNaC7
	S7jng4iRiGLxZVtBDD0LiKopGDylnsRCJmee+AzHCItt2PUIr/7By7Ctf1JC6gDMKVYe8972nRZ
	dY0aYro9IKP+ZJB7Zlnm1o+Wp/9afiXnNF/sSIBhCplvCTBNTK4aLLuAwGeX88bEcjHjmViaGOJ
	AQIe4EnKQUoXux5hO8ia482evehwQRdpbzJJY0AoaKgOL4Oq4Ljh4yn7akv54ijPfKH9/u6Y+f5
	S5keT13f1IEAU9Owd+hFHj1AbGeoyug5xA8SwZ/tABIX/d2GK3iYMfaU1mj+Alx3jhhcm8joNSf
	Z+Kt8JL1NbmzuZ0xaAala6e44EChEMZVg7hvptb9Ydhe1Ek9gg0g==
X-Received: by 2002:a05:7300:df41:b0:2b7:1b54:6081 with SMTP id
 5a478bee46e88-2bd7baed292mr8035736eec.11.1772054474469; Wed, 25 Feb 2026
 13:21:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260225155341.094945851@linuxfoundation.org> <35369c82-facc-46d4-86c2-a71fc03e299e@gmx.de>
In-Reply-To: <35369c82-facc-46d4-86c2-a71fc03e299e@gmx.de>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 25 Feb 2026 22:21:01 +0100
X-Gm-Features: AaiRm53eyhfFk9GPcvJQXt37by3yPQgMY5c1F-xkUJX0eO61Lvzy9lOns0cAInc
Message-ID: <CADo9pHjK8XB2K2oeNbLa2cc0CHhTf9=40_EGa4AZEN0-RZFZzw@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
To: Ronald Warsow <rwarsow@gmx.de>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den ons 25 feb. 2026 kl 21:37 skrev Ronald Warsow <rwarsow@gmx.de>:
>
> Hi
>
> no regressions here on x86_64 (Intel 11th Gen. CPU)
>
> Thanks
>
> Tested-by: Ronald Warsow <rwarsow@gmx.de>
>
