Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0843331211
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 18:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773425003; cv=none; b=InqPoO4tTrRQsoV2psjrXMvRx8uiw8acKWDCV+lkUUkDHWvFOkXAxN+Jc8EBuJmYYWqDS51SvN0ctlL4lU5sTPLdD+gul/6NsdPhCy0a0hgUReg1IYk/a/R14NL0MuAP4XRMWLSlYcA6qOMDYflQgriGv3ZcgEvzLKTdk2kG9XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773425003; c=relaxed/simple;
	bh=qh20l3b/0HKWTON/GYTrHeqfsIlTbjC71F7cJPk2N1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ii52lJUtr5FAMJWS7ymqofutaksu9gPwg33DRClVMA8I13yJECHaCcWM10k/WBC0v+LcD+fwaNpMwuSg8rLV0ShncdrbacFAQm/l9YrqsXXasXF0VU70wFRG4ylwvprz8fqguu+GiSp+6nG5ev4lk+rJnblwFG/3DGr0DqFFJKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T5SGA6dv; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5SGA6dv"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5ffbcfbcec4so645213137.3
        for <patches@lists.linux.dev>; Fri, 13 Mar 2026 11:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773425001; x=1774029801; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FGqCFSULWUrkR10G0FIZvp6yvlkIMXD6lkVLcWVFX9w=;
        b=T5SGA6dvjCj8h9CijZiJe2IE95puAXS7eliRHM0kOONnpnt1N9D/NYjg0/lHb/w6km
         kfZEbpdRATb536RjYXvq3MR2A/oYYCZWh++/spurvf4g2N8GG1ORjTQLfdgmoP/5uVOq
         fMhPGcSYY9C9CWtqqSw5SSjU89lbB7NyFbA3gc0QkBv0Sulf8K1mARRsNSSXezmp0q3g
         vbdwenRNWBaWRzrOK112OD+iibMKLYvriaL18OWEsZau2x2qhAwgmn+kNMWlzf3TH8tA
         qq9qwJG18gRPXhHNGp08vNNclYjrB524HAe/vP4l7DcJqvO7r44/ZebQIfTwYHRQP5pP
         +EZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773425001; x=1774029801;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FGqCFSULWUrkR10G0FIZvp6yvlkIMXD6lkVLcWVFX9w=;
        b=kXrl4eNFIlq6PHf7jBekPDs8a6Ceb2ac9dOM775VblHGJ9LrlwgR4pFS0hbEa4ODD8
         E52JUC6GMvpLycKLoILVtTPPXtNpL6bZkSj6JmN+YB5O0/hcplvIqTsUTsc/25nha+la
         Zq+QoYWNFWGVFCn9YD+iZQ1Z9cVRqrmDLZQr2AGfVE7uosQcevD4N9C3qBQjDDQWz+Z+
         ABNLYjFwV382G625+Hf666U8dZTEy93/0KJ5bO0jp3O7/UHUmmZHSkuZ6MpM6H7iuPmk
         rffuxVl7oIA84Vni1zC9QtPVitK/0sCg0pAt7ar5fBDXnpimmROkBSIdKvp2pC6rhVag
         tdpQ==
X-Gm-Message-State: AOJu0Yzb85FeVSIolhiebyNDi+2HpMesCcpYrr19XX9zsBQoSnvbzLJO
	0gfWP3cypXKIVXB2eqwVvsVpVr8hhhG7CNO5QZyqfm9JZ0LPow+s9mHQzhDMBQ==
X-Gm-Gg: ATEYQzyqNV9iMZ0wf6fuTVnelGgQIt+ZG2VWF5H+1j4Dt9X/Ofe5eOkrPKLFp3iASzJ
	AQCbQk7L1Vj50xnH3kSbOIRDlkTqWZqJaUKBqIbTrYrsXokgjdnxcxU6QsBBB5YGJOJeHprftP5
	ttsHEDKa1DdvpI22xq2PdbGk7BzpyA7cEoapl/aAt7Evel4ovAyHqz3qCU4F+Ff4RydAYLY2BG0
	rVRe7aXZLa5UYFgimp/MP1TebexGTjN3zWrZoWwo1UvcwEjGcuJb0fHz0DyoAe5+isOUtx7WTRj
	5bAC5V8u/oiPV1vTLyp9dOZ6h8o0dS92ljwJrPdahFN3cJbYd5TahRNozPkm6TCKVWmeb618QyW
	BBUogmPawjcSdueraVchxOEz6mfHNBWZO04CaQyJscXsvz2x1k/8NA4uubhPL2lAiTij/eNjkgc
	bspEGDwBd1MCKbkhFUTRyWU+X/yLMvjc0OZkcxAKcK7yr+uaafhWdSynBzd1yG
X-Received: by 2002:a05:6102:5094:b0:5ff:da11:fbb4 with SMTP id ada2fe7eead31-6020e1ec407mr1753942137.1.1773425001496;
        Fri, 13 Mar 2026 11:03:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda71834d9sm596081285a.14.2026.03.13.11.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 11:03:20 -0700 (PDT)
Message-ID: <2e78aa86-08e7-4d1c-b0c3-b84ea7beda96@gmail.com>
Date: Fri, 13 Mar 2026 11:03:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/13] 6.18.18-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260312200326.246396673@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260312200326.246396673@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 13:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.18 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2026 20:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.18-rc1.gz
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
