Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666DC3D984
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 14:52:53 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1c39f2b4f5aso17879625ad.0
        for <patches@lists.linux.dev>; Fri, 22 Sep 2023 07:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695394372; x=1695999172; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=uFOz5B5cvfyphqLib4XjPgRuoCQemaGEyuj1nS/YTcY=;
        b=jloNmC4FZeZQp71cX8m3+bAc7BPFy/XPpRJgagp3mzFKA87I+av7HO5BR763u/0Ul3
         hs3uDpOqGzy+upRDbNwuiCxLAnx/usJUSU2QAZXHmH9BPvJPEl4/3PHEJKDEyqsG+m48
         Im7wbltnhcABo0oum/KUPYfvga73EtbqCifJi3/pKHfcN7vAXYfGOW1bB/vEWucK3At7
         SIfK1vepNsZ0jzC9Xdx3bg/ABcfNQWaUpOUUzyYu2E7LQYb7uz2QMgHaWyE+FrQRrBgQ
         G9QT2Q0iYoko2UzHyb2UFYVp7tf9tQwHMLj4zU/bXMRaoDtCdjbB20qI5v8lXAy+o16L
         ZSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695394372; x=1695999172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uFOz5B5cvfyphqLib4XjPgRuoCQemaGEyuj1nS/YTcY=;
        b=BZUYfVpVnb65S/GHAEEvOQv3yDAabKVAcD9HgiRrkBS8w4veX21zuiqcXa/O5k5zx3
         9SwP1BjPXJU+YOUXccNmDvGQH6RqzFMiP4ZmxQZb1ZoaHzQd3DGC1cNtphvAN4RfROuK
         oJCxwL5Pf9rO0655EUwe/KOgRLWiJLWeumqUg04bURVBPT8hzqITGNtNpzk/rtnfSXaJ
         wY3TsKeNQc8ui+kYwK21dN8AdyjeRtxSCxtIIgNVhBb6pGBOH2pUGoelOdp9Hiie0rb+
         FrD3Gf5vkH2ag/tsH7Epe3Bk/+qrxN5URZHmDtGhIJ9K+f5gdg1jIJGUKawmpmeQjt9W
         aSxQ==
X-Gm-Message-State: AOJu0Ywh3SUwxMnyQQ3lY40Yj+isHd+oeFDVkd0M9rqjXPRfQ5IH9skb
	v8VBdoOrF0n304AGQOeP+ZofMtLKaYo=
X-Google-Smtp-Source: AGHT+IEZN572fa6bFTfpRChjwE2UuVpBnja/f797TYM8J0DmFRetiu2CQF9UKBb4yh5diMB89nb/qg==
X-Received: by 2002:a17:902:e808:b0:1c4:3ea7:4328 with SMTP id u8-20020a170902e80800b001c43ea74328mr10800989plg.45.1695394372514;
        Fri, 22 Sep 2023 07:52:52 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u15-20020a170902e5cf00b001c0af36dd64sm3548071plf.162.2023.09.22.07.52.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 07:52:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <53c9f81e-55b9-b8bb-7821-cb124780d4c0@roeck-us.net>
Date: Fri, 22 Sep 2023 07:52:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 6.1 000/139] 6.1.55-rc1 review
Content-Language: en-US
To: Jon Hunter <jonathanh@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
 robdclark@chromium.org
References: <20230920112835.549467415@linuxfoundation.org>
 <79a96d41-1b79-51b4-fda0-743b853213b9@nvidia.com>
 <7e0355bd-64cd-f6c2-b720-e4643579078c@nvidia.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <7e0355bd-64cd-f6c2-b720-e4643579078c@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/22/23 05:31, Jon Hunter wrote:
> 
> On 22/09/2023 10:45, Jon Hunter wrote:
>> Hi Greg,
>>
>> On 20/09/2023 12:28, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.1.55 release.
>>> There are 139 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.55-rc1.gz
>>> or in the git tree and branch at:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> I am seeing some suspend failures with this update ...
>>
>> Test results for stable-v6.1:
>>      11 builds:    11 pass, 0 fail
>>      28 boots:    28 pass, 0 fail
>>      130 tests:    124 pass, 6 fail
>>
>> Linux version:    6.1.55-rc1-gd5ace918366e
>> Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
>>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>                  tegra20-ventana, tegra210-p2371-2180,
>>                  tegra210-p3450-0000, tegra30-cardhu-a04
>>
>> Test failures:    tegra124-jetson-tk1: pm-system-suspend.sh
>>                  tegra186-p2771-0000: pm-system-suspend.sh
>>                  tegra20-ventana: pm-system-suspend.sh
>>                  tegra30-cardhu-a04: pm-system-suspend.sh
>>
>> Bisect is underway.
> 
> 
> Bisect for this issue is also pointing to ...
> 
> Rob Clark <robdclark@chromium.org>
>       interconnect: Fix locking for runpm vs reclaim
> 
> Looks like all the Tegra issues are related to this.
> 

This isn't surprising because upstream commit 136191703038 ("interconnect: Teach
lockdep about icc_bw_lock order") silently fixes it without Fixes: tag. If you
look into that patch you'll see that the the missing call to mutex_unlock() is
added to icc_sync_state().

Guenter

