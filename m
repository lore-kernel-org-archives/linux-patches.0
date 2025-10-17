Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9433126D5
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 22:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760741880; cv=none; b=QNTLx3qirZrqksqKhKbRqcbCHTJx50DDyxS8MIG0TI+xtxvhQhijF3oCzyvqkoXWd8M8jvBLF4kCzu0WaM8sh0pTlme1mkKV7cDZ/GH+N69usnw4d2NgHoctUJZB5YDiYH+sBEkUuTuysvG+gYyEdaxrK5CCVUDcTqCiX4nKny8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760741880; c=relaxed/simple;
	bh=TVTG+O8iKJqOlsONKOctFtR5vUb2qk74Xxw1eeL6LKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s12BAdOuA0jEnQQh1siBOORiL4FPznb+kSO67mfXCS3CoA9cZy3kSMIHXrqIiMkSxbr+4xVyot7FtqpJlH+OnSgjisRl1hHBTi19Efy3xVSM4pSQ9R85DBTUDTT9TWL05VU2JVPSXqlIul/IXtdJJRpBwyxGV2KtQRiLi/Z7Xzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T3/FREhu; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T3/FREhu"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8738c6fdbe8so37972186d6.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 15:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760741878; x=1761346678; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pucK7w/tDLEJVDkMQTugbZEqJtDfp6Kr9NZGNFPGjzE=;
        b=T3/FREhuXyBXEGdQeKMS5fjZicUju6H8c+zJn3r20XKVVPhFBqy6uK7tFIxHQzRIhf
         sHBkm6GbyFSSJNH+579TnaunuhIqL8HzPH9667Z21JlfhUh7HgjomlojTJu5DD9ifleN
         cujswbMW0b/tSU4cVsDyh/j51E8uRuINpQ3TaMEFWOUitXQjhK11gdmqXN05yrJZh3V3
         H6on/m3qT1l9F3X7PX+RC1WlS0XVJ4yBeditx+ojEQ+ZNgkyvXOM53EuP2ukScAkdfYY
         WFHeFHcOqIv6gIbK2E+MZUiJmf0sF3TowSsWU3PAlHXo8eFqoWdt5yyTSYtNJiQlfzcp
         SgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760741878; x=1761346678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pucK7w/tDLEJVDkMQTugbZEqJtDfp6Kr9NZGNFPGjzE=;
        b=v79/1lyesC45nBH0nUaWZHaOo5r8Qn0vy/pQaC8E+ZRb0TrYdBhWpLe2io8Jk9JLfd
         kpRzj8uFjBJdscYZafS4MkVIErQS+NHvbb5x1YmOa2tYXURoAKjc/ixu8PtAe1jN1e26
         FwPRbD15/qXbabfcNZbioxuvz07rQ/cRHs8EeuGTb4uBDgVWAknBRzQPWV3onEBS7C27
         SCULmKgt3XbSqaM/xz3/nRzUrInaryfy+535Ezxt2O1giSngaFgMhhqzWkqBMLNPPt5s
         NMTCzhUAx+c1JyPSrsGaKu3FTv+h0X1/qM74qMixYteE2MR4mp9clS18siezTh+OYmp9
         PNBA==
X-Gm-Message-State: AOJu0YyVKXqumEoSZskHGk+qhSqJHGvYg0U155nVg5c3PNHY8v4MAMbS
	ue9MjzD2AtAvNPRsPSM75AA/Vcbhy+RiTtspLcOMe6T3uxyb08Tz8Pun
X-Gm-Gg: ASbGncsDRnI/RZdjojDm7DO+KodCMWkd3NsYjgUnUWuQ9jUTkZPlfHbq+vVbTKWSYwl
	UXO8aY9xHdUgpzCUef1Wf+KIHx3vcHQ5SCj0Jf3yJ40LZK82PDCuuw2ngA0KSHybuNLZ4O3845l
	8AgbmBWm/3nh8oB/H2G1sFadBZX6jSt6gV/q2eK/9+XmVP1yP7lyWjYPA5Yi4K91jOr7Mmjm+rM
	A9t31DGI9aBh6POso8iWvKzsR1nP1Dr7V3qMnL5yjR14ePE2ypZitbc9f/hz08bmwJZ701ia/+6
	ohW2i+h5ItGLv8HKzC0GewnWyGVdWhIQLqKMRN9k+LxrohcdWJC6ZKrqz4j2HGEGWXhfeohgkJj
	DjrPC7r7rnpXRZcWzO3HUyEUftrBesmJCMYdrGOiflw9laq24X/qeFTUnbJSh1PbWYo+508+189
	w39hLi3dhK+FNq0XJKRnItM53+w68=
X-Google-Smtp-Source: AGHT+IFtOTk+TeUWYZvFwbJ/WtL4J7f8SdXdsAQcBbwmd+vwHRetDEZvhB/XNjVaLuhKRvl+qTdF4g==
X-Received: by 2002:a05:6214:518c:b0:87c:2095:c582 with SMTP id 6a1803df08f44-87c2095cb68mr80609666d6.18.1760741877657;
        Fri, 17 Oct 2025 15:57:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87ce9d474fdsm6863656d6.0.2025.10.17.15.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 15:57:57 -0700 (PDT)
Message-ID: <c1b098d5-3499-4e24-aff9-6e5a293b4b1b@gmail.com>
Date: Fri, 17 Oct 2025 15:57:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/276] 5.15.195-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145142.382145055@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/25 07:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.195 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.195-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build on ARM, ARM64 and MIPS with:

In file included from util/arm-spe.c:37:
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/include/../../arch/arm64/include/asm/cputype.h:198:10: 
fatal error: asm/sysreg.h: No such file or directory
   198 | #include <asm/sysreg.h>
       |          ^~~~~~~~~~~~~~
compilation terminated.

I was not able to run a bisection but will attempt to do that later 
during the weekend.
-- 
Florian
