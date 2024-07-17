Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A7B1DA3D
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 16:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721235535; cv=none; b=rLsclaffYXjzpMpfVw1b6jwNdVqpD+hx48DYpPw9JKkxTXmBeys6iz2whFCmNKQhwQW7PuNkVodyj88q8q+cV3C6gj1elfQaJt6JGECEL7yAtIpdjmeD7lip2OQyLhOGBUjpnesDe4tRjZvhV7eP6+hPiF+I9sF0Lcgo/tmMMeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721235535; c=relaxed/simple;
	bh=J/fZGIcpVgzURWR0AKdnRLBbXlQuODVg1v5+8HBFdME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=buf3jtGrsnztuDoQQZSb1e7BwSI8DyaykyAR75DY1CwkQZilbyovj1zthOGYhXWmJVU9miE9WaulCTrDhshCPVhLnyikAfJv2gLeHDq5ELSbOqkf4pMXd55qoNMNRcw/zGExEeHLVyOTvIm8VnkQbTyw0yA8D6WatdoY1G5lSsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IPvVIkk6; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IPvVIkk6"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-8100ff277f0so415277241.0
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 09:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721235533; x=1721840333; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m/wM4gpm0SoOpAcqjYgbNHlW7uWa52VPZvPhGBKO/CU=;
        b=IPvVIkk6C4770zEGzIB2RtWYTEaBBrMwkdr/qWfmbXTEbZfpg3iBkv+h64zP+23tbj
         /HT8UXK7UqiJRh2Jxp0KKC6MwM/8zNnE8Og4p7UmgGDG3SGHZXLNXfYLx7WB53taLyrl
         sse7QpHdFlwqR6sDgz1D5JJ22Ew+w9f2vFOaaSlHyxjURdm7D+d488gBibDNxaF3br8O
         WqZqzYOAZf9UI74YCI9Hzrk9NpSgsTYtX2uJbMqlYMx45n+NZIohTm9Vq9oCfDnw6Kix
         CLkOujOuDCUYH+HUcXiczInqsqcQGQJlLXpVrVIpAds2ppPkscDCL1cyWegmvMrqksXr
         jE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721235533; x=1721840333;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m/wM4gpm0SoOpAcqjYgbNHlW7uWa52VPZvPhGBKO/CU=;
        b=LXK5CxqgxCZIvAqCR+aaWiDb0pxyfI5ysh0VZi6miHYKXxolb5dlicKpg46i+sSHyQ
         2FxhpdGmpmAoF2lhFR1szIuiY081IzG71Xlo+X4sJPuFlSW6qJrhglJxNp1nXXcOkl86
         58LsEUg5xVuxgoNLsvZ+2EzmUZKi+MMu7eeoHCUqqRJVDNL8vnw6oH41RpYytadR8eo1
         H/QgmCMevAeWcNdyK3ASsh1zA0Qqm+2IaLdCI80CaLjRXHLIIumysbCO1481ASCiLsmj
         Shn3VmpsEkcul1pz2RLBqK81jg24KKjdHmgYqU/M0BdsV5ma/KPitZmkL2cmuM2ANUoV
         yQMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRXqjLdmPvdPLllZJe0KlT/y6GoW2IA8zar6fnih/DuCasX7tHfmkd8G+LAshdfwIjV9eIlsgOgpcX7Z0YNJksH2pk14Ly1g==
X-Gm-Message-State: AOJu0YzUXLSPE6baMA0rwRXMPfVGJXsRC1OIg7gN2BkTm91JSd8eji70
	kaRxtHTrOPqGNTk/gJVmvNFOaUK4m3c7nVH340ivnH+PdfG6Ez6cCTFhtjRHmb4CStXt7zHp0IS
	mT4hXwdqOYAMQG0xYsUx7pVT0Q3s=
X-Google-Smtp-Source: AGHT+IEE/oz0KWLT7PiFsCDFV9xth+lZxE15maqEJA/MS/jptuXNW1DSh+OrzITCEep4T/d+cOTcq8Mp2BrSlX+IDJ8=
X-Received: by 2002:a05:6102:cca:b0:48f:e802:4b26 with SMTP id
 ada2fe7eead31-4915993662emr3092012137.18.1721235533145; Wed, 17 Jul 2024
 09:58:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240716152751.312512071@linuxfoundation.org>
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 17 Jul 2024 09:58:42 -0700
Message-ID: <CAOMdWSLvdQ6RK8wdgR4i=KeSkvp6ZxB7Bi4g5F+rFpwqEmh_Dw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/121] 6.6.41-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 6.6.41 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.41-rc1.gz
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
