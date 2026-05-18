Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728F6388E5B
	for <patches@lists.linux.dev>; Mon, 18 May 2026 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779127024; cv=none; b=RQwzVqsT49AMi5crrgyQCfdND8WLMplZilxets8FVpEFDopiUl63hgt/e05DK1iIGDpSejpRlfDSP0KA+x5UEaSBp58z4ArMDFGbkGVN131H1tj+tzBDOs1tAsFe1WQKItqfmVOKWdNgQ1klORFEANSz1VqM0BfPmC0WJT2+tIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779127024; c=relaxed/simple;
	bh=6Ef5zUQkRYLoDGZqzyWK1Yo8k5u8LRci9fP876wsGh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OBzpZRdnL/176rmABBY/Xb/2y584LZkwNoRjke8FDVG/q1Og7AqF5PSgmDsihy+lTU46pa9TJwETOPxluPTRMloknQIFzk1fNICHZ39ZYL+KzMEmdwvWYQCMhz0XCrJVh9j/K4nzguf/TU4Rnbl+lydVIaRpsjgbW2BXdZwtlKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UOtQhr8d; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOtQhr8d"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-132830d8281so10122234c88.1
        for <patches@lists.linux.dev>; Mon, 18 May 2026 10:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779127022; x=1779731822; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fr9+LJpvYtC/XychbRKgUcRTqP2ZpjjZU2abiiQiSpk=;
        b=UOtQhr8d2xZP6I6w3GmOkAuOsbvuUESHzZPadTi2e19mSvhyQL3Y6ylhPi/I0UTqoH
         LWODGwQ78cCdialCwuQp2vtJWW5/grYe4wtTVKHYADlqY1mVuFWFh4MnE7xfGCV7hrbO
         +lpL12WMz21oHR2sBTEBIKYEFzo5D1utlI6rBYVe1ACANVYrboiSatLwiekoZE/vQlcj
         As48dzJbJwjfPHEUofP/bL0tdjAyIRRYzYYRmhxisa8gdWZYR+3G2TY7g4yTNAmmDiiP
         lqMNS7raYE8zxA/6ZXS3EgeGA1BpsFg9wTvAiZSNdjkuz499aURfL/PbTn3UY3ITauEb
         2fwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779127022; x=1779731822;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fr9+LJpvYtC/XychbRKgUcRTqP2ZpjjZU2abiiQiSpk=;
        b=PgPeg6taCWWDxjZT1pLNC23k7ynd1mQ/4OduAD+4KRWYfy4en4DitTkmWQc96YMIeq
         QTLZYR0cCdXFRQbm1gsJOcRyBrPOVPknmc3yZ8zUWC1u9M/SJn8KqRJra7CZpM47MxDW
         CD6TmJxpNH4DNYSlihjsHgtADhKFDvvBKuVww5Dk8uQjmj08OlQF4U82hNmswyPlXXsV
         OZsn9FVedW6MXvUCP+aCRbJK11+IL+Oa8ASZrVHiFMUkTr0FYFTf/wYRFalqJLGcf+eU
         JevpWbvRqA6fchR5LM4F8JMiUicCh6zo1OyRhwHVuwQ0FHqIM1BGJD8KH/vP81UyYOiP
         eG2A==
X-Gm-Message-State: AOJu0YyvUj4lXFdtRCFZGtNgR0It81rIq5auMGNtPnATDnc8Yz65uNKf
	GX+t4dgZJFUu6AbqhIOAUYFn/MGQRoVk06utNcTjkESGxJ0XuFIO95pk
X-Gm-Gg: Acq92OHgxIRjMDMx71DoGbvMrYRKYf/fAAFk91m+kGPK1iqRwA6AkCg473EyVhpB5mV
	R+mP6BSzWw7ivoaNug30lnnZi0d24aR1qLercJjty91QMtuLchlV9R2Y5GrVckgZCHmv0UaefQr
	aI9QRmJBIA5WSpGmV5k9hEdfPvhMFYYQKgAv1KU3GUBRfgoM3cR+jdHBUrLuhT1TUI//FK6RwIl
	Vb8Z++t2ONqO25dL67e7PYijfXj2B4k+ZvHH4Xw8nOSAKNrLglq8q8KwjuT/FyNbcfRzzmtHWx0
	Tj/DtXwzZWKO6FBhUR33iASrXu4q0CUlR1gSwe3kWt08B41oNOS/TO36ZFizYkY1bFw+EStJq2+
	6aCDlwEJcHa8lfMhRWaj1+3LM8vbkNlwK6OMjBONbbnXAkUu3/RIXFvRgK2f48kbZAwBvT4kHzG
	ICY5MKGjWOwcxcS+v/SAP6VGuawUTQbmCw33fOJfVpfySG/hThjg==
X-Received: by 2002:a05:701a:c971:b0:12b:fb81:d69b with SMTP id a92af1059eb24-1350542e923mr7251767c88.19.1779127022438;
        Mon, 18 May 2026 10:57:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cbed531esm19598533c88.8.2026.05.18.10.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 10:57:01 -0700 (PDT)
Message-ID: <3c16d6a1-1f5a-479a-95db-014f4c540ce5@gmail.com>
Date: Mon, 18 May 2026 10:56:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/143] 6.12.90-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260516102210.570453769@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260516102210.570453769@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/26 03:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.90 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 18 May 2026 10:21:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.90-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
