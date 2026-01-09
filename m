Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D692204583
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 19:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767987322; cv=none; b=TWxfxrhFWEPtXd63hGRpPH/auesoEC0LcAkVk1gwkxk5+PTAplQl7LtKEtDm7fsbz/Sheh3en6sObGjeI/hjUX0U/ITtK+gAgQ19xxcJ69EakYnq0tlFw34tNemW9OwG7EfAkM+QjVxUBY820EzFVGTlm6ffmoU4a/PKQCIGMLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767987322; c=relaxed/simple;
	bh=FoexX/zNtllKIA93si6dgUTvX1J2v7VkMvTvZgDZPlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uisH7BHU91adayEcztgdf32cMzcP0WI6ddxAq/j7WUlO8ULG9nknY04wcKs6EOdV9EsNbZF7atNatz4QScpZze7wyC/kauLSlMOWfxp9lZA4Yvn5KwHrKrl6KAXcXVGdf0t9rsDoU/aVweK2dIz6nyzSbId4i5deVFQK39s6qLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K8ZdcaA3; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K8ZdcaA3"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8b31a665ba5so542519785a.2
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 11:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767987319; x=1768592119; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rngID4frIYo+TaZBYopWqUq/ulJvr7+5m9Jxnfzzftw=;
        b=K8ZdcaA3Del3KiHdbVbW2XoQpitM0FFySS36yWyrFbd35YfLvl1crxK9cIyRz38+Ci
         YUqo2XvqIfj/bAUR/6GTn/gq62TJ6dGR/CDndo/cqgRVb/uQchMw99iasWEvInmRkN8p
         GXkYPNNuWQeGfdZy2kCDpLgb/vXHX+fTrZTPoV/o9ddoSpRfnmbJSWffWoVFzc1Ltw3l
         br60yWPy26bAa5Qs6dnv7aOJVnXCFtPsoFg+66woQum8TEBeC0xSpFmwcctBtaDG8Na5
         LH7jmjNABzrTM8gQ9MwW4EFFi3iozJ6yCVTyRjXBwWCeWsSrZWn3wa7Raxem7qClc7/G
         Lp9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767987319; x=1768592119;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rngID4frIYo+TaZBYopWqUq/ulJvr7+5m9Jxnfzzftw=;
        b=HYlnx7bXCe/J5GKfvaANJV0iDzrDVjzARaTM6V/JcA/sF71+Bx999glwdnPZ5KIRDE
         MQwI8Vtd7VtDZ8SVW6MtxHYoLzBhn1grdG/OfmLrcrqjNAsAYgTo3nmfS+VPPFK1Y8pd
         YMXZ8j7yjl/cB99wF38+KyTYDp931g2MkhdSIx0Sp+X3l/kvnJ9BRVNpJ++a01RISIhP
         ULuu+2rbWH6yqz1U09HHKK/luPvjEjHbEvt52f13t96ynT3i/OsUhLcfIxaSkEGifU7l
         6XqbcA4g3Jvw4xq6x0rNtXSkEG/1tL46CIGIS1mYTw0XdGD8wTN3CeUlY5nw6pns4JEA
         gcYQ==
X-Gm-Message-State: AOJu0Yxbs6ooJro7eWyrltRHCkI/hijfMxShdd8qasPP11ZEf8w08gHr
	ocNsPmMJn6aPExKOuBB6JMmRMoOURUWPTh+cee4QFVUNvsRI9tYg2uSLUZK4/g==
X-Gm-Gg: AY/fxX7tWxkcmDunN6iVgbigDQXV8NVwtoP/vg/KHUjTBYHRYqymvSaqkqBmnxvyzR1
	bGhazjcc5jZS8KIINuBvwCLRp7uwHPsEb3Smv1vliwzN9BkbbYuq1uSsVEG90d7DnuXmasl+dPC
	Gqzgmea94gjzZs4bIEq/8ml6JbySZcm3ubackrMiL0d0sSsoUlHeX0rS8zwdvsgaMdSpn7dNxpH
	T+dK+bD2QSLqfWPZ19lXFmpJCWFacxTpwg2oEWsD0qsQcI+7h/NJKOiNM6MwAWdtjVNREE2NWqh
	aEMA8Yj33wp4pUTKTvH3Z8bsIH3F+ymndRca/ujNZ4K8GP+xmVVNZ8w8kgubqz62+xRTTzJrLgk
	iAHqu5+9TCR4H8CkSBrGuEZeTNjUDwJFCXcckrpTRroqJRofQnGvMQmC7bakKg3Eyf/zahYEzIG
	RVXphR55A0uX01iGBt67tzrFqQQ/Fu1W4Nc5ONRw==
X-Google-Smtp-Source: AGHT+IGtlnhX+CYEaNovAoiK0mCDNf2F8U3QIJfiXIenC6fNEq7XFFbLlEe7OIs9mF9PA9LZOgiZGA==
X-Received: by 2002:a05:620a:2587:b0:8b2:db27:425e with SMTP id af79cd13be357-8c3893dcab2mr1377614485a.50.1767987319241;
        Fri, 09 Jan 2026 11:35:19 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a9a19sm890780085a.1.2026.01.09.11.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 11:35:18 -0800 (PST)
Message-ID: <62560a47-9e64-4c71-bb73-bc86ef6e9711@gmail.com>
Date: Fri, 9 Jan 2026 11:35:14 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/737] 6.6.120-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260109112133.973195406@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/26 03:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.120 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.120-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
