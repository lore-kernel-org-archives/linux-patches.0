Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D506A954
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 23:05:23 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id r19so4881164ilj.6
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 16:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1680563122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wXRkIAwOhh0DOERhIHsGnDuRshRJI4hCQwRzFdUHWdM=;
        b=HRpsXW1tkv3ps98LKNcUhkLE2CVELOFCRA+/OtzmgWal/v1xQiVRuCaL/14LZzQak/
         OpVv1PA6ELtL5o52hZ4aa+XgH5LXFllsS1/wgOXDSoFcv2MF2qlx4L9gDe9Et7bHUGot
         UYqqTJYmZdNainnjFjf9aoxihwP268RaUKMug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680563122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wXRkIAwOhh0DOERhIHsGnDuRshRJI4hCQwRzFdUHWdM=;
        b=rZUtlOFoaf0JeTwCLWFniU3N7eNIFhv3qcQ9YLowLIxxyl71SZcMWM4WZLpQ/1vqT5
         QR5UXKM5lquntlv+F+zoD00uSVEe0KJa1CMCQpjt775Z8jvlDNbcCIgTsOsILS40UEnR
         U4cB3nKro5pzu7uwkJD/XuugJ971u7SVoLMB/gHUd2g3p1Up8R4s4d+givXctOxWVMdX
         3D8f9BSM3oRRqQofv4dhtuphVx3V9iJ5cKdzmHuuyDO27QxkWig9qeGDNoD6lhP2C2Lj
         zFnOTbtw+vlGIm+YQo7Kq0MAw0vL6WOU5jllCFjRLtgGkV1wT4zZCOXCRgCNyYC8IJ3o
         8cFw==
X-Gm-Message-State: AAQBX9cRqyVprWcPo1QnNAyXa2WYM+U62sdjXTeU3+7w7BxQrW1aZBQ4
	MAbyv8p2+rrBI2eagw0C/UxMOQ==
X-Google-Smtp-Source: AKy350anHs0avJWNmXs7CgV6UZeVLq+7pE418WRtr/9WgLNknu0x79yhjkx+G16XMpzZOC9WXpjIQA==
X-Received: by 2002:a92:7108:0:b0:323:504:cff6 with SMTP id m8-20020a927108000000b003230504cff6mr419783ilc.3.1680563122567;
        Mon, 03 Apr 2023 16:05:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ch24-20020a0566383e9800b003a958f51423sm2945082jab.167.2023.04.03.16.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 16:05:22 -0700 (PDT)
Message-ID: <646952b1-4d52-dc5b-6e8f-83ca6c99ee13@linuxfoundation.org>
Date: Mon, 3 Apr 2023 17:05:21 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.4 000/104] 5.4.240-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/23 08:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.240 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.240-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
