Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792453961;
	b=txvKh2tnIzgr+T2Qy/zktvTqJsBztHll4Cttk92eOajyjhKjKlFnIWLO9pQZn8XQl1dH
	 m5HF3RmyCyIQdKRcamBOHBj0gszxnTCyUhw3XC8wkqC6IlYqEztmKzW+kejadL3+jcyxe
	 l9rNO2ITTeeX0+sdcjlQkgPTSbd+VHxByQ8pnZUSzQweCc1qVikZkMXK20qXAed7V1Gft
	 U2e26BJ01K8Qfkcf5m8wkMvnFE6kJdHIC9YkGkdEI7eX4alSUfEK6nauEC7w3j8WP4U2h
	 Pd5DlLeC3/Xz59ojqCbT6x0QYnp0Dv2KMFk5bOZJx44VWKgFvDBmulrRsmzMe6vyxlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792453961;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ttyZRwyHx05poioOuaGhTlTLSeN4ZZB8Cywga9DS7rE=;
	b=vjDSkZig54Jl3jZPfpjnj9P9PAQ/sC3T7PhbATRWsdvVIOI6F9n/FFl+eVlbZb8O7qFD
	 WLMrtC7xR/pHRGjU2U2BFTWcpMBIGvCu2EBVkgJH6gW+uvBo3/2tnz2v6UuWIlBJzUj23
	 m2KYNDpknuIqc6KDxuMENHKpkADgrl0Ir/uVh1E9iGvyS/cCe4N6TZd0rWHKRui8vhRAW
	 BuY8HSeAFDAz0EqJTWeJXCMW/mMSRsxTKec7vNoRzIgZTb3J3GUj5OAtq7hLDfICBlGO9
	 4nDGt9ibWt+Qz9EwAwdEu+LKF2IdqUxv6N6zFhL2UeXUMUvH1MZEr50+8Bmhgkm9jgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=GDIWqsCq;
	arc=none smtp.remote-ip=209.85.160.44
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A15F606A31B
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 23:52:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A15F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=GDIWqsCq
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-4a76f63b243so184730fac.0
        for <patches@lists.linux.dev>; Mon, 19 Oct 2026 16:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1792453958; x=1793058758; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ttyZRwyHx05poioOuaGhTlTLSeN4ZZB8Cywga9DS7rE=;
        b=GDIWqsCqtM3uw5IFDrwhqryqdh9RF1TyMOyJvEJRf7DQK5UVy2hXxvXHl1kZzxlbAW
         veLMXsyr3Cn1qq476mR7oCd9DUK2Rxb9rnjUB1HACzGO8iEnZcj3eXXg878k+03ZfLrU
         +gRbTHdXvaGJsBz+NiXAlj5GHuPm8l93QUDdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792453958; x=1793058758;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ttyZRwyHx05poioOuaGhTlTLSeN4ZZB8Cywga9DS7rE=;
        b=JK4H2mVsy+xkftiSEY2ptXGgMeBuMdka6SCHvIIcC6WiYaPZeX/Jjz3sTEnJ0zHJ/q
         ildotkdUuk2eXdTd1HTupMGk1KVwm3OdouRwQ7ANiAP8UEIsvBa9Ioi1qUrp0qcPCiDw
         dSTN9vHEJglp0UyG5wxHFQLILierekkjXCOmN67KoXa89nd0kCaUbcYX06Pjf5t/o1M+
         ssLyyrKlrGgeAkKmL9VJ65wjHU13hFu2coKebM3wYXcorvsAfmMh6LJsI4UuSzoqJUV1
         KTGDIpahFfAKQChmxHLFaANgA/8lUfA1Xm10Guc3Kmi7Rp2doB6sirD9YYaO3x0VSz05
         CGHQ==
X-Gm-Message-State: AFq9FYLk19pPxPHdJu6TpXgJlwCR9bHBQsR9jLC+S/TmScVR6BFHOMZm
	6NV+ynVLCUTXwXxMAwKA5tiWYSMviitVrKeACMU2WIwqJRwRibk77JXa7h3oODXpww0=
X-Gm-Gg: AYBFou2gMNl04KSlc9cZkcLNN0ZBk9TwUZcFcfEFMikgKGmUhKaZPbgN7BL4ZhDX/+9
	j9aNo4P8wQP011kaGHnl8PaIdKByHI4mcqmerXhVGyAp3oPkvlfoSN02AM6qE06Z8nuQA+lnszA
	B9joM+mg2aIdAqdqg7BW930500vxiq2V64zmX79sJnX92pC4A+ow8AWsA4l/vdtiLVH9vCO0GPp
	xrfPamS5mr1VQHrfY2k8SymYeG/aJtENXacXWO/1klZ6s+/x19XIhuKWDDKCHjDPcb0PocnEik8
	esPbTFTCILL3CR9HGNLSGFpJ9S4Zv7Ll3lmY5zTFkCAXfU3e8jFNRcONnfO79P1FUbOJoJ5H+4n
	zuRGGMqpNAYsUvEszJWhQAQepZLUrYtew0SOqdt3ghrmyQDXbOUG8uu4IrpldZ1D5ph2IeULsGD
	13GPJoDUt8UuCcSnJD0O7by0lckpyanp+1hLB1PGcvrRGZBlulF4j7tpwUMeX5p9nnuHYoOpdMq
	cxkjV//
X-Received: by 2002:a05:6808:f0a:b0:4dd:f8bb:e1bd with SMTP id 5614622812f47-54d90fa2165mr420470b6e.13.1792453958309;
        Mon, 19 Oct 2026 16:52:38 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-5388c1654e9sm7801946b6e.8.2026.10.19.16.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 16:52:37 -0700 (PDT)
Message-ID: <0357c306-e1ab-4a66-91cb-2002c1f23f79@linuxfoundation.org>
Date: Mon, 19 Oct 2026 17:52:32 -0600
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
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 09:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.160 release.
> There are 1674 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 16:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
