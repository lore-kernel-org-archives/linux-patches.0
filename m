Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434578;
	b=MHDomXKIqtHEo7GAzxLdu/qv3mmMyybtmABCstHk+xdClCL06iejAEpRUGCS6ovqxOyW
	 zNgvDyHRXgtQqnX7RzKS6FLgGb7SEfOBlFvQ95LrCWdePfBX7xtY+Vrco64WktB2PBg0j
	 btBqJyDshdZkgPI+dtTdWrdist2k8UDbW6eC0ctni/wquDfyo0DFCLjhPGQdgMFEJ4+op
	 rRrxKj/18f3JCchq7BlRt2pzAwCgoY1JedJVQlyC2iCSbPHsfjtHucRfGsm5cN6AKGqKt
	 t3rewNb4z4ih81uKUCVd66ZRPw4CIyN11MiuS9EOE8bsuMAIB9xgpgWNPJ6JB95KGuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434578;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=jSBiV7ul+0Ul9MLE/H5BpAaYAk0aqMfUljP7X5tbwpw=;
	b=2U63q6QXnhbYb6F+gyp8XKQm4nBLH+yhSPBTMnbpBtZ8P59aXjXVj6qBjbvpjCgmfQ+7
	 S2ODVLq+xK/ftUntme90Pv8aA1+BiWcGf7/Y8tpZ/ReNyWyEL7kMgA0wfNExmpZQH8J7t
	 mk54JwktbQi/+7tpycnNTu2PXY678NxxDnkvGX/ny9yYxBUH/00OZUHpMFWcQsZoPTNYp
	 n13Brk63hhojsvcYPpM/r8MnA39GnXabodN3u/bUUbOqINpAMDabECruJa59hNENtTMx1
	 cAZHd4HQTUm76aKQXmFR+oT+eJzgOhF0dq24STNu4iDTcDHdf4eS47ZMLnILQtntHQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Dmnfl2RW;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772AD606A31B
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 18:29:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 772AD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Dmnfl2RW
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e946155442so19537485ad.3
        for <patches@lists.linux.dev>; Mon, 19 Oct 2026 11:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792434578; x=1793039378; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jSBiV7ul+0Ul9MLE/H5BpAaYAk0aqMfUljP7X5tbwpw=;
        b=Dmnfl2RW+bDgwsYXPm7mYmzi+M0TYpUo/wtM2ARgUF6bjWHZZZ8orOJUCwTaN62cp/
         IUCNYYvKH/8P9ksg2TECqBGen2mkFBdtunMeU9NUvlSVhLMjVcNSwySZODCEctiMdc5R
         GfbYH+8TBpk8uFlVKVa+OcrWGMGk7jU/WZAetvPBtO6af7PC39+XuY850aWKbpkL0AR9
         mLVSeOlQH1IkqDeEF2d+JFd1C2ArhxKnrloQuXSgty5ZEUQfg8wpjaCnBo5Z+UGKxkHX
         4710hf4DyRqRevuGWjvThi+9j5lnToil4ejSB9mqj6gszo1z/S9AmV9Nxy/+CY2nSGs9
         47uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434578; x=1793039378;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jSBiV7ul+0Ul9MLE/H5BpAaYAk0aqMfUljP7X5tbwpw=;
        b=eWbYsVeTWQwQ5wMWTbOH/wtaZHQ8XiGD9QvZHfxbP6bBE+PRjd6FvmsNzBc7Zr9rv9
         VVfS3kIzjUT8v46PttSdw0tWDf5tT3HzdbN7MUsWaMPnAeYyrQ9skcU5XSzju4v5Fe0k
         cBg6cby8EQp+Bsp/45AE9dBCDM2eX1oX9dfbbtc9S/d5JD3ff2heGMiQBsT44aXV2OjR
         nT50aB7YlXsu4WjAve7qIuOkdTFKWJkx77f3WojglVo6rFmGi6aE0JlDZWvBwSmqUP8x
         sn3AQNKBJ+9R5gZVLDb2qlLGs/2u+tlM9im0eG2QoVcE9AlCAFhuevU0BziZDGn8lQal
         gdpg==
X-Gm-Message-State: AFq9FYKZZhvmj/tK6AMjBiZEmgRK5C8ShQp8vQoLHVHzMowMt7e4H3Q+
	KKpQDYPTfH0M63g0agReIgZpnrxJBBeBQGEf9o3U14RreWY80bQgmv8eR2yd3g==
X-Gm-Gg: AYBFou3qrRM1BZvBKFfzw8I/jx2Dzg2AcZL6ky4cOGQQn2pixeKSLIY1zhK+b6siamS
	WR9H+QIuPdJ3x8YEVgebJDgC/kXyfNThU40tsv0Tr819/KJczBOCzt+QvaQMP2J0kespEBJeAaF
	EuFHGxm6ZN4w6PAB9+kzAhanPqAfGZpQb3ydEhnm950WaXk+5M5D2ENyiDCpBHCFCjcEd8KKPgq
	d2FUelSxqLF6pCxv5ezQQROjYVEXaN2g19QsTpnzseQBGOexl5NaXggqnh0eTJeTqALJQKN1swD
	FxfzkCWeOsNKDdSbJ2UhrtjTqPpH/WJ4iP99+FyEX9QgDWQSxe1HtuDVpy0B5NhJ+jDYnXFtJGE
	0kGOwTyhT+viVDEkZ5Y+oVY4c7T6HZH93bhSInE7OOc2L4WT8DBinA90cNqb4xZY8SzWVZg01Fx
	RwPXk9rA6w7OJApLq7HUIFQAqfUNwVPx0WVBh9dlflQEtgcN52fVbSwgGEHiWa88Ik0bj9xxztI
	p9Pjih7INRfCwIFWw27u01G
X-Received: by 2002:a17:902:f546:b0:2dd:ad73:c938 with SMTP id d9443c01a7336-2e9a6d40f02mr71830455ad.25.1792434577572;
        Mon, 19 Oct 2026 11:29:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea13c7ddc9sm5303515ad.0.2026.10.19.11.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 11:29:36 -0700 (PDT)
Message-ID: <8bef225d-f3aa-403c-aab4-f629aa197b3a@gmail.com>
Date: Mon, 19 Oct 2026 11:29:34 -0700
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
Subject: Re: [PATCH 6.18 00/52] 6.18.58-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261017155104.830766652@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.58 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.58-rc1.gz
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
