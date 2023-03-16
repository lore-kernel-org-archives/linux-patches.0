Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AB78F79
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 00:00:14 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id y12so107771ilq.4
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 17:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678924813;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M5n6N4Kf45DWAUdDU8gCqH2UU9H1ulFevAL57GqiUGY=;
        b=UCsuKHu2bj7zopFA1WRte9Z/MDmlBS9AsRyqRGflrYMvGJRbrjvwm0IGO87DgwM73s
         oEd7qDfvdkyKbIRz1jDBuPO6U2XwwI58LomuboMuXBU19cOONe95qY9QpiC9ua2S2q/8
         9Oel2NIJSDLVo8vGcxO3JMIpmJOQwKQSYDye0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924813;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5n6N4Kf45DWAUdDU8gCqH2UU9H1ulFevAL57GqiUGY=;
        b=VBkyPtlMAoTKwmxSC/AqSML/sGighQYT30HFo/+wjxDV783EfprcXHlauJUb0R13ps
         GfSjgOuOsXelfEnE2z75hCJMy2LvIPLvQ/EZJjC4hhGrY1gLBD8oSw4c2NW+SPEy9cn1
         NSPnmgtvUyFewAgkViAPyW3g6Ol+88JDoYndlNisl+USnOdU5ivVgOdXSi8dFdXvwdv3
         W1Sr2BCifZmhTMIRopbMb/eBD7CclopxgR9yNnP0AVCgPomuBCakgzCqZ6M/UuA5saxC
         O/9IRwcs5xFTOkkuqeV2rkkvFLSpM16qE5jon43oL65j61o3MWy6ukHVtjf9Hjo7ehcR
         oufQ==
X-Gm-Message-State: AO0yUKXhd+5XOs5+06bkCHdI/LWRTOXsFHoOXFoShiETXD+T/Ket6nZc
	IY+2VR3cv2AdXK3DRFU1rJmEdA==
X-Google-Smtp-Source: AK7set9j3X3dxYOjKgXnzMWtyyMmj4wF08Z8ZmecfQECcUg4gxKG34tkDHCOOfX6oZEObmCswOVK4w==
X-Received: by 2002:a05:6e02:1190:b0:323:504:cff6 with SMTP id y16-20020a056e02119000b003230504cff6mr521499ili.3.1678924813457;
        Wed, 15 Mar 2023 17:00:13 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y13-20020a92950d000000b003230fd0b2eesm1953198ilh.61.2023.03.15.17.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 17:00:13 -0700 (PDT)
Message-ID: <4b45cea8-5881-34af-830f-c37f000e1300@linuxfoundation.org>
Date: Wed, 15 Mar 2023 18:00:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 000/104] 5.10.175-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 06:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.175-rc1.gz
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
