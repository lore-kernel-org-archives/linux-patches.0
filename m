Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC936347C7
	for <patches@lists.linux.dev>; Tue, 13 May 2025 12:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747140907; cv=none; b=iW/q7NwSoXZbyZniOrkmH/W0/gOtKJAIrEqXUHTg5hdf36tb65vpuo57uCF0gRtlYMAfd5D8NkKYCzsoRRkb6+KBIIECm1m/9AMP9jcaMe0rm8oagMAWOo4k2pa39jCaMWIOEaKWDK3IXhTUTDGIxlCqiUyDj9nuglNYPAaA4lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747140907; c=relaxed/simple;
	bh=aVB2C3FDKUw+f78CChzpnXoxjn+33ek/tLNE7/EMYZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MED/L+wjxnzcWsKE81FtBjfcbLnWNF5ZsRpPfKJcMjRG06tAbw26ieJDo80iEIrNsUmko13bkTc1UqF/VsBa0jMPL6yPAsBtIbUrcTIZWlJFVeNYiFditWGsu7EVW5jbT4+fQkQNZdvDQCM7WRta9ds5vhe1bJcGwVMLxw5va0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M4PPMeW5; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M4PPMeW5"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-30dfd9e7fa8so1984614a91.2
        for <patches@lists.linux.dev>; Tue, 13 May 2025 05:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747140905; x=1747745705; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=EN9fI41SwUNEvRIBPpCmbmrqn5bUWQsOT/anNGrdqFk=;
        b=M4PPMeW5jeXUHivHpePU2JlLycf/0VzXkU7eS1NzISuV3P94YgiIHbSFZNj4cWIeRd
         mUT8niCBiU63+ijq0fIx0CF8D+ZxyHd+cisjJkXIFxQzud46WDWlLa1+nbSqKy1K0nNO
         itg12DaltAwKOtIPdBsfLwOXJmA68VRteGtnr4Qb5yfnyzop+baj34ZjeaWscrEv/wXi
         cg5CQyp2iGcKq3d6Z4BZoE7pQZcfTpBBH0YL0V0CSR+0x5Dyq+r5M20yrj8q0HQPUo15
         Pim2VN6V5F6VDPxKdQvh54ljVTZH7SptHh360N7z9k8gNLF+qpWI3r8zBosRTTdm+jRB
         ue+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747140905; x=1747745705;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EN9fI41SwUNEvRIBPpCmbmrqn5bUWQsOT/anNGrdqFk=;
        b=okQ4rBmr7ffW/Sa9xA2iFX30IEkI+19FyzSYbKUjpjog3WD05wAytJDksrB5iOKdgJ
         4fq4MniJnPf8AayNZd2OPlz6lX0N+g1hmWkA+c2/j1x9s1xIvIMUVmMhU2TAjOQ3f0Wl
         xcBNy3b9ZNXnLKd9KAHVn5AAKUK+3b/8My0Vhgcp8ohQjRyg7zXVzG3mUJENp9aMXz60
         4oTOK37Wdqkpu3BhSSpMYwsVzHJFAYYMrTMV6PIVM/rfAhlOv7TwvVSf7USV1M6x9xL8
         L+yCJFAHkQOMRajA4Ip/sFORdACsFCa+PZLOT8JxS+F9JGxSuI78jFhzXEsHsWNYsejT
         TP9g==
X-Gm-Message-State: AOJu0Yx1iW/BBgJ1RDvQNjRqM6Y+IU9HkpRQGUgh6dJFossxXtgPmBMe
	Syg9W+6NiDPJk3plx5HZnuZoBbKhttB0faEvDjjK71Q3KrCNjOS2
X-Gm-Gg: ASbGncum+0IVNkQaDext3CTj7KAb2L9ppWq9/KaB+5pesFErJP6Rn4v0M5dlbqx0MHB
	qu2GvzYn4nt0DBdLSuDD5MVpolN7bFMkFJ9ss76iBLVUKVQilHhUFhjLlecRdClB/+rzLLSQ0aM
	zXAkXOORhh7cauKEYbBpXjjyjez2rOlQiKmS4yODZEAg2HnboKbqPg5O0fMSBECWEz0bOEJpvJA
	aVzfRTM3Jtft98ISOUVEdJklK5vTxflWen7TzCPrggBB6eZKakFZPRxtygn7U54vGFS5agI9ac4
	XWeEbivlwSO+z8Clwyqy2Gs4wRhAXk65FWNct812gv0igmMVBKIXQ8ve0YmWFGfGp0KBck5sYjY
	w0mt09uuTP0ymPNCQ6FXHcTN0MsJpj5Q2KduNAA==
X-Google-Smtp-Source: AGHT+IEwvl+MJeoRrUjahOBnEcQiVj2a8Jmt/6h75M6MpzvP3HWVLL2ES27iCHaasx3CiubgowebNA==
X-Received: by 2002:a17:90b:3908:b0:2f8:49ad:4079 with SMTP id 98e67ed59e1d1-30c3cc1106dmr24791390a91.6.1747140904825;
        Tue, 13 May 2025 05:55:04 -0700 (PDT)
Received: from [192.168.1.24] (90-47-60-187.ftth.fr.orangecustomers.net. [90.47.60.187])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e11e81788sm602945a91.1.2025.05.13.05.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 05:55:04 -0700 (PDT)
Message-ID: <b5cfa725-d3ed-4c77-beb7-3eec065580e7@gmail.com>
Date: Tue, 13 May 2025 14:54:59 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172044.326436266@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/12/2025 7:37 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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

