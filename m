Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704100;
	b=TS+m6uJjnx105FdGEapY1WxBsCFkcj4K6i9gxYSYbtT51+gqk5KTsYkG6aiOewhxsC8N
	 zwz3eHsD20YMBMsaMSjhmNNIJXcEpyAwoUX45+sEsDzbeflJCoJyvhTioY2ZeK0OYRjdF
	 1magW1ftmjljtss4iFjLSHCGcgNl+Qt4VRgUHaDj1Lxh+QrBwrSXH3xATfR2gH89iE7Kl
	 221dXCbCKB1a7yRZ9URX9C327Y1GlUtQ/wXcGl7wO7JwCs1zd63Lnya0gW+qJ5h3Qpuw0
	 gYB4qeTjzCwUsA6uedRu2lVkH4LMOC1XdS0Rp2GScC2cI5G2wziz88aMDvMX60tixew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704100;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=LpdDH3GEwcUlVHPK2yBSFsZGWkbH52RFZRnAmaJgBf8=;
	b=kvBCbl8lW3eYeG/ePV7+jbwqIeKcHRrwhgeMf6Z51iGWYFlbGN/KHqZrEApPSpnKbxQ8
	 VlBPHFNTC7MVv5NJg+5/N2jkt7LlyQ2AH6sbi4QsG7/dRnzr2nxICRvrD77bwTUzrxU03
	 CqgbisWBYAe92NqUREGyTkPX7y4zBOCqZrDPgz+6DyxbWClgXsvFwFybRvclhbXDgVc3b
	 8nFBm0N2yK1Xkg2ir/YiNlDfoE3MjrObn/UgfRcwkrchiulXFI+C7PagJBvbuS11YwULh
	 jh9RcWpA6o4pMBUMetRhomycF7lQOVAdhmuequXVEav3iW4ine8MZDXOds702xN5ffg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="uA6QYu//";
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4051606A321
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 14:41:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4051606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uA6QYu//
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2f04b676219so39610405ad.0
        for <patches@lists.linux.dev>; Thu, 26 Nov 2026 06:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795704099; x=1796308899; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LpdDH3GEwcUlVHPK2yBSFsZGWkbH52RFZRnAmaJgBf8=;
        b=uA6QYu//+KcQHnID8rXC5me/BrFUEMH5ztvtM1DKLJ4wnqqjFCRfD/WvqZ9SL4JZEj
         kiKQWhrUGg7gBjS+SoYWhPUJZJv5UXyClCN6G8B3nhlv2tWfVrz0MPG+WwCMNPuROC7G
         zEo/8wwM1iXCLBmGP164+1/Oq/PDnLC4ZUfDp+na3JXmZ5yIKTOmxoQDOwOHzj+SCjNB
         3wFYs2THbWPNuX1fOx27aymLAV0MM9CQU5r3KSqcd6Ul/q460G2jUWzqam0UnZnq/7XM
         oG6tLF4nCdd7CPx83OArVcWB0DvPNH1r3YL3CZXAO/4Y1ZzaGUPRlT/Jc16mpESA6dER
         3Bgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795704099; x=1796308899;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LpdDH3GEwcUlVHPK2yBSFsZGWkbH52RFZRnAmaJgBf8=;
        b=2T8O029aR5lWN79xSjKSMVjsD5kRO43jsmxMULqQsZEgtdVE/HetQZFVxvXuNvPOCK
         ZXROSyvZbPneQG7xsqOP2bo6NGnB83I0zbf89oDpIXHnQ7LkFc7RAQblYS7gxTBL43/Y
         cExWwSzJ21eYSwMLk5hefoN+ZsExvQoGc6mcMLUnwbZmjAwc4nEkY6lUixMyKhJYqyUV
         gCGwPJq9+V0rYnXSkYS5LgTxifEGRpAsQGFPexQfj2hx5+IvW6OXx5bXURA5ftYQeHDf
         BMZZfwcmc77Pj/B2GvQ24/ZdkdZV/ZNfHzM1lQSEhJRjsRG6EN8zZXiRtgU2l3sD6pgT
         gzcA==
