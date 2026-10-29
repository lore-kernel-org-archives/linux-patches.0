Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793296089;
	b=4AUN75ZMnGBaDKJZu48Ou5wO7Ueei4SWz41HpWzQyoJHWbZ8FJXwt6p4UMmGZRNYw0jh
	 05jnCv7t3G3JUBTgCcrjk/yPqwdbuyBwoqTCIHym80Y2LTnnRM4YkRNNm5rQjK7fhRgYM
	 qiBlTR4s0TiEdzcmFaIoZLKSqVZ9AuleztjvmwfOivrYwEV/HrM/a/dXPZj8fiNhP4cGI
	 cuPqp0K88YGy5InRJgK7kYkxjPAKtZghuZ4grjP6beujZDqn7BJ8FOBqaeyUTyFm+g9V8
	 Bo5b5FBVRGxVFTIgSJJO5bO235GCr1YwLtUqWAHxG4/vcYZr3WD6SzeSgntGi2T5Pow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793296089;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=HaforV2IeP0NmgJIChxLqIjhpAm5azYdHH9oA6zE+e0=;
	b=oihPueigwYR5196EAkvya22ePTRpCUGFtLk2iFC8pTL+0EX2mPbPitn1FpHS+R/03usT
	 JhivIHhIqbqKgRE7JMakpJRWDMWASRqzq+Ovdts2P3KQTfU38zLfyMZM6PR7ZApxlJ4Jy
	 X4B6zftMV1QPjU79jNbj2RKUQ6OlfRCu1WoLskMc8zNxKXcULv2zric1OcQy4izIwsU+Y
	 qf6awlWRepeqsTDWWje6DDjBTA4P+VPx7ewgPWyvhTBftYkN+Id2arS2oC1Ss3woybj7z
	 +V7wf6ciiPyZLfJyVO+frn9mqmm+eD6BE1aJTt4Kclc4MwI9fsTZCEaBPM8cvyCZHZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b4qcRkOK;
	arc=none smtp.remote-ip=209.85.222.182
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F73606A31D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 17:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0F73606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b4qcRkOK
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93f30660e69so176198385a.0
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 10:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793296087; x=1793900887; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HaforV2IeP0NmgJIChxLqIjhpAm5azYdHH9oA6zE+e0=;
        b=b4qcRkOKgNy/EZKYAPKtmKQ37Wk1qX7Qt5Eq3AsV2SpRyVjtF4cefZuEGM/AmiaCBs
         Vha5OpLlr1okfcI1d+uxAWkGIXO5Od4Gbl8CC3qDoli9KlASSHWLN+SZChp6y1renCIP
         w1WsAQh3HnggAB7zetDC4UmhQKp5/calAjjPi+GdiwKuczSwczZmvCGDy2gUQyIeI0Ta
         YYI7N69HI2aQnjnk8LWVeepOmXAEMs8ltfEkgB2JIb+u+AnwSdJoCQKakw7xx2bRdbRo
         Knhag5XThMk5FFNTeqZZTvBPIXVArxlErjOJCO/AKdFW0Gms3FJbXSPedUIeOdMms4vy
         Ngsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793296088; x=1793900888;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HaforV2IeP0NmgJIChxLqIjhpAm5azYdHH9oA6zE+e0=;
        b=dKXUwdqw6OWI5Ou/wjXtSpfRM1jbgy7oGiextq2Hncn/SNXR5fTwFgOE0e93d6nPh9
         R3G+irXa0ba97Gw9TY5kUi+kxAp2GYltDL3+mlQMRKExUDchWkYgeI4rAUXotiNTnQwa
         40Tt0mkREfdijMy4SC2X9A2duFf2Gtu1GKicOzIwCEit45QymsbGBepxGq0wmtXsW0h2
         J9ejfSBxlGuz9rHx5ikFlMaEtsVH5T8oDNF9vuhlkXFZH9cbhETpRyfsnHJ504Cr6gvd
         3XZZnPq/dJHJWSX1OXpqwVIAeAQn/qDoScxslvv2HQZxR9vClSEtzXxzPEw+SjwrsIdP
         ikow==
X-Gm-Message-State: AFq9FYLAsGtrbbjdRhCTmQn+CzSm6W4nGawcpc/5wV+Z3Nq0y75fh40u
	WrqqufioFvzh8b+QRIcETn/K8bfsnxMBm3EOXvPKUzPhPwVSQZL8lokv
X-Gm-Gg: AYBFou3DUzmDiRtjI09IBicuLZzNcJbm8wd3rkCRt0Taq4P99/fVxNDKDM3KMmNdkx4
	GW0YHm/hSd1+Uj57ZL15rAu4nhrCT6yYBGWTISznaNW2hatWKKhNypboAQeYKK5JgwQBsBMKsk2
	LFxtpHH994yKH+csrd9DeKl/yhlzoS9+9xC373FcSgjWC01XmTaLacU4u46deqd75Kx9Txul8jY
	gFjMuTqLcLTGTvgRKo2QYhYPvNEokjs/RDC6EMooH9uWIBUip4mpjBZDKpR+ZvGvZKsm9+T4xzX
	RR19P54Vs6ulWvduPvrCsiwu1Cq9ya7+TuNyB25wuUufY8GY44vkej1IS0YJq34CNYdzIRn10U7
	mvS8AB8IbRAduSahBKehzpmxB3DeplrWfbBJHAghrsxbXvEzae5Fcp/T6tXmNKxZiYhGxqQ+vFF
	gsDHA5sCrj3bMtY3B6AX1FR/ySi9TuYo6oR87w9IOIX1D4nmYO2mrYeYgxZUuOHYbNNUFQ4x/37
	0FgWvwR3AAIHJJPYnK0k+QaC6LLtyoquWktxT8eD4cE2YZYrhYaUuDiOH0cDIrrQDzA5qexd/AV
	5tI1tEy8oKd5ffFzVRemk/xx2OiRx7wzfkzyE307NQ==
X-Received: by 2002:a05:620a:44c2:b0:93b:e578:583d with SMTP id af79cd13be357-94408aa1416mr958437485a.21.1793296087475;
        Thu, 29 Oct 2026 10:48:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-944210e6a20sm4958285a.4.2026.10.29.10.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 10:48:05 -0700 (PDT)
Message-ID: <9921a8c1-ee84-4886-a96d-6a38f36ae46f@gmail.com>
Date: Thu, 29 Oct 2026 10:48:01 -0700
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
Subject: Re: [PATCH 7.3 00/38] 7.3.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261028165940.394092994@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 09:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.1 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
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
