Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6AF1862F
	for <patches@lists.linux.dev>; Thu,  2 May 2024 03:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714619617; cv=none; b=XTj13eXRPOHS5alEe+i8+6KfGzLPVR5bnLGYK11PXy5/nFdw3OaHctDv+i6OwIgUNbayHMSGX9poZ6HzBjalNKqV67EOr6FunWe+K7uwQcqFntZ+5a+8/h9DNV5YW3bgy9Gi3YlxB/TX2V0OgOoNC/wwNog6tWFJyleuvlQocwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714619617; c=relaxed/simple;
	bh=5XTfPr4IRbJ7mVGRcfndFaOJC4COJuxR/NwIjpIlx2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r/ISpzTx1l8Q7uPbVBYzCFeay3+CNpoHS2s6cPulFXcEQWV/uID3X1bd0nwjPE20mfME+2QkzCZ3PpUMoaeVSpzy3wqlBuaFLSqMnT/X71opVrr29E/5Rr/TAijtVovibFhPTlxm9ZZaFOC4mBVqpSXY5FLnj5a0mK6kkV6CqaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lvu+Oo3R; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lvu+Oo3R"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-36c6803570aso40495ab.1
        for <patches@lists.linux.dev>; Wed, 01 May 2024 20:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1714619615; x=1715224415; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LWSztiZ0J905gZ/ofKM8FZjwM5J8mddj2PYT/nPR83k=;
        b=Lvu+Oo3RqCabg/coGcI+kId/Rdawf/3TVx1cMip3War2YqGfbNtE6I6S9i/+5SiQYp
         IVaMDhRb1CPEbFlCeHgSOLmkBlVUSbwqm612/Z7kEec8VdpBIayfpbsUXhOENu0D6bmm
         Br5+O/EP4M46J/1O101aponkQfKh0wrp5Qj2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714619615; x=1715224415;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWSztiZ0J905gZ/ofKM8FZjwM5J8mddj2PYT/nPR83k=;
        b=ll29L+IWsBlv/xLV2FeH0RBBoW7LZMlvU9se34fRj2pFxnpim57WdicTVYfXSEADgG
         jCnGJSe4A3rVDlI90HsgnM70OlNwL6xH5ZWfbGGbErbux8rqkXu5bwTATpYEytgPYzl+
         LL7wgprIa9gp8Yh7Who9OiInorMaoWGvq6CVTzVbmhZSZC2WpSRSa5uKnH3s4elOz0zo
         DVp/oJiO5dg2Sw8gcjNkUgTznvs2061gbFETvhSoC7Gu1N8VR7+ahGfgpza1s3uS4qc7
         KgRtmyoCT977vTej0m5BEqugqsR6IebZ3vwLrZjPedBWf8eCj/dFmyegrh7I74S+P3Tk
         MZNQ==
X-Gm-Message-State: AOJu0YxMlWsbntX2ZclZqMsB/uv2aHKpoHkPcEi5VTLjj6pc3Uyes09U
	DHPJA0IfBQXg5ArSe8rfEJKJt5nJdqLANUjouiz9qJdmy/ytpu/5BFOvUW0oepU=
X-Google-Smtp-Source: AGHT+IGflx79ER+Vhq1h7akcsKhdeZmwayTvTxHYAuKOu0N6/C9SX0Nukp7IpIEJP73j4ChlCLBcFg==
X-Received: by 2002:a05:6e02:13a5:b0:368:974b:f7c7 with SMTP id h5-20020a056e0213a500b00368974bf7c7mr5573879ilo.0.1714619614970;
        Wed, 01 May 2024 20:13:34 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id m3-20020a056e02158300b0036c6bb70d9csm15814ilu.10.2024.05.01.20.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 May 2024 20:13:34 -0700 (PDT)
Message-ID: <e1b6cabd-adef-44f3-a4e8-739629037632@linuxfoundation.org>
Date: Wed, 1 May 2024 21:13:33 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/77] 4.19.313-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 04:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.313 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.313-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
