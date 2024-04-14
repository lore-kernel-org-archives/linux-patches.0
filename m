Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC57136E2D
	for <patches@lists.linux.dev>; Sun, 14 Apr 2024 21:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713129488; cv=none; b=tmHuO2fe6Pflgann2IUN0bKjTanaBIe27ZntSiogXZ7JXOC5ElycChMiAmNJ+I1zciGFJ//OG5h86LEgFZE/9t0hEYQQFWG1t8vXxxM3k2JpcJYJ+wyUaqzgMQo8yi8m/pUF0XD79fgC7QT8lMmyDay6hHcpO9bnZzpWoaerp2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713129488; c=relaxed/simple;
	bh=G4TuJqmhrfi+7PAxNMiM5MQgUdsKKap5UGFURvOLTXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PkPMHcUhQG/LukiJUz370eBS7P1DTgeuQ0gQkZNIwNzZhRaJzkT06zUuhvzeo+hN7pi4+lfZCaMZYCvHkNCi17GrxIUpe51JTzfoTp7MicB7WPNBmcutlpZbh3MYJ01sDuGM7muuamVEC7AnW7oJoVsdVg7pcZoc+2We1KZam00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L27k+ljY; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L27k+ljY"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6ed32341906so2169251b3a.1
        for <patches@lists.linux.dev>; Sun, 14 Apr 2024 14:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713129486; x=1713734286; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ZHsaHa41oigrMjD4LKjbkplqhy4ZTYVhx/T8eHvHZw=;
        b=L27k+ljYNP9PJ+QaRQBlhhqs+IYgL9jNBZ09Y9kCZM8QeDnXEmQTOITiNyFlgibLMl
         TvAO73s77YDK6vH4SCZxr/bM/nJjM3V94x7PSRgSMY7TcESDsNz9tYYf+NI9IhMQBDWa
         96R7ehBmbaNpYL85y+dcEDf+oCuzJ50BOOBATGuBkjqOPOfxqPYbFxLFA7sTccpe20+m
         IjkOW4FYu18C4LH+UdS8tYkNwTpirDH+2vpKM9Ll99dQFRCApkC6Xd2GwQXcfrTqS1bl
         wiFESwyEG1CEmH+0EpJLUTo6wR1Te1QU4sdn2fgeRGJhlP5r5hXosGBfESNFMwDEBiDx
         2hSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713129486; x=1713734286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ZHsaHa41oigrMjD4LKjbkplqhy4ZTYVhx/T8eHvHZw=;
        b=JNeUbMpxXL2BNajN1K/8EClFcSDDkI2F+LxhmBUCoNr4/hgLVNSjJPHEf66/eNzRYl
         cs4hkSZhN+ahxfY+fd3jQQfAlr0rcODxWkBRNn/uApRSC3wgaMKlfjRnVhnK+6ZrCWWx
         +/WDb2kZ8yII0Mi5yEfKCz6Id8RUm8fS8BKauRNGkLJq8XKHec59mDu5dPa9un0KR0Ci
         k920UoxzX+zLj/zX/YVGQp5u6Nww/UA1X+taCJUfmJoqUxLWv/fINxx9n26StN4DdPhG
         gxz/tWvZ+YJCN79BuUgOrnxgUO22zqfHYpI5YZ8zkZ+izTMc+EhyrCNcKh50JqPUQr6u
         n0UQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7MVFevLo3lQAgTDu/km6bLaGiQA0biJsGrS6rOgVhepzUVt6q+P24nvmbFc80zC6D2TeGpnDXrHaDWFMBdBiX2PFpUfLzDQ==
X-Gm-Message-State: AOJu0YyQT9m3F86gjZwjVe/aiW64xXcLhnqSl8gZHoK2++gr8LF8R4om
	a5jwmt1lIxE2/L114fVFa2NGALOidaKZBphhJdjHlkt//wuEMgh2
X-Google-Smtp-Source: AGHT+IFTYF9O0qn/emzVcYUt15HD4pY5VqmLs2K6GAWKwrb3f+qHDW5ftkqPaEPm11vtJiCFfG4NiQ==
X-Received: by 2002:a05:6a00:2308:b0:6e7:3223:4556 with SMTP id h8-20020a056a00230800b006e732234556mr8029025pfh.32.1713129486139;
        Sun, 14 Apr 2024 14:18:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y30-20020a056a00181e00b006e6854d45afsm6127641pfa.97.2024.04.14.14.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Apr 2024 14:18:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sun, 14 Apr 2024 14:18:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org, aleksandermj@google.com,
	ejcaruso@google.com, oneukum@suse.com
Subject: Re: [PATCH 5.10 000/294] 5.10.215-rc1 review
Message-ID: <039f041e-ca03-4750-8d69-87aef0ad1752@roeck-us.net>
References: <20240411095435.633465671@linuxfoundation.org>
 <9ac4f94c-414e-4c12-bfe0-36aff3e318bc@roeck-us.net>
 <2024041411-stencil-unscathed-bc65@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024041411-stencil-unscathed-bc65@gregkh>

Hi Greg,

On Sun, Apr 14, 2024 at 08:09:39AM +0200, Greg Kroah-Hartman wrote:
> On Sat, Apr 13, 2024 at 07:11:57AM -0700, Guenter Roeck wrote:
> > Hi,
> > 
> > On Thu, Apr 11, 2024 at 11:52:43AM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.215 release.
> > > There are 294 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.215-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > -------------
> > [ ... ]
> > > 
> > > Oliver Neukum <oneukum@suse.com>
> > >     usb: cdc-wdm: close race between read and workqueue
> > > 
> > 
> > Just in case it has not been reported yet:
> > 
> > This patch is causing connection failures (timeouts) on all
> > Chromebooks using the cdc-wdm driver for cellular modems, with
> > all kernel branches where this patch has been applied.
> > Reverting it fixes the problem.
> > 
> > I am copying some of the Google employees involved in identifying
> > the regression in case additional feedback is needed.
> 
> Can you all respond to Oliver on the linux-usb list where this was
> originally submitted to work it out?  This commit has been in the tree
> for almost a month now with no reported problems that I can see.
> 

Who knows, maybe only a certain type of usb cellular modems using cdc-wdm
is affected. Either case, the problem was found less than two days after
the stable tree merges into ChromeOS, and it took only about a week from
there to identify the offending patch. I think that was actually an amazing
job, given the size of those merges and because the failure is not absolute
but results in unreliable tests due to timeouts.

Anyway, sure, we'll get in touch with Oliver. Other than that, please take
this report as a heads-up in case anyone else reports similar problems.

Thanks,
Guenter
