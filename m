Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B91238B154
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 18:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785436811; cv=none; b=ZbCYIG/e4kgLnNrFh0s0EHVXePHtDAXvn8L7MpUBCW9gSMTd09GL5K4gsqu9lE61cVvCnujhs49W7k7qNih/IzEKBE6e4iaxqDcz0AX5DWo+FeXHvbtVkA/IZm4CmHzkq+T5NzlA+71Jq954ijjiDEKSlvqMIeRNRt7ZW2uAtns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785436811; c=relaxed/simple;
	bh=hy6fx6N3Nh/WxBBogRW5aSz2ZGxWvmhqsB9P6yfusvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JGcE48MypXS8mcNFRRitOTJGpwiqYLeBXkzrkCVPRLAQjlceYUgIWI8DiLIKufzHcpy+GS/b1pnMWlaHJYgLKNeHTinPUCspNu/VncUK3pfBFIlWoztYoRibyXjzYeIyFt00AjPNxSlOIQx1ZrZ4EWjIjK1KWdsAiCSmBkwQWIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gZ75kyfR; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gZ75kyfR"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-848595b338cso305521b3a.0
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 11:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785436801; x=1786041601; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Ii8g7gfGJyZMSKYNBxvXh449cEi0V2rqHcf+jvAPVQ=;
        b=gZ75kyfRew2ZzSLNtDBxulNGW4H7uF/wlyq6Z000MnfmbccD3nHoO1RYBeUyqjYcV/
         CPLPxky3q6Kc7j606DplwavvUCL8IzlaR10OWBmwlAOcJwc23M5H0/nfXkQ5Ffa1MMde
         9EjQqHCqL52k6D+qkaQCmBbe0jynpLsTjBfG21tSrpmHmWWzANQtC1NGBl1Yw0PumpGh
         XADgAX0DSD2SilIcKLkFYq+0kXLqFf4sDoM1rDwNemesfNqAcmV560gE6B7OyNlKQqNw
         iTVS3cp60yEXVRKT3von4X17Itf+v/MF7vh0gvKaqVI+a2BfppC/QgLolWWZifRF/pMx
         vygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785436801; x=1786041601;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4Ii8g7gfGJyZMSKYNBxvXh449cEi0V2rqHcf+jvAPVQ=;
        b=j63vgh0Y6cLc/gjXqPIXMSTSl/yOMzYa+q+ETmQ8eGCnul91Km30Vcw1hBwLyoWfZf
         5b3SB7yIsmsg3NagasT727LyVuXhV3/OcRgav88sHof9hQH4mrjtyqukff+uIuFRDSXM
         vu3zWc6mjmOSq2Qd6ww0ETmSFfeEW9p1SmIZ7O/ywXZcSwURq6GqT5tqrMOOWD4piZOt
         Okl3gWrb6rQzGJRuQhXnUrbkjiACet3Rxbqx7iBkTnD+nmNkLkHZKdtyh7IbNeHS+0//
         M12HTL97viJ7yNem3MAvTO+0RLHoaPfzvaNdB+vU7JyTFgaEd99Nlt9rME8YRs3Ncmaj
         3dCQ==
X-Gm-Message-State: AOJu0YxuuymIHSgTJrxQvgjRnsnDDYMrnqhbZ78LK6yhTmf5GabCp1vE
	GsrJ5k8gV0eBMGHS6WqSuM1A6nhGH93T+jJei2BS45atvnfcPdTcoCCJ
X-Gm-Gg: AR+sD10Jz+m4b5RR9abFHhGBMLIyKBoY8wMrf3vJbnUOWZjIvo7qUqeAUwER2I74E1k
	13+P3NVmw1jtcxSzymJwPw11Gs4bJXfbAWF1lki5Ac182z24/WBHqBZQRw/gxirrYtnIswOb51i
	2qCG/Ab1M41jKelD1uhpbWYP2uGs9YibocUEzc9AbuDja2tfJYIVCXGVAi+lGtbUSNHfSiBKBwG
	lFZ+5exgtDiH5bc5OksxxVAZGzNByApZ304R/000tN4TsC60FodoMvgxmjAB0AIb29F9rDo8zX6
	36DObaCB7xMkPlRwIleAjHpLdZmltVxGx15SG9cgNQC0vN8TiTrQMj9MvIbHswDMq5NLWRLGkUl
	upw3cVD4dGMGHQ0sodSIuT9R6AYg+3K43QwxtLLOX2sC6KzKlRnYZdrQvregBkPkFXY1ESwDEuY
	no31qUxi5/aj5MocaIvHpGD1DQcXNIAhmosWvJMDwm9pzynsMgxd2zubCmsz7EkA02pb4wEkmyi
	1reyPHVeQloSE0=
X-Received: by 2002:a05:6a20:7f89:b0:3c3:9595:57ef with SMTP id adf61e73a8af0-3c9006b6d23mr3663067637.31.1785436801475;
        Thu, 30 Jul 2026 11:40:01 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504baa01dsm25330548eec.12.2026.07.30.11.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 11:40:00 -0700 (PDT)
Message-ID: <e85b5fff-b92f-48ff-b33e-359c3f048d12@gmail.com>
Date: Thu, 30 Jul 2026 11:39:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/675] 6.18.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260730141445.110192266@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/26 07:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.42 release.
> There are 675 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.42-rc1.gz
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
