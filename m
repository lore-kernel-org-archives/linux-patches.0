Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEA63603F7
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 21:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774299692; cv=none; b=kXlqtCsvMMjK97xRslTx8MrtrMKZLUbIrYu3peBuFggPTVqK5lBalSJFHgTg/ze31AhON3MuOFhQor0efgipS9ttfZV/fhrAX6jMz+KKZQO0w/hDVQxcD8kaa7iDKWaKUlvmbg/84XiWtgwBcF+bl644Cn87ZpQdiKnY3OE+DNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774299692; c=relaxed/simple;
	bh=1ggRSxfqVjf+Nkyd6/5CnLXPxn5r8Z7UtuC7H2J1Yi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SV0LFeyP9RnvBZai3tp59z3fDBdq6rxBDSP0/HkRk5iT4BzzjDVHOh4Go8qzVzYVu9kZxI/Rw5SPA7Sl2TseTl2v03pHWAb7Iwk8c2mSvj2mhP21ayp9G2idgvieHfRy/nZbBdGWpWJcvC/cpFR1JrJNjyU4T4JnuIsG4JkZ3GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l8+i46/a; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l8+i46/a"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89a0ecbc713so52644846d6.1
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 14:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774299690; x=1774904490; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x7OYuNJrumOUG8swZz30U31phe5D0Nn9dOcsToznFEA=;
        b=l8+i46/al5f+6KKVzvzMFBi6/JqYBi3Cmc//WLATJrWpA1gvLzA7lmWwfcDz9mJ2pE
         ad+UyogrKSJJrkckoyE200VbDX5SyY3l+++9jxJR1fYYmXTF3XscTKevH3aH1eW0UGGG
         dLUFUDE2+0Oyx4NAmk+Ks1jgYQtZBMsMP5y1W0Vo1G8EcaRhCfKBfUj/hlW3YnTin3fS
         4Xzvt7vkEqOD0avECNxRqiOFNGKy8ZiKCutim4oUajEIDkbbIzwpux8h/9zxefl/HiO6
         4hi5MbojFHxFvtSwC/E7cOTOSROfJOnfK4yETh/00neqjyLVjpZB2sNIOZHkGbPnm9yh
         ShZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774299690; x=1774904490;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x7OYuNJrumOUG8swZz30U31phe5D0Nn9dOcsToznFEA=;
        b=FgCYv7ws2WoEC+Gstf9cVMfWkVl5lj+qUP8pQmGEKPZBHiW4uP+jOcYXEbo1zEBHdp
         YwB8LqcalfeFvgcilyMoF7/Dc7lF/omytMbKXmNm/k1X3ja72Itn2sK1luTq7YAAdgUr
         2FsrvvnOThrcIkXnpeR6d7hRCFnLhEV5i257k3/YNDm+MW+KxGNw/23EI2uYC5haYFOx
         s5SLn2JdWSDhxHlB1FuNpWXAy52Gr49nyoRB19pw/ieYU43eDyRU9hp6bBfeFaD6bOuo
         Q+8eQe1uLtmdi9JIgE98od5gBPXuZcns6gOCVEwKQ1kLljODRblYzRmXtr/SW2RRZm5H
         kqVg==
X-Gm-Message-State: AOJu0Yx3tQomRq9abFEC8Jz80VoeP6RunEiJse9Dc8j8N/aneeBRl+PK
	KXGOvMyGecpN+XaE6CV5CtNPMOFdskoU/kPAgcuI20WyxXCJTVJXaze/
X-Gm-Gg: ATEYQzwmzapD+bBUEYY72O7/02Nq+AC78MJ2zZAtVgn/DPb27foAzRj+Y8KRNLB1e2q
	ke4vqfLqhkRj816CCElwVlQK+Kz7iOosVZmIGggjI8Cuud9i1VEdUejlYoFy9LEA/FHuWb39LBp
	nypL1EWIijxhN85HeGcuaPlRY+JD4Vgl4wPs7PYsFi/npBTI4QKjX11SXPqStpwyDEY6nbHR+S3
	O4M1b/52GliQsxv5ZN5jBhfbsxreu9Udq2JG6JuHkg4cl6DlaKyfbSeyRXoyXnl9Deeycp6Eb+x
	uCaCIN92EEDoy7gGXKIOwQVYIz3xB5MubssjE3sp55X3SPai0/nND8c1n6AbBa7R0Vj1+/IzM7d
	gjXHsYZdGybPV+MwH98nFaKFuOKbWbBmsFnhDEKkmDKteAOXCqtaEf/pikwla+idzXwQxaxBPzX
	gY4O/0zAilq/EQo8xmxzw0t5wpPOC7bGdIcWK21CxSSu14edwuUg==
X-Received: by 2002:ad4:5b8e:0:b0:89a:1c81:65a6 with SMTP id 6a1803df08f44-89cb4e708f6mr16097336d6.17.1774299690158;
        Mon, 23 Mar 2026 14:01:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c852148a5sm116660896d6.1.2026.03.23.14.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 14:01:29 -0700 (PDT)
Message-ID: <10619618-8256-4fed-974d-361fa12b12db@gmail.com>
Date: Mon, 23 Mar 2026 14:01:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260323134504.575022936@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 06:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
