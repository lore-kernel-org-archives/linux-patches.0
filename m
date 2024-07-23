Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A4314900E
	for <patches@lists.linux.dev>; Tue, 23 Jul 2024 22:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721775270; cv=none; b=UqSgXeN+nCZN+kGvKbn+Ic9Gr/hU7hI3h/zIG1TJy9Fu+nRG5Dut7HRWNfXo4FpFYYdOxOnKijACr8BmU8LNQhluLlXRGt5XIAfMZY7KtL1CFCGdTGa6hBZsOOuS+0WMvCUcp8NlA4B7c8fd3YwSiKyqugQDOgthYeL7BlJiBt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721775270; c=relaxed/simple;
	bh=1AjLTDbuhyesuT1YeSuYmfbEfq7w+4c503zcZIhhfTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qscnz2R+urGyMITRwglhdM4hYzJY7OunRkxPV36VdtCecf2hSb6MjHQ+FE2udOho0u1/3ga9i/1ghlmfPGZsl2enorqSWpaO5KeBygwVycg4a9XPBsFZMW/mf+vU7LeHpbF90XFa/Ejb2RuhLiTxjiZ++pSK/05+RBGFBrYov/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UwQL7S1X; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UwQL7S1X"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6b797fb1c4aso45854766d6.2
        for <patches@lists.linux.dev>; Tue, 23 Jul 2024 15:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721775268; x=1722380068; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LWMntoosXb0dgJn0gpXmbDSjr5NrrVKbXCip5YcXW2c=;
        b=UwQL7S1XQUEvmMpTNNwmDpZRVPGaoRbiqg90NjGKxqRxTab/9crHGq9JE5xeYwP8Cp
         9XXDuIqRjsTLPX4eJdSBCnoYtkmth5N+PK0FujU1VYcElxZ/fXhdi3W9hemsJmdfF5ZN
         41zk67/O6deuVaa5RtTCDR+Pe6/HbK3HHopC15S4fxxeRt4X0T1hRw7jBuYJYzDD7etF
         K98VjSBOc86SY0f6Oc5U3yYlkuEb2QRYyt8FzgGtTiY33z7i1ZofCRj15zsEsv5yIyoQ
         w3XEjwGXFaNZI8v+hFXUcqfjtA2CT2gc3nnrOegalDbkBwBz2G3lpP9ATW1f48Jmntqu
         IvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721775268; x=1722380068;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWMntoosXb0dgJn0gpXmbDSjr5NrrVKbXCip5YcXW2c=;
        b=P5oIo2fQLsDjbxk3Jk8BTl5/tRl7CBl80tMAxKQVZ9lOKKZV1XHaO/1VUOc7k90Y2b
         2HV1Lx6hOPrz5nuVTiVp+dqknVmbTf4fIOPmElnacmhQv2DShGO/ERVcU9iKb0onL7fk
         D/Wlaq3M93jOxChbLHRKwal8bWXyIBzYW+BubFudGE/jUoF6OKpZPuCP1whcZFUSRpNI
         /Hh6ZV8j7SycrbnNqIyaW48gu9kZhS2YlO3g5NiK0fJkYY5FZD8+v1swK/WGLd/pb1rd
         6GkpVAqHMpzCXC9z6IgWqpCIAwiZXgK/9d9EKlbP/Ik+j8xPjt9xgsamoe1pY8BksyHB
         piOQ==
X-Gm-Message-State: AOJu0YxsOT4CAQhJ/x4MF19N5CpKZCh9MTGMf5xPt7ahUtaRFMaHYJer
	7DyTbJFRvJkGhL4cndSY3ibra7DU1mZiPo/stmdsWRrGVxDJA4ur
X-Google-Smtp-Source: AGHT+IFiIruTHHXZAK76VBbvCdeRelJiq4cHOVQDT+BXtQr4+VOSTzm+Xj/KJddY40pYXnK5MCIOFQ==
X-Received: by 2002:a05:6214:76b:b0:6b9:611f:eb32 with SMTP id 6a1803df08f44-6b98ed48304mr11465216d6.34.1721775268192;
        Tue, 23 Jul 2024 15:54:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6b96e8bf456sm30388576d6.56.2024.07.23.15.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jul 2024 15:54:27 -0700 (PDT)
Message-ID: <cd7b0b38-af8e-42f2-be5c-c57fd8e3937e@gmail.com>
Date: Tue, 23 Jul 2024 15:54:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 00/11] 6.10.1-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240723122838.406690588@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240723122838.406690588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/24 05:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 12:28:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.1-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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

