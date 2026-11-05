Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793914072;
	b=QDEBHp76LoJ44KMqU3ukaZ+CZhCtP3xy2/jWE4TGP9TNdX3PAepSh3P95oYy62QVA5Ld
	 /Xh7wc4ot8hNBhf3CzkVrwrzVXme7FCnBaAVj35lEbPoiguyzhlq+xkQR9eeTfVqJTVQJ
	 d/XHNksYsnzGd5XIyv1m6yLkbJfaC5/Z6uMrYmZQm2IQxqU/3w79PLk3EZ74ehxpZU6u2
	 kXjyBQO/qMWygNnXJYHRryFVH+YbIzMe18d3u3X+rIoOF5Stm4mkaaahClrsX9DFUvcY+
	 qTC+Bgt26Z25NBet255s/rLlC9ZeiLd5nGmgcNTPqlUoh+l6dWxukBLLgpctMv2Npeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793914072;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=wX06EQOYjMy/aW6xZlZGYk/V5Xw9pqyAzAzdo7pf5JQ=;
	b=kYQyyTNUO8OxmfsBARDOiJIVc9yvv1XMdaQPmDLEfQ/IOEhD/Maayyazf9Cxt6pTldhE
	 XlJ+HDim71BPvgzauN71TCPzi6kBWmhISaBjOc/PEI3ZvGrqvqdPEpezhAbT7OeXjK808
	 BDFhC9DOiaVRc9NR25iSOIfI91pBe0G32EVJaoxFKHCHlwwPIa3Mi8fjsGi2OSxK0rNPr
	 GfFoQyu5VkRW3rNyukhsCgvL/UV5aJD0+UnAgju5Jf40iKz/qmKoDlyU8fQ7jQciEYyAl
	 6RFpUgNtnya2eH2EPoFbeE1NlFe0YL1oCK+ev5tVz+xfWAbPbk/WpjZD7F7HinNS+PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VDt1Cozd;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62F8606A31B
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 21:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A62F8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VDt1Cozd
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-35b2c599f43so148397eec.0
        for <patches@lists.linux.dev>; Thu, 05 Nov 2026 13:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793914071; x=1794518871; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wX06EQOYjMy/aW6xZlZGYk/V5Xw9pqyAzAzdo7pf5JQ=;
        b=VDt1Cozd7QjoQjWCrbcCgt3RZRt4GAonL4hcWBcCNs7oZSkODNYnZRhMv19kfZezVw
         Uldkp7jQ40gszvHRnph5uImL2FQ8OrdbtMzdeVZcu7wQMxdkybaQKvcosb2GfNWJC8aA
         Hix8DXORzeOk87TYDczl6dnohjGMPFvDC5E833a+S5meEI5RBELP6UE/z4qr4Td+fe52
         wNO6iuIWcecoeuCzzIQWciCZrsZCvokxCtVZaF2+3iXup3qAJu6F3ZTwLUKmeEZJ18Ob
         LlO90/6i04whGJTxCZ5/X2vQZq1Wztsa2e6OIaF8/6kcL3VisBlLeILeGGpqTarYZJqM
         Ec5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793914071; x=1794518871;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wX06EQOYjMy/aW6xZlZGYk/V5Xw9pqyAzAzdo7pf5JQ=;
        b=cquxceAAw2Jt/pVF3YQWuXVFgGiFVPpfJrnBmQKHT3641rPlNApqnzhxY3uE3oyPBh
         VVk6QJzfg2+GWDRf/cYDCulRoDLzP+3DFQW2zLHlrVis11sGfFaQfflzF2iTYEGOf7JG
         I5W8rncs0WpKnuP3arTK0mLmEGRvWp+tE4GarXrH6HSsHXYTyPm5Av+QOvtAbD95iUgM
         f/9N6f8EqhwX/DbNYujWtSu9FcxZtjXVPaCCC1sl5rNnH0NFC1iY2Bcip+N/VvhdrNPN
         MH8jMAKhhQ6nBRRKbniKfPrJn6Kl+UKwpEG+V60lX77ubtsyn4C5drhq7b/pNDy4w3fh
         Qa/w==
X-Gm-Message-State: APuU4Z+KKd4rU24+QPe7wsmkFaQi7ybrwWCN0gHrmOLoTzaDk5Htz6Na
	/3ygE/x2bPlxQaSaRDCuVlJ0uxSvneZwaS/ISP2REnqZ2s1wtNl01Ene
X-Gm-Gg: AYBFou2vLOdEwNCGztiBc8MmZKyZB3WtI+rqE2YodoYioNGg9qrEAeCbfZ7EEA/awnc
	3oRGu39clxxXvzh//9lkyBRj4Rp3lPNqg87SFpxzSs3243jUIA/fX7SnEI750l+Fp37wY5Bn8is
	462N0pcA5SnFbN6NUqjxM4JquvwLEoNMZOtbcHY9YlcDcE2ZpuiqeC9nOQb4WqM4GegAokvkzKx
	8V0Kei0sN1CSZzlZPCSnQQULCloUlxz08qMIYGVYHHVcPPrUz1hi3p+EePzNPyBB5vnk9hCaDRo
	iCPezxvTVZInpq60VlDNjZxmrpVjtxjwG+dEjE7+5kRLe8zaARpK/mCsPidDnW/Ocd46qFzjrPF
	LoL6wrbFv/Cu/NerNmMHO8lEkKhYj/Nbd2TeBEVFfwmlATcd11Ldc0EMuOuhvTp2LKeHC5wozeG
	E4CnK0ueQngs2EiihEcqPh1oV+VF9IU19vap9zn6nYXbHcQiz/NH4AOMQfAhmgXdBiXTOgaTIgQ
	/8Q4fdJsfABNSnnlhb0dNW/99Vzuirm6T138Upj1QdicJt6dXTOfpRnQbAuAna694zR4Lqo1pl9
	rNUc6pWbyMUgO1Wsn2Rnl5pHLMqHZZTB4qobQJHc4LiqRb2/BYMGet0=
X-Received: by 2002:a05:7300:10d:b0:36c:c434:b6b5 with SMTP id 5a478bee46e88-36f76621095mr567569eec.17.1793914070609;
        Thu, 05 Nov 2026 13:27:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72fbe241sm999556eec.10.2026.11.05.13.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 13:27:49 -0800 (PST)
Message-ID: <118849cc-6953-4f05-b1d0-22949f4cdec0@gmail.com>
Date: Thu, 5 Nov 2026 13:27:48 -0800
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
Subject: Re: [PATCH 6.18 0000/1005] 6.18.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261104211043.516122098@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 12:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.61 release.
> There are 1005 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.61-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
