Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5F81DFE37
	for <patches@lists.linux.dev>; Tue,  3 Dec 2024 22:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733265208; cv=none; b=CIoibIBQEGoFvQhxLLtkrqyw4RCXxECrHH1b8+TxOa+huUIL4U7GiMBHMxK+owgR258NYMoaVVEFt2GtZGO7OWkgeaJrvi/5zpmjCNLo276BsR/yFVMj+kysHfIxPe+gSoZa/ssUigj4UlsNb5ySV17VvQ90ElY+IiwNNOi3KDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733265208; c=relaxed/simple;
	bh=++BKE19X/423fa3Pz7UpJw7IzqNGkxSx5++yeCYTJ3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TYEb69uOi3A/g64eN9DHH1s8LEgUOXsNkBMZ4Qd4jPC9hX21weQuiillJmP+NzuPGz6sDXvHZ6k6etdW32VHSXeAyVuSQYFZiPISve++n3d/niEdocaW+vwhFFCAaK37B6jBm9cudD+a+h6gBUuDm4hlzJlqg8LXwbs/yv2AKIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kimYfdzD; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kimYfdzD"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-215bd2c32a6so13297275ad.1
        for <patches@lists.linux.dev>; Tue, 03 Dec 2024 14:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733265206; x=1733870006; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7wcwjgY8U3EHSDN0Cy2cHC8zHubCiLdno9hU9kCj5tY=;
        b=kimYfdzDKJ3VOKvG0lg9yIjR2ipBBxE5kh5ow9AakmtsCFSZ2tsEgJy64wzZZR7xLu
         3Rnnhw+Mv6ByKJBA6nDy5AqHWSXUS+sO7K7Rk6pUT0w3dzvMCF0nhBFecUlx2Eo7AUli
         NmDndCbESQvWR/fQo/ojoEw/SnvVe6LJzdP64TYN7V7NZe5xkhnHt+BPAvY/XRWsn0Ka
         pe5N+QDgyKr9umoVb4f4y5p8HgDuy1mvgVp8lWpSWAAFOCGTTD0sBRRqNw/q3teTbKfN
         WIt+wyFp6Ens/FPpIZE/5/VAeqhRCCIkSO1VtG1/yRiC1YhsYUU7KqaERa3/pRUVfeu2
         CyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733265206; x=1733870006;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7wcwjgY8U3EHSDN0Cy2cHC8zHubCiLdno9hU9kCj5tY=;
        b=S66BnreETtQhKB4SWrN3sNNA5GQaSPPj0MFKiP931YBoULh1RfzqEVmZ/cgJWjhMWj
         1m8tR3xCL8+vCIBCrHfF7RFJb9h20Sgw+SnWVh1QX+BPXXFILEHEo3pnhSHgGi3UPyDG
         Z7sWBIcBjVXivCv73Z0gAe2ZJX1S91i1TdEPV7xDgONvHEYwuR+4l0gfcpVV5rw8frAR
         SC3F+3Gyg6+ggPxyfyu0zgmfwlrbdLwckLUzjnlbR2W/fASarNCsGhh7E0NmgDJO1R1T
         6I7WigmlEUVLpTKPQu+6TZvSXzO/jhzb/YzUPj6HHGvbQd01C6KOsl1NlX7KCTanc6gC
         nX1A==
X-Gm-Message-State: AOJu0Yx/mr6q2yhrR5etVA4rkscGWShlBGNFt7m/wwuobqRDw339a9/n
	8Zy8AgQXaKGdan+fvE9Qib4CAnZ2ZQUTbQJb/cml8oDmhDDe4cKsKrHRpXnR
X-Gm-Gg: ASbGncuZPa97CQYLIcWHMY7f073yBays/alN3v46rrCm7qeQjVJBJz+IONCrHT/Ma/i
	isaKFLb5CgqUIY8akLOSeHrRUZi8ENhDEivFe7zXDFMGGVEPituGfdRQwChYEkN/bUGTtX9DM8J
	Idir39gS7JR2QTWe4Q5ubZ9+/Dq1th+clL+mjHkWak22XT+nwb2q2lMHulMRPo9Eg7Kg2Ge0508
	F/2qzONScy9vpl/OsDN/nWkZiHubZ2U0WxLo2rzRYJszkOMpD+WAYnERgyr9EHSyYfsevmi5+dn
	BA==
X-Google-Smtp-Source: AGHT+IEs0oGfVC5VfImEvCM4VUes6hm2WW7bSm0483Uh7U05zK1sRzsMiJSaMiBUQFNMd1oNN/wjwQ==
X-Received: by 2002:a17:902:f64d:b0:215:8270:77e2 with SMTP id d9443c01a7336-215bc423d23mr67233725ad.0.1733265206045;
        Tue, 03 Dec 2024 14:33:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2158f38c849sm43184695ad.104.2024.12.03.14.33.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 14:33:24 -0800 (PST)
Message-ID: <713b5871-c7a3-44fa-a5ac-5cf558be81c9@gmail.com>
Date: Tue, 3 Dec 2024 14:33:22 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/817] 6.11.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241203143955.605130076@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/24 06:32, Greg Kroah-Hartman wrote:
> -----------
> Note, this is will probably be the last 6.11.y kernel to be released.
> Please move to the 6.12.y branch at this time.
> -----------
> 
> This is the start of the stable review cycle for the 6.11.11 release.
> There are 817 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2024 14:36:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build for ARM 32-bit, ARM 64-bit and BMIPS with:

util/stat-display.c: In function 'uniquify_event_name':
util/stat-display.c:895:45: error: 'struct evsel' has no member named 
'alternate_hw_config'
   895 |         if (counter->pmu->is_core && 
counter->alternate_hw_config != PERF_COUNT_HW_MAX)
       |                                             ^~
make[6]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:106: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/stat-display.o] 
Error 1
make[5]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:158: 
util] Error 2
make[4]: *** [Makefile.perf:787: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-util-in.o] 
Error 2
make[3]: *** [Makefile.perf:290: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2
make[1]: *** [package/pkg-generic.mk:300: 
/local/users/fainelli/buildroot/output/arm/build/linux-tools/.stamp_built] 
Error 2
make: *** [Makefile:29: _all] Error 2

This is caused by 73666ad2a629ae8c2fbe3b7211ef9a56de4b5948 ("perf stat: 
Uniquify event name improvements")
-- 
Florian
