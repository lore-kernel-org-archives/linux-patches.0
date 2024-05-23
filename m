Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0A97EF1F
	for <patches@lists.linux.dev>; Thu, 23 May 2024 17:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716486629; cv=none; b=Nbj1UU8G60IBJJsoShtrRxqzgJiiVNsAxJHIRCxDe0zr2i8sYVTydN5/EGRIjzQaeEsiMDh68MLihpdBhLJro5tzZXP0L/YSQxVKLTebSchDYgs62BZl7DW4nZJDkeSaz0oUb06sTceGlnKSiOxqEiyncqgyuck6PhcUUR+okB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716486629; c=relaxed/simple;
	bh=Oj5V8Zl8AxyLYxbl99PVAplCD/Zk2R4iz+sX+zS8bRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AL/oAmnP1xxxXHVRXFO7fUV+SypTRQjnAB+Nw+w5Fa/80u1Oxp7HlP72FzOBM+qUVBhCzl0+Zv+O0iVjryut68YcxffFJR8Mvoj2BURdXBLoVB4Qhi7fi/pLBUMnK0mppHJK9OpYYrS5r0pp/NWCkE4NI/YqkrXpIl+64BKOm1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CYvjLyBL; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CYvjLyBL"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-62a08099115so121127b3.0
        for <patches@lists.linux.dev>; Thu, 23 May 2024 10:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716486626; x=1717091426; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A2WExOwhOvPENBtOdrwpIwXYpidNTG4NO4SqsZ/h7Wg=;
        b=CYvjLyBLFV0DXG25XOMTFQQAPYEiDByBmNx952RnF911jr4XRlhyfV0BUFCybA7ko2
         AFw1bUVdoCo7yab2uKtYN9smt2q38SBiTz9LQI7T5Iz10UgYjPIYBvcwgaK6A4qvi/W8
         2Urv/gs1v8ybmykN21cmml1MwNeIfQIRPgcBuUIArdwzf2qy8LZNAZsng6jbI4zUVJ9v
         0RTdSqJUpKyITIqcPGL5zbWL0F4WinwNfVACZjXbSHJqJO0BWmVHPyELiYtvCwAl8xek
         mLnKCA7DpwNh159Bk7Q9qSTO93suOq0nfYr93dP8Rmw44TjqhVwdDAlkwsyY7UvCK/pa
         MGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716486626; x=1717091426;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A2WExOwhOvPENBtOdrwpIwXYpidNTG4NO4SqsZ/h7Wg=;
        b=iViJDh0T7v4ab2drCGDNRhIPRXO33pk5QaK4+omJQRGT0v5z/Zf3jMDubXb5FQ+inw
         EYbzvznKj6JfgEsy9vxI/f+GM1WiH/hIdGI5nKJax8ajBvTO4MV+otiCJf/r+mDSH8LF
         zVSYdgrlhjLAIUocuacrWc33bdmWaRxwnRwzGcXFqeVhpCs9wmuG4kAlHbyJAulk52iJ
         OsQ5fxG6oTDpKcjQlNn5ofC/SkTfseQPMHcu7syrTexfHe1qg5QPq49Kmw1gsbVXsUfN
         Aor46Zh/VCL+rqYlY9nWF/cAt+I1W1Q6nvlgPV5c7Iy0FFK1kn2586f0KiXWdXh9APQ8
         widg==
X-Gm-Message-State: AOJu0Yz8pN2O79hzCFARlGFzXsnUmvkIhQ6xcHeqGzpJnYlEboII/WIw
	dcdFw/WkoHHkwBegTefyUvQDuj9tbXxKbJQo+ZutFPr4D59sxlGP
X-Google-Smtp-Source: AGHT+IHD3RdQmvaRRzVInl/+fceU/kNYKQqsX2H+wX4kUbad5XiDJpOzmGkEBgD5kyM++z+nQwpvlw==
X-Received: by 2002:a0d:ddc6:0:b0:61d:fcf7:3377 with SMTP id 00721157ae682-627e48809fbmr57863297b3.44.1716486626489;
        Thu, 23 May 2024 10:50:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6ab8b22d082sm13532626d6.41.2024.05.23.10.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 10:50:25 -0700 (PDT)
Message-ID: <6b51836b-bdf1-495c-903b-b73439b86449@gmail.com>
Date: Thu, 23 May 2024 10:50:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/16] 5.4.277-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130325.743454852@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 06:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.277 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.277-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

