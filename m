Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AF047ACF6
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 17:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075415; cv=none; b=Vz0lISRwWlLeAk93HegN1yg6VG0YMuU//yMkMt7Es9JgDVzo09X6hOdodXSfFKzmKymCP1wcBaHR9C2Q74TYAgrh+icRuQSbyx1z7BRgTmkH57fykynf186yIGTMLVc5CebW0O0bIOLV3ufdD0fkQUIJMJpRCiuovkQp37IH87I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075415; c=relaxed/simple;
	bh=6oeHzMp7Ds2zqQQ6KuTgHRLm0wzWhDN6LUijSL1QMlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NjHR3lIsrZfzN/k8D8+T2QOrrHBXH81aI6t+EIvIrq3z3mGseNLIFYR3gwRuejSSo16rNXa/OB+syYutKuwBDqElMFBEaRKbAkFVDkx8dbDhkFUz0cFwRVOwhnfaP9NoulFY57mkB5qGidGzCkMSALertdZQTMl/8Ki90qcFK6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DN76KPaD; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DN76KPaD"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6b0b7464c99so113807eaf.3
        for <patches@lists.linux.dev>; Tue, 18 Aug 2026 10:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787075412; x=1787680212; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6Hts1Aw8R5eKycNYcfV877YpxuyVxc2DdbMBIfo45KI=;
        b=DN76KPaD5JGlD24HDSs/Dr891etiQ6+H/thpBsfofkkWQugO4KY5sG2av+e+g41Xyp
         5pKeAy29gCGAwHUumXKlMG+4s8DNBipUT0GxRvxkBLJ7GuJjaHWdgShjuW89gFjbtQ3E
         GKVpJ10zOBbbNxSJ1XVUXktXeOzRitwDcoaZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075412; x=1787680212;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6Hts1Aw8R5eKycNYcfV877YpxuyVxc2DdbMBIfo45KI=;
        b=fLH7SvN2SyvHp61+QpYQCcBctM0Qq+JRb/EOU+kmtMEnttHiWrM6NC4nSmuCfktawG
         /Hf+w/Yg54qQ0n0X7vrlIgWAllldfcET2gSNuF4Tl79TrDPWB/QyYPbB0tWObj5invGl
         E5zDe1hNVmhAwtVRQ964jq2s/4D53SCe6sMxSDEFtDwWOOJchhxPVcxDV8JIoW2mUqjN
         dhVjfhXeQ408HULxMDqsW5AhrvWM3BSPVj6sk0Dn7Pleiwt8EyKzhdIMm4JY1ggDagNr
         s0bweoZj2d2d8Ka0ib/yK9ApgokYWnCHSoTGvZ+o+J5YZLnvZr1R1gkjPHcrn8EU21QQ
         IXvA==
X-Gm-Message-State: AOJu0YwmfmzCNHUQT+sc0bgLkc4zvm0QrP6gx2eCfuSKYamfnG9AAyAR
	0Kc9sJuabsyPnO9wSTQqn7nA8W3DbuzVEr6tQvGsKcd7JzXn/1/UB+wek/hf8iyYOLmbY3OOBjf
	hcOpUrMc=
X-Gm-Gg: AR+sD13FeZcV0a9fUNlxFASAlRSD7VvKgi8BRCmHeg1ovt84ozscJNK8d1LZHE2+erk
	lIM95jENKlsnUfXmUloQEXNWZfHmfSlZep9gCQ6wGof9m53nghpoajcp9Oth1ig0emsmdHs4OVA
	If36m5Q5LjTFuKxBmesc2dy1BmjlKmkafYFxzLXjPNC50VW7YbpHxQc2mKE8bGK4Qcsxez+l/QQ
	5HQs7qZVBhe+P4p9QBQHfxik5Q/ICZRQaMvW0y6Vtp2oX8eEYxpbNUwV5IVM6JifBcFUXe1F5XV
	6dHFlYIvx1HPuvJwbc1Uv72KgVN0OvhOTBY1MTt8iBlsLxD06P17dGuz9OnzPSRxQab9o3uWZly
	4cIpGcFuv+s4EAlcCj2BdKZI3qENdezJnfAsIQJTC+Bl5zMCJ9o5vczSrroz8gwWV5OTdVy4Hor
	Q+AbEm8JTVQTTcgVPOlXdur2Dr3SiPaogLkspJSTafqrQS4C5pxD6scHkgDhpiJr5cmLokGA==
X-Received: by 2002:a05:6820:f004:b0:6aa:e1f6:32dc with SMTP id 006d021491bc7-6b0d6279964mr28011878eaf.22.1787075412028;
        Tue, 18 Aug 2026 10:50:12 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b115fa53desm5156363eaf.0.2026.08.18.10.50.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:50:11 -0700 (PDT)
Message-ID: <94636860-20d4-4aa1-8545-34e91c0ba37a@linuxfoundation.org>
Date: Tue, 18 Aug 2026 11:50:05 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/156] 6.6.152-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 07:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.152 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.152-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
