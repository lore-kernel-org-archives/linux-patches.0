Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF24A77659
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjgtsVDG"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7b05e65e784so47492639f.1
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 08:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1702397646; x=1703002446; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5bmlfvvZM9RQjnrj4u41EYEYF+Fr4h87K1fw5d/6M30=;
        b=ZjgtsVDGTrC7EMVnIMgIdzg6JYNOUypsxe7PCko/n0SVGetGedjCGcL8f0OS8db4Mk
         XLA9pxxULZGCVNOkBHEp8IY1H928iEt20plLTPb/BkpvXQ9ydxYiiZ11rV+dSFTVUBK7
         eOu9QrIhcgjnOgF6QEBsCtYckKxw88m8j0GVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702397646; x=1703002446;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5bmlfvvZM9RQjnrj4u41EYEYF+Fr4h87K1fw5d/6M30=;
        b=MNE5HSCtxKxurm9Owx6edfETozMtY2O+bAp7OGEQ/C8O/6pWGobRFdWo9YYYHgns8l
         yufpMTekk5YufozhgM5LvgPZgL5tc48Jz6kM/uJg/1HRtBHPBnORNobxnH8rx+GfBvpk
         cK0E2Qgc+HY+HSfD5IDk2kU7C8uaQUNG/sLt1iR+XPln2sRYPSFoqR89c1cKeRd2FFuD
         ATzLxWWOg5wzrz1+6cq3ZkUVwWvot95qHukQ+GyO5Gr8gBVc+J8qlqlcvYvvn9/KrGu/
         4je6URJ1GhEnFdlMrKQwljQjWg68J/d/il7HnnHWe8NNcXIOlnXdGXtsm+vsu1fgNSfP
         HnXg==
X-Gm-Message-State: AOJu0YxSGLPLsWFaaXmZuWs623mZuwO7h0psYsFIi4A93JEefZGC0crb
	Mt9sep/aQkNnDWShCXns40i0Ig==
X-Google-Smtp-Source: AGHT+IHaG0x3XF1wweqZpO03xiSwEpRTZvLSUofRfC9gC3CFjErlqRHWOrCssJBqgyeHMnjz9O0VLg==
X-Received: by 2002:a05:6602:254e:b0:7b7:3ba4:8949 with SMTP id cg14-20020a056602254e00b007b73ba48949mr7121414iob.2.1702397646086;
        Tue, 12 Dec 2023 08:14:06 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id t1-20020a6b5f01000000b007a6816de789sm3012606iob.48.2023.12.12.08.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 08:14:05 -0800 (PST)
Message-ID: <734382b8-9858-4c56-8c66-25d140807dc7@linuxfoundation.org>
Date: Tue, 12 Dec 2023 09:14:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/55] 4.19.302-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231211182012.263036284@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231211182012.263036284@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 11:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.302 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.302-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
