Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E893A143885
	for <patches@lists.linux.dev>; Tue, 23 Jul 2024 20:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721768165; cv=none; b=NaV18qTd0OaFCTCzlp05TklwudttTprSDuQAYDCMYRJ656bInVdYqWAERyyZyMHs+jjraesEL0Pc3iHQdkP5FH1IlGxDL3qdmj6PQ1indjnoI4yIvp1JEqD5Mi8mXGVPE6iqQhJvSfk6elAHG6FzxTUOfH7RvS4TzuE3Ak/ITY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721768165; c=relaxed/simple;
	bh=CKE12PG2ujHkA7bFJm+/JoYiWMicVup224YXZcCr7xU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XBXJVytYtUQaWvSNAF5eK751eIF+bzwSjaQNV2Ry06s2YxTuA6jyl5ISDMJlHoH4Doxi32cJSulYKo78hkcbaTrD9pJPdYPiIwqTZm5fxffpnB2awRH8mcktzGjv3mXyv6v4jf7buQSNit/bDNAazyGk9ouA054jWEzKvIt6t1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S1u5OiSo; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S1u5OiSo"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70d18112b60so173986b3a.1
        for <patches@lists.linux.dev>; Tue, 23 Jul 2024 13:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721768163; x=1722372963; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5NCzGXrh8n06olyrAiz8650mTJFyCIMqyVh9qyVnxko=;
        b=S1u5OiSodey9cZgIbswbUkhwYLaMSbxoUvNemN/9E/zFfyxl4ph6VUDfx+MgVNYlNo
         Ktq3hwbGpd3XsOl+oPTG5D+Dsh0ndAEMCNHPKt3FlNaX2pZU+wuVjOe2bngZ6HBMVPve
         UoDLdsLAtlDCOlR5bfCXBCrtKqvxEVUDtIpRBB2Jyc7kdNcgUOHYVijDPhQ0EpkSHq29
         T6yWGtloPqPr1i54cIEBLxw72914vP/kchUg6irKeRK8HBmn0SZ311/rAayqJypKacHi
         tFz1ALNU18sXskxoJIkOprLG3bRgxxu79qJBOgOVfH6aVViT1fPNa8QJuYgzq+O4VMZ5
         hoIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721768163; x=1722372963;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5NCzGXrh8n06olyrAiz8650mTJFyCIMqyVh9qyVnxko=;
        b=cLGANy2LFsT35hq5hVPB8zdSUwP63+lE/5OiWL5hFC5ur+tiDFeAmJ5zc4dOxpxSZb
         ukTvaLSmRrWvKBp0+KHtdgNiRmbOwNM+7vtZZuojLl+HCfk2vDPSJol7y7xRYrW5sSZ9
         YT+kGrExr5zZtJa8YGqWlLQIREto8TLNlztrP03sCfHQB7JPEptIM6azvArsgy34vd07
         Wf7Zx7FsDhFvQ9zdSex9jiisZIa4DErf0thnA8pOAui1aQXDOdfP7WEUntF4iLb52LwY
         vt8NOicVihCZ1J4gTk3gardzaiScGsAl4OgNOQ6Bx9cpeQprbnRRyCUzfls9ydqlZB8u
         WxFA==
X-Gm-Message-State: AOJu0YzrR0XSUgCyZu0OlgYQFyR/vVasNKoAM7cLcqCq/C16MDgc56BD
	URTme5J7krTVT/e4n9C8KuDxyLbVuzEQ60cc1j3H8mi6zXcif4e1
X-Google-Smtp-Source: AGHT+IHw052qz8tLBs9sqFgmZdY9aGOzii0HRaNMhW+3QI4mY25KD/LlPT6D5yZQEPRA1UZnF2hBnQ==
X-Received: by 2002:a05:6a00:814:b0:70d:2ab5:8677 with SMTP id d2e1a72fcca58-70e8089965bmr5792409b3a.10.1721768163053;
        Tue, 23 Jul 2024 13:56:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-70cff4b5cbfsm7355555b3a.73.2024.07.23.13.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jul 2024 13:56:02 -0700 (PDT)
Message-ID: <a9704dc9-f461-4e13-a06f-345b9b05ad3b@gmail.com>
Date: Tue, 23 Jul 2024 13:55:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/129] 6.6.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240723180404.759900207@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/24 11:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.42 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 18:03:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.42-rc1.gz
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

