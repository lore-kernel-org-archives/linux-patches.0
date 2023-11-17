Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8793454C
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 19:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8OIA4Bw"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-28098ebd5aeso1911688a91.0
        for <patches@lists.linux.dev>; Fri, 17 Nov 2023 11:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700249288; x=1700854088; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=id9bEmxNMwkBfvEWdosyxs6JLZUmUudjE79JcILkBXw=;
        b=k8OIA4Bw0n/5u1DRcYsrY2hoowIVkG6T7d6U3V0BVgm/UksNfEPPZgekSSDItG9+Jj
         7NVEsSuQ3R8SWr/YFl78aelcD/Xft8tcG6NW8oXPXy9XyUcnogitHx6EBi6ldZWGS9ZC
         ZW10WsZIp87ov5M6l9w4poiZVGSqYE/SFScAfINKb7bBCLvFe38FAISA2n+nf8D477IM
         gCS4eloDw+aqYDgZrEE7kd11uhyTTQob1G2uid7I/wRAw4J1G9U1seEv7ADnfk1WXvNJ
         jWFH6p+slYxbiTwUNDwr8Ij/wchjpdcPz8iop1qaPOqC51UiZF3UTgQAD2AGy6/IfT6w
         9RCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700249288; x=1700854088;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=id9bEmxNMwkBfvEWdosyxs6JLZUmUudjE79JcILkBXw=;
        b=IHlzzoJp39j+8+mHykfFt0P6/ZO5m6MJtCsTfNbz1pvXu+79etQW4oMigzYydpOS/8
         Je7EOAt6WUi5idvTGhOY3I2UGtbrT49MavnVRw0vlPXx0VIEojCeOFDHdUvSfC9omfjn
         6ZKaiWpV7kXhNN2KJPGe6cthXSDtDSp9+1umbIljkUrDPZquZo9djezk5JB3A+707j8s
         iRBfW9S84lI8QGCLcGHQJKnnc5oIJMaHcDHuwyoPsN/fa5rWe1GZqVXk/3NY+SlfUOm5
         maMVZvAvGPeabcDq2I1l4Cc9r5JFmER5QfHAY/6OG3a37H0bhaO1ATxJ2OXG3kTJ3w2L
         ciCw==
X-Gm-Message-State: AOJu0Ywgf9jktHZ0gHgG2g+zlNjI4EGdgHsB1Sj9Lsa0mPjUomFdDf+n
	c/D4doF2wYpXlGnxhSJ2tktTbPMHwDhv/bWI4Vs=
X-Google-Smtp-Source: AGHT+IGJoasHnwhcvJ9VGKmXyGSubTd4bNLiRRuYHCgEvsNQNZBbUyo8u/UuqpQSWOpmglEOb+bMqvZtpvyxsugZYWQ=
X-Received: by 2002:a17:90b:4d92:b0:27d:97e5:f3fa with SMTP id
 oj18-20020a17090b4d9200b0027d97e5f3famr455694pjb.29.1700249287877; Fri, 17
 Nov 2023 11:28:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115192645.143643130@linuxfoundation.org>
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 17 Nov 2023 11:27:56 -0800
Message-ID: <CAJq+SaB+R0Aox4wvEXt9Qjtq+xi9fAqerakEzXvj3b=UjHYx9g@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/379] 6.1.63-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.63 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Nov 2023 19:25:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.63-rc1.gz
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
