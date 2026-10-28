Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793220211;
	b=mtNvQ3/zGXHN+/APU5ZcFt/4csfTytI0BGgouBddL4/ZO0pBsl1thtpRHEbvahPWEs3X
	 rJ6+VpaXBo/KHNIidnYi7319N1qRuDlG1i5xMF7CUX6Ph0wXTa/CPTYPR7T5UdnCUqWif
	 5yYCXu15kyMZvwCX19hKW8IRUc7Yj7i4iEIkzeMNjZJNwPEIYMQxL7rfBGCwoSBDm0A3T
	 Y5bt2tRpEQoGPVDTCKK5aKdkwd7uFV4lvJh5fhAX9PS5vNuzIghyWVL5vCtnJE6w5eLVz
	 +l+1UzEi44bqwBj2q667IrrVK6jLq9oI7etngF/+/hjPNQwRlY6v8vj/1Z6b9IWtmWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793220211;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+Knq+SFx3pxVCNywq9r2730akCFH+DH4I66drqpj7+c=;
	b=zCv0ZwGUrlpy+rMmrew4yBPZ145hrE1D2gWFVb7lYTT/5NMZXK1LcfocGteb+iiAoaZw
	 lF9H/bkzkdQdTpePBULJWWTc7C1idAt9bw2xP4o8eKYa3bMMYXZLRq6oiwjvDhChM/rJ5
	 klhgmIClomPE7dgiBmOauUCaY3Hf4OTzOn+8/cNNsu5plaFVGc4L+Cv2Os+TcpPbIlF9A
	 1fBYX+oLj4zZr7fniAaxFOEydc0kZ21bbvWSUMlcSxCotBQ2ETWgtXw9jr4+x3w7VUBgy
	 Eysr7dfV2DhzJHFBLfGex3CeB3shkfh01gnFdLuX/eEtu52OVVvlAeKHNhgZUfC8Ofg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cRF9LTRc;
	arc=none smtp.remote-ip=209.85.216.53
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E946B606A31D
	for <patches@lists.linux.dev>; Wed, 28 Oct 2026 20:43:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E946B606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cRF9LTRc
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac6794fe45so1173313a91.0
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 13:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793220210; x=1793825010; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Knq+SFx3pxVCNywq9r2730akCFH+DH4I66drqpj7+c=;
        b=cRF9LTRcsnpgyM0EBNNqmYm3N3sa207++d5QNiFqDcV6uO9vOeF6qJBQex/8cq36Ut
         jQ9aHsj9PypngF88hwtaSgo+y/rfFOSAGyFtdf+5U9xISuVhlZHeE5Re3Q2j8wLuqZPz
         9L3tLCHomHEv9/S+2Hfvt+eQJDGGyfzB3e++Auu1sHrpqwAGbgwflt/JU2EqMAqi6Cva
         dt6fdJeUq5TgsFEy/Dx5Snxj7OpsJpt6r1eSmsRdXIXqAtaiIbLiH3ykRy4FLQiiSgS6
         23RC0Uy9U/rYUkeK2mspf+nHY80c2L3OM/0RCF6ES8pZpYIQ/UHfBL5ZXWaGloMQNC04
         d66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793220210; x=1793825010;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Knq+SFx3pxVCNywq9r2730akCFH+DH4I66drqpj7+c=;
        b=WxIxrpz4fNTakeKkO185uOsGFCQePpW0YJhWu7cKPRkbBuXIsNzrzzrX0g8w6txPOO
         k69MBkuFN8KkeHWGTH/KddlDNhtPIoGBb99XFguvihr8cRXc/szvB4JenbOzicDCgqoj
         7AO/kduQK5c3V+unBhq+qhJHJG3LV4SG/HRzFKbQQRhlpkCI2Himx/L2XP/xJxS40Ur7
         IEhxMunq0eC3cF2AA0reG3OV4sb16Eb/XdE/kKlp6CcmEkzSff0IpU/8uQjdokS8XqR9
         J8O3pTRLg8VXA2x4hZp1npbMjMNhYYB1z+sL24AYZRT75Mc58hJxTYhKxVBi9bu/v1d8
         MW7A==
X-Gm-Message-State: AFq9FYLemnuDYp5KVYu+biaegcGSQOydY0qHPT4KQO3kAPzDBdceiEyt
	/OG+H8JfcOUJnflkSND49CckNoRMvoCSaUp0jpCDGx+jIRlR1+r82DKr
X-Gm-Gg: AYBFou2Q+C/sXdMnD9T0v8LZVG9WGQeBUjLmu1492Pbe29Ah9A/tE83tOAVil0bkbol
	B6YuFKtNw5DwDg1D+vm2t0293ebfMQGUlPKJV+TAil1SaIziewTksbD7uDoC6+dWMXLC3IlBJMY
	37rQSWnCh9um1mXY+VLd2WQfUKOmRrXxfOQY/3cyaTgsTF8FdCTIYjUIiQyBvn9NGzj4RuszfF8
	rVruieKUyiV1ZfVP0qhY4YF2AnXT1CJSG05gfxcPrX8qrogDyi2JdVr8EKQRDgDL6kZZYHMb60G
	DFEIzIIf5vmMbOrNX41N/J1DIlAPuzB+OLTMWsQcZX3I2MsRuDTZJkVHNaJ4BWzkmMpCfD6dJfp
	iMSfs2z2UJw4UWsyMKgdus0Yc17SFFfdjMnj1kj5P7vriZzZJqaOkGVGMndKIKigoOkB/9VGhk1
	Ig7A1P2KPhxW1ZgUJK81OmYvYzd61OJ7YL7sHdDr0c028C73N/+KVdjDLOOxfOslq47MUdf962G
	eqwS6J4A/NdetYmMr0orVBfIlI4x24tUjYnSTqAFU2klV2qcCMxxuKGyNBVA7ISP63OhlA71sdg
	jvja8dZE4uHpx/Sdrbh2bN9sEVkIGm97huIXdhVtwp4uCdulzQb1VLhx
X-Received: by 2002:a17:90b:1d44:b0:3ad:ce24:acfa with SMTP id 98e67ed59e1d1-3ae57f638cbmr2422136a91.20.1793220210245;
        Wed, 28 Oct 2026 13:43:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e898317sm940454a91.16.2026.10.28.13.43.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 13:43:29 -0700 (PDT)
Message-ID: <7cec1e35-fbb9-4e9f-ab90-c81b7af10aa3@gmail.com>
Date: Wed, 28 Oct 2026 13:43:27 -0700
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
Subject: Re: [PATCH 5.15 000/571] 5.15.224-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261028170008.009143722@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 09:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.224 release.
> There are 571 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.224-rc1.gz
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
