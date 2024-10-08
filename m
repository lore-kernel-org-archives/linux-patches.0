Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DA12139C6
	for <patches@lists.linux.dev>; Tue,  8 Oct 2024 22:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728424993; cv=none; b=QDQmPiEPxELTY0Sp06UfD4PD78uPdTvC+T8/vWwf7J/FRLJ2pSAbT99/FjQfrdN8Gao3SAhnciIJ+2XSB55pvYuFi8iTL9luwH2I+8zPXyZucI6ESIjAaIdT19yACb3PdN9cYHQruyqZcVLuYAz+mKnz1iwzSdxFETEBlNZSIMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728424993; c=relaxed/simple;
	bh=BXAmuJ7ILq+rT+k8LO3lE0/nVu01ECozpjquJa006AM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=La0Kr9xDZh+LQ8RrkeNGFbMQzUKj/+O01xyfQKD0BWqrM6+vmetBu5klCHzKFnMIK/c+grcUeUNsC1imNrkmJIgBUEuiqZr4NhX0mow8B8m3P3O0wpqYdp+BTOqoeOFsHURKrVkUZkSJGEHMeQ5nPB14EfaZ5cRt95Xz5TDPELI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMWcXnUm; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMWcXnUm"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a39620ff54so1945455ab.1
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 15:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1728424990; x=1729029790; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8k/h1zc1if6v/PtO4/Z0OMrVugcpBclAQ9weFD2DFTs=;
        b=AMWcXnUmkK3mIQlsAxShFCbsn5czxyypV1hDi5o0GuY58QuN/MyRGRhC7KuCMI4yIl
         mUIWxhpEjlqlNIX0cyzJWgPGkzWIOXkC9GZgI7ChKC+qz5Yqew9x/8VzdZynGi/WHNtL
         68W9uS/C55qyZp5xYV3OUg9TupRit3vD8GdWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728424990; x=1729029790;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8k/h1zc1if6v/PtO4/Z0OMrVugcpBclAQ9weFD2DFTs=;
        b=aNbQynZ16pkd7uegPaW1b+CNxRPpasFTNDCcUI9ep3juXPp9JVdjL8t9T6dagYkZ0w
         h+92e9MJykaFHZIUvEenkSch1lx1inJGknqAKlD/Mj0xLSsOo/aUww7TmHNwTFQ1NAcJ
         9qBICIk1X48H3ClurCCWVW4OI9GWxLsTNYkxZu3Cv7gG2onC6mzccri5HoOxsR/sZmjc
         7XBlcAFjNFyseti10VdOeQbgRHFwc/VJEkes8fXDFckTryM/yemjwKcf5mYelb9h5R/L
         x8Xw7n5fOw2TCCSrRsn41k8GDrP6fPn6UlsX5Hf2Wgy9xsxhhCAZJ1+ckIHRws6pUYZ0
         ejsw==
X-Gm-Message-State: AOJu0Yx+x1mM1kB7s0MBpJoPWA3k+hqmkuXLAv/Bc/f3MFqz7uJWKvlg
	MAn/SzWJOKRJdKVKZNElEhfY4LUE8EW3ZvguxNLQpSNx39wjsHC5zmao1S8SJlg=
X-Google-Smtp-Source: AGHT+IEbwfQqS1rnCN/fqKqbgzAthDXhnK25PIZwnEuU6F500jfrAspi+MkyW7GIBwdWt2QIv/P83g==
X-Received: by 2002:a05:6e02:1a2c:b0:3a0:9a32:dedc with SMTP id e9e14a558f8ab-3a397cf78e6mr4402395ab.6.1728424990268;
        Tue, 08 Oct 2024 15:03:10 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db7db303besm1461620173.107.2024.10.08.15.03.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 15:03:09 -0700 (PDT)
Message-ID: <b1659a9a-66a4-4a07-a76a-31222bf8cfc5@linuxfoundation.org>
Date: Tue, 8 Oct 2024 16:03:08 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/24 06:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.14 release.
> There are 482 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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
