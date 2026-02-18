Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA64A2F7449
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 04:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771388729; cv=none; b=M1Z0bAx0b3VYtxKA5ciUN+Vmii06pNMlgRq55mfUuDxB4kW18qSkzh+HhUpM3X5Fe73evXSOnR0J76b0SqvH11bEMdMGIcmqjt3gcTnzZxdf/oqSkLMFNtgrNaD6Suhi4Fv2oHZW5D8ZY78W264i3t7VReqp5REvU7sLpk/CTwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771388729; c=relaxed/simple;
	bh=K7UGgyHiqsjGzNipfuJaySEfDiIRk067pWPJgz/VZFE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aK2gy7KF1d+2dxDfPSTcpiotN5FJ5hHxOHmFY7EGXyss68nIoPWM4tMDM6Jlz4fYhOn50vvhXO15zis7gtYMPAXyIKyt/bUEutBsallP/Uzhl0+H8tS86x797Q8BWsYbfyL6Q3m77a33NKtakn1gNGZweX8AmEwou+jmaBjnU6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=JCFt2Z9O; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="JCFt2Z9O"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4837584120eso32323455e9.1
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 20:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1771388726; x=1771993526; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gxYkdkpfCuLqQUe3oaFgMp8zU8CGCCigXFsjkMzyrV4=;
        b=JCFt2Z9OwFnRGlWhLGKis+wabN3oBJKozz6AfV/eANXSnFU2jC5g2cAuv0ojIsRmJS
         n4ayet5zh3fnq47mqUj7spGCR+kUkTP5gYo6DR/cZP7GZlZl8PyTzhSghvQTzKIPdgQi
         qjlI50ozBaVN3GlAUvzE7cKNbT62iys13kAgHp19sdW4HIIQ3BguPco8+XvyxDDKGg5j
         VjUZKjuty5pBh/RpraREh4xHDny3mINd5BT1cWEcPb6uvtf0ofVQRhKKEjGBE4/Ls7CK
         BwBGngqjMo4qrtlj2daL9Uzb7qfhzmop7jdN21xt7JQnkYVUTG19y5DL+iz2U4wDUg30
         LAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771388726; x=1771993526;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gxYkdkpfCuLqQUe3oaFgMp8zU8CGCCigXFsjkMzyrV4=;
        b=DcZRJI7KD2KVaq+b4rmaOeWxBAsH+lhuzW6iDU3e48cX5USslvzXjTYyChuViFYweK
         LTaEJ3siOrXDaiwcUuQQmKMPZ/4nkjmFCG1gC9wk2ZGaPy/UMRJaqw2xtWLF9x0GCfau
         g9VUSxxBfUPrfu/5CS1lT2H7EPioq63dvAlm682De49Ii2zy+QqgDT2Jp7JpuGpjvpfD
         lEvcoATU4vEZELWyFEq+osK0djGPe295zim+Sus6PR2MdvACanJBM3nyQZFuZJyDnBGl
         4/Hq0IJFLcSbGL8Y1NWOmZz6FIUlMXediUeiMTQwsNaFPTsd/R0X81lj3UQ3DTRne37R
         7evw==
X-Gm-Message-State: AOJu0YzRihO8A5sppDnPhR2TL6kGBk6zDB3ZRe7VmvwwEt137QzHqKbO
	tlEQT2k1xpHo4/ceVozYcG1CfTs9LhTqKVfAxbyT8Pm2jlNhOADzNOc=
X-Gm-Gg: AZuq6aI+wKk3eChZCzr2nwvDCyevXthD41Nz6i6Aei+U0dC+YmcNgJWeIIcjOynyWP/
	SM/yi3ygmSBRrxiB4UVDheq/Bso2nsFqPQhHtDZhHIV2duM3qK8BOgiXq15YgnMPPjd21eHP7y+
	OIXBmrYj1xb3Pr8QCc+gD62wq8E68QSk8GPCtAyIL+mD0kxKS2wNNErmuBKUsRXwHVXAcjQaGux
	X9BisXiUDJ8w0HLL2qBIgjn8qlMkdUlRRdd+TH0KzutNS1AVME+nBknw1OJHtTPbEExec/6hdFZ
	Wu5iOa6Xf7rPW/LJzpQq37WmIqZmBJ2NBDu8KhRgnL5fxqllh1nwMTcCCVZ6KofW+qREoT+GfQy
	zuMa5xXk0VC3HDGgKGCx4xOhyKg7i80EYz8Z4zvENkeRa2i8DdmkV9NFRX879owu0xrEZg8/T4O
	zO6HRNXJCBwAWhPGt9TOqCfACpRzQD14MJiomT5ofRC3kqjNf0j/SKqQL6xTm5h3pkAgevchA6H
	Kw=
X-Received: by 2002:a05:600c:c095:b0:483:7f4e:fef6 with SMTP id 5b1f17b1804b1-4837f4f00f8mr171570925e9.26.1771388726011;
        Tue, 17 Feb 2026 20:25:26 -0800 (PST)
Received: from [192.168.1.3] (p5b0574ca.dip0.t-ipconnect.de. [91.5.116.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a6c1bfsm40127691f8f.13.2026.02.17.20.25.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 20:25:25 -0800 (PST)
Message-ID: <46c36fe0-77cd-4f2b-a121-7439efc37ae2@googlemail.com>
Date: Wed, 18 Feb 2026 05:25:25 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 00/18] 6.19.3-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260217200002.683975158@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.02.2026 um 21:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.19.3 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