X-Gm-Message-State: APuU4Z8tEshg2slRVrZw9e2UQjggPB0OR36SvtBwKD12vnxPKU7xR7Z6
	owH4WRYU5syUhwWwK2R0Yx2YotAY8ldCwsd+tHIPmTa7XxAXJjbQkvkw
X-Gm-Gg: AZFdTZcmMIF40rS4Q6XuCdBfhUMSJFOir7UGY8YQya5PeDMZraj33u7d5EThQMs+Hux
	U9s5VQIPw+hFivn81emCT3GBLTUnRlx5uqi8Eiz7ziqFWLJtYKo3bFgBFaKFBCdTowyv+tRniIM
	N1ciJ+NXwJJZdoeAbYOULE02cNFcpcyvoCwa1wpyA+vuDVZmdu7Q6YH4+fh2k4u1pz0ROsw268O
	YDqCVQ1M6OJ8LFtWbQMLfiHGTvhFxNYxtafK/G3639Xm0BxJoz4KBRR4W9ldMyEPNsCfhaCfWfx
	JoPjjhytEA6l/RHOk/Q870HE/h0KIOa02UEns/w2ppWu5hpm4va2KVgiX0rmdg/h506NkKB6QG5
	eC4rcxaSyLuHGbrGNTp6eCH2sS3AgduzWKuA4gvSmqb3vl/MQMrx62OeTODUxhhrJb1CH6fJhjF
	MB33YUhTsGx0Z/m2WNruSNZHk0RHg/ROVnvI+jeJATghwuonUjNxlh6tgO/et50j8JsMd07Runl
	850qIWt0eDAU2hrBvoj3U1bLZAHIKOcDg1j00HvXCCU5Wy2gIC1McbKUCAAHotF2AqCm+Gi4emU
	FwQiQDBMsRlSCtlCw7/nC8oq6SS7oNs4vg==
X-Received: by 2002:a17:903:1a0e:b0:2ed:38c0:332d with SMTP id d9443c01a7336-2f03f16eabamr208027145ad.23.1795704098961;
        Thu, 26 Nov 2026 06:41:38 -0800 (PST)
Received: from [192.168.100.6] ([121.144.254.242])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f10e67csm104457755ad.53.2026.11.26.06.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 06:41:38 -0800 (PST)
Message-ID: <b8ed68cd-4d8b-486d-b933-b1e093a403cf@gmail.com>
Date: Thu, 26 Nov 2026 23:41:33 +0900
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
Subject: Re: [PATCH 7.3 0000/1002] 7.3.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261126105729.110697432@linuxfoundation.org>
Content-Language: en-US
From: Joungmin Lee <leejm516@gmail.com>
In-Reply-To: <20261126105729.110697432@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26. 11. 26. 19:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.7 release.
> There are 1002 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Hi, Greg:

7.3.7-rc2 built and booted successfully on my system with no regressions
observed when compared to 7.3.6.

Note that the kernel was marked as dirty due to two
distribution-specific patches, which are required to build with
OpenMandriva's modified LLVM toolchain.
https://github.com/OpenMandrivaAssociation/kernel/blob/master/linux-6.18-clang.patch
https://github.com/OpenMandrivaAssociation/kernel/blob/master/linux-6.19-acpi-clang.patch

Distribution: OpenMandriva Lx Rome
Architecture: x86_64 (ASUS Zenbook UM3504DA)
CPU: AMD Ryzen 7 7735U
iGPU: AMD Radeon 680M

[    0.000000] Linux version 7.3.7-rc2-myllvm-gce73b94700e6-dirty
(user1@omv-zenbook) (OpenMandriva 23.1.5-1 clang version 23.1.5
(/builddir/build/BUILD/llvm-23.1.5-build/llvm-project-llvmorg-23.1.5/clang
0b5f47964323614ae2dc227f0b267ba43892bf06), OpenMandriva 23.1.5-1 LLD
23.1.5
(/builddir/build/BUILD/llvm-23.1.5-build/llvm-project-llvmorg-23.1.5/llvm
0b5f47964323614ae2dc227f0b267ba43892bf06)) #1 SMP PREEMPT_DYNAMIC Thu
Nov 26 23:29:00 KST 2026

Tested-by: Joungmin Lee <leejm516@gmail.com>

Best,
Joungmin

