Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE4528DD2
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 19:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mPex18HB"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5aa7172bafdso2080096a12.1
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 12:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697484941; x=1698089741; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NOJxXXeBtjc0spitVwBsAGSK4WaERY8PQRMb0100h7M=;
        b=mPex18HBwuU7BChWWArKyR8TjvL7bbWeJwKyOdhC/bg75mlZnz0hLnWM+4PGT2+v+M
         ctsy07f7RD6juAszcCYoH6EcssAYNP40ix6MKnKQXFmt1xbeeLjCAMEv0/Mlfx52HZL4
         ibPegWYYSMyGwstdhLWR8kXQayniGb1VDoVIbJj+7srSGj/jn+8jF/Duxryh6jOH1yuu
         HSpsOKOu6SPz/R6vdqRxLX0asKgYpnTXdLZkdzCPkDpDyAfbqLxt4uMl5Ztq6ZbbrDxM
         B6ZSCyhFT9xd2sfTugnisoflpMR9IdcfhdLYpGK2LXJzuaNJrA1B8CzGgWAOTtW20/N/
         HNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697484941; x=1698089741;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOJxXXeBtjc0spitVwBsAGSK4WaERY8PQRMb0100h7M=;
        b=OgbseCZAA2qoS8aVcFI+6p2X8553IVkfYKhltU2lt1GdEX8bl142QawpyT9S2hNuoV
         5kum7kT5rehtwifqO/8+SIHEYnv6MuPLm4SZQGZ/SC4xkx1kro1hsxpd2Gy97j++nJKG
         LAxYrD7CXPG1TLBimh5I++X0y/jx2yj0zQwNQrN7HSGyNuladyyJqID4AcWLDgOHAsRF
         fx8vIGRrTeXd4LMJ7cdsvVXR4rdPGIFBieBFd6qrB4P4rjX/YEMAPY4hRE9jKRUP7bP+
         cmlp0WE58Dj9fSRZzOBZ6v/5199YvuTFy05Po7L80MW9P/xId2c5fqNh+czpeMWkUgEp
         N4sA==
X-Gm-Message-State: AOJu0YzEwElmWI6uKyLB106WCwg5MEHHUnJltEwBp4LUDSgqwn0jbmXW
	6P/BbwBWZTXmjdiXoW6FqSE=
X-Google-Smtp-Source: AGHT+IErO7JHvJXX9sU4QBFDKVtFr9LGVWDF8mau/ICaxo8dHwmUqFSgMuqNQN5D2vsct6Lww2q+uQ==
X-Received: by 2002:a17:90a:77c6:b0:27d:2109:6279 with SMTP id e6-20020a17090a77c600b0027d21096279mr110007pjs.12.1697484940556;
        Mon, 16 Oct 2023 12:35:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id go6-20020a17090b03c600b0026b76edd607sm5181577pjb.15.2023.10.16.12.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 12:35:39 -0700 (PDT)
Message-ID: <17ddeb79-b5c3-46b9-ab59-0f1918b8de95@gmail.com>
Date: Mon, 16 Oct 2023 12:35:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/191] 6.5.8-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231016084015.400031271@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/23 01:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.8 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Oct 2023 08:39:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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

