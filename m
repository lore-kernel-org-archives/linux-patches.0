Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967843CB55E
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 21:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787260856; cv=none; b=cCQc/xKPbBigpEmpByv4Qw7cPdnZZhEePBVbdP7vQls8ggAFTXuvpsyRfywZzV1oahWvm+Jp6OqVajb0hbfEql8Uc+QMxD8GYkSLiWuGOkbW4cLX2k9LWtDMEvOUOM9V3PO40+/R2yj7ZBdlg8uuSu/8L49FBGVB1g/vZPCOAGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787260856; c=relaxed/simple;
	bh=J+o9dH3EtFMjqpoc6CIIwziyQDea7+QKvQj34ZKbAWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qRZ/QuuRYf0nyn61Cc+kcthmpnWjA9FY9dYZb9C2K8xJ41IyNgu0Ltyc5/Bl90diNr8+pNME5f3KBzphC72UsF0G9hXxGCwrEcjjQZWtiZRuEx4vTIZ56wznzQm01Z7KR/SAV05m5M8Nf7cpVhz0Mo2vUSxuleZXrXUfCPolMFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mNIALqkQ; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mNIALqkQ"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cbedda4c154so206500a12.1
        for <patches@lists.linux.dev>; Thu, 20 Aug 2026 14:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787260854; x=1787865654; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4SwYkwkNmLdvsbCWU4wBK88wpaHOEd82aK+RJCNSoNg=;
        b=mNIALqkQ8lgdumuk5sOPDM99V5m0lzM6M6Ajl2UzPd6OTiPRGNX7iTv4LnRGLJzade
         usmBBIFFUg4lS7WHKg1Lh6i+hJcgZD8DTOe7yBhrhqgY7SCGfGqVSk109dfqOPSl+l82
         3WTudE327FFMX0+beR91WHxWE5N2J6HUUyC887w3IH/Bc4ESihY3c42lUN7jRJ+0aWUU
         lyVV/8adJx0ZHLH3BRsTOvbrj8gYYFDO2DKp4MY1vSRxagBvMQUYr0LAeuo9PkugAiZT
         ik3/5uGcNjlF++N14ZAOUhgpdDqJ6s4I7JSPrN26ghLVbAekOGjBUjy5iPXxRQWUA3kH
         0kCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787260854; x=1787865654;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4SwYkwkNmLdvsbCWU4wBK88wpaHOEd82aK+RJCNSoNg=;
        b=INsKOpvYCSYJE+GR7SQ4zhSMJDS5OHcv3thEYtPLJObEuTBnAT7g62y8hjbZo+qBby
         DG80+oFbykg/q3iI77NvSK1Zu2/Z3YylTHV4kLh3tjSTnoTHZn2TCBoQfJbiWJ5Y3HKI
         c7yS83So2W0Pt8CL8RlhA4SNlYqHGC50hPDxlguS+ZIym4ssuIypItGhK/euTvDl1tV2
         t2YDEl090QgzjRpTXcAueAmgyhZ6D/arcX1chCi54LpfCEOkBpp7anZS2Ja8ltcg8Iwm
         V75AKxIZE5U83wU1DYAuMWADG9ft8LeDaa8Oz61L/Av5MVcZmL4EHYzBt1AJvW5pPyVf
         064w==
X-Gm-Message-State: AFuF++nE5U5Zu28EFQNS53G9pvqMqX6dtxDmSFKDorLYEdkyObCEFL9p
	JjgPHQ2etCBxmNaPlUTKnZ3tfdyIoNW6oe77MqkYihiZmBDT+kZspM12
X-Gm-Gg: AR+sD13BgchTw6CFqB1jz1+n4nhs+LpRu3MpcSm/FzD0xpQ6CYV94j8F97vt1yU67fu
	/x+ZwLOH/BRycn71kcO/7CjDWfDzpqObqs9uLGkiKG5ji7TCqbb8WxILec0LhGMOpqMO3UWfjzS
	zYJ8tHmcaClgrLA2JvmI2GjWBKZTxxC006CVnUYgi6Givs4Flco+4ufu9AXrD5vIkIxmS/NMgTa
	zWuq8q7cf47aeXJ/xdfuFmdzKp61RuVjKvDf+TVtztYfMQSipVhEJJfg28Zi5qJPnVXsowrfgL8
	YaTWiz3mT+jRNYmab3IVNZ7ROl8MMjUfKJe25y+/sEUHIzd2uehJN5O8Hhhu0FqAAzjnMOWAmBi
	ZFsGjfaaaG5MNykaacs7m1GOGaiJyAPrUtn7+dvcoJkBpsp/qh7rga9GlDX1Wz3eOtZMGqQiO+W
	8qPJEt2rYnm+0sicseZ8R5j3EH3dK8n8GqALApzYinhFbZQxsiIo9WByNdgFMhBlncZnX7yZknL
	ZIYtDjquO3KYp4=
X-Received: by 2002:a17:90b:1a85:b0:38e:250b:122f with SMTP id 98e67ed59e1d1-395c3aa9e26mr1971749a91.16.1787260853762;
        Thu, 20 Aug 2026 14:20:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327cbb46ff8sm14493836eec.23.2026.08.20.14.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 14:20:52 -0700 (PDT)
Message-ID: <de2d1251-83c4-43f1-918f-9dd27891e446@gmail.com>
Date: Thu, 20 Aug 2026 14:20:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/217] 6.18.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260820145237.531699751@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 07:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.46 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.46-rc1.gz
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
