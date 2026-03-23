Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C091C3E0C6B
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 20:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774298989; cv=none; b=dYYZKCw6t+p1FHAoNhY9/0wWLcqjq/hnKk24O/iZZig5t7CK1TZcOfHBvp6X48N/fq28JONmkSD6JkrNClm9eSSZCfhO5aJ0szA4/eb+2j9aauXY89CIEPulO+TxkyRVhCTu54oVkGfG9Po3k8Tfnn8vBaQ1wCWyh1a1beWbbBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774298989; c=relaxed/simple;
	bh=auYP9MYJSyjhBF1N6WFP+akNUhkZr9dHIIxbAvkDctM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FF7tNr7LcdPaf/kQpA4Peg6eF9j4ayGR1WRnlRRk3XSrLrABAb8HbVIHuLjfI11CKZWy++EFFmMdf5mEhYEsU+DsE0YazSzIj81+/3h8YwCN8lCDxWk9Q45y18HwykT6zu3Un3DBMcsbnptkfZ3GHi+vxl9fFsbugm5lOQkDWI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TLT9iDGz; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TLT9iDGz"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-12732165d1eso956352c88.1
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 13:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774298985; x=1774903785; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i3HLWnZfbLleA1cQWw+AwRBY910esrohV/DArv1HLfU=;
        b=TLT9iDGznSfuSZ3AiR//01VTkYPXCZXRv2YaISKAiNjEN62HlOQRJA6eLwPmyuMB6v
         1MBUWT2lR6rCfXYQkrB3Xv3nojp5+9oeLxElA95g8+YZHF8vCe+IIH+N5/AEWM5SycYN
         MHhP+fZ7XgSvuJVCfE2DJNZVKtEneLH9Zv1l8I1GE4yRIoaCNbTnsglZOMQPSDnYyJ1/
         c8K3Ca+oJhYPm6ZCODW8hshdTr7sV+iqe+iqYCvjHnsNBa2OJVga6XKo3euayBB8r9Qe
         PJga+kptHmpUlWHMmf4duh/NQKk5Hw/rqJDvTDkK1PjVTQ+ffyXYXi0zAoBMsh//sJoO
         CrCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774298985; x=1774903785;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i3HLWnZfbLleA1cQWw+AwRBY910esrohV/DArv1HLfU=;
        b=Cx1+zqWNMhokkXcd9ecuf4wiDzN1LsCgInEJTQtbqCuqRRYKj39mg2fad28jpfrWWU
         Mk/zfNPjiZkgklPZpwrAeSAaL44zqiHM0vtj5Ty/My9HHv268uGmX8xW5NFwgXyrDQJp
         2teSJxAPyd3SVrdQsTaREHCa+GjC64yjlpgNtwka8Sz/oHaJZxIa21sip2eooVhrnxNo
         59j9DvvwV6qijATiLKspO6dXcLkG8DXnmLSM8f8OWE/3Iiyb5fGoAoIyRd9s1Clinks/
         yY86y7xo40wzjTSjR0l8+f88P1PIF94JpbtDNtKVsPv8Gddn9xJlBVLIoAx1CgW3bZq4
         HNxg==
X-Gm-Message-State: AOJu0YzGcWZg2FkhyPmbVSm/sAZXJks+tpIdXWsnmZX6wEMm2XNq2daF
	D5gkPfOLHSQXRDYV9mxkusiseSyypIcnuavu2cBht734tXXqMLv+ffb9
X-Gm-Gg: ATEYQzwu/DGbu0+ygwxKMUCpEf82Vj+8sXpTwUrO7+/Rzy3mpqTXennfk2uXdxTXqnI
	ZvFar7mJh1s+l9GbOC3YBoTiyQkdiffk0bf/X0p5pMk0azhfmXY5SLYJJcwL8scefar4RIDqxnk
	lFacueaBK7EQJLFldcjX6sAFzCHwXAaPwu8svog7VQyuNiG3Z90Sopk9iBDnMa9cxBHXIUVSbWc
	PvkiOt2lrZUsiLnFEpLd6Kr84j4GKhUDiMPSBbFVaaACEb9QeuReI8KDTR2yL6dnavjNsuYuB4C
	AbX0htgx0wE4CK1JJ54cEFXFa5gw689lWhMC2NLbMtkB2LGHVIAkXXBAFc6ZprrNSxW8NZidBpO
	kuDISP9jIcCp2ifPCo3mYLbmUbRAT9FV+rAFR8vtRcsUqJ/bCYVdXA/SUni1q6bltnE0beTQ/FF
	gccAr/eDEmzy4v2yJStuO7aIoG9PCgaOfY1JxvvlNbwlASlzT5ew==
X-Received: by 2002:a05:7022:ec9:b0:119:e56b:98a0 with SMTP id a92af1059eb24-12a7263dd7fmr6366754c88.7.1774298984563;
        Mon, 23 Mar 2026 13:49:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12a733fe80esm12185190c88.7.2026.03.23.13.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 13:49:43 -0700 (PDT)
Message-ID: <e3907e0e-16e7-417f-a1fb-50f7fc87e610@gmail.com>
Date: Mon, 23 Mar 2026 13:49:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/212] 6.18.20-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260323134503.770111826@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 06:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.20 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
