Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6385B7E
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 02:06:59 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id d13so29082857pjh.0
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 19:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680574019; x=1683166019;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t0ge3CIUOEAdSzey1zXLiQEJE19ZYS3sqtGQOCknv/4=;
        b=TdNchomHmFG6XQeTfzd8bCgqQZzmqhfdiH2VqbSs0CYCR2cw92h0zcP8kp9ppvkEqY
         m5mttRjQQNoXLz7ctQTuCvmWNEwucn6Ir21DxI4reEFoau+zOyiTIkCmHH011B/pGiPu
         wseRjZupLmIkZvB6BEZsFVIQVGJSF4HLGsQWDp/WvWYrIGsCh7bdWRogfEFgilqVWnTi
         7y7c1mqY77J9ROyRnH+IF1xtarQNrXd93diNrYrw/KuPi00E2Rg9nAobPPrcgvDYLGjv
         tmr0aRieAhJzP/PayxAWXWXVNM2R+6HVdAdcVacJeKmD941ggvOY6bjjZ3z4CO04mSVn
         aaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680574019; x=1683166019;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t0ge3CIUOEAdSzey1zXLiQEJE19ZYS3sqtGQOCknv/4=;
        b=Li4tD6qqEEV66I6oxkXD/I5zQQv+JONxJc2uB3P7ktNyzoY62TSfftaM+ZIt93ULE+
         plhniUnklzcWcHkZbXhFUVLszMJbyMgJFOj+Dr2FiKER9jQt8QY7ATiOTl36yrM8MFkO
         kwhQR/CV++xbeb1/IDZ6ADB/dw/O+8kAx6wMnlSvIqI77JzRg/CL+6YKkVahWWtqPi3k
         Rel9zV0THAR5wBQvNEGcmDGgr9El+0Fr0TPWGbY977B0i4E3F6E7To8AqXtuTyMyMOzJ
         9oiHrVzeKr4vtk4bk7T05oedFa9P7B1Z65vsn7JnnFhj72aFX4ojECKX2O3EctXN/+vA
         h4eQ==
X-Gm-Message-State: AAQBX9d9Jga5Xs7CqU+91PnvtUtBjpsW3YlLhU/zjW9dwwttxX5R6jPr
	pnjbJnNCM45UKg6Do7+fpiI=
X-Google-Smtp-Source: AKy350YAvo/0m+M3bZC6eGs4064RCzJc6O96Blh7uRJ5TQJb71K3Kw4dF37bCkgkje9GPeRy0PNLtg==
X-Received: by 2002:a17:90a:be07:b0:23f:3b89:7f16 with SMTP id a7-20020a17090abe0700b0023f3b897f16mr1089060pjs.0.1680574018726;
        Mon, 03 Apr 2023 19:06:58 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902bf4400b001a27f810a2esm7205541pls.256.2023.04.03.19.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 19:06:58 -0700 (PDT)
Message-ID: <8df91261-eb16-7190-dc20-93387ffe003a@gmail.com>
Date: Mon, 3 Apr 2023 19:06:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 5.15 00/99] 5.15.106-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230403140356.079638751@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/3/2023 7:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.106 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.106-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
