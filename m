Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795205752;
	b=WPBTsroE2iKp0J5BifQhqFC2T3cIqxedMXukiGY2HxVztMPnmYjEpW9w57oc22ZW4sVC
	 HcHmtNluTBif6IUfBYkGfJ44HTqOlW7c1qHtZ0hhlow/4fTOX3AtpESBj7omTbczqQIdd
	 9OhqCXmVxT6ESf6cbTG5ToHIY9aAbT3yhodY79B/t9f/Z0T6GlXyx/WCkPjujE7CRQGpH
	 hph6MdlHPkVjt7tmjELFtnVEswafDUCGeOXtmS4wy2gdazQH6+4GAHfCQta7NSxf5GJKE
	 JUWBwPXBFObGYckxcHmMeKLjFwpAhci/2lvUmxiy+b8JBeRwomKkN4VbbzLNbtOgNGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795205752;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Bmres2veI4WmKoOO0djqwZlxjU4vTSr8LiYOV14rpMI=;
	b=grIsfqL5nuhVUNAy8BpVYVMEFntDTpILK+LPeJrRwU/Za+9MzHRQdAgVlBSGsCc4Owlz
	 p0crcbC7EDT2+jHua5KqLOfHwvuQ6zES8Ufom23d9H1EzrTQfKqzAwpMil+wlLAoJtiBA
	 MDNgIdRQDP1JACm+YuzcIyi+ZjwbFEr8jKN6oferEo528KM4ClKQnhOYoTxKwovfUz10v
	 N33qIdUFdiaSF3+fvk+LGw9Pm8SSmrRovVhL8mAYSEx+g7uSG+EM96YX+ljeIqsw56wwS
	 Z5u3r73qRa4EZb/9VmWeLPrEYi4TvIsNRLRLpBCSNbhC5Dpyl987YtsIofZlg25Bq9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dekd523T;
	arc=none smtp.remote-ip=209.85.160.173
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF52606A6E9
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 20:15:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AF52606A6E9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dekd523T
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-53634b8328eso12899011cf.0
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 12:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795205748; x=1795810548; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bmres2veI4WmKoOO0djqwZlxjU4vTSr8LiYOV14rpMI=;
        b=dekd523T8VRpGLEUJv0c4C6lNJbVaRwLuYzeRtf+yAROL5xwoLpIRS33hJmw/u+sTD
         sZ8oQDuQxQhYuCnFBkQs5ITjHap50KR8bIQXPMu8AE4s0KhRsqD2hDejtxa8g3/LW/qO
         UzFEXMQ3IfpJy20ELkBbRwxPSDDxjNhds04ZgildJCm4d8tbDNP5kLj1fpgDdpdSP8r6
         lxl/qWLOky/N1zBhAMz3CRA8PaSkcCyh6TEeaPz5l2PqrIbE0yNWOFe8+FWU0oikIbae
         5MG/Rt7l1GUG/Ix/1X9XeAQmrxJprX4tPydpozRR5PcouRtcJPy0S5nodBkRUT3XZah8
         MdAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795205748; x=1795810548;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bmres2veI4WmKoOO0djqwZlxjU4vTSr8LiYOV14rpMI=;
        b=j6xbmTSo/2+mxMsX6OAYQGRAjsqB4c3yR/Hjt8rrrVoNK5FMlfMv8ZkzmLEf/PQC5V
         iBcSdfF29edaUqI8yMBzK/RKQdIVWvjNJIba/X09Q6o8/Gg6gtXy0YUYCN8GuG2S520W
         pj1Ol7xCDtQlvrpiXYBHzc9tbfwNnzdaz3gGNz6TBd0IdPVUFeFo7wXPksPJvrBCRZiz
         3KwMZrwbEgUZJmqysQgSorcnfEQ+iWJ9PYCHsgKewyJiiSbh/UNoaJ+Y9V/Ue84O7FpV
         xtQyL3wHb1xd9T9K8+qOdQAEDopTeKIwzUFtnEHoPFIJzHPaiXxbBnmqmrLhgHMHFzrm
         R+7g==
X-Gm-Message-State: APuU4Z+XdcpsWd/Mh/nGB7534biN+i+Zd8hlnvTbrvYSdxDn2inciELa
	6HuFuir+GJRIf9kNBNJKdjI2QxM9JUoXxt1+jR2Fp0JMNXE+qfTyEHdW
X-Gm-Gg: AYBFou2Nhfq8nG0gonR1Rq+LE+jnzjgt5gTayOCrKtoATfV+lUwU+6ZcmuDfJ7cRQoy
	0Uidqc7vqMQggP16qqf79F3ztaCyMRKtlMkuk/+duOA0eT5+LorSMatnUUEXQrewRCGpggLUZ/8
	ATKFftEjD8bkwLdG5CjyB5Kr7tk4Dl7SWoUlukM+XmdmLONvbvntpfYZsCLpMU3N95H8wrrLgBH
	1tAhVhN43VznecK2Vr+LGJ+Pf1LNna1c2yQRmYFiQgNP3bdxIT2tXryjrL2YmOauXWvET7kbqYE
	h5ctgiLscjfR52k1syfQimTyWA8RVVAnCEI33B9Awj07WW0dyDLJejuQ5NXXWg5X/DzMfoEK1xm
	TInmh07Fb5d5h+1kCr5cgtw5XqZOsCZnLrb7J9rD0I5nNuluXxc/hm5GUVWwrHamqiryVa9lfgR
	K1/eADX4PSPmEZ+jt0Kykdq4ezidD4GWwhc7Oe/5eKOLAwZI+lcd7csCWsMt3RVjCdRr80fxPg8
	u8eZd6fflB/ZAuTkxFWwfw3+B+3FQo1ddBoK+JkqpR6OmB3XLHT8ukbVmkRajH72IkhjXYuY3Sn
	sKQMObIT659dUHgw0Z55vbnfkSDvQXnAdm9HBwSNpI+kHBDfSNCsV/SDws4qmnA3hXiJ0hO0duu
	TZA==
X-Received: by 2002:a05:622a:230b:b0:55b:f621:e7ce with SMTP id d75a77b69052e-55d76a26c80mr68335001cf.25.1795205748149;
        Fri, 20 Nov 2026 12:15:48 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d78807b5fsm31219881cf.6.2026.11.20.12.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 12:15:47 -0800 (PST)
Message-ID: <ac9a7cea-0d4e-4856-b796-03a1b887476a@gmail.com>
Date: Fri, 20 Nov 2026 12:15:44 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0000/2178] 5.15.226-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261120055015.328810133@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261120055015.328810133@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 21:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.226-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
