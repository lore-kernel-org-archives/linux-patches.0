Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B7D1A2C20
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 17:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723568428; cv=none; b=hBqmAmef1zUoN0o077fsilUYj8t3of4EXNw+k5yHv/EMlCNw4IhiRzEIda9qYszOvNuF1bWndnEdQcniKstOiS3A6qKxTvARihbVvCiwjjTvaIvIYhFwD8BqKSphLpI3DVfLph3FMOaJnBnffXzHemuapYvVy68Fjbi1xMUY0fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723568428; c=relaxed/simple;
	bh=XIrCPo883vIf29bWB8QanLy2xFIBQjXDszmwWGqlqVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ESJ7aprAEDpcDMktfmImo4K6eILLRv42h3E9uoVeKj/JLXOYkxS1bcKTR5YleZnXQ2z5etl2Yli9zRU1uq9FTNRmMt5h+SBtKDNOfc33s6f5wg3njLJwuCkIQYjqufUsT526MlztHYGOnizYZ9sKHAhqWpKVeZmPQcAw8fPFfMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hREllwkN; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hREllwkN"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7a20c529c77so364360385a.1
        for <patches@lists.linux.dev>; Tue, 13 Aug 2024 10:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723568425; x=1724173225; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nuc5EsBkWIMusrD6s2rE9U/6OjYd0kLjzG4He9KIV6E=;
        b=hREllwkNftbv4Nl4KZxASfDsN1FKc299OzPrwEvtHFWCaQL/Z+umwHBVHYgMgDPtOB
         3nAcJIbuxhTQPgZSZBfsJRwAkyq5IrnVFk88Cgo1NrNa7W484M/L8uxW8AMnPe9Ps6Sj
         BJXdB7CTuzFpbOSGxUa0vEqGzhKakc5oE2Zo/nmfjQ2ZoJlKB11aw6acuaXQOX7ikJsA
         RUSlkpVnJ25upF2rkUDYp7MM1sDhIJ37+NGrq3tuYHBguui9yfWzX5V0orXOncEMClv7
         s0e0VevwEGWdJCZnrRj00B+4IXcEJMV2qSDYQQ6Xo3/k4Kvfnm9JhTJaUmKRAZQX5NI8
         7u1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723568425; x=1724173225;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nuc5EsBkWIMusrD6s2rE9U/6OjYd0kLjzG4He9KIV6E=;
        b=xBwZ+H73h56h1OqSgg4MB7AU63jiiMTCHuZOIe3c5bRgUTn3KxvkbvVufy2yTkAKML
         z78H98ioB4Y0MJv+UvRdva97V8ciHz87MAm2SAl/kD0ArrQfQCjm+Z3F65nO1rfadns4
         zBZC819GJg0BA2DtC09r1ttph4TSx5+cR8Qu+mJvAWLZdzMjjNa6Kf8Up31KmoWjOLLg
         2KnL97iJRIFx3bmtE9zpQZ+zjWqWb2H/w8A+qBtxJ2iRMPUu9QUyPMNW3O9CY6ncLdl6
         r1C8ax75jsRz3CPE98fDi83f0Whn61PbchDArYmE8u0A2NBIJOA/8LZe/U5uyizvJde2
         KWmQ==
X-Gm-Message-State: AOJu0Yy8DD3W7Mmj+fDlYqFl3C85VEke29zA5eeTYdjyLVodzUlJW2hK
	7J9p8KcJL3YAe1qSScxl/nx5GGoy5AvYp4n86K4x7mM3K6TltJola5Cnrw==
X-Google-Smtp-Source: AGHT+IGWbE9/Lv1hgrChzLrTS1+FSO3IGgIpwHA3XWmcPnMqO2SvNyb5132iSQqtT1xL/ONfqI7NlQ==
X-Received: by 2002:a05:6a00:10d5:b0:70d:2368:d8b7 with SMTP id d2e1a72fcca58-7126711863emr268087b3a.13.1723568414784;
        Tue, 13 Aug 2024 10:00:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-710e58ae59esm5987898b3a.74.2024.08.13.10.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 10:00:13 -0700 (PDT)
Message-ID: <8a34ab5c-00ce-4adf-86b1-e55ec2342b94@gmail.com>
Date: Tue, 13 Aug 2024 10:00:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/149] 6.1.105-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240813061957.925312455@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240813061957.925312455@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/24 23:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.105 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Aug 2024 06:19:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.105-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

