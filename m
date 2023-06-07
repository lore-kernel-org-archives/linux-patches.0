Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED44E3B3E0
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 23:35:14 +0000 (UTC)
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-75d528d0811so554571985a.0
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 16:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686180913; x=1688772913;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6MuL2EHf6nMwXxCCdzWfY9K5gblhiCkw94oAeq9cMRI=;
        b=Ly84wFPmRYV8DYQhiOF4FSzSB6vygUsMzGI/nn+uenyk8nlnTCjscY4gHhajJioJGU
         nY2TYCLb0qfZT/lX0oLHolL1p3mJB2SOMp/cPdYoda7wAQC9IiQ04k0EeNyg+imXUnFm
         Jc5/C5qg2LtMIpIKQ7JA6mV7q31uUcNkO41QdEC+mzSD2Xut8JeUDGb3cCVnfelgNKd1
         1CdxHZC1uyjGH9ve79j44BzJtkYDqs2p3aWHekVQgu2iXCDXozi9a3xHRYKanBPCC8tr
         gSpuNhD6xyVXBoDnlM0kErLJmo1nWsIh1651WZVVMPMe2Z2nMXrLye2FC8jbLaDVvLRV
         y/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686180913; x=1688772913;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6MuL2EHf6nMwXxCCdzWfY9K5gblhiCkw94oAeq9cMRI=;
        b=iYIhE5nf+NMaNie7+B3ZBWKEr8c+2BLo2On6zfRKcV5tbJEcVnzBc4NasQd2DV0eb2
         Ofk/yjZgKLNWkYmSMNHqOggtG2LI02MkPIi4zecvfPZhz8gPL2E5Xvq0V4d4UZ4i5Miq
         zospD7TzCcJ9ZUvJ0nKjkVBR7Ahrl7jSjK1rAQ1vcvYQHHXPmAEGoYhTW5aT6a/qm+1Z
         40Sv7/PU/4uuZInNY3emEOlOSD5lCPyVf0+3mc4CRbbVLX3rrEO6gTRHvm0CIW8G5MRc
         p4Noibw+VW1o3ArxeEMYZrf/WAFrMKxg4KqNMn9bMl5IzURUG12DSAOtB/PugeO4jpng
         zfiw==
X-Gm-Message-State: AC+VfDyyiUBKQgDJ5R47ECRVycFq7z2wRwLcxkVfLcqV6ytdaIG4Sl+p
	xGSOgM547yVgHpyGqjtKtIY=
X-Google-Smtp-Source: ACHHUZ6qQ9uHoTIKpG6b8jiUfCpdLDc90NHRJgYHmJ80fdTYoonKYafGF9O+cijkkIL8jOUwr2NHrA==
X-Received: by 2002:a05:620a:44c7:b0:75b:23a1:362f with SMTP id y7-20020a05620a44c700b0075b23a1362fmr4917119qkp.64.1686180913530;
        Wed, 07 Jun 2023 16:35:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i25-20020a05620a075900b0075b327a2988sm214819qki.133.2023.06.07.16.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 16:35:12 -0700 (PDT)
Message-ID: <35d1b011-dd43-9e85-1043-1cbd9a4e807e@gmail.com>
Date: Wed, 7 Jun 2023 16:35:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.10 000/120] 5.10.183-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230607200900.915613242@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/23 13:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.183 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.183-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tseted on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

