Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166CE8462
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 23:05:25 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-666e64e97e2so3747333b3a.1
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 16:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690326325; x=1690931125;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5+Rj5HE+U7eILrOCnywUgryQcn05XBMLVDPwImnu2yQ=;
        b=fdLyJVPOR/Q7tVlvJo9S4VR7dGrlRV+GhT9Tia9yYAq+3mpyNrJ42gC7S34jT8qQIh
         nSEuAvM9051/3Vj1Z7Tl+qFsp41VWqUylatlnrcdsQ8F+n2aoPv7f0bha4ZDy6HeJ18t
         4YFIm5JXkn0nFRbJWowSE1aRhwOcgTQFPDibwfFffEovnBMuKcxIuHYaCt08oUoO9kfn
         ZytoPsiBND2zT05LtikjbUpq+OrEVUqZp4tPwHhBlL4M3fq7H7xVGffFJQfrcy67SXAs
         QzjO5sjRRGj1Y6K91mpcj670616djZ9e5Pq3MzrNaN8HGWJ4JQHM6BUoqauwdGgPWk6m
         I/ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690326325; x=1690931125;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5+Rj5HE+U7eILrOCnywUgryQcn05XBMLVDPwImnu2yQ=;
        b=aKkHtEbDGNUQvz0Vxdo1LSJ6es3d9TSrNb6RKRAIR6XY6LEjUv8JRbGDOf0+aTCEL8
         JwACuMIlg6RZG2Suz5wRjmwA/EPp8sEl0w3/6An4JE+8vYjAUpgzcADNARrnsVX98npc
         evxDLbcPJUOWUpr2ieckc6sIrStUNfpL7l97bnEboaO9gD5G5YzUZtg+9nxjHAX7QcIH
         xKjXL82l6L+xSVFh0p0dR/sBpY9jE6fo/nyijbPGNvCC/Azv7WAQwt/MaGgmJhOyHq0S
         XKF4ZwWqIzCAZDFum10/Mex5zj8LUn+kfwGp7lnkQ7+VcklBugtAlLr5l4Pr9UI1pe1E
         vDkw==
X-Gm-Message-State: ABy/qLbrUE0DKcT3xB6xAmI6CopYIpaAWRgNitNlNEzHsARDuXGq6MHB
	8dzIShRN3/nN7DacynqfLjs=
X-Google-Smtp-Source: APBJJlHi3dgidEaSE0dFIGHL5Now0nZ4TpUmbeH8G3nq5VuJfWmw5hdmCqVsCKwY6/udTT+GDgUapQ==
X-Received: by 2002:a05:6a20:9697:b0:133:ec83:598 with SMTP id hp23-20020a056a20969700b00133ec830598mr308514pzc.28.1690326325180;
        Tue, 25 Jul 2023 16:05:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c16-20020aa78810000000b006828ee9fdaesm10082027pfo.127.2023.07.25.16.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 16:05:24 -0700 (PDT)
Message-ID: <19226f61-7e47-eaab-f463-50b88ae1f2f0@gmail.com>
Date: Tue, 25 Jul 2023 16:05:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 000/227] 6.4.7-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230725104514.821564989@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/23 03:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.7 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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

