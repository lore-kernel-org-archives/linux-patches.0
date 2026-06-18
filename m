Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F583DB319
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 12:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781784450; cv=none; b=MGHJhr2PmMJswiT856HrQwxojYDtuhmeUSFsq49i/3lIpyK0Ic+nIiUWDMGx95KbGGb+8wGnAQR6oSbMKPgO5uacMF66+m2Tfkd17CBE53qZ4RC7YNuY4TfZZoFvFxNGKq0h6eQZPnrRNsdjIb/sLLAVO6x6Ol9Abv4d9hqjdWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781784450; c=relaxed/simple;
	bh=rvUJtS+4F0/HkiQYZkn4KPT8KMj4ZyTWCGc1dug5DVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IjDV4G8AUzsPxkIj+HshHCtXsc5n7eLpwhCya9IfbWdRoWlLAiw+TXBwBT1SdQ/Rg0hH876W2Lnz+P1wW1P57TTUoQqGsWAm2UIOGKX/qIMpnBu0Y3/yeHFUZ1LT3qkl3O0VayuQm54BqqenwkThpCdLCeKn6mjWDeoa02RPFXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WNCsTn+I; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WNCsTn+I"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b12270b3so4444585e9.1
        for <patches@lists.linux.dev>; Thu, 18 Jun 2026 05:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781784447; x=1782389247; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uAFu3iieP1epU57dc1h0pgsCpphj+R9P3j26Urr6Nvk=;
        b=WNCsTn+ICwn+wsMw0/2y775MVwZbKcnZy/zkCGeuUY6rjsuOWEYdSKRshOdf6npHVf
         MHmKZbI3D4+ufK8aaCV6qDLPiHe1Rh/1udkaCMs+Z6YP1fV3Q42chpCqxG6T8gvGjMM9
         QBRJB6ti5wreksuspHVNSi823bLsUdJBgRaRTPIRp4BoHYleK5ilsOtAyLW6Nd855NFl
         H/nsYuHtuvvMlls9kW1RWnW+Q2wFVa6HaEu9ro9B7KDEOHgdXLN1nkgeSU1B6RW5aDP9
         bNTFroryoxpkYcxQ3p8T93QiNv+9dhFosCDC4M8Wq9XPFBRNfCV8qpfZNg1CiDlfNmk8
         f0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781784447; x=1782389247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uAFu3iieP1epU57dc1h0pgsCpphj+R9P3j26Urr6Nvk=;
        b=K6Gap6KZU0gGBp6HEr/JWnljLWpIayfW9PfUol1+F479yLUKoGOwW8IAsMa46rk28F
         3Q4ZCKq3lwkff2X80mieqhaTj+ZU662sC+8Pmri4Tt0MknOVybZubj7R5UGtgurDQ7jQ
         4d8UOCmED2gLjCWEELr+lWIA+SONOPBt9UsjxqPiaw2pQCEc+C7o6oYreumt5AcPknWb
         NBRtIllA49oUCbuParxSYHu809fIjPMPw5VLi53xAp9km27DSc6QWzpn4lRXBz+ghhRS
         OIJtgBNOHxwx5I2mxsDRBDJ+3wrHjMpgTE+PXjmHD2DWLwZFwVuPufmYj9Cc+BOtoGNl
         bvew==
X-Gm-Message-State: AOJu0YyN0Zf9FZYmfGFCwIROBcm+ly3NJQc/AzQZSL31xnoxsStaPLoa
	NF5XgaC4DK3Wd4RLBwkqz2kK2LsqIoEJ/mh4bM2WgjV1W/T9gLegifrh
X-Gm-Gg: AfdE7cm+Htsh9F9EIHNF9KJ6J1TbZPRwLe33aQU1L7/sZ5u2M8Fvi+74PUksN4OU8/W
	i/YpAlVtyypQEZjfM0VExuWiG/Fv2AEE7EtqDYipqXzfdD4JR8SYaH3qBCLHTcwJ31qnVSQxsg9
	/i/89Bc+ASr7JjC398tSdlqRRijJBwDhwgNnjl6OL7MyXE9DRdKJTUvYb8jJ6Ckbt1SiDPvKdyH
	lXWuDyYW9Q0wydBPvZxn/5RQBWyOdLvSJV7jfOa7y37BG+RHLvOkevPrR1zSm+O4MweN/+OPpVf
	2o9EPHDgwLob/IpbxsGtJULY3pzMUCu9e17L9nFtZqvNI+9Wt8Op2+vIgUOSk74hg/k+26d5CBV
	LZW6p0Igmaj+PpgAXTgUJGibLiBASLbVOLOMMHdcgIXXW/NRBK8wRww33xXqw1kSQDhYCY5Zez2
	ycMDfz+RSYfT9u77KCVnGiyWUfxBGsjA==
X-Received: by 2002:a05:600c:c178:b0:490:4b89:535d with SMTP id 5b1f17b1804b1-49234100907mr131154445e9.1.1781784446971;
        Thu, 18 Jun 2026 05:07:26 -0700 (PDT)
Received: from [192.168.1.21] ([41.140.50.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa47d1csm243843195e9.4.2026.06.18.05.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 05:07:25 -0700 (PDT)
Message-ID: <93a18d21-cc98-4dae-9433-a6a68d88d0ee@gmail.com>
Date: Thu, 18 Jun 2026 13:07:23 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/325] 6.18.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260616145057.827196531@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/16/2026 7:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.36 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENEIRC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

