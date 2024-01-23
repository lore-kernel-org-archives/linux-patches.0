Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFDA537E4
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 22:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706050227; cv=none; b=fKZ/ql1cSUZyuR4eh5P7+mBtZ/BNxMZlFuHd3fq3451mnHXfPGBeO+heYAugoxjM8O8f0XtmeCjA8GvNvvDsWv6/mrV6NbDmtoERygtDe2hkyeSHWfgqKUaCXAIYODNAUSpCxh94XyzVVokWbZxBEQADmV6KSXG8ek4/3vfTDgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706050227; c=relaxed/simple;
	bh=zA8h2hgvGIm7xCc7pkw2uK7so5TYfseQahtnnzFpgFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X58hGNVOFYdcHob8YCZ3NyII0ncZcH4rjAuiChyoRfbVFdgaSUjBOwlIZ3wbX8/K+4Fsb5Le8wSKF7eLYcSkSfSLbo14NFY0jgEfJ8upjYBskyHw2KqpFyMzqUB6vjxWpVYMwpsJY83+wjdbwL2sn+jV2D/uypNM2i/0nVV/PRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XPmB67Xh; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XPmB67Xh"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-42a49d42d17so10051071cf.1
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 14:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706050225; x=1706655025; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=70lzYBb2kXF1e/6clrMDT/m2Y9gDx8gUW5Ok8l0+bHs=;
        b=XPmB67Xhh6Gc1G8QKas/IE9Mh4qYco/aVI00v7ODE3ePG+v8vWpRfY9Mm2uRwFWVFS
         /A6GeqtRny4wozRbsrMRlaVZOWXhxf6B8JxU5mRVsGkrZ3onAf1ISybWr7W0b1yJDAPe
         pSKPthmkepnqIy96Ug7ek9FKDQiX/isoRoUjD4JPPb5llI4MdeDC9ityKrLGklDISnLe
         pbLYXu2vZ8OMKVzShEVhSzf8McYLgd3bMJu+4lEZ/5A2//DxIkqfgnlobcaeaanIeWUL
         rMnPj5tlrY7HZ5nqOEepfwmooISQYG9hactYZrTA0wZn2en9kcF0G9akuH6mssyavBAA
         iMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706050225; x=1706655025;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=70lzYBb2kXF1e/6clrMDT/m2Y9gDx8gUW5Ok8l0+bHs=;
        b=KCh72qJHOCCx71+aOgRQYf2Gc9MBbAOVucrQowmFT4zfMeroYSrWrIxpQXjw2P8gKz
         AaUClcHKVsb9TvVtoKknZgEZyY9dG02EnuE+Y+aSpC6BtZ0vv4L38Q/pAfkvYCPQExed
         T9qwnQ0jYdiHYPvyhw0k0k14pX7X0CVdKjDz8EzMsaa0PaUBwKs5Ze+asFF+7DmCjWsa
         FizKl1uGXfur6mE0c5DkwJbCTN6ddbOW33UYkitlzz+tHOlNSBuCZxId6sZWSI3g+6eZ
         ukx1Z/FO4sciCsY08vaq7y9mK8TBVfs41Pyco696Y29Zhg6OORRIxJaDmiOumBUx87nM
         203g==
X-Gm-Message-State: AOJu0YzBsIf2kSCH5F71KbwBTHBVRcUuz6JLaYvGe00NouKZUHpadAtJ
	+i0i3k4/nkW9y8oYOQgUR40sqxYgJEHJ1q/xwiZGALP+06BKVG8E
X-Google-Smtp-Source: AGHT+IHsqpQPGlTs+KXEhp1WVTBfD8OW9Rc1aNAYsdwz/JyF964LUi/EdJcqSpaYwrgcNJ/UU8e1nw==
X-Received: by 2002:ac8:7e8d:0:b0:429:bfca:bed0 with SMTP id w13-20020ac87e8d000000b00429bfcabed0mr1489145qtj.137.1706050224679;
        Tue, 23 Jan 2024 14:50:24 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bp44-20020a05622a1bac00b004299f09e3aesm3863091qtb.51.2024.01.23.14.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 14:50:24 -0800 (PST)
Message-ID: <840d1ee4-6ee2-4fb3-a604-cf25ab83d9fe@gmail.com>
Date: Tue, 23 Jan 2024 14:50:21 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/414] 6.1.75-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240123174510.372863442@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240123174510.372863442@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/24 09:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.75 release.
> There are 414 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jan 2024 17:44:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.75-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

