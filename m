Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D0518E10
	for <patches@lists.linux.dev>; Mon, 15 Jan 2024 19:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2W0V3sc"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-4678c4e51a5so2260096137.0
        for <patches@lists.linux.dev>; Mon, 15 Jan 2024 11:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705348014; x=1705952814; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jwPEwRCpFgdHL+2xJbtG/kkdaMyfZ90AQyODncoQ0Gc=;
        b=K2W0V3scdFjAS76OGe29g5mjxqOfhq9eF2ORAxCSiQNEF5zvPpCevbfGzkeQW2DlSu
         MHH0+Fu//kJZeO3+hU2bOEt9K89YohaO7Q5aDcZWMFM/NjXHOWR0AQCqDfvzDym/vSrT
         bThpLa35cbZorJIeX5Qafi98NmlzmTFrdraTnpJU1iidqqlf0uvkoQTcPdAgcghtFs3F
         NGNaGbW/ByTTF1cBZOtWKkEd29fVpM9km/3xtsn+uBlychx53hTMz6Z8+Em8a6UjHRwA
         j13Vsf/LdgrpAWYayxJXCZQfaFfxD5leIO5JqRhQFMTF2pPLFnNr5pjN1Vb6iIA6mh26
         /T7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705348014; x=1705952814;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jwPEwRCpFgdHL+2xJbtG/kkdaMyfZ90AQyODncoQ0Gc=;
        b=XrbqjT7oqtwfEEpCyyj7GQBO1BO95qNoFDSCOJkWsWd8geWtBjY8G4c4IIS66MMqrK
         vmXb0iCo+zkpP7/yUgIrnlJcAFfDJl2PR1XUnEQUgtAMgmx69wVwgDuZlE54U6F+Zehf
         tiUtY/67phdEeT0HQGbCzXa89DgsC21fRI5WihJP0M/wDerLvQeCCFf5z2KNRkvzy16F
         y++qH7yKWDWff2cXFtSQfbIp0i++dK5iYzjiCT5ROSNSxnlcbqsiuRFymcaLuYdN4Tvd
         T+5iR+xkaQ+9RtocVkhpWFWp9AAjlkKJ11lH3tL+rgIAOHPTKhTeulVsjbKQjhG0MF89
         +PDQ==
X-Gm-Message-State: AOJu0YzDxtNZnY9kkcQlb1ufKpPR/0M4D9xKoamIZ1m2I63ZNhind48f
	XeLUMs+7H80fiK32wfcFLN7dvBnnXFbP+DdXyGY=
X-Google-Smtp-Source: AGHT+IG+O6Do43YBKCFtsxPYQyjSkp2exc0bClam7UxvmdXXSoWEtVaV8W4ChIFQ9LjiUmi90jk9Cm+OsTfKWmsBP0c=
X-Received: by 2002:a67:fc86:0:b0:469:5874:d834 with SMTP id
 x6-20020a67fc86000000b004695874d834mr1577917vsp.5.1705348013989; Mon, 15 Jan
 2024 11:46:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240113094204.017594027@linuxfoundation.org>
In-Reply-To: <20240113094204.017594027@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 15 Jan 2024 11:46:42 -0800
Message-ID: <CAOMdWSJS58RL1YLhcBGYN50c_4tMbDCmKFNHz=SpX8P06zi5zg@mail.gmail.com>
Subject: Re: [PATCH 6.1 0/4] 6.1.73-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.73 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.73-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
