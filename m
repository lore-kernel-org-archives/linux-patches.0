Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5649D1428B
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 22:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJPG18Kd"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7a24c86aae3so64926739f.0
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 15:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1696891746; x=1697496546; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MD4vOLEn+ODCKC4aNr/ZHy2GXrVIqzwTElTE2Jci6B4=;
        b=FJPG18KdSAcQsORBthsJ7qW4TkYNKhnwbNx2E0is2tet0y0O0D7FYMdWMXOQcdJ8S7
         7Y4BljApCce1K12yfDk+blkob7YW6KXxjqfOAjEcNrmnQAjhiFN3GSp5vKdFHF1cOmih
         1ogdCHbKd0e/L6YX21lUIcDl2aabndMI6YXwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696891746; x=1697496546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MD4vOLEn+ODCKC4aNr/ZHy2GXrVIqzwTElTE2Jci6B4=;
        b=VG1leG946s/Ei9LFv4vWMF82qqTdikZoev+po12hclKSA1AmAc2q36JOM1dzSMDhhm
         e+NPDdCq9BKZzwvWUKdNCMf0bGvSR1A/dYwQGeeFIrV/tAO17F0+RNEuscTskrQIEz40
         4fwUz0iKg+8A5RDA5SrVGPcm3saFTuJ8Vv0hV+60l4Q5RC2G/JQRgGndz+V1i+NX6QOB
         NWTkyclry/HWDwUZ1KnJ7xv+37+vxJmoM07nLUY8lQj6JeipdWONDsgFxUVVVHyBu5eB
         6P00gk4f5k1LSgFlQcrK2SbRg9m2ODFL47bTu3U2zs47evm3GmkQBFg3k0FAAKdz/dsZ
         9LHw==
X-Gm-Message-State: AOJu0YzIvavPse9s/kiDqMdKL/YyWq0e1YVnHkfKtK1+CydHN0Z2i/58
	XonpR0lu12N9on+2PcLxtIlgwA==
X-Google-Smtp-Source: AGHT+IGLHs++IFJz8wlEpI8qgfbggIA6BhZ2M0hqNsP9yD+fAKnhBOBLIGGd5dJqyph0EZxYxePapQ==
X-Received: by 2002:a05:6602:140c:b0:79f:a8c2:290d with SMTP id t12-20020a056602140c00b0079fa8c2290dmr22053272iov.0.1696891746444;
        Mon, 09 Oct 2023 15:49:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q6-20020a02a306000000b004290985a1efsm2344564jai.43.2023.10.09.15.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 15:49:06 -0700 (PDT)
Message-ID: <92b78aaa-1ea6-4040-ab81-e30a8980fcf9@linuxfoundation.org>
Date: Mon, 9 Oct 2023 16:49:05 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/162] 6.1.57-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/23 06:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.57 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.57-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

