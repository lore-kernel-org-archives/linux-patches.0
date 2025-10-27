Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE0632D0E0
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 23:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607420; cv=none; b=qY7V0/5mwIeOZ0eEaXBzv+rZF0T1LqfgmKdZ/iukBZXzc+LwYosLb/USTpNEQKcfsnL4jFm1q6KJSAu6Xa4qdTOvtzTOfisyccYZcu9gi6TWH/Ip3uUMQtdIratpeZ6ofDhRETkrzJhkaRo/329WRMyU23DObOkPc6aDTTeYHSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607420; c=relaxed/simple;
	bh=bMX9jzNeBFXkZ6Y7HMFTaT/xWB1zBcledpc/9DsCuaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TsO4mbUQDUAKoKbWcr7EEG6xazzwDHy+sUGfhfJAXeiLknPdORtk12MJuemJ5DUAqLLAoyOtb0qgsJ4+Q/BVVTx3gc9oKB+qlYdACbPkJerUxxSdT3/gPs86dI770WCM8BI2KiSM5Dzr3f+WndjU7WkyEVqZLDNNvp0Q1HLjnAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=ZKFtf5uj; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="ZKFtf5uj"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-430da09aa87so25015315ab.2
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 16:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1761607417; x=1762212217; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oEYdNd7+OFAMq+81QLmV1d41glwOS9opiHm4I2f9DlQ=;
        b=ZKFtf5ujfjYheNllYlXqQg4GXz/7IluhHFm2w3DLu05uvM1eCC0kTBW7qQLRLJ2RY6
         peYe5OegPnTf4uOa4FecfDcnNt+j+qPu2p04uoz5ookG6s9GXhvb49m0EOD1TQIZD5hd
         vNOtcOdnaLiDDwuxKaGee0ctUXAs2xDVXxu+DL4DJcr7m727WE22GsgL9yUKlbi/nq5J
         j5sYMbNt53cjYOy2NWv+7xUBzKDSszMWGWdAOdqugzMmM1UMe84ehWSA7RMVKfUc0+y6
         4brIdJUSV/EjEffRqXJSAjeOgZAxMXQcUhBPGavQTPndTdYasu+r9/IydVBNCZEfDBfl
         ux8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607417; x=1762212217;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oEYdNd7+OFAMq+81QLmV1d41glwOS9opiHm4I2f9DlQ=;
        b=ql/H4epcrPP1A05sUqgabYYyjC3dGsRrQXQuN5+XER/Mc4yMJqczP9rgI8todHf9r6
         jvajBMqzQBXV/MMWj8qEUv9E15zBmmzJHl2O1zgP14UvaHXSTcU/TxzIXUWP/zLuFm9w
         zEuz4KNopEOmCLuJFTDrRfjCBPbpb8bHtsLwbGndpwN5eGuFE6Y7IAs6rHvR+FBYnW4S
         0kk+ZJlv3MLdkGM3gBkDHDMi3rSX9mS0hSiykVJkFYFiwq/2xOvAwf7EGGYgeJm91l9F
         dqMTRWj7awUJ/E8pOG9Xg1dOVvQXOaTGkuqy06RmgvEm4W3KGhR2KlJHhGKOBA8XziBU
         v0/g==
X-Forwarded-Encrypted: i=1; AJvYcCUHfcbTvQjTUhErJAxiEDUWVx/Ne/D19qHtRiQvniNitBot7IjYKA18vc468iWZdk9G1/MVteXZ@lists.linux.dev
X-Gm-Message-State: AOJu0YxGKzP1OApRVbU5oLDiCgz28Pu6T5d5Jrp5e0qN1FC6AGRxj+Eh
	DBI9UU//NbD9H2OsmEZ7Wz9Kf8HdmTbccYS5uEXAGxOvKIN0tg+6KANNCVnO7bwImT8=
X-Gm-Gg: ASbGnctMknNpnfAPwmkVE+E0DacBPeQGS6TTY5ajHog+QcCzfTovC/+8ZNr4P5sQWfx
	kg/2JS8kN9ul8ElOXaxQHQGUvO8U0SefIQze5nChRKAT32O8oGwdXjOq6PIR8v1LMIIV6XR5iIk
	FvoQJiuGUNEF9CE15gciXTz3z0TslLV2Qx3oHcrk6xRybZXxdQt58PzkCv4WxC/+3rQR0Y4NjYx
	jI7NIKoYnOL+ChlRdExuKh2egJmdNvYnHk1cxEXNatf6hmX4pX4n2lLYqn0cNoJKCTKzX6/dSgW
	7ubk23eZQ3AUjYnaLtsC+J6sA1gpSNGrsXnJftGdyNaDgUv8H2Pttrq90UC6YLEyicSpog2m3H1
	N6OTxA2i08J8DS5TE+tNp16AxZMX77EGD3TR2RYj80eNMz+LwGlb0RU/aSDwwMdkkplx3X5W+Bl
	aYHuheMTFPTDJ5CzA=
X-Google-Smtp-Source: AGHT+IH0ZPGnVVgtPdbyncjoeDuRW4QsW14xPxt5y+rrOlXlui4rOMIhJm1pDebe0CYZXcs2RVpexg==
X-Received: by 2002:a05:6e02:2586:b0:42e:7273:a370 with SMTP id e9e14a558f8ab-4320f6a770cmr23370685ab.5.1761607416707;
        Mon, 27 Oct 2025 16:23:36 -0700 (PDT)
Received: from [192.168.5.72] ([174.97.1.113])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5aea7ce584bsm3684302173.27.2025.10.27.16.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:23:36 -0700 (PDT)
Message-ID: <007900a3-bd49-4532-87bc-3fb7a83d6a1a@sladewatkins.com>
Date: Mon, 27 Oct 2025 19:23:34 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/332] 5.10.246-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20251027183524.611456697@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <sr@sladewatkins.com>
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/2025 2:30 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.246 release.
> There are 332 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.

5.10.246-rc1 built and run on x86_64 test system with no errors or 
regressions:
Tested-by: Slade Watkins <sr@sladewatkins.com>

Slade
