Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533EB1DFF5
	for <patches@lists.linux.dev>; Tue, 23 Apr 2024 23:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713915150; cv=none; b=desSuh6BPm3BWpf3nI6ddGO6y0oIIfYWVxldZ9g06shwK0IdQj7RpVJzvsAVYMXJh/ud9tCSYJWV1Dp7WhAz17s6NbJwXEHPeZz1hstDt4cV/lE/8Ez6IKoqc7V9H49ki5JULn52oyfuTp7x8txaw1tIYJs0oIr6Uby+VnsLYhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713915150; c=relaxed/simple;
	bh=23hS/brzScawZeSs4fKtuEAynjjzvMh/uEnoc2P5GwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hHIgr4Z1YwB8OlTj5ULoaS73cDSSa7umveLPrbankQtl5KEPSPy8mD53IeB+LUcNnnTqOiqlLNED5lwzDsNoRYNX+5JVb7pn3ASbB/9jfTwpW/lOFgXuXAEUqy23uGdI2/gkv8bGmxzt+xjrjUsvU/uFX5jgDjKAtL7k+8mw0Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EelZsX7G; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EelZsX7G"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-439dfa27003so10057951cf.2
        for <patches@lists.linux.dev>; Tue, 23 Apr 2024 16:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713915148; x=1714519948; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SmXyH9dvxmCU3cg83hUuLVi3PIy6mOxfY3AEbqVj3JQ=;
        b=EelZsX7GJJoIPdko+PjckWJMfgqLQ3EGUwpVN6+JMYm7Af6jp1ALAXuJOD0EFftht7
         MdX6E7Eo8vXCwKwwqlBJwnYdZ3icRjRNLnJKWM7jk69Q3SNUjh7hSMpR0/+4T81FR5rt
         Z/Jhh3lt7wu0OBQ/LwTMILBudJHfS3F9thD5VKfoKUaM4/KbUcIIZ+VAlZfaLJrImiTE
         RMGTj8nHnugfsNhrWY+HrWfraNG8p27TYAK2tvmVGmodwQfQMWPYEMUUrA+ltrLx69hu
         Xg6UPdl9voVN9e3uZBB/NiagKVqE6cU/hBC3XJK5Kj8aaC7fozFeQqzVLi/H5KsLkfBR
         VTKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713915148; x=1714519948;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SmXyH9dvxmCU3cg83hUuLVi3PIy6mOxfY3AEbqVj3JQ=;
        b=QUR8z6pQPfbZKXgMOwtaIUZ3J7hEEcB0BSCWLE+V+WZf0P/eRRIQKBf2Zkjk8nWadh
         0dVyJv4rVHkTywgFPpLSIPrCP2IPDbyuaADJy/lZZ5MTHfYn7XkaCBpnMal9MQdvhEX8
         4T6syOZnjWkGipltyFG7KCrX12CexIVIo2Ms5PJA3PwCWiC+H1ps0rSWj3GtJy5hfk2S
         oMfH7scgmf8OkL1k+xOl/iV627f7rcMkrfshKjfb0JTodvz6mCSBW7OSgLxzFsiCmi8m
         DbuJoPKNyeoR0LH1ZylYxKVSSGRCa2RYVvRBC3rxpQTC9QDfltyjwKV0Pj/B5EsPC7cU
         FkHQ==
X-Gm-Message-State: AOJu0YwDiUHyMppLJb0ocIz+mzQsT4EZoDu9H9BHrVDnajuDoWKktatg
	csRl/v9jMolc02dGEVNmkY2J2rfxruAaesPkSz+LmiZhX+sLJ3eL
X-Google-Smtp-Source: AGHT+IEIcF45RXhALXWmglYUuAQPe/v3F5iDAqUKYfrtp96kJ8HQ44745LYH4NAQQPDcZT7LMAumjg==
X-Received: by 2002:a05:622a:5a0e:b0:43a:15c9:34b9 with SMTP id fy14-20020a05622a5a0e00b0043a15c934b9mr1058320qtb.28.1713915148115;
        Tue, 23 Apr 2024 16:32:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ic10-20020a05622a68ca00b00436510ddc5esm5588027qtb.34.2024.04.23.16.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Apr 2024 16:32:27 -0700 (PDT)
Message-ID: <79e05a74-0de6-48de-b570-cea567d9aca9@gmail.com>
Date: Tue, 23 Apr 2024 16:32:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/71] 5.15.157-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240423213844.122920086@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/24 14:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.157 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.157-rc1.gz
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

