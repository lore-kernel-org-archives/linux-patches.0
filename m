Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5DF620
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 00:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIXemgat"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1f9f23b4fa2so302861fac.0
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 16:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1701389368; x=1701994168; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4fHHUuDWZn9YqqYK3EYAhJra7nQxFC5yxmzo6hYrotQ=;
        b=LIXemgatcl2zMmbSDiHyhe52qk4Ag7nKcWblsBKmn7CflJid35QMJ8KZQabYdc2pIm
         J+we5URJvpWfWz7S3BdXSVF5g5YGIF2M3ccHIyAazvL0lOWlL9c5+MvgZCQOc47En7Ky
         gLzJ9K8pj5Z/7q5ZSy+OPjcmsTWkQFS2Of5c8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701389368; x=1701994168;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4fHHUuDWZn9YqqYK3EYAhJra7nQxFC5yxmzo6hYrotQ=;
        b=uXLj/+UbV2Q49u5BHctltE7H/8kA8sZvP1VZI3bGjnI8EXhGFWOdrTNmruDz8Ypdfn
         8HDS0HFh9iNZZa1FioGSu+s4rUqAiw2nUO4D3zIJBxdsH9uaPmmdpfcU0EWFff8CRMoO
         xKL95jRkgMu0wJkmnMldgZs4UHu2iXN6NvsIfYAQMDDmLbe+uulHAUTUHgSeZsJzb6HQ
         s7Iag5IteeVmwEznJMDTq466fEgPvpfbmOa6FrkcK/oMM32TNdhQBSiw2vdRxPhNF+/C
         OYJsqCRH3NgICoTR6Gldi5iawKuoJQHyeQF6StgfNsj96nvJSc1f4Dd7UOfIYF3fc3BS
         lLYQ==
X-Gm-Message-State: AOJu0YzJ3N084VZobTUNS4hO1CAiIkfSUvibpf9lbfJPINdVLl39bo1i
	OhPs+0752IhG689XZvau//ipPTAdd64Xn4UkbvA=
X-Google-Smtp-Source: AGHT+IG8zzeD/auPSzGDXSrUbTz7+QRxnqkXG7XFtfKuRtBOeOFYfWJ5FDWCIruPxeg5QPBDml1OIg==
X-Received: by 2002:a05:6870:4c12:b0:1fa:3b7d:157d with SMTP id pk18-20020a0568704c1200b001fa3b7d157dmr4532394oab.1.1701389367779;
        Thu, 30 Nov 2023 16:09:27 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e24-20020a0568301e5800b006cd09ba046fsm315807otj.61.2023.11.30.16.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 16:09:27 -0800 (PST)
Message-ID: <30b73319-4958-4089-8dbc-7c72e66cccec@linuxfoundation.org>
Date: Thu, 30 Nov 2023 17:09:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/82] 6.1.65-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/23 09:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.65 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

