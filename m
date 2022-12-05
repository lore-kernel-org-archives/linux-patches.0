Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6A52F3A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 22:48:08 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id 4so12260020pli.0
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 14:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FIM8cOZnFf+hJ/RzssfzC4c3e6l34LrRCuOKeBtFZkw=;
        b=Uy3vLli75PvUovwv3R6LxBei9NdEpaSxYl0ovO9Si0tXUgAvolVy6v0AHA6gcaXEGe
         SRc5mROuDqeN/io4TtI2jn9JiS16HLdfoCIysIB8RunhhKSOQLvO3OB7xAM5SdiKXYOk
         npQhkIKbKT2AHFIFewvc74aSLPdBLMC5B0Cy9iFxg63hPfFB3b2h9YRwkcaB1N/Q8eNB
         UkC/60IJH3svb64yV1WlhXTT5yz/7pNlADVF95oMtBXiF9n7dxcurBoSpC9UxW4c+F1J
         QfIIcsKex4Hgxr0AgGYu/tV0PGEPSujao98o6gioSm02HZZ1tJUOb6/FRwCJm7GhxGdp
         MtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FIM8cOZnFf+hJ/RzssfzC4c3e6l34LrRCuOKeBtFZkw=;
        b=upYzAdMBeUJOMAsf/aC2BuiSJF9rkvTVEzH1T4RSWrpGjJGPcKKKpYSBLvRbNOwT1E
         XRSB6oyb1R5M/G+Yx4GZhqL+SXR/qML/dyPTF+a6CzTgeN8zdav8XrpwGmP0QsdCITbr
         SbYxlffXPy1E6p7hDu2C4AUWn8/LGe/fOFMxraZjaO3dgrSl9BD9z5bLg/ZRO1W8BQTW
         b0jM6o9X5wwUgaFZA2LFBLEnGqhnVTmcIeeoiAPwV4nACYzCut3oJNNgXm3l1jPFhrpd
         ihr+8w3sEIa/Yu61WAyd7gquhRdATMGFev5uIKciSI9Arc60D26ou6EOUmIHWyct6xLX
         Repg==
X-Gm-Message-State: ANoB5pmwLDKTkaTKdLrkN3BfEx3G09FGwYYGoVoJq5y2LmC8ud/dEVY5
	aCuXoN8fV/R62FKPLG1ZiSU=
X-Google-Smtp-Source: AA0mqf414ZUiW8PrWeib6fKdHGgyKZi5tmPVx/zBfMsY62OY/7jl9MeCItNH0XOcxs9Aouhu7tMaug==
X-Received: by 2002:a17:90b:108:b0:219:36d3:678d with SMTP id p8-20020a17090b010800b0021936d3678dmr41751133pjz.187.1670280487958;
        Mon, 05 Dec 2022 14:48:07 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a3-20020a170902710300b0018963b8e131sm1814407pll.290.2022.12.05.14.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 14:48:07 -0800 (PST)
Message-ID: <2bb37989-7c22-ae06-6568-8419ce57e44b@gmail.com>
Date: Mon, 5 Dec 2022 14:48:05 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/62] 4.9.335-rc1 review
Content-Language: en-US
To: Jon Hunter <jonathanh@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Adrian Hunter <adrian.hunter@intel.com>, Kamal Dasu <kdasu.kdev@gmail.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190758.073114639@linuxfoundation.org>
 <80305ea1-4d52-b1d3-e078-3c1084d96cc7@nvidia.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <80305ea1-4d52-b1d3-e078-3c1084d96cc7@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/22 14:28, Jon Hunter wrote:
> Hi Greg,
> 
> On 05/12/2022 19:08, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.9.335 release.
>> There are 62 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
>> Pseudo-Shortlog of commits:
>>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>      Linux 4.9.335-rc1
>>
>> Adrian Hunter <adrian.hunter@intel.com>
>>      mmc: sdhci: Fix voltage switch delay
> 
> 
> I am seeing a boot regression on a couple boards and bisect is pointing 
> to the above commit.

Same thing here, getting a hard lock for our devices with the SDHCI 
controller enabled, sometimes we are lucky to see the following:

[    4.790367] mmc0: SDHCI controller on 84b0000.sdhci [84b0000.sdhci] 
using ADMA 64-bit
[   25.802351] INFO: rcu_sched detected stalls on CPUs/tasks:
[   25.807871]  1-...: (1 GPs behind) idle=561/140000000000000/0 
softirq=728/728 fqs=5252
[   25.815892]  (detected by 0, t=21017 jiffies, g=61, c=60, q=55)
[   25.821834] Task dump for CPU 1:
[   25.825069] kworker/1:1     R  running task        0   509      2 
0x00000002
[   25.832164] Workqueue: events_freezable mmc_rescan
[   25.836974] Backtrace:
[   25.839440] [<ce32fea4>] (0xce32fea4) from [<ce32fed4>] (0xce32fed4)
[   25.845803] Backtrace aborted due to bad frame pointer <cd2f0a54>

Also confirmed that reverting that change ("mmc: sdhci: Fix voltage 
switch delay") allows devices to boot properly.

Had not a chance to test the change when submitted for mainline despite 
being copied, sorry about that.

Since that specific commit is also included in the other stable trees 
(5.4, 5.10, 5.15 and 6.0) I will let you know whether the same issue is 
present in those trees shortly thereafter.
-- 
Florian

