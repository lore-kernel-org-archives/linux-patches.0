Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB3524F21
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 18:24:55 +0000 (UTC)
Received: by mail-qv1-f49.google.com with SMTP id o8so13047211qvw.5
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 11:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bAxK6YFmky/qIZ4/dsMrrkPwupDe2/XOhrW+jM9nuZo=;
        b=Q4TGWjjmvsV0i++UUxIoGn0BfuMSVO5ZQHAjHRTHywLrr2e/k1iovtSR3RjaM+OHmM
         bvfSrGC/0MESeNXlHe7EHVB4/SnNWwSJTU8IWzDbII0F/mlrXkoWZXlTmFav4jkQwpel
         YV0fRrR0Zo/VZHUr7aLAKLrfu3jjE1yiVMVWIv4JMTw0O8593f0SR1P5w4GfUeqXprpt
         W/2/R/+tjdxG6VSoWkivEVCvsdI9XN2Pj8EpCXnuus405Gsxs1VFy8yj0J2XXhRc0CgH
         5xpnIMA9Xs9YKrIR7Aizo7IR0wzUj7QDTZjxOCYnHARPqQ8Bgd3N3bVutG/KYzzS9q1o
         5y5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bAxK6YFmky/qIZ4/dsMrrkPwupDe2/XOhrW+jM9nuZo=;
        b=4LYvvIyMDvhMvFStKuZ1oq7xLWfNUN8TBHLpo3QjckSsawIPfNmAO6iHMbxFfttotd
         UTWwkY0JoXnscJkBmFZEilCUOCFsPQGnbHQmW/3zI++xhkGDKYm9COYu/bq6seZj8tUZ
         rMgpgyyvwHkJF7POprodQV2sWZb1JSEDRyBsVxMOSpJ0YfpBRfbmjCByN8+GhrHHn2wQ
         KsQb733gY8e8n+gQwUvGscur4pSXjbN6qtsQdt4OXCHlVQDXCP4HE7hBpj8osCwkPKAt
         H7IhvZ9vRHIR11gU4BQI+N5u/MbqtTHUuecxEhzsY4meBbUMqINARycxPgsuEkr2aHoI
         jiWQ==
X-Gm-Message-State: ACrzQf3ftEGXczcfixXXhfM6ZcFDycBOV6ShBuobUtJd//t1aiR60CpU
	ZPZuj1gEOFnMrMdHxZStuJE=
X-Google-Smtp-Source: AMsMyM7KX6sJPc7+0Yi6Aq0zfSZke1j1ZMjz81yEFb/qRLnMce6k9XhYzoHSlwpSoVCrTej1JBu3fQ==
X-Received: by 2002:ad4:5d6a:0:b0:4bb:d900:ff56 with SMTP id fn10-20020ad45d6a000000b004bbd900ff56mr19873181qvb.74.1667413494342;
        Wed, 02 Nov 2022 11:24:54 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b15-20020ac8540f000000b0039cc22a2c49sm6904548qtq.47.2022.11.02.11.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 11:24:53 -0700 (PDT)
Message-ID: <725be691-2209-72c0-8ccd-5ffae920943c@gmail.com>
Date: Wed, 2 Nov 2022 11:24:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.15 000/132] 5.15.77-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221102022059.593236470@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/22 19:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.77 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.77-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

