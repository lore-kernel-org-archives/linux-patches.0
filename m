Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47EC746A
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 19:23:41 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id cl23-20020a17090af69700b0022c745bfdc3so5532236pjb.3
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 11:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ituez93tXiPISb8QxsJuaj50hV2g6GXvJqV6M4Cvo9I=;
        b=ojDTbg1ZpHomHEeNlJBCU78XmRk0cHtwOWVdFQilsoYzfR/FEgA+igDdr5rDKzsKRA
         IEOswJR5bYhQA3S4x6bLoO+4oNessN2mA93BTBLJ5CAsL8pCxNtSMhrfuM3z7crXlsn2
         dNnQ/3QJRHTqa9U30LKkFLUtUPIwhmvV61SN6HrxGOywkYszV1eONTCyAWn6xNUixHpN
         n40RzaRHFQqGNXjoPpx0ry4zPOgy7BbhNuRddC+f5xYAhyd4gkDH4sTgG7WvWGdBhzMj
         ue36SSxc0GCdWET8GdK9y7aPfJYqnQ72QUn0v0zvF1RvveI7IbFRJIVz1LQ0+5zBX6s8
         Z1PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ituez93tXiPISb8QxsJuaj50hV2g6GXvJqV6M4Cvo9I=;
        b=tIMIzNRRgCMhwny1c/PdpN9hGE2Zy/nTX7iOcFi3wG+IfAMJjmFFyrVM6rFs+aheMq
         quT3AH33hOxAll4YjymzCeMnSMe+IMSjXQlhIHbqiOanBGhq5tg7kJzrbzCj3BFT6IVL
         P2TH9fgsFRocy3wvEO+2wRFiaSGo4V0NqYtYyVYwfI10o2intEcfknnPkSqynSCxX/6I
         bMtQ/knws2NUNmINoITu+CXbsVwNf5xYb8pDgBJqQpMdO2pEYk1RCzVXTVoSjBgJK7sD
         q0g5mMm2oc9ewVol6bkaF42EXScII30v3zvl1IopEo5XxejshEbcMCrT8anu9KTSu7Zg
         s9CA==
X-Gm-Message-State: AO0yUKVY0iHGu3ilzIERMDCbGJDgmiCTGp1ENiTHVrG7YCawH/bTCHt1
	ys64sNhD1o+oM5n2u2Ob0QY=
X-Google-Smtp-Source: AK7set9IzBJytj1bxn9fO8Ny04tdwbCymt2l5GwbitOTn5A41npF9H3kqxZtOvP2B0wgVMNXttIlMg==
X-Received: by 2002:a17:902:e2cb:b0:196:357f:9382 with SMTP id l11-20020a170902e2cb00b00196357f9382mr7427034plc.24.1675106621023;
        Mon, 30 Jan 2023 11:23:41 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b8-20020a170902a9c800b001967cfc81a0sm3093654plr.287.2023.01.30.11.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 11:23:40 -0800 (PST)
Message-ID: <1f046722-dcaf-5775-7c12-2d604e69e528@gmail.com>
Date: Mon, 30 Jan 2023 11:23:38 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230130134336.532886729@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/23 05:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
--
Florian

