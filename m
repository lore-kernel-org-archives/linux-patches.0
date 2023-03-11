Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B1B7B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 19:04:37 +0000 (UTC)
Received: by mail-qt1-f169.google.com with SMTP id y10so9387706qtj.2
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 11:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678561476;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fnvGap3bZNSv+sB+kLpIELEU6ix0YkzCIcb65Gg4LUc=;
        b=CyNQ3xGcn2or2jno/8rbuV8XXVK8RbZAnnUdTtSR7FjCl3V5szrjhI377Pz4Wtew4K
         4S0Ij+MX45gWCiJvErBSLZ/X/+W4VWm2x+pSBfwsE1K2fnRp/6xdHzJitGpMtgkw1Rk0
         N35zZ/sADLGn1/9PBLVxA66Sij5zKidQvBvXpKHciJqA7VPC8rgoQMk9BwXEpxNSRmXm
         dsNZgum/2DdMQRAVS3SBF+Toi5MFDY21KBi+dFzkGlWcRtHrs2yOZONNk7d9mTka3JsD
         QfhWWGzUOjsVY8hzQ++7nSc+uShJ9onbCaLRIk8pd/npscPZEZcQ0FY24KgnfacRBh3T
         ao6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678561476;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fnvGap3bZNSv+sB+kLpIELEU6ix0YkzCIcb65Gg4LUc=;
        b=nIfokq3ef0dJ2JjG+LcHiBbqB3/egWVabs4LlAkkiRI5/q+Z0Y1TMHeGiPiz2ajaxL
         M5Lgoci+5Rrg5M7p0Cj0ImXZbJSWn1VaFbQmToYenS9iaMjlSr/+2Up0FdaKmVmHBZPT
         ZtU/sHwP4Y7krjm5/TrhRkqTuwrV70acdulV8HYoQV1nY4x1q2FQSUjphhlKt5Pwee7e
         8rWE2FtUb3dZasUSdpjUPfid+RiZXV1/aYGsrT7HucQCRvoh2EqB1nNeKUHXu+qbTEu2
         FF6Z6WTAWhrcMq9NWbRGyZ2hoF7IcrB1hddIvwpS5jYx8Lc70NpK04UXjj7PSPzWb0dD
         +pVg==
X-Gm-Message-State: AO0yUKUFNHGBiO4Q7PrhbFbypP2PFaeHt5EXqOBUmCn362jmY3NON6Ov
	oIp3uqauJm8/8w+U9L+SG10=
X-Google-Smtp-Source: AK7set8my+8yHmODiFJavWlaRUMaP4V/y7Lvl5C5GdCXGtsBwwK8FifsiEJyI3bfRd8vps8E8+zVsA==
X-Received: by 2002:a05:622a:281:b0:3b9:bc8c:c215 with SMTP id z1-20020a05622a028100b003b9bc8cc215mr9101123qtw.32.1678561476017;
        Sat, 11 Mar 2023 11:04:36 -0800 (PST)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id e21-20020ac85995000000b003bfc2d5ddb7sm2340297qte.73.2023.03.11.11.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 11:04:35 -0800 (PST)
Message-ID: <fc5a38a8-60b3-62d5-95cd-6b1500f3f122@gmail.com>
Date: Sat, 11 Mar 2023 11:04:32 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 000/528] 5.10.173-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230311091908.975813595@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230311091908.975813595@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/11/2023 1:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 528 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Mar 2023 09:17:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.173-rc2.gz
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
