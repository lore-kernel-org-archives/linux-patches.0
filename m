Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2CA37EFFC
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 20:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786999473; cv=none; b=jaGi5FebF1/Q28enRPIBDyqGTnlliRAb+HGzlEpP9YBrYP3sY3PZaMMTOv8NWwIb5M8xo4Nk5EYCoxGq1u78TuReocA++S5GGkGB1NhwmgfQFzf9Ot9Pz7RkBjfs/x7QjU1PftuCDG4EmnNdTiijWL4jCccHu9d7knTOfdNo8Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786999473; c=relaxed/simple;
	bh=uvG1pQDdAHtYTp3fVqKQ9zjEj4I3LF3WH12RcltAZzE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jBoSHkUn4MqYm6ENG2PpP+Q7tKRW7e88/W8H1xQPWrJVgnIO4Bb4DfpO4e80hSf1XHjPg5SIT/BUBuL15zICELtvcmaWo1x+ihG/gIx4TmThTvXE8N4pke7FlN0axUjQuNxC0pKQdyGrVz9w7JZXr99qsz2Dqc4BwL1RhWpikbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eoRGM4sx; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eoRGM4sx"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ff20870ac7so25343576d6.1
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 13:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786999471; x=1787604271; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qPDq1Kb5UwI/zjAqBLHoJZETNskmh8QDvEqMyrkW3k0=;
        b=eoRGM4sxsLmob2EL7Gla5ovVj64qN5G6RhqLCFJ0reNwVutDkf2VlyynQykog+hB3S
         dVvX/AAZ/7ViACOgIG5a33Jz0+4/3HyNeGm++avrCNgEUsKu+jUlYRHeRjp2y20xKFds
         q8NP6CUW4+ZlmvVP0/fXdaoJdxGGkqZa42fRYErdBiQF7zAHURtuHgPWXlEE/I3sXciQ
         tmkVNZEdBVRvLGtvZiNEoBLD4NJ4VC5v95zttSTy4UvHDJQfO0pfStg0MwKqwLpeSdVS
         vg1zPnVRbva31V6A5j0RVZ0g2vpPUJA+MIwnM2L/58j+LCUSiBKyUJfeRce2a0kRtwbi
         QccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786999471; x=1787604271;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qPDq1Kb5UwI/zjAqBLHoJZETNskmh8QDvEqMyrkW3k0=;
        b=Fq6vmGFweVzOGw8YM2egv2DSllpRPsm6z2PIZkvcz5umABUgfJQsf9oqPib3kMPsLj
         etk4ML0bZfrFjiVFjuT2nOeEoe8/UA2ZuaW2CxWRRS1KqdSNoPqyP+L542MtOf3OzyJS
         sa9SnJiATtXgu01X9BF6i77GE298HVS0TnKXvhC2aQq9AT5dLC9KEUJHXjporpv0TLGc
         JUQykXfxIfr80tT8bnZe7OwMuciT1Ss8f+Qb5BmF085aXTbpm4/A7EENMB8HWFiXyDfU
         hAAqag6VE5m3V2BAHMpLIa0IKccxv7hvO6BMqAo+jRdpMCY1hIreR9aa1ZsUSQ11X6SK
         14Sg==
X-Gm-Message-State: AOJu0YwqUvV+yXNEjpI/3LdV7qoh57ksCKorqL8DzfomFFykotUoLKtv
	dQpO3VO5JRIYxt5en4v1QgqmrXs+5CE3x7RJYu8Eh19Idk6uC1EZBwkz
X-Gm-Gg: AR+sD13dw0SZklbnPlnpgFJwqBcO+yP7xQ8gyoetep19ZZXhrwSVoTGZA21gKjirfEl
	mVnafX+1ELXyKLrwsCDGUTnkrBSEOh7i1mcICQdTBSUzDpA30FefjNc59ot0FbhkRu8swCLIrZh
	lWmQ9BfbPyF+UW8amnkIaRdVcOotXVopwGiB6LFQfHJANrRJlxPyAxii1vDr15ZRLDrqrIJialv
	WY5vvjnbP5AXwkP53O2GCWVT3FPXE0IDD/07Ha8UdrDm87FUIaD3TuSeMJXls47AgS1wvnlEbpZ
	loTKY9R3EHNozf1MK8mM7XesITb0/CF7uxLB+wpWb2caUcM7Hh3Vn3tQFqBFQ3y/d/LUSYtHSz2
	PzwZz1b22+Q6wka0mWU9gYKNSM4waO5BjukvOYANmiW/UEG90vJDTq7gHvb+f1kzEjJjrL8YDfM
	VSdRjVpov40BKuyXP7Qk4hkvIy0xJPwGC4Nr9VNWEG1wNAx4QISdbVtg3DtV7L5lEMgV3aSLVRu
	uaJCAUoSoZt6TsoRONgPB57Fg==
X-Received: by 2002:a05:6214:4518:b0:8be:1620:a95a with SMTP id 6a1803df08f44-90c4b3f113fmr39253886d6.27.1786999471123;
        Mon, 17 Aug 2026 13:44:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c45950413sm16824676d6.35.2026.08.17.13.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 13:44:30 -0700 (PDT)
Message-ID: <989951b3-37b1-4d54-930f-6f8a34631887@gmail.com>
Date: Mon, 17 Aug 2026 13:44:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/250] 6.18.45-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260817132536.466235697@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 06:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.45 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.45-rc1.gz
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
