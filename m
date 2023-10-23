Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D6214AA9
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 18:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="REoSCQVz"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-66d1ef93284so22976396d6.3
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698087383; x=1698692183; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BH0kWO9VUQM2/DeE8iMxAfNKsGS6sxeTdVFQPB4LzGE=;
        b=REoSCQVzpqGCrAbnua38ZQJmIHpCSlxsuYpV8259inPlfl+CCO3aPqZczCphrEROV2
         9BILfpoU5hTElc/xeFzwRkMGywUpwiP6vwpZgucaKQTADL/CjiSsVu9M050AtIfwAGEO
         pnDgwygXr11xfihrycDaS9gY0it3GK0pWdoqFHbEhpjYVLAiJVxTMt532BnP2EQhQ1kN
         jBTzTy0CSlKf3LBQxngm0GJ5pgGTeXWuyjsrAfGf4zm+ab4x39PJQpRrv5yPaFHhHK8Z
         0BJhGYxTqweKkHdBztg+hYc2PIHQv66niQY1U36Iz8YGAOYS07WYOuMR3XxXNq5LlCLY
         DMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698087383; x=1698692183;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BH0kWO9VUQM2/DeE8iMxAfNKsGS6sxeTdVFQPB4LzGE=;
        b=aLxASb6hhg+UmZKSZlWUSlov34w+obS/4noYjCVNMHbtPopfQbjvSUWdPD3v6p38+y
         t8OC1bCILIMCAzeHAsTKJD5S+AUC5ZUHGqWaPKjQzDdG2vPo27S+n83A2jDfF0JQTj9j
         zOb6j6VUc1gSYIhdMTOLLrMDGbNLcEzp+1FjI11RttsxF77TEPKPsvf3+CMDHjs3Fhnf
         AwXsCkAcqZfNsPuvVmQXhSyG2dwk5feP3q/JbMIflKwF1NmIwqLSyK+qVXYNbgGRtj8Y
         lpsVYq2dEyGTiuIOxpc/KJ8DRVk3k5+EGIsOjgi6CbQPh3ee8qL0yvf0tgl9TiAa3xeP
         zzaA==
X-Gm-Message-State: AOJu0Yz+PgvLX7+1mQRH9ZzV/J1gJVX1tLTAJKUr6/yal9Je9GDJdWII
	7I97MfsRzzQ+2uG53L0PSVI=
X-Google-Smtp-Source: AGHT+IHnMV4ob3kA/InN8Dg8NmBPlXO8MzNOjVKhkWuGzIlBEie5ZcWNCFQVx7vNFBjc4aulm4M6wA==
X-Received: by 2002:a05:6214:f24:b0:66d:4680:6dc5 with SMTP id iw4-20020a0562140f2400b0066d46806dc5mr15426148qvb.50.1698087382615;
        Mon, 23 Oct 2023 11:56:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k28-20020a05620a143c00b00767e2668536sm2922978qkj.17.2023.10.23.11.56.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 11:56:22 -0700 (PDT)
Message-ID: <2ce536f4-19c1-4822-aba1-648c1927c90c@gmail.com>
Date: Mon, 23 Oct 2023 11:56:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/202] 5.10.199-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231023104826.569169691@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/23 03:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.199 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.199-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

