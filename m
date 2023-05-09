Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACFC14A8D
	for <patches@lists.linux.dev>; Tue,  9 May 2023 18:58:02 +0000 (UTC)
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7577a91cfd6so148041485a.3
        for <patches@lists.linux.dev>; Tue, 09 May 2023 11:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683658682; x=1686250682;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8V0E9Malroc1TAAMIhSlx3NR6ZiF6osX3Y+HgRDRWIU=;
        b=EKdXpy+TDI36sZFladBF1FqrjwDHHhsXhtm7iOmlR0wlSFsmMzWqRF1SJEJK2ttv/O
         aN+wyiybvF1K4JEE3rQc3NT2QyThbRx3hd+yrThMcQvsZ3MV51zk5Bmv5XAveuRYWY09
         r+rIs3qdFRv4nUII7YEMkXNh2Mu4QYL0w5d3cgMn52K5fhXVeR3HeMmX1sU/Yv2eExEa
         SFf2L0y54DbtpteS9gYdgbG/TL1WIZZFwFgpvRxQWbHI4id551l0G+Qshr7d5p/cjH8r
         zAuHducVa5hL8ohdaKRSWEKETYhOj+C5bLfNQC0Tm9GJxv+wt8dn3ZgtZAGYowCOsH2p
         +e7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683658682; x=1686250682;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8V0E9Malroc1TAAMIhSlx3NR6ZiF6osX3Y+HgRDRWIU=;
        b=VT2CBCaDQKWDCgvfwdFuEDWi8e6yLf8tAcFSapJmsITdX+hJyd4YGNxHJr92b8oNa2
         qLGJAfNLKILA182/gzLLvWXpN67+iq2ZH00YkIA5uDz5etWPwP8GDm4hzkzR/jVIvXr/
         fbYrSZFJJ/e9kxpzVALtiWx496HwKpMbSlaID2Pe2h7WYmp9yk+IX52xTYwCWBkwQB/M
         MC9MnMgLAXSD+DqkE2CoTeVu/yO5LJzM4UyA3vUtfN3hGQzYjknOxrx7PYWvPOJZCEBy
         Qm5BjWdrtCSD/NZTsR34y74oYxXHCYV+U+oaAVdDxOg2wSoPCqYVyylR5xtHtqXc23iv
         j1RA==
X-Gm-Message-State: AC+VfDyokzh6OP5z4/9fK4U148E/fo+BJyNQptbcKRlGh2cwuogB2W5m
	Sf7kJah1f477n8UNzEAEvzI=
X-Google-Smtp-Source: ACHHUZ4lO26t9a0WZcv3QwzPYHouOsySIPYTsmuuRK+H5FjT9oKHesprwuGdQbezOkPDDXOQhTYPWQ==
X-Received: by 2002:a05:6214:62b:b0:621:431e:5409 with SMTP id a11-20020a056214062b00b00621431e5409mr3646779qvx.16.1683658681904;
        Tue, 09 May 2023 11:58:01 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id jy13-20020a0562142b4d00b005dd8b9345dbsm955831qvb.115.2023.05.09.11.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 11:57:59 -0700 (PDT)
Message-ID: <858f43fb-65b1-3b75-129b-ad8fc3d6bb15@gmail.com>
Date: Tue, 9 May 2023 11:57:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230509030705.399628514@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230509030705.399628514@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 20:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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

