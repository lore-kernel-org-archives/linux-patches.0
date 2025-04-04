Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838A6207657
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 00:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743725246; cv=none; b=SEUfjhWjqMqPabolWozZoFcnIG3Nqmz3zyc54+wslcUsrv+tFbr7RE7AZLYqZ8bW0F0KG+ozup1SuG12qNLlt339w9BAPiuyUnJIrNYVPdPnE6aAKeE9XF/aVZHVUZhp1t2oCfAe8V8Jr/XaSNixN9NWrzP8biPuUNsiEA38siA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743725246; c=relaxed/simple;
	bh=wwpb9s8kG3kLPEw7M7GRVujwurSFOziTKoDed26JFQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YjmasIuTt9S2lG5U6HJ2asj9nZHyuCUSX5bdqjLjDlTZIMgD5AzfQX3eEcUDNNW6BH+5xpdbQFwsClGz3IY/gwbx78TLfZL3VkygnCH+CrGlYiIW5JegA3B9XNyXya3ECK5fnO9T59vNG16uCTHTyR+CJ3fZi9y7mMGfExB9bdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SBjivORn; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SBjivORn"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3f6a92f234dso853260b6e.3
        for <patches@lists.linux.dev>; Thu, 03 Apr 2025 17:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743725242; x=1744330042; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xinD1XJ5zJ/zFBRlXFxdReOtuK0q42vMXByaQxIVb3M=;
        b=SBjivORnzpARYWU+Wr2mTd7RHEuJjHjRvIWO8ieNJ/B6Vac9YgwrjbAS4PvhdAn8w2
         tXhJA41UwunQlvmeC/AYu6tURzjayBThj7LdSlMojRXUhZh1SzqozgljlRndyJRSPRtS
         BB4zFwkkyxEE2d+/lEjIHQwn18mpLguuLT1mowuwSSKx/AkU2XCBRY8msKMIG9SbmbkU
         vFc1Sn/7cTfZR5kwYrJFVfZzeEQ8Ha9yTkmyoicsDyqq7jj1+YfK89kDdMOvxNVkrx5K
         FrjFK9fq6yYTeDwhJEDphEYsnO74FFf3lKm3yHkWX9c4Lz4KQYL6aAtysiUBNRQ0yNdl
         pHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743725242; x=1744330042;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xinD1XJ5zJ/zFBRlXFxdReOtuK0q42vMXByaQxIVb3M=;
        b=c0YQmZhKPJrNEzrq9QdFtqSb0hjvhObvxVtEBFFzGVHp9nMdMd0p4V/P1eUPad2cI8
         PKuOlDdHi7WPl4TkHJTmNxKlUbEXkUsurEQx078nCCBYRI79O+aYVSQ30FBeR0ruuzf9
         tdYc7jJLnHcj0ioJSg04KCnuFDIlLCy7al4Tnsc7aVQUE51+X6fsjv4NS030J/QblbE3
         0PVc9OW5H9IxlhDVjLT1A9FuRvuYXOtVOzJWai8sMOxexnyQQDKjHbzmLnMzWPKQbvAN
         5WCKA5wpGT8fXwR6uPvyk0vwag50ymC+pT8WvtsqYsjDO13H/VwXtUCtLZcqqSC06Jer
         LM2Q==
X-Gm-Message-State: AOJu0Yw7947bMyZIcqOPkwlN6TpP7fw52vqJwSehBVOIfg02z7G+5tHy
	Bwq9Ox2YMFDZL529c8O0C6QvVsj+Ij0yqQoCOFR5W9ueZGbgUhVD
X-Gm-Gg: ASbGncuYn6yFPeHEuDJkKV3LYiS1P33yByB3RD8GZ7quW7PNHFnadozQLfebOVE5Lzo
	zrzPQchTz680RHwUP2NoRnGwCa0Lg/a5YqKB0G3khuWEReZHG7v9SGt0kQVq5g6wPpDIOYuaZLm
	LJJ7iw+DqGwlYmz1tljLCTUyVXa+cXq1lr8pXrqyuMMlvuu1bgxwahbaDx5GuWWetJMxr/1s2BJ
	gU65CTLy18cJt1PsOTU70fdmRuXpctDcCt77PTZYNV2HnGoJtxhJvZcZftWV/RgSUA2ro3t1CH7
	zuVBDE5E9/+VAzASc2kSlpJ0VTLb31b8SYhSGj2HPaF+cgsi+h2W+wovKAn73B58bVvD1u3Y
X-Google-Smtp-Source: AGHT+IExKNvOJV29wP7FfCm4xMdNsOUlULzTGuvDptMUeEJuGnrdYvDkZy5Z1OSbjeNgQVjC4l0xqg==
X-Received: by 2002:a05:6808:1644:b0:3f8:91d1:d950 with SMTP id 5614622812f47-4004564e62dmr774828b6e.38.1743725242536;
        Thu, 03 Apr 2025 17:07:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6040c4aab95sm428188eaf.1.2025.04.03.17.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 17:07:21 -0700 (PDT)
Message-ID: <fd60ac3d-fb21-4a90-85eb-b065f8711b95@gmail.com>
Date: Thu, 3 Apr 2025 17:07:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/22] 6.12.22-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151622.055059925@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 08:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.22 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
