Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795701773;
	b=06Kioh90ZSU6W5Bc6ip/ssoGjRfeI57m3v7Vypp+m6AqDm17lZjMaPtD+MLYsVSYAzaM
	 Y90r9HyFYsaqBq0RpZKhEFdF74Vi2kSwJ6wx7woPOy8BGyhygUJnd3Z5IYtMKSe/5Zq+y
	 J54ehXv/7r3hSFvOrbsEbpv/jPUlu69qRtVdXeBk/NTG2J7hznECmEC3mc3eluF/uPJBE
	 t/gdUyadfr42CsLxkuhfLjhoBVjtEgysbLZpqGez5tdvdU8s4ui85ZImoU4zWqZ6vofqr
	 OhqAdmR6Y67HIAInDrnW1MqbldoVnSS2sMC/0IChWhH1aR+P6UPSmPGMO2q5VpsN43w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795701773;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=lHTP7tK3RH+sk4NPGUbDTRffLgmU1INyF5ZWw/2WVfQ=;
	b=4nCFRvKk+BfHfrJ4GQxpVIZt2xBJBsvKCtLC5x+bMWECezToexdkUZXt368ZZ7dfKgiW
	 3OqOUWiNgyICVdmB3xmszFAkn8oHnt4PLbQUyTu40dOgyT8+hmhiioD//io4GtE4JrJWw
	 bcfaq48Uc5okufjrdze0GWeoaF5a4UBdY9K4pgTvT6J879pj0opycQYa4Z6dS7dt1eQiR
	 X8YZyl92QtymEZUSt6MYCrOW9tAqHvsmSnDMSUoEMv7cIKJ9g+QCrV/9HZWFyde9Lyfei
	 LE8tBNWDL+grJJeLawb9ypew2fpvUn/NZ70LLOrkiwnm339ZOLmRrjxhU2vx2gt6Wmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eBL3O9pQ;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69D2606A31C
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 14:02:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E69D2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eBL3O9pQ
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2f04244c3d0so56532465ad.3
        for <patches@lists.linux.dev>; Thu, 26 Nov 2026 06:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795701772; x=1796306572; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lHTP7tK3RH+sk4NPGUbDTRffLgmU1INyF5ZWw/2WVfQ=;
        b=eBL3O9pQ39dcIlHh/K7/Bc41dAp7EeIn50g9YPDitDTiDj90+U1zG9B3sQUgaPOPky
         gE/dB3MjypQgZ26fs6kJd+IiiduPdDHQtIq1HGpm4BHpQEG/7OKkuZOlkGgs+lrAeK04
         N233xKYo1u2kpJ51Z9egIc9xcrGNeNAx8Hxhya9E5HFY07xYUQmTok7XbtG4viTNoj44
         axEBeKM1etj51iLqFNH3GWqHBbzdBpdXfvpI1nCH5LHxf2YMkLH4yKlXBsEBWWApjAkT
         YdU/LoFooXysQKuC8huop+eo0epYSWMgWEd7T3LQb1Zpt/walFHUnO6gnMz0bozgdiOS
         A+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795701772; x=1796306572;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lHTP7tK3RH+sk4NPGUbDTRffLgmU1INyF5ZWw/2WVfQ=;
        b=B/UXq4sh2AMf1kLSL2nRLWKDEUQtUhEaPN9ub7zwhe5IKSGuah7KKo21HztePZ4iT/
         g3+oTKyFkW+IKp6U12437RcroTHFfywAl2uYpnS9Xk/LOs1Y4y44N7DDl9pI2i7dMEKm
         CbjiOE7OMafpccJ0X9dTpn7rSu8djuryevz3hy+DYhprDqOa+vfjqW84VH/gM6YfuKkb
         yQnsL+HmE71axy0e9jv07uO4Fv/Lf0hN7BwCmIQHrp6avZX+0t/Jn5nhwBGbSY+xfYhe
         YPksewNHUFWl+mxT9Lw5SGAzRLQ8zsfLrRVm07bX3MxZYo8HS/J6a/quM/6LJbrk2bni
         O5Pw==
