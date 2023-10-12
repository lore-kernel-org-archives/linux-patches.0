Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC72328C0
	for <patches@lists.linux.dev>; Thu, 12 Oct 2023 18:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TX2IAzmE"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-775751c35d4so84724985a.0
        for <patches@lists.linux.dev>; Thu, 12 Oct 2023 11:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697136195; x=1697740995; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G5vgE2fYXgKlfq4nH2TUkTSW1zkdBwLIEnXGe5BmWog=;
        b=TX2IAzmEnNL0P9NZN7yOi4SRgwIIsHEvsRSD+diWf3eY3nt/qWN3J16oRKjj4IGTMq
         vRrBp4q9CmGWpgBIOgzT+2J2t+USCSauVW4kcj+USLbC7f2rMoBmXyRMGNxcGRBO7wM/
         End910JXFvQYeQmSQUKF0tu+Q+9oCTiw+TuM/HuXyACguXFz94vj7EPOzf9IPJIxT0G8
         mHCgw5yD65Tsa+/szpBPii21qQR27GL7UOL+r4uEEXe/ukmSMgj0zfYha44vvJMOexuI
         WPt+fXRMehfQYEZdabmC60VAv0B5hCLtVjsONjB0+5OdOySu0geKIB5M/QwvJ5krlunP
         r/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697136195; x=1697740995;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G5vgE2fYXgKlfq4nH2TUkTSW1zkdBwLIEnXGe5BmWog=;
        b=Pf0pQo8ZxVNE0xmQxNxROx5lS0p4ClGiNkF2XpDBSCt6yQ1X2arEMK070mcVuepNb1
         pjJjsKOHVEcEkDaTCLE9+AtpWR6diP//+d+pn4ChwdUPtxvpjZ4yYHw2q01SFvvSsAXJ
         ZkOAHxcaZPmHJS6Q/22l1Bn1tfowlmtXsx2+1xpYnYeLe3/jd1ei2TifL4HN6v0olxaD
         BPPdw1IDN6RcLJuWDTISte1BO5IYAiBjbjO29/JgtZF34DQP33lXVQbts3BC6MyuTOmZ
         5Pc7g2K5EsesqOCXm5CN5mlUX0pB6QWPCPqmFkTZzaFKQsmJnfPoCqYEMzL9C5VUh/ae
         VUhw==
X-Gm-Message-State: AOJu0YwQPjX9f4FyAkS+hX5GEPAOboNtBl7e+Wkk0+a5tCAS3zQ7oA6j
	Xi7Q8BQXmoYEYhP9Szr36TY=
X-Google-Smtp-Source: AGHT+IGNXM1JbRwqsGrTfGInKbc4JVqtJUbsW3aoOcuBfbXiDeKITiAf0Ac6PH0/oHGa+6LYWwyvLQ==
X-Received: by 2002:a05:620a:4106:b0:76f:1614:576b with SMTP id j6-20020a05620a410600b0076f1614576bmr29725754qko.1.1697136195052;
        Thu, 12 Oct 2023 11:43:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pa25-20020a05620a831900b00772662b7804sm6205838qkn.100.2023.10.12.11.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 11:43:14 -0700 (PDT)
Message-ID: <1638385d-a5b3-40ab-ae0c-25b53d761336@gmail.com>
Date: Thu, 12 Oct 2023 11:43:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0/6] 6.1.58-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231012180030.112560642@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231012180030.112560642@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/12/23 11:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.58 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Oct 2023 18:00:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

