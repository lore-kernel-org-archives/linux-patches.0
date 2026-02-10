Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F16513957E
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 03:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770692501; cv=none; b=VqBRVFv6Pg0EEZ5fGKWlLV4yB9IblysfZx3nWvZ+rKmXkkLfft1f06wJQINM3baMGPK8GYxu7K1DBMfcFK1NQz05nH5/PUPZrBYuvV/oAu7XHxmaZpKtNeO4BAsDSr7fRHkhMlC6X3HWqu+qi0HREPt3E8REyLsM656xwH/iQpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770692501; c=relaxed/simple;
	bh=kzYAHJMQFuP5XlBe987OzNYxqmo2rmucgvzJ1A+Zcf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n9PbSfBozl+g9kGMu+z/O763ZRh4XyvHUzlRj7IYz8+M602tnxo3KydReY/DWkPSR8d0KWFPHMaRIF/TtFDQcgRW68I3ru7TvSoeOo2npE5Us1NP59v5DTjOpxhLs35SPq/9bPMkgKzm+9Zdw7qkm/H8DHxXfhdQY6zy1wkLyp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hsmKOcbS; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hsmKOcbS"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-126ea4e9694so4228603c88.1
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 19:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770692499; x=1771297299; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uh4hL2hmMpxCHLYEr45X+FcngLLc9iD1ju5Dym3O4Wk=;
        b=hsmKOcbSY8vTpEsOdJV7E+j683SOS/siaTYC8Vgnc1y0S+UftS/cwfh6EDWokPif/B
         n2TvYH+1dqpvoVWG2brbiQ+6Vx10q8b44xN4HelHtet9veptJpaoHFsjA7XXlVkWt9TR
         cFPaxmVKyzzgdlk1sBqmBG/kF6JTEOo0YM2BZhtmqm+wV0YE2RBzrcSPR4F73oXWzwup
         rajigzeKNNyuSiwcwuhAcTaWkipObJ8EmE5QBilUvoC722bUHXtzQwvRqScWSHW3PK8G
         uy5R2hu8ln9vXKG6dL/8AEYRtJCJpem+o8z73kALPDM91s08kclDjO9Oxk1whon9QnLv
         S+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770692499; x=1771297299;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uh4hL2hmMpxCHLYEr45X+FcngLLc9iD1ju5Dym3O4Wk=;
        b=VW/YyyP9em8NYTujd9pdGkWBZVaNkOVcFeDOmjdgAT/HVkRnknXoAoOdhdPQJS9uh4
         CeMnV/lm08XFZylyQ5+RI97vgAs3v9wGKrLjgk5D7Em5KHzbg9eTRQCsnHxKwuWmY5Dx
         6pHubVfjGZXxdyTWkO7kTkaVLVjFLWw7tXvWkqWll32SMejvt3jDfynzyUGHCYUXjEvx
         fHLcReM6u/VzBUvdIayMt4kKsj1EJsxvBxrBu2vSs6R+rfwqEcMOlruyAPbUeqFcS5a9
         wddrRD0zOxzwkstIMIcfqM8nMRlFasz05kr4zlHGNgok7Jz4VPucDQAAvPaHuFwkfqNV
         lBdA==
X-Gm-Message-State: AOJu0Yxa6huQtNmLY4g9cXD/M4cHaFW3fjfYjmeBp0cEDmivhuws1rhk
	N+kElHTgQP/ag2vGkqib4h+yngedVJbY3ZiSJRaFDyepcuD2svaLY8nW
X-Gm-Gg: AZuq6aIUWslJ7kvCaPvnQqrviV7JlBhOutawIJWbORrjz4wM/NGxegRamO4+tXYDNst
	89aNfNrjBw3sTNzKpa3pDEJb25GGNL4jesjqSUmAhKd/AHh7c8kYZRcgnlvbucvRoMHf64Y07MR
	P25Mylxejn305b5/TLDOe/boUALX0jD2A2pA1BTLEdJlIX/9OBw7xI9ChPkIhdDMRzhXOwodiV6
	z/lra04GDIxiILHaE9GHxFvZFSeBQwBe3hAS1WajiMfMqu7polXPbyXPe0mDP72Qc3T8FyN8Lfm
	XiEC+WS16YI8EElctfQqpjUuZKQPjg3jQmdC4a6/3evgoakcj8Dw0BYi4MoVCNUVayg/Y3gw3Td
	c7a5nGD85C64x+VSuCffs7Hc3RIHSxtymRMO4PPsyzsGyfKaYSb/ZZQTq0SatiJzYgdBwGS6xQA
	1PEeNHWYA9iSXwDTan4fWlbWUBoJhmoqXPbWhVWKGnjG/jQbM3g1t5o/Ms4b2CKVGi
X-Received: by 2002:a05:7022:fa9:b0:119:e56b:957b with SMTP id a92af1059eb24-12724285c4bmr365732c88.0.1770692499401;
        Mon, 09 Feb 2026 19:01:39 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba81eab184sm1537855eec.1.2026.02.09.19.01.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 19:01:38 -0800 (PST)
Message-ID: <ff946aad-325e-4c56-96ed-cc7c991bf227@gmail.com>
Date: Mon, 9 Feb 2026 19:01:36 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/41] 5.10.250-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260209142256.797267956@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/9/2026 6:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.250 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.250-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

