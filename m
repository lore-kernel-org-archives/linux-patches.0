Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4FE1C68D
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720029122; cv=none; b=r8hf9q6MtGsqD6ZuJHnnStu3pGo+LpQ27/D7gcVEEr0mBjdyfACTEiBhGa9+s1ebvy+zYs24gPFMP092IovLqP41Ze3GToBlORSdt5Wcf6iTxEpIRj9ecTWps3cR1Z4CjnyUQA5BqCZaK2RgRMSbzmf0IK8IB7OClsTuEj+BXJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720029122; c=relaxed/simple;
	bh=I/SyeQYOGfLQAUSaryB4epiEujHxOBhpHqyBsKYQnmg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=noYkLLrJmeRJ8k79a5cets0XDM3ElMdj3a1c3Sulp0L71vBQkBQlE0FQhlXdBSAQ6Akj+fh0ite1CvfgwK0wL1OOBfHMlvHYf2MvCKJsw1M0vxKtmAKqiLQxtZJgxd56LFytbw4vVcCnH2UNJjNOdyylg1rvU/TZfTwHdHYnfcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=stHZ+si/; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="stHZ+si/"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-80d61a602f2so1561065241.2
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 10:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720029118; x=1720633918; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i8jcvDGwHGDOUPj1r3ad1ZdHqvoFYLPPd5l4l3bI77w=;
        b=stHZ+si/JtGR7F4WSVEJ+N6YwyS+yllwlsgH65OKGgE63DkQgZXzuI48kbGOqR7UsE
         X+HVTo6y2OgpR9P5qRsM5aDLt7rwPlpXrCc2ZqRaMPtuh6HYWJpr0TB+SDI9N7JsyU33
         3xoPLMr+ZLN9nkGiuk6q0BHa4naBPLfOmelGMtQ0W9xSy2ptY/jiwWw5v7d+PeOgmr5i
         xTAMW7sgAK4lHOJhy0pBOn5dSS7dMB2k2NQn86aXXp0bZDdsY0y0lblrTZeBChg6vLXB
         Jy40ONOJhIZ0Fp+ONj25Aob1IlgjlsKf2yJYmzM9d66/D8mL4wbEObxdCUV9ZYRqsx3D
         7gEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720029118; x=1720633918;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i8jcvDGwHGDOUPj1r3ad1ZdHqvoFYLPPd5l4l3bI77w=;
        b=C08DC4myTGYqDU5ok9EsyJO3EqLOXgRRt+R3eL6AM0JmgIJ+7K+o3GtDH63M82xtAU
         KO/unoXHQFGsJkKCgKj72h71sWjHttSEoYjvZ5eMbG8dWIZOX/6v047kLCalaqgsOqCU
         Pgus9GYLaR9UZRHvF8XdGB5zho+prmwbNO2pfIAXMalN64nXYit+n9egx+/ZFBQTa2B8
         aHtO76J01G74GtJachKe8ZX+OvvFwv0EbondgEUFaPkU1Jiuebt7xAgcMVCLmd0nzggF
         aMyiJRBilkY4VtxIXJzttBHK0eNSPuoHTqIvg7o67IGa8kthxjRiI0xskaQcbWzmAKfu
         FXYw==
X-Forwarded-Encrypted: i=1; AJvYcCX/8TXZdhbk51OmvMQphL+d+5CxLfqO3vK34YsAPPqRF+t/WEDEReXlNGoMx3Qm/ehgsnDnoxPsGgTc3x7MKYg99kVnmJPSBw==
X-Gm-Message-State: AOJu0YyD7HWG0J2xQjvm5sDta/ZeJPOMLNXWEZZUtQnIAfFmczeRfAvL
	dOanHA9/31YrtXygc02A/7qOAFPpA7dOQVIcLiM6LlYL9UbucRphKy8brDPLP0V8J66a15mPILi
	Q/aqvJI0a0htk5MnZC7kiGsnHPN2orfr6bgcs8g==
X-Google-Smtp-Source: AGHT+IHhubxatrzSaA5HKwryk/uHLQRo61FC6EY73fx40maWnrKKGtHLfWp7my6T+SlQSv0KB+ZvBb6CauO9auPbwxg=
X-Received: by 2002:a05:6102:e14:b0:48f:9751:198b with SMTP id
 ada2fe7eead31-48faf12de8cmr14916609137.23.1720029118386; Wed, 03 Jul 2024
 10:51:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240702170243.963426416@linuxfoundation.org> <CA+G9fYuK+dFrz3dcuUkxbP3R-5NUiSVNJ3tAcRc=Wn=Hs0C5ng@mail.gmail.com>
 <c440be12-3c22-4bb6-9a10-e3fd03b87974@app.fastmail.com>
In-Reply-To: <c440be12-3c22-4bb6-9a10-e3fd03b87974@app.fastmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Jul 2024 23:21:47 +0530
Message-ID: <CA+G9fYtuiiV0FDFoSZOaKQbKiQYw+SphhWZDjK8R-bH7dBfs5w@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Guenter Roeck <linux@roeck-us.net>, shuah <shuah@kernel.org>, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>, 
	Jon Hunter <jonathanh@nvidia.com>, Florian Fainelli <f.fainelli@gmail.com>, 
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net, rwarsow@gmx.de, 
	Conor Dooley <conor@kernel.org>, Allen <allen.lkml@gmail.com>, Mark Brown <broonie@kernel.org>, 
	linux-block <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Can Guo <quic_cang@quicinc.com>, Ziqi Chen <quic_ziqichen@quicinc.com>, 
	Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jul 2024 at 14:55, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Jul 3, 2024, at 11:08, Naresh Kamboju wrote:
> > On Tue, 2 Jul 2024 at 22:36, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >>
> >> This is the start of the stable review cycle for the 6.9.8 release.
> >> There are 222 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.8-rc1.gz
> >> or in the git tree and branch at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> >>
> >
> > The following kernel warning was noticed on arm64 Qualcomm db845c device while
> > booting stable-rc 6.9.8-rc1.
> >
> > This is not always a reproducible warning.
>
> I see that commit 77691af484e2 ("scsi: ufs: core: Quiesce request
> queues before checking pending cmds") got backported, and
> this adds direct calls to the function that warns, so this
> is my first suspicion without having done a detailed analysis.
>
> Adding everyone from that commit to Cc.
>
> Naresh, could you try reverting that commit?

I have reverted the above patch and boot tested and it works.
Since the reported problem is not easy to reproduce It is hard
to  confirm that the issue has been fixed.

However, I have submitted jobs with and without the patch and
running tests in a loop.

>
>       Arnd

- Naresh
