Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3863194A53
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 21:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731791057; cv=none; b=RmZb1qUpc/hiSOVP1MbCwVoQxItIla1LcVF/YnSLQZvFj4Ux2rJ9kAusm8hUxfHAuUh0+7EJTB89mEHRB1la56hmDXwndH/TxplZ1olZzcEEiyGxW5TwdM52mpzi0wIu+wi9SpYQnCRVFtkE7AJAgY9d2/uIRHEdMdMXS8N3ez8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731791057; c=relaxed/simple;
	bh=kKJ3qTQEwhEQ5IX+PHwZJtS5Ex8dRqGOuTPBeS9WNCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s0qc5RPeXe+cHrF5DX8i8IdT9IjGJ8GW/0iXPeFos9UIWUfUq0TdCF7p4q4hJnQidRvX0i8ixLeX75JbLxAKh8n1971muA9qE0iZUKk+YyimbrbVgTaQ+e2fNbItWTJ9sSSfAxslEi/WGNvvJw6k13TFTrncluUaWBVczzUhi5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kr2Sjfnn; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kr2Sjfnn"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a7372070f9so8877395ab.0
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 13:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1731791054; x=1732395854; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U58JmcjKhSMtIBEtYZmZshd6JtYlfTEpWKxxkoGVqew=;
        b=Kr2SjfnnrPMBUXclb/s2N9PrpoWIgbsL3xmL7oNe6GIpE/20oNVFyJD/eejHC/4odv
         tA68tcjC2Okv1QvykObIjKzcCeoewe9RBqp1kb+qfAq8y49BbAK5u7DEQRsWPs97/RZF
         Y7uaYJxuobF98H8tQ6I3135Ac/WmDX6dWGoLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731791054; x=1732395854;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U58JmcjKhSMtIBEtYZmZshd6JtYlfTEpWKxxkoGVqew=;
        b=xPSPIQq6vXOuyBDNTc4Z2nKTVPK0+7FhgPRnOfbVHTKBXHaWlefFcVSW6f5M6rWRh2
         bxeHZ1BnC6R9B0K9pdomRGswmivxHBxBa9FhR8728naCjmDs30c50MGoEj3fVA5u4C6q
         /igOilj3ZkImbJOboLEaTqXVq6QBCy4my0h+c5midkcsYkdlDD2mHQj2nsnicpskS0s/
         FbKDZ+aFDEm9uAgfadlE1wJ//CUn9sXxD6atGi6SLWdaRc3TDPNOHRp0sWiT2TgvRz0p
         vY/0Hl1WsN9q1/TpXNPBC2/HWZR/ITDrH0UgL+fKlYgP5gOMSZsq0hZGDVgnC6p/Ql9P
         ynMA==
X-Gm-Message-State: AOJu0YwiOHg3lLQPoXwo+PGE56WMVjB51c3DGw3GVa+JPyQsW6xPItWP
	jDFrg4ZzZ4kPDKEU/KFncGpy8w3icapdoJ6IYiErjJmOTu4NWGx3u/BRSDgBDx0=
X-Google-Smtp-Source: AGHT+IHN59PuVmN6IviLKx+2Cem2ed/yJl1OmGwJP3wojhFylRkff5In1R2svHIJhjohf75HlacK5g==
X-Received: by 2002:a05:6602:2ccf:b0:83a:a9e9:6dc9 with SMTP id ca18e2360f4ac-83e6c3199a9mr743702639f.12.1731791054017;
        Sat, 16 Nov 2024 13:04:14 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e0756f5f28sm1175069173.159.2024.11.16.13.04.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2024 13:04:13 -0800 (PST)
Message-ID: <467eaf93-e41c-4c2f-81d3-03cb1934fc5a@linuxfoundation.org>
Date: Sat, 16 Nov 2024 14:04:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 00/63] 6.11.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/24 23:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.9 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
