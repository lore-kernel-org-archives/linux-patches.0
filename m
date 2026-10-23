Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792790909;
	b=DkzNGkU+OmYdg1kqFaGxFb6NWKfRIQ2GLjjGJfl7DHbHhdSJErcQ6a+ngg8cFqm31/2J
	 36TssHc1fSY4mxFG++wVaKjR5cShDYcCxo6bxanwetx/Dfp+D5NFUco0rBBIWIRTalsQ2
	 u4AHtTzNzagzCTjI4luyFba6qGTlVyPnZU/cDcEYyNK128K8To7SeF/6yhF9bBT6Cg0SF
	 B55w6k9PB0aS8d1W5ASHzp4/qBQt8DHst8BWxQK/83wBTI40exKFz8bH2UvToGm3nX3AB
	 vTBYyI+l3aP/50EurPLphqxsfqs0ozTGqk+i6Pr8HjCfW1INKKnFuH6ua/QJMRBIwuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792790909;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=exTyhi+p6FLosAtSIlBuccnoi48symIvLRodBYfafn8=;
	b=QGqq3BCkPjto0zCS+GCVdAPXZkQWC1EUA0ZAi4R2AI1ufcXpTngqqM6nAALIFkjuMhON
	 2kg23Gl6JQ+3vzeVK94lQSoBcBWDVIH4Odh/cFWfhEUmcl7brYrExnTldqBTspyWD8Cp7
	 1GYqLdS3gzwX34hDSYF1mhIYCHRrCtR/02aCcO9vpXUCvye9sxjo7XfYauVbRuSi/3fN8
	 U0zRHQOAHZQtqCr62YQApJZyfW2QDH4MHTYjiaDK/sNmtoQbDYD9odEq81Zi/9NTMokeu
	 LGILDhR4/J7Pxu3q8ybd/oeZxRZl/AoBGVkxV4RERwryII4J990oiSzRDBbzImIIMmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BjFF7slX;
	arc=none smtp.remote-ip=209.85.160.172
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D80606A31E
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 21:28:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7D80606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BjFF7slX
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-535179e995bso12391351cf.0
        for <patches@lists.linux.dev>; Fri, 23 Oct 2026 14:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792790907; x=1793395707; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=exTyhi+p6FLosAtSIlBuccnoi48symIvLRodBYfafn8=;
        b=BjFF7slXx/nqv46bcMne/ymyZgS/roWkJpByQRsu5F116n/A1RxtTTRXUvw7zbV3fU
         NvcM5RkSqXU73CBNpQoasuny4euR+AzYKU61SLjkUrS8kcIIg9pfcINkO8aVARgBQ6ks
         OJ4lobGBwcc4nON1X729nBco74dgRw2z/4t5jGSKCFIAPSb6swQ70MD0Txevv43Gikkv
         ACgX/Jhtx1lTf1zuLWBXA88qq048OU3HuUqCFI5N3oOoDGE+Jvb/QOpMhaI0b6uQdXSK
         T29OvIEhrClvsmskk0Ivn9e3Wzgfgu1EivCMztmfmGDhp7JrRRWm0mpGK1EJHJ7tlkKb
         B/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792790907; x=1793395707;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=exTyhi+p6FLosAtSIlBuccnoi48symIvLRodBYfafn8=;
        b=byn2LZAVd9+UcbstmCM1I6nRbek75lxWkl9wLTG+AFTWixMRvFcA9bnNNgD17q8yF0
         i9EQXyxE35TNC4zpkHZ2SWzFuyQixJwvjXSnhC3z/dgXGmnPPYB9Vsufb76CQHwlZjYf
         OtF1GWeotX5vrw0HP2XJOGzsdFgb3Q9y2ebZ+AlwuJzuLJlvn1E1+cvEpYYMTJtaL0yt
         aNMnQNNhXr2h1wa20Wdw1ZH1lzooLWPKk3qjrpm09ZDe6RBHoqrITmME+ynvFoP1B22o
         JylcAbeyYJaul6wKO1vRHBtuIN6jLIOD+5puGrHiGapJFGWVJ/b+Kjg7fsIoMbaHN0Xw
         xSEQ==
X-Gm-Message-State: AFq9FYJgkKBamcTTXtkjqw5q7CaweqKxecPKugGwNyQmf0uCa0lBiJqm
	Afomhr7ywJCRsMx8uEfIgzLx9Z9KQTansXi67pzLeTi/SwGePtHT5IGd
X-Gm-Gg: AYBFou1ZE76e80lQo6Q8YQcCPVY5NpgDIFVEbhMCGoXgFLJqBQB+6cf0RdJYfeQAl8r
	gvuca6fy1KSsJASpcbn5ISemOOExZ10cObinqUc3p1ncKYKlv2/mHjDd9B0HstclxcesG0NV1bh
	HdKrXMnS3bz0UNy9YXkpC2Ba5ET68F/nGD0kSHQjHlB07hALAD3KSvFBksa7ri6bWLAfLAWu4EK
	EL6FC4uEOEmjstW8zCCMvvjWqUFq6JYPNIe850ZkqiysBXKGQuIc0t3VIE53hTSz0oi70mlxd14
	2Tiwh/Yc6fT1ja+mvZ6P/WS+wsqjYrgOc0G7SDZ4gin1XsiW6P+Seypm/+bCMCCCcYzTcX2A8y1
	wAtzuiFXd9KWYo68WFGB/DQQJt2roJ4L50XFU0JiO6M0EIuWniBtIN7uwP7z84rrJP8ftShGNAP
	Q0CbL7LvLXl/eX4kb8vwKQrbnkxmxIp7VhuWwbWTFM3XXia5foxId5BEdDVJ/MlUr1rIN5kkxJ/
	MIg7QfWIHT4XKz6qQEAC1gfd4v0gsPUkOgf3ibzDv50vVPFiAv0VLgFpN7B7Pz4rKRu4CC2g5Dq
	c6Qm/uQ=
X-Received: by 2002:ac8:5a44:0:b0:536:6c87:ebd7 with SMTP id d75a77b69052e-5383b741db3mr1986071cf.69.1792790907516;
        Fri, 23 Oct 2026 14:28:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47cb85f3sm4781676d6.36.2026.10.23.14.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 14:28:26 -0700 (PDT)
Message-ID: <b79c26ec-5da6-4292-a72d-6ea3298ab7df@gmail.com>
Date: Fri, 23 Oct 2026 14:28:22 -0700
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
Subject: Re: [PATCH 6.18 000/193] 6.18.59-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261023163714.201276352@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/26 09:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.59 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 25 Oct 2026 16:36:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.59-rc1.gz
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
