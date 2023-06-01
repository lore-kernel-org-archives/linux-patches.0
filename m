Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3C3156E2
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 20:47:37 +0000 (UTC)
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-77479a531abso13018839f.1
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 13:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1685652456; x=1688244456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jkYCXrweN4xo12j9HaIou/Xwed4BuCxxv8hy0/0Zvow=;
        b=LaJuKOtBA4jgaPUgDSjx4U/mxwv4A3B72x9AcYRIqsIvTX7qnpG+4iS9s0IVZoZ1Jy
         gh0CzeIKabQ0tMHhgoSDDp924upC7anpppMTriJQUqjfRNSDVUEiKPiLQbQaJeKUDvqe
         aNcJXkuTn4SRQOSaLaqllnt7MSnAFzuTV+/KE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685652456; x=1688244456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jkYCXrweN4xo12j9HaIou/Xwed4BuCxxv8hy0/0Zvow=;
        b=Vg05k/c1PeStRoWX3w0R8fsp6/Ya759lMo9rEat3nSuybgKMLYoNHSTPm1eL/dpw+l
         CUEfM58DWVhvBOKcIW4M9ORHdIqejUn6qygKyamWfwpf5IoFOcjSLJ0MtHfAOU5INMLy
         S5ecdZnFVdZDJbVjfEb38qplRM/GnV09xW5zo7nuA3hazQoMvkfz4X4B0BE9nRhgAb7Z
         GeDvEhzOFra3xLzsM62mX32Aw986NCG/PP/zU1IJ20511B7R4OQ0Vaf3FL4PENzvLrDz
         Xx9i/Y5lKlsylu/h57bK25hFfGagYNiNkCatih5bGk+X+X9DF/1btyK6E9KoDkVTU45o
         pX5w==
X-Gm-Message-State: AC+VfDwPFr3u32sUjgC7zLzUDpTDkyFPyhmULZJU8ZpL2JnOAN5axQEl
	Kx1tt1o5C1xZxjSL6Eb5tymv3g==
X-Google-Smtp-Source: ACHHUZ53NdItFixaXUuAIPT88TETpOTFkhhyXKBM0zlQyDnVh+KzGubZ7MnxWxm237l4NK8hdQJg1g==
X-Received: by 2002:a05:6870:9713:b0:19f:21c3:9771 with SMTP id n19-20020a056870971300b0019f21c39771mr5016111oaq.3.1685652455375;
        Thu, 01 Jun 2023 13:47:35 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s4-20020a056638258400b004161a1fbb06sm2550602jat.121.2023.06.01.13.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 13:47:34 -0700 (PDT)
Message-ID: <32d74445-883e-6a0a-f726-f259bf23098e@linuxfoundation.org>
Date: Thu, 1 Jun 2023 14:47:34 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.10 00/22] 5.10.182-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230601131933.727832920@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230601131933.727832920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 07:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.182 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.182-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
