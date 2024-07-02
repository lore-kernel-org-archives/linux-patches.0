Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD29158853
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 23:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719963819; cv=none; b=CzG534JvSpjBa6uqj8TxQlBnjys23RoDiqtxAvOgidHykqMg9/cIxswAH4yNX1CfAEKpjQ6DEf6Y87vRLLoYcEgr1RBJ/XaOEwy8zNwwPNZSn+Jx8+a6Sag7H8mEe8K2+owR483Tvrl09+sN+PRqIommo1mINvHt+0l/1MEphaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719963819; c=relaxed/simple;
	bh=3rHOtTtX/eBgobiyISQcQyKnKhcM7dv4HpFKtMHXTD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GWD/anaGUO9DUi3hbuz4CsbOcrP/0MWBnxnGhuutixxbA2Fb/Z/4L9UYnfiMFlbqJOnbruzB2fFT7AXC7xjFU9JbeXovkhAMEl0ylVoB3JzOdJ8pKI6xcNrOt59eh6EiOwIvRAIkBTeUej1jvIywAiVscuhtu/dV1y6N4S7voXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcrZQnvQ; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcrZQnvQ"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-24c5ec50da1so693166fac.3
        for <patches@lists.linux.dev>; Tue, 02 Jul 2024 16:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1719963815; x=1720568615; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=exqubn+2LOYZAY1f3ejUa6v9hn+LU2tgQrcCMEUOeSI=;
        b=OcrZQnvQ+JVIYtHdtcy3FWv3ksyl7TXZa4Q1P5uZyrTOHEA6o2pXljFAg5lJhAwgSQ
         ws65lYOGG/zweJgIoBBVhZiU1TvU7nTxhsVeRMmLx029PHcTmuU3arLx71+ugrMUmA3H
         auN8S1WxD7BE8lr8Sjg9RkxlP5B/N2htezexs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719963815; x=1720568615;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=exqubn+2LOYZAY1f3ejUa6v9hn+LU2tgQrcCMEUOeSI=;
        b=h3aKp+uDMRMmZSnYZMkkB7XfrobE6BKOBurPvIzOLLXIjXds0Jpl2SGVEkZmr7kPn0
         GEoJjkmUPSgf2ZjKJj0e+YZ3Hpi6sSn85d799/SBQZDKGWXbAtq360Ij6DnZx45gIxfw
         D+cES8A/H7isEiZtudtvusF96yZ6zuqfiZ2Wyi+vfab/+KZwt7E91V8LnehCmf7Zzp16
         tPgTRXVcXfWC4kQSN5LayiNauBUaRTLER9bCQo/uoEuR67Pjrs9jgtT11SGoOUXandWp
         Pl9dw2fFTmPs0mhEnfbNfCXnEaBGJQgLwRy53RFpn68tfyrZGW15/1yx9LkRCxGY5GjH
         1hUQ==
X-Gm-Message-State: AOJu0YwLwNnBRgPh6ZdwruuOIkpYLfLwA9H+8rZe4OjK8RuSATxoIB9M
	nuCFMpTRkCcvc00KcKbtBq4UmE4/gG0pQv+ogzm+dGZcXP8qLRez9uSqYUojfDs=
X-Google-Smtp-Source: AGHT+IEsQU8oJU5zEmQD4zGi0A+8HyFsrUfkPPf+gpNjRM6jiN8rJ10aPicdU+U6OYHOdUy8GK4Vsg==
X-Received: by 2002:a05:6870:8192:b0:24f:e599:9168 with SMTP id 586e51a60fabf-25db33732ffmr10377174fac.1.1719963815229;
        Tue, 02 Jul 2024 16:43:35 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-25e0b696ec8sm118546fac.11.2024.07.02.16.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jul 2024 16:43:34 -0700 (PDT)
Message-ID: <948e3cca-c590-41a4-9805-fc8f6b43643c@linuxfoundation.org>
Date: Tue, 2 Jul 2024 17:43:33 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/163] 6.6.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/24 11:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.37 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.37-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

