Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A351E1A3D
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 03:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770692449; cv=none; b=kzOqECzMw8OtCbKfQHjXXlWGfIY6IF+xdWYmDMgY8cOHH/PeIYAKZgnPJzWymUOacnSofxNo87jYQvCA1J0x4IhZ+DeFZTBFjzR0jRPYIOnRWKVc4NcYW38mWvFHV/Oc4Dy38acBfnM5+AIBoVdJBhDR8cBw8DlaVypi3v9Qjqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770692449; c=relaxed/simple;
	bh=gHhQgf9PyAtpcPBbpopJtodT2yapy0G+zhoW5CJKnq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X0goJyyeC3nwDpiEHFny4OgdOVO8lceyzNWonIvsNIEjJTpqov0TS+uMuS/nPVCdIYMXajCAkjPsvKFE3+RJtLKFfv+5PDijHFAl88awc2GI+UNQ0u6A24104Vy5d7YudmlYK6CEsxd/CT6rNHyFEaxsm8cV2lP31+M1tkElB9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TSEOLgFq; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TSEOLgFq"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-126ea4e9694so4226862c88.1
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 19:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770692447; x=1771297247; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uf3I/gqfE/c8t0SfsmwjhiktVe2dpIYO6SEtzAKK9p4=;
        b=TSEOLgFqZVuibzckhr/3fv3CpCkwDdkgaajKVUJLq9oaguk/0uL6cIHphu7tqw3oT5
         bGT6D18IkA2fDBgt44TGbQPB2FB/HbCPb/sUc4CI5vTWgX2uDMR6zbpBVJRZtVygcOeh
         cq5I0erR4e2nBw2zWYyGZSyAkpkD1nnLM48xcI2JCjX8p8EQpNhRiU1q7iv331T3J42g
         R/RbpzhbPhj4an/0svAmxuiQzvPkI2zhJr4Qik/FIfP/IubljKG3Wn4GUbfJ4Fde5Gtv
         s05sSmhl1J8omyMg8VHRDF32CMQqJUM6wPwQnT4MdjCUrRvoPy35XLaPrCYGqmEe0e0B
         DT9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770692447; x=1771297247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uf3I/gqfE/c8t0SfsmwjhiktVe2dpIYO6SEtzAKK9p4=;
        b=iXPMLbP0GD7Lr0oX2BDqzI+3sh003qCst7WTn0t3EWRF0nQ0CM+2a0rSvEK+VrCA5+
         XM3tYl0gaU8/I1xbJUJ6cc1ZrtR8Z+hBHnbVzXaPI5lUPIABo982lD/VlicjGnC+/gR/
         MAMCWXQbfjoaEBuzhy2FKjZwoXw9J2Vl4QU/agGJKR8MZ1St7PGbmaFV+jh7lBCYvn0N
         WwYXfR+0jbouvSq6/zWoOAkFpJ9dgvZeE5IwB6PzFvDkXyyyRkldWyneRba7UyizClmg
         MM/IQ9SOFIAc1jdBDhCp97xPpyHaXqdcHeugagieykDLKfZnB2siiVwKIpRvG3g6OWKy
         KQEA==
X-Gm-Message-State: AOJu0YwgBx3B5FuR56mOiIfDwSxOxc1c4dbfYCto1IJlnhPFJ3a4blfL
	NWv1rdr+eNwCb3lr4G2k4YM+qIru4bg9QdeXGUJXvpyw5vqwuX6KPXEq
X-Gm-Gg: AZuq6aIOMmjOPE7G+ThQovPdzZbLbtmQRMZz4sE9vuERfQ8uuf7iDFwUbG711aIdlCY
	suua4l0EgmFbOH4FLbs5SawemTK3vAy3VIw8oOtD+PM1ZlkYYHz062/M7/qDLbuZVYEhb1PQ1Wb
	kcnHKRBmqv7gWJZXblqJk0s+4O3p1G5vseNXzBX/PLoBhz8PCjKmKKYSUAlvrYD1AGDeH43f8aS
	3PdMBeiyNzluxKafipC+2oGiXGuDAtopnyvSGkZp456qK2aWoJVlPUhu1xm4kuSCcbvBaHwPY1T
	EJPGQWw9XVK6p9v2XnJLu2prWdpKO+hFzMDMdm4MEkhAlCSsydte2eCrOvsZcB8P0ux0FOdxZ3F
	72U50wLsoSy5SOU//3eol+pCF0AsGXeBO1bt9IA2iOabilrOqDhkYh0YjTpIABVApHMgOPbJ2r0
	Ijq6v10bKiuysLA2/jOYtjVjOfEN4vn4Vpclni3M7ozFj990gBAZGsF/0Z2yD0sMh9UAuWBnGev
	Go=
X-Received: by 2002:a05:7300:fd84:b0:2b8:2946:72c5 with SMTP id 5a478bee46e88-2ba8a8ba4e2mr359759eec.39.1770692446899;
        Mon, 09 Feb 2026 19:00:46 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba6baef3aasm4607570eec.25.2026.02.09.19.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 19:00:46 -0800 (PST)
Message-ID: <8a99eafb-0382-4fb6-ab4b-e780fe5ff283@gmail.com>
Date: Mon, 9 Feb 2026 19:00:45 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/113] 6.12.70-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260209142310.204833231@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/9/2026 6:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.70 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.70-rc1.gz
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

