Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3083B1C07C3
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 14:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729003178; cv=none; b=bPvCDCVA8sraDkSGT8gdC7Lpt+6qL4g8pEnYPMqQwjAp1XOKjqxBzfO68EojIhKfN//L9n5bvQn0Ks91qaFHtqDA0i/7PS3yfBIps1NX5WJl9BXVwMnd/cD7EFpfelbkXohtVs7+0loNZq6gV6D7rDCO7pLNcCaDwvTKgI8Szjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729003178; c=relaxed/simple;
	bh=+FET4V+Go0PVk0KPckgbUBF2yItjsFHqmEQsxlFShNg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KMyDSVbFv/Ai1e5Nlo7SUk7bd4RzxuWENWHAkn6S+78ikMJtoftkuX//XslbO05Gc2fTFIPJFwj8JEcmswLxuNMNswxpP6f0pohFF/uzZyXCTxaWa/QPRby+2iv/FaRi0XK01GH85oCdIIzG63KppSdrjg+iFLHrIEwdY0maZo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6lg4TMl; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6lg4TMl"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-835393376e1so331577539f.1
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 07:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1729003176; x=1729607976; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aYV3QcxC45dpKB8impDWnSd6jizz1LlWcNLXatvfVSQ=;
        b=V6lg4TMl/YRBm9GT1nCTiVzdMyI+gM2eSBjhlUzpXl85qLDpmMhp+Q8FAfAT7LiWPs
         3wm71zgIxy9f0/Ix06dnJw02wp+CHRb7jQuSJaZxVKSf9P1PacnOoXXt4QaMe1NNt+1r
         5E4jH62JGOrRCP6YfqsmdeAMJuhKCoLzIZSPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729003176; x=1729607976;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aYV3QcxC45dpKB8impDWnSd6jizz1LlWcNLXatvfVSQ=;
        b=i0ZPuxUdCQlI4ofEG+DS/vkVktqzx9Xsk1457CEQ/4p5v+5epq60KT8nOg3zlWdvKp
         Eohy6R7421KBXZqqnxn1hmzaqwpqKH22hYPUszMEfaY1JaloKpH+vFhJDfrwmDxoXXpr
         gLKWDmbHpyIJwkKEu9+AA2mBfs5/YgRPz+3pueir+osyLTQZVbV1kDtVJ3cnGSrOVxwY
         BfDO9lAbNyFrIPT59kYJdNlPlTfWSsC/K7hy7hIx2fLTMUFaXQ4yCLDSDleaQU4hMlcv
         nfU4WphGAr8iKOs+oabFTM0W6eoEUDkZeljJXDmkdPOAYzaeLfzlDMFqyxpupZInE/Lp
         uAZQ==
X-Gm-Message-State: AOJu0Yz+uBCyepF7s6GNqbFEr0qMuKjgSXaTfY3pLCN1Wy9b8M3+wKxz
	tYJGPAYTqtmeaQMTxjSL9WfOU7IDjtHgyq13VYQzdn8JPVyxuFge3OrtiSm094g=
X-Google-Smtp-Source: AGHT+IED5yavwawNcgQC8TkzJld/CVTX7L8NciyUzcWybTw6y0vv+1spOMbUSvc9mmZZ2bo2GmR3dQ==
X-Received: by 2002:a05:6602:164e:b0:82d:38d:1362 with SMTP id ca18e2360f4ac-83a64bf39b8mr1160104639f.0.1729003176231;
        Tue, 15 Oct 2024 07:39:36 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbec9b24c2sm338146173.58.2024.10.15.07.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 07:39:35 -0700 (PDT)
Message-ID: <6b913fd4-ae85-4388-8f41-7378fbf3d137@linuxfoundation.org>
Date: Tue, 15 Oct 2024 08:39:34 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/214] 6.11.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/24 08:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.4 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.4-rc1.gz
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

