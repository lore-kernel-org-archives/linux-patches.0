Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8483128D7
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681877; cv=none; b=rxShi4tni6ZEFMBphVHi7uYRJ77gQaaTvb+QauJeDLpKT3zTOx3VjNPzFGSVnamZpamqLRflwDjfE/jwxTSxjj3zPbHqJ+Lx0UKQMgpboyUElomp4vPzNggXSsHvwDwfNjNT3ZerEhG9En1iaeH/gMsZZdMNOiRvvK8epz0GKFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681877; c=relaxed/simple;
	bh=Dt7ncDe8e3B+3I1UeOHquBqkDmI9/orsxWf/7aiwomk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LUwIh01p0BOu8S6dD2NM3PB3bv83c/deP5tHIcKssc7Jqib8UGAVfGUiRZWsN3ZW1C+0jJeAomi8PBx1ZwtLm3uw7IcQyxaF9wE0FupKGOZxLfQLHeoJGUtOSd9dvVgXRLLIj4DoPR4O5nPNSs8C0wjWJrp3ywaXvLgxUQL14zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F3DYJwQe; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F3DYJwQe"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e5c9211d2so222785a.1
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 11:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787681875; x=1788286675; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VxAwI4Fc+L+F4zd+LT3xyEmwERxG0KOHGZbxsUHLJFk=;
        b=F3DYJwQenuVA7W3Kc9UNT2Q8VqlwQuGtpVGh/l+A2cquRvanqjDxwlmQ4bqnTvFPp3
         CvRuZ2oCl8p6xY/Iy8XO2x5MoVVteMB6YCa/spfpO1HRIUPHQMHIZ8x56ZiDuUNDAMCi
         UAwdDeEzXKPpM9ohzuQveL4pOUgOdeJpgeZGmjJwlksmG+lYclUZfvT5RnSNs5dFo/75
         flo4DuONEYQBRQa2H4n6vL65tg8QC8rXzWHlFHRKtcT84WRwFCRowGv8X2Bu+O8rB0J0
         GGMFnBlWULG9U+lN2Gzke56hsJPqWx+PZ4Sw5YWzZAoC+fdK2tO7E4uhqxTyInTKgImK
         9FWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787681875; x=1788286675;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VxAwI4Fc+L+F4zd+LT3xyEmwERxG0KOHGZbxsUHLJFk=;
        b=ocM1FvlhAQFUawsyPsWZVIByfAPq8t9bh0viuMVObVWwAnckLnUVPsR3b8QnuNI8CQ
         WPGa9OmEKXEp+yApZ0DiwhzcGn04HsMtfXSglOUoGlnd67EmnmTdPE34JaIZpWm9+xU3
         7uHQDnqJEpF6GV1mq0g3VtwaWmIw1UPdBXVUsaxEOc9tJIrPA9a+P1U1WSLDf3qQSjqT
         +ynLCAE5gqCFvZjZ+sG+srveegSFjoIhOoA/esCZlaOoWuXxKwxzuMmt/g2Bxw+/8KVD
         EHNTJaTzBFQIsaHCbHpm1UpJ8Pfe2qtgUpzQNAGbnS7JbggdtOX7kaMut8GAs49OLk70
         9N3Q==
X-Gm-Message-State: AFuF++mfter87kEL9+xyuDBD++NB9NHh8hysgIkp2batet9pmapsyGVO
	RsPJ/Ev3/R/yIb2+sbYROK3ESzdUZS7AddCGVUBBx9BRlDNSS0sFK02d
X-Gm-Gg: AR+sD13Zy1Q6KWZksQPeSvShzISxSQyV1ElKL84Toki8XpB0pz6U24fuTygXUi6LReg
	TwIwh2x1xi4NgNnfYehD1JkoP3br4edglV2EbH9qg1AZkIDpDZRmdslg+cL/sW1b9oxpj4f7I9+
	2RLAQrYoeu+7OZOLrLUs1JWEzoXlVJYJ0C1npUUAid6oV1/3f5g3Gm4811z9rCwOcOopCZlKEQM
	+VDmvdmUF4DJnYsTxpWB7SFDjtxl9VScmQ5iyVeAiY2O6AyfjBZgwd4ktnaY143u9VooGT4j0DU
	VGLuOgrqq6MNJZTPVZ9CCBXspFAI7xS+JJxvpkJLMHKNFW8188VfBsoo6YmEJcASQLUaC6JepQ4
	uDmPCPZHwfah8QyxPKMahFKWE+SIFzzCfQFJNe+PqUUx1i/iis4BapcKQ9flFBFzfGc3rAtFBQ8
	M/orlAk+k/XHOLHoFTi/NKbu7u1MbpRC4crfqyfv2Dtyk1QOan1+y3d93XHSW99LLPOYjqNz2iF
	stj7qaHdqPn8UA=
X-Received: by 2002:a05:620a:a80a:b0:936:315b:a5f4 with SMTP id af79cd13be357-93780186a47mr38178685a.5.1787681874939;
        Tue, 25 Aug 2026 11:17:54 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377f217c5asm22804085a.15.2026.08.25.11.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 11:17:54 -0700 (PDT)
Message-ID: <f88e3144-f38c-4053-940d-cbb1e0cd45ed@gmail.com>
Date: Tue, 25 Aug 2026 11:17:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/76] 5.15.218-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260825132541.568214149@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 06:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.218 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.218-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
