Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809B6242917
	for <patches@lists.linux.dev>; Mon, 22 Sep 2025 23:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758582064; cv=none; b=Ub6YddHTrfeh+3y5EF/bT3pmi33+8nu9Lx5kuV/KVgFnRp1TWrbYzBSydJBCPGZyV46D/QQ4sOGc4V5h7hz18jHeaEojarc84KnBJ0OVKFJJVAsMk1R4GEwsDZKkvzRbtzZpW3hlBX643yXXLVc8Gr+ViOLiB2fWizpHA/S+Wdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758582064; c=relaxed/simple;
	bh=YF49FiKprncqneMObMSuDBid7JTl9NN4qkiSsmutA+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mc2Wi/1MtnaqhT7FKMRhdrbCunBM2P/k8IqCwYuIthmK5SI7ie6if2lFcjYBaIqlW8Wdur24y/3ePCRIHsejXEW0SAFqztUlLiIRssZH9npljgk1WS9rjIablOrrDd9YRA7QCigCom0Z8UTiRwGfSHy+aiYGqbOYjlRL9I2F6RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZUgKBMBp; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZUgKBMBp"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-27c369f898eso3465155ad.3
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 16:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758582063; x=1759186863; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eeNy2aiqf1BC85NqN+Fm2fdEOmzGU7K8Kz4tZyZLL3k=;
        b=ZUgKBMBpr10PHApjgvEVrXJHV2NRv3optFQy9veuZ8YfIgMPjpnpvPxaKwl8KcrlFb
         e0GYINUt3OsrVI5JqltXzA52wbAdusogKUWBvnFxCuXfR4pGhzpWngsnHP9rL7gFp3Zl
         wD/2R8pIMeAavvss37yZOTMVuJ9cXw16w0qjPEjYSgr+grfm53WVedMaODXpg3yI9Wn/
         Mi7qeVhltwODFEsEf9BP7fMl5qBhHQ6iENLptTav4NwOv+DMIX3raLAFFj09ECG5JYlB
         sqdF7o8TyzFQlE+/MLjlRRjdxZo6uoPr2pUyeeyJQO2lff+eTR7AWXtcs/9gzSWLNyKx
         2XsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758582063; x=1759186863;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eeNy2aiqf1BC85NqN+Fm2fdEOmzGU7K8Kz4tZyZLL3k=;
        b=hZ1MILyTI/ZPts8GSwhsWxxQ3TvNaLXiWILSfscVI5YxUbWa+9X36Ea+CiT0gMmkSM
         NdIS63rQfdCB/sSk8jEr1pO/VBp56EIZ5MrO6z1k1S6fe12NZqycSCIwdyM5oJz4Zsm9
         Y89VtOeVR6ScLD8vp3kQZhNqnfEIXc1VWOp2fPtrugWrSMTaeyBhF/lT2cAFjijYzyMd
         0jrYKYgZq2CJDSD5ru8ioML8P4dDxaycTakXRvMHhffVKFRTvBRQCqnRPLJ7TwWDef24
         xmkXD1iI+5bBiPYTx5t+VO1Uo43UCHT+7xDuUkIp7XVlCCz/L8d7UOOgQbzy/Tq31YEn
         7RIg==
X-Gm-Message-State: AOJu0YxapNr448eHj2sPfWh+1X7vOZMP0gXqKbJ5lSt2UqlPIfypbROk
	pCvUchIKrn80LvGswx1nQF+MKk5QMTSIVOdTfT5Y77CiwsGM5Jl8o6qS
X-Gm-Gg: ASbGnct/cN9VKeNFCvDTdTaIJFK7wrxnDyG2rzUZOJGMb5gKCkgLJ3UZZ8XfIuCsWVI
	Wtxw06jipV/BeYVCLjF6/93hBqpCJkxw9J5cYdkt/NhGxaGa4X81FHKu6qapz19vcyd8tUfsrmP
	M943x+tYuuupvNuEP4N9Y+J6hRx1FEkID3Sa+vKDIItDbWF1gOrSy2kVGfaUH3v0rn69EYDZ5NP
	BB3/arbMRLvH9ZAPRTqlNYPnteQz//VAany8Xz4oMrbXq8d7vHNQl8hacpkf3+kG/jrgW+ae2nG
	pK/iN2l9zI5f/JfcNONULXo4Iwarq0ZljoD6jiDQsvBMEv3rI3ng9Rg0vaHe6vEsqaMK01MIcyK
	r6K6qTa3x+ec6tHUtokp4GLPHuxM0DGZBVFZtHS3qvTQC+X+UlDTxWYd8WXAovozZfWMxYmDOaK
	FPBRzrwWxl
X-Google-Smtp-Source: AGHT+IEJUpXiZJYpDaJSVRMQpD6oGixikoujh15zTGcx9C53XnFLYqY6WqAGmtYFnuvTNfHs9MT4Lw==
X-Received: by 2002:a17:903:1d2:b0:267:c8d3:531 with SMTP id d9443c01a7336-27cc48a03e7mr6204565ad.25.1758582062572;
        Mon, 22 Sep 2025 16:01:02 -0700 (PDT)
Received: from [10.255.83.133] (2.newark-18rh15rt.nj.dial-access.att.net. [12.75.221.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-271353b8792sm80534825ad.123.2025.09.22.16.01.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 16:01:01 -0700 (PDT)
Message-ID: <b40b700e-6bff-44d6-9cbd-0a208889a40c@gmail.com>
Date: Mon, 22 Sep 2025 16:00:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/105] 6.12.49-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250922192408.913556629@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/2025 12:28 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.49 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.49-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

