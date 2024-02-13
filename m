Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CC5627E6
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 22:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707864379; cv=none; b=hdBnklB/5FJjkMwdjDPisvsFOpgZxPGOyWc6Qcqxm/r6hYpXY0r9r3x5vZOFp4unfbZHd3qX8c8gQQToBwWi1KIDWDeiNVmPiKKeubQtd/nysE9WBxA65fdYgS81K7l4R8DmG1PQ4br8L2/2MRUYH1bN4eSal0bqldNvsYp37qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707864379; c=relaxed/simple;
	bh=nhQahWR8qxaBAcqLn38WkwfH3WZavzBYN8qTFJQXPx0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZpnSs3gNfv/WRYD+Jh2+DilDM4VePfyRUs/w9MZwwSFDfYekK/ElX0hDKNO/bf8hkpf+CrWxJ2zlMoDrDhLCOp4coB1VP6VqBePBGccbiMrz4SuPcFIZrfKIEBSaaMa13F9qGBjJUddhVjpxwNLSgjscSAXaqA+AWOdzR1vJhec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L/e62NRV; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L/e62NRV"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-7ce55932330so1954305241.0
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 14:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707864376; x=1708469176; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GVpdqfFjdBVaR9nwEwM/0QGjipjHAXDN3BcD9vceeaE=;
        b=L/e62NRVmlttI0ARglxX7Mw0qipRZtpFULoc+q+PdYakqyGtZbZipL2vXDSdeV93B3
         OQgF37fVIG/ubV1leXoOSMpcHVmITYc0DsJR58tmquhnoziwlhmEIC5hMn0wDziIq1j2
         XqRScDcc+m5+A0N0Sr97y8YhF4SvEJsGVuA2z9Liutu5PwWgxfrOWUemdfIwoCLYy493
         x0Zo0hrWalpbAP0VTuR78NY/LcJr9nADX7vqVE8LxBvHYIOu4y/60p+3QbmLcW+t6nPg
         yeM0iWOKXQ0+WUIOupP/tLabk+jd+s34v40p5tSX35im9Koy2QV18XeMPTwk44VOtMpg
         xwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707864376; x=1708469176;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GVpdqfFjdBVaR9nwEwM/0QGjipjHAXDN3BcD9vceeaE=;
        b=iZ3PQNeK0vEPh4HdFbdYDsEobO4UUK2KtztMJkF0Ds08lBf1XvRNdX6WxdUepmTK/v
         hVapW0D2otqjHGm6z3QclonWHz0GMqyNlcAhX89E4W5J9VfY3yqw4qGUl/Ssy344m77F
         3+ep+aUUA5pCH64HYykE1n9onx2d9cYbtzjIe8ITV54Z6enhSdKe0rvTQRpzjXUWGE5x
         et/3Fpg9ICx4jwhr9maUczG4yzF+9erxafYHBr7SqN4Z/oz6kGtpNl0EV2lgYI+b9rk8
         WC57vEoUZ2IJmKaro0c4gqRVdep22SfIbd6z2gvrlHU0G9Pw99ww/7LetVsOqq53mp+5
         HFzg==
X-Forwarded-Encrypted: i=1; AJvYcCVMkJq0QfVhuG+ld/rMohkLZ+smsMEtBA9PLkQp6FyduLh9lVyZLBgm+Nku3/JpOozZXK9VytzIPzp49CdkFobkbFWk8Q2Zuw==
X-Gm-Message-State: AOJu0YzeU+eyXRLQ8eb/rnmQwODcClpZ8/mXwSCzTDKtCXQLEnKR06Gs
	oBAYSvnjHwGvikXeErdif4cxNbb9OVdpAPT2fka46CVicUUMkylrw4ZV8DFXxjU4Wu8nfeNtFh3
	unO7/2JiGJI5MqAOsXinJrIcd8Hk=
X-Google-Smtp-Source: AGHT+IFr4MBTJKL2nB1kW6w5abiX+mdZ5GRxVWRdrOLH2lAoHrSyGQW1BfYX0o+Ye3+dgWTiyGU+ANr1XAuIGwUtD5U=
X-Received: by 2002:a1f:eb04:0:b0:4bd:29f7:53c4 with SMTP id
 j4-20020a1feb04000000b004bd29f753c4mr1014391vkh.1.1707864376266; Tue, 13 Feb
 2024 14:46:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240213171844.702064831@linuxfoundation.org>
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 13 Feb 2024 14:46:04 -0800
Message-ID: <CAOMdWSJy+-KrWK5P0JKMjS=j=fCONhLiR+sLKB4vUSo5R2M-dw@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/64] 6.1.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.78 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.78-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
