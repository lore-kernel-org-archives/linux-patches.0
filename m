Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC357272816
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 00:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786149001; cv=none; b=jPRsrfZc19xACfqk/BgiqrjsO1nDTlIsMenMP6ENA3GoNUSo/VbzRkcrKfgFQ9JBPYkyW1CaBAhYHrfGN6vQEZjE97RSIZt5730FnUyG5Kn1BNl0TMLOlI7GQDs6Bs3ilqz+8cuFdUgj9rpeep9ex1DfN3XSqGkJ0BiMvLhciIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786149001; c=relaxed/simple;
	bh=yAyhBqQVu6QGz8IzkGfgadWcrV4SoBC5FN9ccplLoRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LSmaZBlo20NJQCGtatCMVltt7jIuz1p6m1GCtNnlg9opHKcOuFFMP+X3vSbw+Q3vRWOU1OiaUMNIvwFyrd9vsDTtsow05IJrRIhZwi2kW8MipK0xflH/wL9AYScilAMlng5paHL+cDO1dJAEiY5J5z1epCyWM8kJRE/eQrfaaBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tqmq4IwQ; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tqmq4IwQ"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7e9f1f24cbcso117419a34.0
        for <patches@lists.linux.dev>; Fri, 07 Aug 2026 17:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1786148999; x=1786753799; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a79a5YewEDc0g8txCKvKPP6+86xXxUuuEy9pmqNL6b8=;
        b=Tqmq4IwQ/tEG1/WEak1x7TdDNu1mtz/Lu5Lf53CPsKVCxKhZ/GQvm80aVUbMv5BqDz
         RLor1vPXIOk/f6GRgIH4CwEyBBc7eM4CLlRZ5Z2nxUeU2aw3z0vTk4vj/hIAS3Ez/ZvV
         ADf2MH3oPmch6S0HRyq3v6N3dv/J1ZhlZv6MY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786148999; x=1786753799;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a79a5YewEDc0g8txCKvKPP6+86xXxUuuEy9pmqNL6b8=;
        b=J7EuomE2QCTb9a6LGj6v7f9eRBwex356HpZz8nAA8lBjZlWIYdi2Q2QT3aWU7OBFYn
         jh6JLO0C3VZ4KwWuZJMwYOwmTU424JA34xjkZ7LCrVDEMTfzepWYfLk2bCdbkQpuukfD
         KLcRdl64mZ13vFRfh9vw9dQWyvnSAttWwCFvm6HsGbvK2yZRtJZsfNEho85NZLfbJZG6
         qnloyFWfpPJY7B77Go7TU/o5Ie277FvFxOBEfnLrM1Il6ZcTxPzw5OFNEBOBq4Idb4te
         l2Pb/GiBmMBWwDooS19mfnQGUc4bfJrabAVDJard7MJ9pWD14DWYJGmDj3GSXFkmSpiX
         gZyg==
X-Gm-Message-State: AOJu0Yz3Zz9+8VRvE1UcV4qzgDHezCBJ/9utmQWX5O7FA47Bgv2oD7c/
	2sALLGCgStcOg1UEfEczuurUvFmhYAGZmt6yRh0FBHyymJGD/rqE2arP/PPPOaFYq10=
X-Gm-Gg: AR+sD13EPb61MyP0lpyQnGhBK/lnxcs9M0cUEAhc55pqmQAri1P6Fu+DXeolhp7cCFQ
	YVtBwPjLDECVJ+Uh8ocAHKoVRgPDzEloMkKzr5aa/b4qYVAJcNL6eomAcyxILTF7wTvBxKJf9po
	m2lLQDf8YAJnUrvpI8kZIqm/x+NaUpd9YbvChzqZxndYkKH2ylXEfmTcP/CItxgJp+4xdIFzaQj
	HWetyl/eenWrUpmCoHwFc1FErWH5Z4uXvIkHB+TvLtCo6nTYn2X96XoceBW010VUaVxutULXUnc
	c/dpsOIZkU4b5akIA2KhV6LhOY1xhaCqzuxfD8WdJ/4qUB6tSIfAgKRhr9E6UoW1Xs9i67RKl6Z
	WaXt53YdIGVglkxgwSenGZbbSW9G/cO7HcjtEyy4ej2UFF7vhiOSlICyDmBlW5DKuNyW6Dshi4e
	DTusCdTutUaBrKM//gnrlHT2TmE1kK0X4tZtmRdvetWn0pHSjJbzAtLwZtZaRra9WLnzbw6Q==
X-Received: by 2002:a05:6830:6c11:b0:7dc:cb0d:9e02 with SMTP id 46e09a7af769-7f36c1e22d6mr784775a34.9.1786148998616;
        Fri, 07 Aug 2026 17:29:58 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f35b5633f7sm2388646a34.5.2026.08.07.17.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 17:29:57 -0700 (PDT)
Message-ID: <2b15510a-a018-4596-ae80-cf3ff41b6f42@linuxfoundation.org>
Date: Fri, 7 Aug 2026 18:29:52 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/26 08:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
