Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97EF7475
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 22:47:03 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso1576443pjt.0
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 14:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KyDNT2eNBKDwDp3YS++zsmDaZPh+lT+qP+XmfmgfjRU=;
        b=qGwobmmsTzDi+AcZz6YWYAE2B12GSkxeI6CkpycbgEYFQw2TYC8UNccsGr1D26F1aT
         R/0CJH5i07PemNyr4rIKf+aR71eP/JeFy06RtFunSDqRJXkUV3nGJNEvoRb296r5URAB
         akQXHYqG4U7ThdegZO3XF2/Fo13szTy1gv8PZjQER0RGpUdeEKJjxSlBj1CHFuVYJu5F
         yFlFJ3GoC7lx+Y+c75ndJ9vA8p4KGBf7dtXyCFPq4kdB8Q5w/5qqfIl/nd9EFGCEbREz
         EWW+AzgCWYm6nCmIj5i+IoCII9jVQdcJdha2DVxFQtFUjNMVxfkZBX3FzJvNKQvaatFC
         QGLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KyDNT2eNBKDwDp3YS++zsmDaZPh+lT+qP+XmfmgfjRU=;
        b=CrDILFVzq/cgFIHT+K3g6o05nr1VL7SxTIdqXuzzyzW/tuJSZPlhh9pbaIBMzW97n8
         Sw0KYY0/RdWqCV9sj6qBLCPWOEDaX9wP10gWwr5h2lzxHUvEoZ7GlbhSkfBavYzqyqO1
         iMYmptOscOFks2d4SXJ9Y7PytWiKttyeo11byh+UDSjrPmB8hdTMhCJnhM5OD47jwuAF
         hdqZa4bOd7HmtY4ZDw0qoM1tmfqQPDZqAgrSHg8Cqg+Ka5N9obeNyAhXYic8JPMKGsA1
         VPImu1vUh6CnelcHFL8d8OY6tlxOwgVx5Arj60O4kkGvtbF89okPTOeIo56jb4XmHBvf
         0AdA==
X-Gm-Message-State: ANoB5pkHD09ZzSowU/ZlHPUgvxjMBOKukD69cgNxVvu/jG2setT/xLxe
	KhO4giXKnSB++mg4ZeuAcKvIqi2JPNJoEg==
X-Google-Smtp-Source: AA0mqf7eKyi17/emc2cU4C7lquMKZa/sgyh5h0olmxOmcf2hQk2E1P6q9QNA4Bv3KTT44hAQPuvfYA==
X-Received: by 2002:a05:6a21:8cc7:b0:a2:c45f:f0fc with SMTP id ta7-20020a056a218cc700b000a2c45ff0fcmr23054714pzb.27.1670885223213;
        Mon, 12 Dec 2022 14:47:03 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e9-20020a63ae49000000b0046b1dabf9a8sm1196878pgp.70.2022.12.12.14.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:47:02 -0800 (PST)
Message-ID: <e335bee0-6042-c484-7dbe-4486c14c7ecd@gmail.com>
Date: Mon, 12 Dec 2022 14:46:56 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221212130924.863767275@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/22 05:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.159-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

