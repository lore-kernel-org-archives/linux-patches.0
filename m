Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1426101FC
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 21:26:28 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1b8ad356f03so2568475ad.1
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 14:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691011588; x=1691616388;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vpxv8V9L5JZbPZfIFzQxedIS3P5Jxl68SXEqUp5VX1Y=;
        b=X6WSbmzaTIAv/HyInxOx9KeKlbuu9qh8gZsOBYMIUykFA/ug53wGtt9o0XTD2lkmTc
         ljR5lXKVVZeAIvylCU4LYiWAIxc55b9bE9LMZpb4oQ8fudh5x2w1WSGbz1JLCRpJ19/q
         moU7gWPvm+vYtyiG2IRP05ydm65gmrGOx0yirkOhnirpqfYnMJRsbiLIcwUzpkEB9Y3d
         EqX97wClSGNXXrRqulK/HrlUNk2vx30wbiz0q11Alfd0tYh1cnszWdN9wMMOwOLvrBT1
         J/PazZwAi+wvfehWkHrfIEMzDVSh5wwUb8KXSP2U1Z59R5ywT3FSJY0lFY2esxpdxB3R
         RizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691011588; x=1691616388;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vpxv8V9L5JZbPZfIFzQxedIS3P5Jxl68SXEqUp5VX1Y=;
        b=Lb5J9cA4wV5cyWDeLTHRvlHTTLX1qwhMtSf3GmIsXJLL5wjcD5CYN+ZVpUi0eDgR/n
         /Mk9mMxfm3Ol/geJqmZ/xF5hTZAmtJIw98aRKWMNXiXydJjip9sfyJmEL1wwxgdjsTOD
         vjUPcFhNDQs6ar8a2/ql+mrLRkN5XlGmYoT9zn9YxbdUlwLqig5Lx1viu1MrXq1WugSK
         DJsv1rtJLlheKWAgmOatNHs9JM/eSOdwZkjJuOiAoZIa7UDS3PyMsZGrlomZ2tP3mvkn
         InWQ9tlwtiLIPg/cqKDgoSpm+pmpaffpSj0T0pOo6WduP7tBalHKbCObXI2QVS7HBPus
         498Q==
X-Gm-Message-State: ABy/qLbju0yDReJQzoJzla0rlky7hmacVDuzGJ59xss+LnIwHdtdKI+X
	IowuBK1b6nF0wWGTwIW1DL8=
X-Google-Smtp-Source: APBJJlEgKciE33/chNIcAQ96G1OCtS5OCHSVQg/14SDAGAXKpbOq7gbtv6F6jd3XUXC5lStKovfWeQ==
X-Received: by 2002:a17:903:2351:b0:1bb:d280:5e0b with SMTP id c17-20020a170903235100b001bbd2805e0bmr17334723plh.18.1691011587738;
        Wed, 02 Aug 2023 14:26:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id jj6-20020a170903048600b001bba7aab826sm12880629plb.163.2023.08.02.14.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Aug 2023 14:26:26 -0700 (PDT)
Message-ID: <64b9cfad-94db-9f18-72e7-f88da212b56c@gmail.com>
Date: Wed, 2 Aug 2023 14:26:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 000/153] 5.15.124-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230802065452.161574662@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230802065452.161574662@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/2/23 00:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.124 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Aug 2023 06:54:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.124-rc2.gz
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

