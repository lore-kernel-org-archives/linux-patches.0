Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795236425;
	b=SqT5btJlQtEfvIhXrXftxxa6+ANq7unHsRjqkhKXIuwjcqpR70BeCUPbSn06L4Uz7zoG
	 IyCiqa122tMNokrTD6OYtme5+e+4jTOb4Kagyy1CsnwDLDxTkOHSUK1qjTft23jnzO38r
	 ehc7sPFB58iaGqUux0q3TDAC7bCPeTDJ1Ljz1MC7hLv5y0OTBl0lNERq1fEDonRyArSeS
	 r9eRhPLgi5quhH8R8NcUMeRgRXKHoqHsegEt3KLrkPUffVgW8Que/SUp2MuHap+xFttoE
	 I3ifJSBuqijiXKMAa8ytLovsi23S7sIeH/q0nCGndLXFl8sKlJNONM8eggg8FNuflZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795236425;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Subject:To:Cc:
	 References:From:Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=/CB9rx6q4lOQyZURMO9hFHlkxUMK+i+s+ovpJy5IDcE=;
	b=p+NauZd3pub7aSgK9C11/G/ksUlxng1T8kt9dISnHWkh9OD54meg67YLEsbOaryMKpde
	 rLUe4lXa+WxTB5hoFkLoFL75Esay3KrMmRuw7W3OWcVsT2JrlFkpSLr6AN7aqSrwV1TkE
	 A0YNbRwzsAUu7hBoSzg8TAnhQOfM42SgT1sZiZx1e/TLesspBv8rgBq4NXeWcOa1Racu1
	 iXz0YI1BIJdsCInP0pPGI23QNUxhgnZsvkCaAfWElfJLT5vGngD0W4B7/Z6+gAC2U8Opu
	 u2iozSwkA5DsiFS4SpEcDtI0pGNqKcqviaMUjfIRRBTyMZvW6A72A136R8YFXKORJAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Bnsx4xGt;
	arc=none smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E18606A6BD
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 04:47:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38E18606A6BD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Bnsx4xGt
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-92123f02faeso13497486d6.1
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 20:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795236420; x=1795841220; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/CB9rx6q4lOQyZURMO9hFHlkxUMK+i+s+ovpJy5IDcE=;
        b=Bnsx4xGt/Cd6rBSvoUhjlOnUdw9r/iAY0+7WXqtGODhTV6Le8RlUE8bZDfI1PBGLyK
         QN9McXgEV3B2DJk1Et3TG+Y+MAqrozKjfXV88JYVyIH34tZb7y0+pV+48GeY8VKoVFzx
         CLGdC4wHJ5rGcpcStvsHmn+fgk9mNagAougotLvY2tPg3c1rJeZJ/vtsxsbKCHxeZfwu
         Uk/Q4vmd4WCzAY8H8SXBVq3fiIi4vg3b1OiOiO5aRYEjfC3jP4NV5ndj0QFHQCNo+W/H
         GB3gpbIPKuc5hlqAvc/TmAQmRqrV3zlAe2bsnQONcVVcRw6Uv2Yn5HibsVEBV8rwksaX
         PH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795236420; x=1795841220;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/CB9rx6q4lOQyZURMO9hFHlkxUMK+i+s+ovpJy5IDcE=;
        b=LAc4RZwUfYauaY2cgejx5gQDk6wdNbz+G7qKJE/Pfv312tnaBQtxZedTX3yDxPRCPx
         x3i07K2Cri8vxCNd8Wfn2SgxoX6BAkDkLvCjtyY5bDZuTsl7dsMPk8Al0+lDGl0DlUSE
         bk/PkhXLI4sIu6LAHhywWNlc1wvO3G7B3D2C3M4m50Of45SwAhN4mFth4/t/cUt05iFN
         CV/JVy8auCEwCK3Q34byCSAomfphj/DYgYmOJ0ams2TvyxtoP8+82RpDt1xI8/WC/twH
         KcKQzxXhEZW2uoH/Yly1Qhce69FiDascV2RkDJJQFGXsHIKQyUE8kJzKXcKG7YuRpd75
         ZdhA==
X-Gm-Message-State: APuU4Z/uJvbicWcLKVpNkIC1II1eKGPB+6zr5ExnT56BNX5sD31VS9Fd
	/2xXD6EW7Mcxq61hal7vhPIyRq+KdxLjr1yz4Xxtuvuypj39QAtYP/g=
X-Gm-Gg: AZFdTZd40cWN8vYp6hEWsMiPaz8wD5DIIU83aMaqu2t3SMu8O8TTHkJ5+c7PiAVl4Ub
	elz2xqP5rH3dON6Bv6jniOWiJ/PBkBayV6wQiAFSyF0pxNvbwM2FzWRyyvpHei+GwjEXzjepofx
	HT3SQotM4XLSS48dVMCyRei721xcUMe5CTj+q0Coh4kCgLL6LJf+FzvzsrWn/Atnr26Az2D5YtN
	A+zNMtQ8oMzVPyQJkbzNiv6qQGt9y/Z+LoiIjhefZRCfHVwdW+poGf3cuNv/ZI4YtN+ozs7Y6iO
	EMIuK/OgHrOQDAQ08OdMGjuBjPHmAdTQNwFbXdeVN2d3Mgh4N6l3ppoPbeNa3AfoSR8m++hyuiK
	0Tz+0GqhfOlXmDv1CSDHleURVFSt14P4T/ZqzHO2a/MaARQG7sja0lCTp2aWzYiG9EfrYhcSfDh
	FU8Xt58JPrcGaNdZTn4vxowc+hXuUZxeEi6qwYr2zioiz7D5virHcl2k1yNNvsGhdATFkvcepxn
	lj8RrK+uL3Pl8frDdEB4vFTJyN5Jx9Pv5xciTA5dA6uoY7n9R97PcZT1WZfC7SvLpVjMvP6yiUn
	Ab9JboLxWdvTOM/uPFQb52PXN2AOfzWUn2qPPjhp4tDd1TC0KrmFjkP7xdBtvMoRpkUJkrK8+Vg
	bcPxlUNuBmw==
X-Received: by 2002:a05:6214:5701:b0:91f:12f9:fc6e with SMTP id 6a1803df08f44-92134a9b97bmr100160196d6.31.1795236420154;
        Fri, 20 Nov 2026 20:47:00 -0800 (PST)
Received: from [120.7.1.23] (198-84-204-175.cpe.teksavvy.com. [198.84.204.175])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349b0b10sm44711596d6.10.2026.11.20.20.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 20:46:59 -0800 (PST)
Subject: Re: [PATCH 5.10 0000/1811] 5.10.275-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261120054906.397973290@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <488235ed-c296-4d76-6d3f-430db7877922@gmail.com>
Date: Fri, 20 Nov 2026 23:47:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101
 Firefox/140.0 SeaMonkey/2.53.25
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261120054906.397973290@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.275 release.
> There are 1811 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
>
>
Built OK for i386, tested on a 32-bit EeePC.
No problems noticed.

Tested-by: Woody Suwalski <terraluna977@gmail.com>

