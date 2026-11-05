Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793915809;
	b=rwqP1qbMCpDh4BpQ/2THgsxWOfy6dEQfiOnZsm2+UuBoVLMdbQOBgCkjzWQ5YIeFV8MU
	 QxBSCSmWGJKgF7pO0jNjjsEbTtn58bNwsfkVUw2kIZhqiILq/zyvjYQx+QgHePZg6/B2c
	 0kfQQKPH+RpNXxMCHMCXntqq6vvlkFZ2nx5GaTCmRIny1OrJ5gjqlkMmydrlqu8scwbnv
	 rmyB6CyaOkKXXI8GVProrfjQFf1PgDdRdz6q+5z9ruzXWJNIOE4CYD+7ZOvnFBhAHP5du
	 D8sUw/CLXL1EIfF5yp9wKlkUNQLDJwqOlWfuMpzKmC2gyDXn0z7iLVAFi9FW63nRMYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793915809;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=CPyUJuu2yeOSTelLItaNsxminWyw+/YBw1HOW8wGPck=;
	b=WP3NG81IOaGWm45d7a3z9se5oW5KC2oRHa2QrTDrzpKU2/otBDX4v0Jya4skPLTqybzq
	 8WMvVsmuZ8OFHNnv26cCkMVBoKa3e8/ziSqYexL1eZy9OrOdd5nHowtBdV7j+7v7WFeEe
	 lRY81/43MyBHimIFXywsGNFWemZzsQwIUjm2ffcwT3mcPc0lXLhp+imeps0yELLZwEAFt
	 XHfRpmwmd2dv+xX9wW8LYKu6YwPVYOJYbUIOfh5tYGDfeyBFabYMAwjAJ1jJQeDnZ3iUv
	 2lb/jJAlti6nVPId6bwvoyD1iZvV/op0hBqVxz8aItCPC+RLwU5mlzLtxtR7PB3LaCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z4TVwucc;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DF9606A339
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 21:56:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42DF9606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z4TVwucc
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36a1947498bso92579eec.1
        for <patches@lists.linux.dev>; Thu, 05 Nov 2026 13:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793915808; x=1794520608; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CPyUJuu2yeOSTelLItaNsxminWyw+/YBw1HOW8wGPck=;
        b=z4TVwuccvZbRmolnWalLqFMDV+xlE6VPBa5wGWKYk9/a3r927eQpt4ony8ZEiWPnt4
         AKz/do5hT3tPKVFDa5XYBkh0zngtA9zi8Of9Xl46sW+5K4UQ5sRG5XLM5sj9WCD2LTO6
         BWFI0zCTkh1/z9nku3ksJcF5ieVcZQagD1xlt/8UAwrmMxfGE3KHNIUaFmiFfBhteIli
         Og9+RIUF+mVFkG6zXTDGEibV+yFm4UZgRJQO6/sdwlpVyQgh1Sjy+OclzLzV89vYSB0b
         yWvM6c0PxxWtqXdMMNULjnZwck8WETqzWcZxSWm85Sy/qqw9IWudcagnPRFX/8y+GFTV
         1sgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793915808; x=1794520608;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CPyUJuu2yeOSTelLItaNsxminWyw+/YBw1HOW8wGPck=;
        b=PsS4rDP9+p1ebykKQYvMtYBgBADDX5FLC/ch7szrcnc/G79brnvQw1Vitpwddpzn4v
         ouNTw+DaUqZUjUnQjYGkSyv4DbyT45Su0NTRVnisg3I42KJKfMd7dTmEWhNSTGqswX0X
         BjK7zZ2y/NTciCO7HFduidKtjcVWKGvJ8bgIDf10KwrDaRdNGO+TDml0qKdKqLQ0PyES
         QRua1WEVikl4NWSgcg1b+BuQpGdD+hf4Kw5W9J9JQvjwXeXRDoj/7KlMwAz5Cfk1TyPx
         iqIF6uuhne7cBYpUdsEhL/aNRCKOHR8NkBgaum4v7a3UCzPuUABhutdGziSBhD7tf/r2
         9yjA==
X-Gm-Message-State: APuU4Z9eHj9uC7AzzQwVOzTxF77HNLLvaA8WP7N1AeHmrszZBe5C0ZVz
	hj1Y1FC7ZmvT7r0+hyR8b5RDc/iZz1R/jF2TGfAAqwooLFLzXNOrQHnx
X-Gm-Gg: AYBFou2vDx94nL41swMt+xNE6uoACWd+j5yoWEf/n1pRUDRkZPYJxF5y5T2i5CpgaGv
	bqmQmF2FOL7bDYcqf7ubbRJKrHSwqDBU/g/5D2a71OyhHWxy9sk4HXv92kcNSTpCheqBnvPTGZ6
	oJ9hxRsLCw4ON2w1bwFPRQBA5+MOeUjYYMy46+mlfX9h1sSbuR9mcRaIzisoGqjph++iQxskWn8
	6q1Ho5IhxywtOTeX9HEx2IV/VUKmU79B9m1yR1y4o1LUPmdE5+RwDPE6EucpbnqoXTKVrDihoYl
	NaigCv2N+uTcgNsy60twrxzGCy1VeDmN3DYN0Hi7vBPyctnJIGJ9yyJ9pLPNqkYmBEFaOqghfnN
	emegk6z5gpcf5Uvp+1GHYoSZ/vDAUdVa+ScLnqUmvRGRlybIijKJk8TDF9vQs16+Jibm1colyoE
	d4tkebg9JRpwEeLlB1dk10a/NmUTUhgFhQL84rAuyVOJIbqNVgp8bKcfnzFAXc0gQ5kU2EiUqn2
	z8A9veV36Xqf9bt0/zSYUAQw+1Oekj+VGMfagK1iA0JoEQ1dBEgO2yf2OJwQfjq9sNPaz7uuT9d
	zWWTinOwvnChoG/LOO9W2W1EpUhBx25j2VnR4FkkSio63F2Lr/LmrwucpqajKGX8Q+RBXvJYXHY
	F
X-Received: by 2002:a05:693c:40c3:b0:36d:a465:b38e with SMTP id 5a478bee46e88-36f72cc18cfmr774374eec.5.1793915808199;
        Thu, 05 Nov 2026 13:56:48 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f736a1da4sm1053048eec.7.2026.11.05.13.56.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 13:56:47 -0800 (PST)
Message-ID: <99b56b59-a1f9-49cb-96b8-6bc844a878f3@gmail.com>
Date: Thu, 5 Nov 2026 13:56:45 -0800
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
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261104211038.406938024@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 13:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.2 release.
> There are 547 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.2-rc1.gz
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
