Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55BB3644AF
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 19:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784315305; cv=none; b=hr3k74TDjVnjV3g/2C/VDkLQ6YPEkO7kJvlwA684zMnYN7apjb7nSutnXPvaCIntowFKtqwPG3s21M62VMOhmeEF5MGtj5tCgLUTmzk6DqNVIFNryyja47C5njFEYCkdpNnSl2q7KialMMJtYWn7vzPBzXiylauhG3IFyoGz9W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784315305; c=relaxed/simple;
	bh=8rwDxA0XSOwvaBmFjlbE4Je5DPFd6kCu56rmVbuWb4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oDD8w2sQEmXCwrzPhZq1kgULr6wAQ4gHYORXxVMzjFvpt+poAxRzos6T75muIBaNvEs1TVwdZmPTgWrCE35W5kCUh9VVkndLDDX8bqdvMNEBo96FFOXu9iCNGCoUf26BZ6DRP6NolROeeOj5Uu+uIBBYGtVFAn1PUzXOujL3bFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sH/GZApN; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sH/GZApN"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e071ed6aeso4686133a91.0
        for <patches@lists.linux.dev>; Fri, 17 Jul 2026 12:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784315303; x=1784920103; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NtNKtp784jLI3cfxFkoMon75bDpNr5z9iWtT6MawmxQ=;
        b=sH/GZApNKssqi6KIcQpgQFHcQ3lRWE8JHkJ185fWUN/LVgKOb8i9ubO63c2Xx/4vox
         G3OU+33tQYsC64U3CMsYAiGbIVjAiGaCi8H2kqIAIhRiQ+WfvRYvGHzMOPwmSNC67vpp
         9Kj2rb6pSiIqi6m6NCG1wLBnC0omrZzAV2nc5n75AyuMKf1jOMx00faQ8PvBYuzaGyj/
         kQO0cM8st/YVaCMb+KZK8OaG8WBvCN3A0lYLiQjUs0p2wLkVYXlGraCqe8lS9N7NWnyP
         KQHozYfx9SeUxPbi8m0eXD7FJKBT8IHESpuce8vdwi5Uw3jqASZty2OB9dQHX2Vd1sGC
         CU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784315303; x=1784920103;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NtNKtp784jLI3cfxFkoMon75bDpNr5z9iWtT6MawmxQ=;
        b=Wva6E6QDts2ZQEpG78iKzgHK/g/tWESGTIoot2d5+Tr7td0mAZO3jr23eoFOTcnrer
         iJUesOOnRjMREN+eABfSMwlbGvYbk7u13H5FtCB6xKD9W5aLldMePywSGs1CcpQL1a9U
         xUgNSqbmojD7Y5ahjCiqOQeF0MzpiknrFG49bZVf9yWkxWTgHeSgUpDHFXM+nf5Mw9jb
         2bISVcb/kjD7cr4gGUXi8YBrvF2PN9TIjYJYM4VruZRJ8u6rrbxw5FWVRGc0zMF0ZWfB
         qlb2g7YtNymiUYk8YLDaYKkIjnEOCIg557JypRY6Uu9XIQVH2ITGwjpbbbGa8IUzjxzd
         4kUQ==
X-Gm-Message-State: AOJu0YyUdbxwONg5OD6FV2G952+Ea9oX04adfp2iEVD67YAet+dJTuRN
	ORG6rLStGalAZRZipSK2s8kPnMlhIwQYC9/s8GwujJlMaLoH1PTZlbKm
X-Gm-Gg: AfdE7cndEuwCGAnT3epUY4CDPFQfRQFUYA2SJgadoPDwbgt6IpOHBSadqUrRd7rWnNC
	CVp0llcC26/mZcqZTyP2WeoL/aVjKcXrLC3Igg/dLMqpWlDl3xbJuzXDUGAPg9J6uxtUlVCSbpv
	zKj5ddypsiWWkd5Nr6eBS0pUA4ixbat6j5e4VTN41Y+f0eFmolkreKp86R+/PwnTdvkBAwHb1nS
	Rbu2zyrDNPl+9vWBhR4kUMELA6tV1iVCnIsXq7z1ajiikPdOcuvukusrjdE6sj2cqTSo3WPi+Mo
	jbybu4zqeNmhXJCDNbFSBNIrfmizq8kId8Qyl2pGt/YstxAm5STEmuMcuXe1k5jFcGYI5Y1F7CL
	iH/w1mCM0Dm/hcxsn2JZzT7l0WA7Mo/JrwNxr2kV1hnnPpGBixe/vjQ8mB6tgtl8RwJO2cScamh
	tDV62gUzCy+y73hkoab5897WYpZ4xZ
X-Received: by 2002:a17:90b:3ccd:b0:38e:11ba:992e with SMTP id 98e67ed59e1d1-38e4b57dd07mr3819471a91.35.1784315303098;
        Fri, 17 Jul 2026 12:08:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429f9bb62sm9209012eec.2.2026.07.17.12.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 12:08:22 -0700 (PDT)
Message-ID: <a230a463-a9d4-49fa-878c-a2117965a748@gmail.com>
Date: Fri, 17 Jul 2026 12:08:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/495] 6.18.39-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260717101904.922623678@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260717101904.922623678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/26 03:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.39 release.
> There are 495 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Jul 2026 10:18:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.39-rc2.gz
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