X-Gm-Message-State: APuU4Z9UcVFztT0T+YgfryUi4Gx3u7Mai0XaieNTunEfXF9YYDO7QlHo
	jw4+L040huYT8/31t3luUlCCuP6D677egKn+uPnyMQVRpSTQHlzuKSM4
X-Gm-Gg: AZFdTZcKuqr0w0X8+WlAL7KW/55Dpw+KNwh1utarDCzAy7qINv+U6XMH1hSP5GfEdk3
	vSsQ/toWJOdqdxtyBnHtSkSxYchWP4ngpK4KBOd6OEXeFJ7LeJU3UH44f+vGy4ZKcYx/I1v6ju4
	/PecWQYjy9St6aBX74hzlvP/WexREb1HmljosvmjwTA8MACYIpWncwg/yLPW6pkngL/PCPBK/+0
	rzeGDnhHsODiatr284vKK6yGWWwdGzC9hGxxEPMUERGvV9MFAIpT9qkEtKPrjmNYhvjB/H4BVBX
	I+f0CEPGKZTACdEdEb+bFiOH3rxrUhIelMelpZWhMcAtxSrLhY0jOVeh8/Xmfwx+KVhRDPmNAl+
	t6yKgK98Pdqa8K2HlGeutie1nU1u/PfbGKPNyJgariPZkHwkn/yRT+GO11I6CDe0dBCyHQbc/Kw
	08+Z4JvzIPopoOLpZCZbfh4brSRdYCjH4/6+mPKlLoufC29409uN2hs64aiGor98XKLqjJxDPkw
	fSld/LY1wsi7CM/ny1dLLfny87fizmw2IuH9cvBEniL8s3IUz/YhejkKov5FXJZHJikLEp1B6S8
	43y2Av8eBLHZk0PCImoB2XqVzo7cbT9fE1o=
X-Received: by 2002:a17:902:ea0a:b0:2f0:7ba2:e9ed with SMTP id d9443c01a7336-2f07ba2ea9fmr155052575ad.44.1795701772176;
        Thu, 26 Nov 2026 06:02:52 -0800 (PST)
Received: from [192.168.100.6] ([121.144.254.242])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f120282sm103130015ad.59.2026.11.26.06.02.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 06:02:51 -0800 (PST)
Message-ID: <e0cf6325-d280-46cc-a3ac-a44a8b5b1ce2@gmail.com>
Date: Thu, 26 Nov 2026 23:02:47 +0900
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261126105725.767748294@linuxfoundation.org>
Content-Language: en-US
From: Joungmin Lee <leejm516@gmail.com>
In-Reply-To: <20261126105725.767748294@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/26 19:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.66 release.
> There are 990 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.66-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Hi, Greg:

6.18.66-rc2 built and booted successfully on my system with no
regressions observed when compared to 6.18.65.

Note that the kernel was marked as dirty due to two
distribution-specific patches, which are required to build with
OpenMandriva's modified LLVM toolchain.
https://github.com/OpenMandrivaAssociation/kernel/blob/master/linux-6.18-clang.patch
https://github.com/OpenMandrivaAssociation/kernel/blob/master/linux-6.19-acpi-clang.patch

Distribution: OpenMandriva Lx Rome
Architecture: x86_64 (ASUS Zenbook UM3504DA)
CPU: AMD Ryzen 7 7735U
iGPU: AMD Radeon 680M

[    0.000000] Linux version 6.18.66-rc2-myllvm-gcdbd1b15b2ec-dirty
(user1@omv-zenbook) (OpenMandriva 23.1.5-1 clang version 23.1.5
(/builddir/build/BUILD/llvm-23.1.5-build/llvm-project-llvmorg-23.1.5/clang
0b5f47964323614ae2dc227f0b267ba43892bf06), OpenMandriva 23.1.5-1 LLD
23.1.5
(/builddir/build/BUILD/llvm-23.1.5-build/llvm-project-llvmorg-23.1.5/llvm
0b5f47964323614ae2dc227f0b267ba43892bf06)) #1 SMP PREEMPT_DYNAMIC Thu
Nov 26 22:31:08 KST 2026

Tested-by: Joungmin Lee <leejm516@gmail.com>

Best,
Joungmin


