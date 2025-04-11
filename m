Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4B91F30D1
	for <patches@lists.linux.dev>; Fri, 11 Apr 2025 14:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744381793; cv=none; b=lDus/RQnuZgf76zf9mFkWDavq3D4Wv8HdHnKdwk+GTFkWZXoxmnWhh6qmZex2M2C/YKEMEDMEtnB67nRqO/XCJA1wWpEZznM0+IQWvXstAbfLYiFBGpx2ywx2WXEXY7kcWTqizi1HII5dT0VnrvN9dXssLilzVxc/55hTKCLVTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744381793; c=relaxed/simple;
	bh=G+0nVYQRoJH4rJppKIhEIBLL7hjyhBhGIcXNcwUucIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kxsr+hOew17xiBG1Ve0+86GS4TLDx40nSGYqQ65qNLhRRYr35nvHFb6jKwWjfnP8+SuhzdvRdWRmTMr1KMejfNx2m53jzkJho6uaXgEPne8nIV/SPgN/x7ShSexzRjyOwQ9FMK4RQ36U+4vsbRag+FA9nBsvu649tiM8F6b6lnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ux/Jy5eU; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ux/Jy5eU"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-73bb647eb23so1861832b3a.0
        for <patches@lists.linux.dev>; Fri, 11 Apr 2025 07:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744381781; x=1744986581; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=P0B2X27Vy1PVZALJj52RE/yzAKgD4YWmN8f+MkQnKqE=;
        b=Ux/Jy5eUbT2MAEjoIpphQ8vr49+X71S/9GXXURUyT6jh12zENCb2oL5DQTM/7XLXZJ
         ZJhojXN8anqMFa5q5+RA1JU++M4gSeDDvQmg0kEwOLLzBzSmqCEd3XR/cTQJsl8B9o2F
         sghb2MPF8JYjzpv0rWi5loYz69SCK1kDLuJukvSGjuBItrZcEyddmwx6U0itAPrGxugF
         kXL96SuJw6XXdgt/21WeMhQbfi9EuojBZNd7qTgkxx3+y5gTHyDe033embhq3eM5s1hp
         6VdIZEzdgnlHqfkTleYrbZ7YJj7zAL5i4dbJ3UZyefJb0lJdi24jh9SWlvG/OfKDtc+B
         7mfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744381781; x=1744986581;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P0B2X27Vy1PVZALJj52RE/yzAKgD4YWmN8f+MkQnKqE=;
        b=VBz92O4NKZtf0xfXRlviHiY5UG+UJgt6nJDkOv5dvvptTOf2qd/hAthJNRlH1YR9Mu
         PH0Dt+cC8NSOlVBHzXAnV0nxchyUGx+DIKMzMons+TU9Xapau9z7JqTBwOAPvSuIdnrv
         NlxbZQbGQv6kVSF4f7BE3G8P84YhSN2Pjjo2zMSxg99up6yxRle+30JQXswAUlXrbnPY
         FXmZwD4/QObBk/L2AZdhtxYlzsV7hvjr9T8V5aW6WBhTH9Jw29hZzbeet0ANz3EcgeG2
         TwQ1k48LLmeyBPGOA4/bSXM/OvBRncetVPYrbx66d5qIEREP6RsHO+hfq0TAte+WOiuj
         KcRQ==
X-Gm-Message-State: AOJu0Ywj27sV7ZAfK2cB2ESjohx49Ba3/lpetYEPzqNtxHW9nxa2SVff
	g5k7/ysPwqBlZbE5bqBQa0Re1HmtjzmXB/OyoNAUei+h8UhbEwCe
X-Gm-Gg: ASbGnctwNc68f3yVbsqJzCCKRQ5Q211gvsGrvzp7jpKApqWxvWmbifewWJ0a8TR3PYU
	spjKBScsQ0S3Ymor/FoCfRBwRmBQLsCUR+zJ/U9HFJC7vFFek5xRDaxiq+RlrxlEF5sLWiUitQ1
	ktoZcnzucN+4gjzrhw/hH0kq86wyy1z3igjYTr2E4VO7zlBhTYxIzz+aFkXuZ10EXmfHiMQv2hx
	TpXm3EH5GjtXAUVZm1BXp9vrZlChcYQT5PjJ7X8eHSJBABzeCsIwHemHYoNHpaT+fIn3TxlgezK
	sAIU1qqFLGgwWUhUKm3bypmGz/Io+bqRYOq/4/uHmpFIO+8qCISsD7FsKCT8uI9/ENzPFAC2S5P
	9j2Qa4m6occ9ljQ==
X-Google-Smtp-Source: AGHT+IGAnZdXK8PXfdxuwTPTQNYwmDyrng6oztRepxmPAHYqxemSZWZ7A3RasclLiCfvOYTVVUh+1g==
X-Received: by 2002:a05:6a20:6f07:b0:1f5:8714:8147 with SMTP id adf61e73a8af0-201797c3481mr4195387637.23.1744381780848;
        Fri, 11 Apr 2025 07:29:40 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd2334468sm1540239b3a.169.2025.04.11.07.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Apr 2025 07:29:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <90288944-3f5b-45b7-ae7d-c7a54398db55@roeck-us.net>
Date: Fri, 11 Apr 2025 07:29:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/205] 6.1.134-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20250409115832.610030955@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250409115832.610030955@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 05:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 205 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:02 +0000.
> Anything received after that time might be too late.
> 

Building loongarch:defconfig ... failed
--------------
Error log:
In file included from arch/loongarch/net/bpf_jit.c:7:
arch/loongarch/net/bpf_jit.h: In function 'emit_nop':
arch/loongarch/net/bpf_jit.h:30:22: error: 'INSN_NOP' undeclared

Caused by commit e9ccb262b39a ("LoongArch: BPF: Fix off-by-one error
in build_prologue()"). INSN_NOP was introduced with commit 19e5eb15b00c5
in v6.2.

Also, the description of e9ccb262b39a says "With BPF progs mixing bpf2bpf
and tailcalls...". Support for that was introduced in v6.4 with commit
bb035ef0cc91 ("LoongArch: BPF: Support mixing bpf2bpf and tailcalls"),
so I do wonder if e9ccb262b39a was really needed in 6.1.

Guenter

