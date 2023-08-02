Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C7E10947
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 23:00:28 +0000 (UTC)
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-63f4f75b3a7so1907966d6.2
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 16:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691017227; x=1691622027;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LxADmvrlLWmDyCAfvF5yFmWfrqeRu+A61EMrjZsBdpU=;
        b=MCTvs2WU0T65ZORgtIgfJ87PCli+WTdroZQHVcG4PCHRDJaFXjywFGlYS9Btx4uBn4
         2IliSatuleFIQ6L6o+MPmzZtXLk/+8v1l0xJK9xmEmMyW1xO+fdznksEsfvUiyzCkKdA
         mb8A3A6Zddk9MVpou1oCuqs5DcgxO4Ol4iOWZdNglz9Gbx6r/Yy6FZoZ1zxQoio9aKe3
         XnFXeJVAH6Bu6aDgr1JwZ9s2cNN5r5Dy4uplFwA/ZSiuMU7aw2aH9NO1D/Koh0GZ3U4x
         2x0oP3Y5PT7sDh+qmorH0yuws2CQ2QQulz93ovGs2K7tJX/VHUzyxS2YLqHXhtMRBxB0
         lVYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691017227; x=1691622027;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LxADmvrlLWmDyCAfvF5yFmWfrqeRu+A61EMrjZsBdpU=;
        b=IJt32d4hWo5v7uvHJZBbHZRE47eTdRzE1jEqUec5P5qWyktG8icu6DqV4C9y3yzKM8
         PjybitfWWr1EZau74hJfQdyIWG6G495sAQzZvMknRGv9Kiohd94BRzdXgpcC16fBBPuf
         Ij3WEpg3jHPz6ZST+/e569NvYDDTOKSnv3dmWnQrx6HAaVubC9jlARYMiI1wYinCNtCN
         NkgJAzkybXfjd+T3v699bkhPT+hH+A24J1WSDeZpu4BHcdpalV37y8S5RGGsTv+fOB6W
         MS4eCcQj1cp+hQv4ppYXNa8uKDaXe5yU1m99+U1TM0WtjYPaPimObOZINxbnZ7DcPUkQ
         UFCQ==
X-Gm-Message-State: ABy/qLYz/6MMH9Nwp5v4cxthcilYUQ2o92N45lYeXLy9Ecyx1Kl0ORie
	S6nw/SamRR8vdL8YwUZR3B4=
X-Google-Smtp-Source: APBJJlHK7nE7o0Ajw+MONwVK5MWQ4wAv41//AS/uvZj9o4BsInIdqPWTGQ0NHbYfN5uvF3OssOdDTQ==
X-Received: by 2002:a0c:de0e:0:b0:634:cdae:9931 with SMTP id t14-20020a0cde0e000000b00634cdae9931mr15395990qvk.0.1691017227366;
        Wed, 02 Aug 2023 16:00:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n16-20020a0ce550000000b0063d585225e0sm4275868qvm.61.2023.08.02.16.00.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Aug 2023 16:00:26 -0700 (PDT)
Message-ID: <671b5b2c-1913-3693-296a-844abf5852a2@gmail.com>
Date: Wed, 2 Aug 2023 16:00:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/225] 6.1.43-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230802065510.869511253@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230802065510.869511253@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/2/23 00:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.43 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Aug 2023 06:54:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.43-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

