Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54C038F647
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 18:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776106319; cv=none; b=TRHhkEiri/+Vr8W3smMqT5csN1UKhIKmAGtUaEGse0TvnOuk4+4Kwrk93Oe1rfW+4jSC5fsxSl0ypBi2a7xoLqp43XPgVBk2idqc8v+S5Wt2obkWGWZ1MSfbFFB6eW8oi3bLnCkBKR402PSZrVhE6Ds26iwnnYuioa0svbcEW+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776106319; c=relaxed/simple;
	bh=7OReK0xhaVWwzq3lCjA8XnfHRyadhGmFgqb2ClITC+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I4qY8moYscGGijJi8j3oTUAV/gnic2PzcNPa6JwOoQ4iuW67W+LZy3Iv4EStT72y4h6fYKZhMQvvXls0WNdHWO6Vibx2bU7tRKcILNBgiui3xup3n/82feS0KoqEz6nKcecCZWtPTEsN7NrM+w3xGWedaW3FpuTGCrXZ44M8q2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oe8n3ex/; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oe8n3ex/"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1273349c56bso6335535c88.0
        for <patches@lists.linux.dev>; Mon, 13 Apr 2026 11:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776106317; x=1776711117; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1EBvOVAJFA2G2UKFguZ/FfurCHUOcXs61KpfGnt95Cs=;
        b=Oe8n3ex/1+yHk2NDDasPzKWk+InGd75uiuHKSHuCHV57X+CkPlYk6H2dV/M/z0OJSk
         81M737mppXS+PHaUdqmT7CivjFWTLZNHCJn4lLLUEf8wtYWL1d8cHx3ZEItctY+y7BGZ
         81gkaihfIFQxGgY3FKVm8n9lGKl76IeQS+0DGSDZpiQdXlvTtRK27xeDqRNZd0YutLrA
         zZZXjyhiHangoalsfiFesNT1gAbUeSKSKyB0NH+RWr9pEbQtqzFqS5ddNZBL9ZfD26QD
         E/zTVoHBlJ62kscQPRqwUqmGQpQpaO7J5gRbvJQzo0n+tLKpUsNjUFV3zc81cG1VyANP
         Jzuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106317; x=1776711117;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1EBvOVAJFA2G2UKFguZ/FfurCHUOcXs61KpfGnt95Cs=;
        b=B1CCOoaf/xq/h4vrCdFLUuUOrhRLmlyUhX+l4tQYZXvRAwd5B11WfpdVkKG4aJY4n2
         3AM3/4fXlfSWw39as/yGoTAIaLDbnoSWNbSHu4HWIuIUTD4uhutiQGMc/BzQmwcBL49h
         EkXaCGrZR5ytl/El3Pu9fonw6W7F3uYfUCzOLjvVtrdu8TDo1lzOG62RUj8m5U02TNev
         SYU3b6tWkmlU1rOvjlfOBEGJ1QGB6QsNwbOdjEQcY5AQBVOB/XN1jPJsCvXAM5jSuWvM
         vE2pO47NPanNhynN53wl786N6QoLWki82wUa9CPC7PaNlPjVIWZoIugOEfXQLpiZXlNY
         cn9g==
X-Gm-Message-State: AOJu0Yw6GHbBlqYoPV188PhIrWLRsWhNBTp4EV6D+SeWjBcJ13qyg+vS
	p6Q8QeEDPUBe8HaqhZ+TC3LFbXE7vbtu27a0DvwO39R89Iwuvujga2XibwLIrA==
X-Gm-Gg: AeBDietY8P3+CUSuS5+1UrV2+CKRkslN9v/xc3G7S9V+AaReiiSTKISIuY1bSXUF1Oj
	rstNkm5NZQBlMy3vr1f9VBzYll1x/DfSVX+rPmqiz6rAKM9HxEtrM4JkZrBS1TSsdWkDrbpYoEq
	rU6OIFu3daJAMjKFoJRmKxziidWjpVxgyajUDYJMc4CjvVw4PdWnu81WHIVzgPPse4TwsO031jK
	mgiNLFOurBdTF7hQ4+e8t1EhAqODXiKi9GY2XZrro60Xf8hvB5dDN8aWfIR7xplNGrWIxg0Sq6E
	SVtewBiYiauo9YLm5xwU1aeYr+bq9TvFSnr2epHm+AWouFLRQAs8N88BPHEgFsry0rvei6vrUTe
	sc/DUFDzZYUlMY3OFRNbXIIexCIptNfbgBuAWKizNWgj3boSsltGQUnLzhSM80UnEvqexDzmZ0V
	hiqXz0Y6EA6rEp2aMYMyM3/0Ef/CihDKB9Ydzwhb4YmwHsdJLHHA==
X-Received: by 2002:a05:7301:1e91:b0:2cb:c1f8:a7f5 with SMTP id 5a478bee46e88-2d5881a8fc2mr7509739eec.19.1776106316736;
        Mon, 13 Apr 2026 11:51:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d562db6ac8sm17717582eec.26.2026.04.13.11.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 11:51:56 -0700 (PDT)
Message-ID: <ff673bea-6a1f-4c0b-bec7-a0bc5dec0970@gmail.com>
Date: Mon, 13 Apr 2026 11:51:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260413155724.820472494@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 09:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.169 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.169-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
