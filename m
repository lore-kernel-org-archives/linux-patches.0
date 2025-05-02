Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86371242D65
	for <patches@lists.linux.dev>; Fri,  2 May 2025 12:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746189210; cv=none; b=f/0g6aTKskhQS9gv9O0HG+s6r17p0L7zG6cFWeF4BvckgCeESbeuHZ2fYK1pxbBqgwMjnMPqzjEhWyaoO8DoIpGswRkc49mH39mhpyJXNM9TqSb/hf6f+R5bSLZowgq4SohOcuQ0afemgLR0R9RtKFK/K8bgN02ewI1GiHGcytQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746189210; c=relaxed/simple;
	bh=z6z8DOFK9JCqv0xb1jgf68DObLMsaturhjSGbJ1U/rk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kpA/nkLwkPtcxSoNIL2w7IcMVxB/BTfDTIoazdH3BS3qHqzs06IRmv2E3m7C7tLi9yOn/8iu7W62WgHRvNvD/IXSq4RDOIy1qAlGUOrHSIq+ISdjL/FfwVq37LARmH1uCQ9KWtTfyPYMa++LHQ13YRKKhiTYw3suliVXEwbEH0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mbAtBHgy; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mbAtBHgy"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-301a4d5156aso2764891a91.1
        for <patches@lists.linux.dev>; Fri, 02 May 2025 05:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746189208; x=1746794008; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8LFbdO81pjLbU3iMuNN+ugtfZ7paGqSVKOTIGx3Lamw=;
        b=mbAtBHgy0S2zSQC6uFzXVnbCp+aasSYXAMTMKcN/8twEYugy2bH8bzCKNkQJgk1ZlG
         zKkyo5b/WuNcQO7jqPY0EvqnZXPE6HiNNRC7VHMmujH9WmiI45gDaVHfgjbDde7tCwPh
         FzYVDJtIqZR949o4wZ4b+WTdLIuZA7V0t+l52m8UaylH/2FzT9s6fJCSAvjqBOJBPiT8
         2Gh76rI8oB2DUEDwZiDbOCwiG9aAFRMbKPTgDJWNWLfzQTITLl0mEA/DN89VJBH59uiM
         6JAFhwaFzZm/gxCtTtmyNikdzOn2MTJrxj7GDXPKRhIaVrkgplpC0ZNYGgtvU3/3UGis
         3dtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746189208; x=1746794008;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8LFbdO81pjLbU3iMuNN+ugtfZ7paGqSVKOTIGx3Lamw=;
        b=XBrzg4QGFWwbFFOVRXLhQWVj3hy77QbJfBm3hi+2+nIBvBXLnC+UBiMON2qoMD1f+y
         zlsRWfgdHmjmxuaW6cy4AchuzVM2Qwsn17YWds48QIIqfZ++MFU9HkwLTEqnWasx8uhC
         Gzn5yr+cPuFZ8ZyeEUkbKPSqrSLwP9bmckR4d5k527qhd6B0Ol3jLO4vQEAKMMTnKPuJ
         gOUZ7exHx9FqkRdnm+3153T0KTVIwH7uFvi+dFMU7Ld2sxWDjJ8tVKdJcYa+lZ3xTf3E
         JOS/HjLBSj9Ur1JbqWbYaEuD/FfvOUyWbuUqP62W8PaCO/N2T6JYNj20GVDH8cU9bctJ
         SU0g==
X-Gm-Message-State: AOJu0YxXklDhOuuUOP0LwdKuNzvgMyQjltq0hiqhDyZOPVLHBcYwJ9nZ
	1KrPW/cLmxWgYkI+Dn4UY1vujm5HrHXn/o9WbUch8043/zlf6mVJ
X-Gm-Gg: ASbGncuQ6v0UKNP5oajlnu9xc3akhNHVTLTr7KGND/Lh0ZgqFodsOkeiHrujYd1HYhb
	9agPaZnoK23xhyJsS6pMbgc2PiMBFVkjukAlaQpoI/c4A47ykd4q0jiwhoi5usNBOgQd2qWZ9pk
	4VysX2nM7RwjFonxYW5SIkUp63Nh3PXeuDBKtgnqtejh3+N4OMqhI2u6dgDhjJy1xokU4yx7N3n
	NJ5NOvkR3Y1TNLALOhiVZ3zwCCI/SN8Zz3LUMqsoVnfEmeYIiEXFqs9BDrpP/I04Mjuw4dHEc/y
	RuHM7s8NDy2HaiusAhb3FLn2UJGAUZFC11ZcPEik3VoLEB+bLubkaz6vZujLOW/8v4s=
X-Google-Smtp-Source: AGHT+IES1oMpEpa2nbuC/A86IqMpoOcTS4u6tbnudaz9Gj5lBssrqoVHSSuYEIPZqrNZJrdwxL2KZg==
X-Received: by 2002:a17:90b:37c8:b0:309:be48:a77c with SMTP id 98e67ed59e1d1-30a4e5c6388mr5128351a91.18.1746189207654;
        Fri, 02 May 2025 05:33:27 -0700 (PDT)
Received: from [192.168.0.24] (home.mimichou.net. [82.67.5.108])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151ea71csm5934345ad.101.2025.05.02.05.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 05:33:27 -0700 (PDT)
Message-ID: <8b15a1ca-fbda-4bc0-b6af-e543ee03f7f9@gmail.com>
Date: Fri, 2 May 2025 14:33:17 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/368] 5.15.181-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250501081459.064070563@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250501081459.064070563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/1/2025 10:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.181 release.
> There are 368 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 May 2025 08:13:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.181-rc2.gz
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

