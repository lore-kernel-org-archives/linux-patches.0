Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB80018C26
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 20:23:16 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-26934bc3059so1684745a91.1
        for <patches@lists.linux.dev>; Thu, 31 Aug 2023 13:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693513396; x=1694118196; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vUNHbyKTSQS93UHBi8ExMlTCLzp4hfcMKt31LVSlu18=;
        b=BLtDOvBfxFXUdFIJdv0mKgHYeKmZbYztPUZRPdk44A4pOpSBUpBYXnwVftj0q9v9MA
         Tyu2YEFBUEmEBQQ5MaTUDmZqVTSHoLVcr0Kqlys2EU4iFU9L6lyb9AaMMi9kPHe9BqHa
         vD4UfbCLG5iOj0RCqX0nrFW9uiNkeIptx8YUK6u0PproOHM6B7IvJZskL/jWKVgUSxE2
         dgzqOMBQNQbxFAwJaLioB0XkhP9ZqPVX2Po9yc3Z6Kx1AZ3nMl3rg5qtWefGCiNCT3Mb
         9JrKVJH3o0W47on+HEEScNJ7pClyBo09q9WK5HuhmFoQqx66SEnBSMi4vuoN/xrH+tK5
         uARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693513396; x=1694118196;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vUNHbyKTSQS93UHBi8ExMlTCLzp4hfcMKt31LVSlu18=;
        b=RzB+mdsjlxpRzq/RX6/HR3jGqVsZam32/AmzQIZshWwgSYjsGgT2t3nKj7A4JY6zws
         EYkqbffw6hq/woRDY44FHyzP50DtfgTifEc6UVpOvXi/gbcX/o94UBRsh23ur1rU3oHR
         JQkqPDluIMVXNnUslfTesfhVnJ6FBTUJW9+LFWMnG4T18eoVOk3M5/3e3TwnUi1FKGBy
         Li3CQNXtJq/gxlm6zfPbMB4AuVNUqpBiirOfjqrTQIMjkBsU1LnYpvDOHGZh9VHpnh3X
         w0aeeMyE9o5uQPEPdPKgeSN40usVupyR4pMGzwdbk17B6Vj1lrJa+E10y4yC8aklJ4kU
         mQQg==
X-Gm-Message-State: AOJu0YyITUqLhHE/nl+/E9x1mgoOz3vUCKNMtHLqgQvYRfu3wEHSvt2t
	0y3ucQDic92cMIPOU8yij4U=
X-Google-Smtp-Source: AGHT+IGeiB0OTdQeE7+Q39Fwoi5mY5qweQfsfdYkffkwDWT73haMIPvpC5Bf5B2/h8gkW+Q2kLrqLg==
X-Received: by 2002:a17:90b:154:b0:26b:2d0f:56c6 with SMTP id em20-20020a17090b015400b0026b2d0f56c6mr701332pjb.18.1693513395704;
        Thu, 31 Aug 2023 13:23:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t2-20020a17090a024200b002717a368efasm3579134pje.12.2023.08.31.13.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Aug 2023 13:23:14 -0700 (PDT)
Message-ID: <447f5a2f-c4ec-8749-5136-0abd14920237@gmail.com>
Date: Thu, 31 Aug 2023 13:22:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 00/11] 5.10.194-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230831110830.455765526@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230831110830.455765526@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/23 04:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.194 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.194-rc1.gz
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

