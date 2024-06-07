Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AE01805A
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 18:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717783385; cv=none; b=NU1zpcN5Hi2upuKLNYdIKeWctWa5EmEeQ3ZvjfoUVRATorCyeirx1YMmsF3P/i8fxCb7UDE7+7IQjGasEiKzzPGYygtcXWyekyZgCT6UQc1jpOzr6Yr8+NzG9oTkY8JSv7RKYC6eB2Boi7VR6M6j+fsmo2dBcSE7sOs6ZnSlSqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717783385; c=relaxed/simple;
	bh=S9vlXymCuw8y2soXFtQEl6vKMBGohi8Chq1vzxf6eaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gk96M0CtrpqlT1HvlJS3k/LrLwg6XfQ0vjjBbZoPGV4UVJSIwdtxGhQlszQEUsg1CcrqqxqWCzOWXIBJ1yLSYN5S9st6Q5Aneyg5SddKqMY2qZ3pUn3T7QmYqTu/xU58KjBAmxymnxHu3e+t2qWGe40MClbsm6iLCCCqsOcbFnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R1KADPA4; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R1KADPA4"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a626919d19dso642852366b.0
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 11:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717783382; x=1718388182; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M4JhFWYIaba6S7NZfwQpR1LZP1nrX/OWl8a4IvQCyvQ=;
        b=R1KADPA4pu3OSYRcO9BZh2xPIZsUTO+pQNKdB7NXFPM1xrWv/a94vumQVCFexaX1+H
         Xf5JcB2caBuHVjB02deq0+cSkJpk3BgB7S3vEK7r7FD3z7FaFjwVrI0vAdMBsIGwgXaf
         HIDSBhJ60Whn346nXBcrVG9fXBJLE4PobBiUkWCzsA6tZrk+zuKlxDSyLXK6Mb0gB7pC
         kdx6UWyyg3kM9K+QpgKT1vfx7olDsXLIKqWp86/I+IMDR114VcO2NMt8HotymlfugHmG
         DIuVEDGovGoVhZibpVGs0PLCTjAcFiro5G5sSpX/IDsKK9W24sm54WVJw3sCTubakbPA
         MBNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717783382; x=1718388182;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M4JhFWYIaba6S7NZfwQpR1LZP1nrX/OWl8a4IvQCyvQ=;
        b=ryO3jAFcC61/Oy5O7osz5z+8ai+SA9aIJKIryLhOHGvwpu8Lfxti6v2VKgMdYthiou
         cBhdtXs1oIWDMZ/a9jPAx3d2nNvszvBB9jmLEPLWu8yhct+1KWl0CjdlW6RxM9q0QoSd
         5vcsQ4Jig4T5uqsEkBwNKFntJ9aHnldAby4HNDd/s2TYTdtyFrRvFQAJVuf5Q5J3aIF6
         5A/p/xKJsqoKdm2Z6z72t7znXEZ7ucK3j5Wjr+NEU7nFHcgpkemYsVxcssLIN5bw5Wj+
         Dm4EGt2r70EAzDvRrBa4ceNzaKY3696s6GjoCxy+Arr3osQwxYoNuFNpWakBTuqtvCYu
         ZrpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVALva8FdgsaOuKKazJegd3d0eoK5GgPcz21eeVFRY4eUyvrY8lyyohXkdc0FAV2g4BCOI8JtAHtDKfKMBJS7Soicti/KVLwg==
X-Gm-Message-State: AOJu0Yxk0Gft5cLyzNthLnG9CYwiIDQ1I2vQrhXbLDuktfjguD/VSaiC
	4ev1HaRPprc4pYAa+WlZ/lFwlWc1tJ2sZKzrdepHfDBxt4q/uz2RLEH9q80TFs/G9jkYEqayJkP
	HNgJbtTYLlDO0n7rQTbgpgjRBWhQ=
X-Google-Smtp-Source: AGHT+IGnj2ysUfh7SOHLkJc3CGDkP6SwlsXhwVpEmOYlNR31bDcHXd9kiuPue/wzF/0qSpCM7o3lXDUckdPju300slU=
X-Received: by 2002:a17:906:4154:b0:a68:e268:fa30 with SMTP id
 a640c23a62f3a-a6c7651ad4emr448512966b.38.1717783382081; Fri, 07 Jun 2024
 11:03:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131732.440653204@linuxfoundation.org>
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Fri, 7 Jun 2024 11:02:49 -0700
Message-ID: <CAOMdWSJr-KSGgWrv0zG+nBu=NzQVpw-z7ef5+ykoKXO1uczLzw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.33 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.33-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
