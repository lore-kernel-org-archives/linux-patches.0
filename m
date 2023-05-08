Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2058A2598
	for <patches@lists.linux.dev>; Mon,  8 May 2023 22:46:07 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6439f186366so2750044b3a.2
        for <patches@lists.linux.dev>; Mon, 08 May 2023 15:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683585966; x=1686177966;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xLLOYAC59DVDjop+l8KkOqRs2bxgq3yUahEerwyPg5E=;
        b=VNkz/3aOv9WVtmwmwomnoKeAd5gQ+PTtWKmS3L8DFTSBDiQbxPcJ9aZ0SnoPVo5s01
         LFFwsNr2vcry7J8U12M2PHY6ZeferZ+j90KvH/I1Cn9Cgz/YHkoYkCj+cw0pOJZgErfT
         lQ9vtS2gDS8Lc9H1WxK/x7RVmCaJdcQUY03iJdM/mjNF40Lt2Y0iiTDovvg4eiGZI9zf
         n9QEjsFEQKephG2c4GUgs/HsBOb19EOIyYUT9k0J0ziE+Dh/t7KUlMHgcrI/mlYuChaU
         HoeEyFkDuRJRoO2EFh4og7pI3ueQ84HGo8H6CyrHUyllLvKe2BQEMAdzskCr4Y/nA+0J
         B9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683585966; x=1686177966;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xLLOYAC59DVDjop+l8KkOqRs2bxgq3yUahEerwyPg5E=;
        b=bZrbRdZ+bySFPS/uWnsIgslbfBUZjVR+nEikxhBhpA8fwQrGXYhn7boEO0VCeorbES
         yeHpESWD2HP1Kc/JQFGt5fsqW9KtScIpHS8A2pmu6nykkxlFHb1szSYdsoA0rasSJTQr
         yAH/GP0USfYkaF4cBCB1npiR0krhmYGFcWtXAP19zeTwk//zcyopHMh+uPiP2Zw7g7X0
         zz/dfIuRbeoBfk+ZRWCn1IZr870Ibmg7HNpJ1dQOmU4gG2+j5ThhEoWe8xqNWZki4Qg5
         kkQpkxlseEylFJwL8fJNXzUOy6am1pBvi796jQ8jEDFfdn5Sn3/1ePnPukhw296SpTn0
         79lg==
X-Gm-Message-State: AC+VfDyfgdE3HJ17atRjQI2AzYxcWZ9ZPpgVdrTC5YI6LF9Bh+jwhSnZ
	0VzlCmE31vkt6p/nt5JFX7Q=
X-Google-Smtp-Source: ACHHUZ6J3OcCBI0a+wEEdU6vdhErzLEbzra+/IDwat6zq0aX1ZuuzWP24krl79t/Dkonrtt/rOaOmg==
X-Received: by 2002:a05:6a00:1343:b0:646:c30d:e9c2 with SMTP id k3-20020a056a00134300b00646c30de9c2mr1820404pfu.28.1683585966469;
        Mon, 08 May 2023 15:46:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q15-20020a62e10f000000b0062ddaa823bfsm422358pfh.185.2023.05.08.15.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 15:46:05 -0700 (PDT)
Message-ID: <0ab5fa02-c2cf-fe09-8825-a25493f6e358@gmail.com>
Date: Mon, 8 May 2023 15:46:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Pierre Gondois <pierre.gondois@arm.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230508094432.603705160@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 02:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We also need to bring in this patch from upstream:

3522340199cc060b70f0094e3039bdb43c3f6ee1 ("arch_topology: Remove early 
cacheinfo error message if -ENOENT") otherwise we will be spitting out 
the "Early cacheinfo failed, ret = " messages on boot.

Thanks!
-- 
Florian

