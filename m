Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864C0382299
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 22:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303974; cv=none; b=jW74Ym9ePIHfu6xBzrVykH14Mv/C/5H4qMGurYHfrgorDJrFaK6IbdCTMszrSAMteQ3I6yN1dkppNHjwKECER/0aUDjRoAIhyPZIb/PKzQxWfZC1AjHBJz5W908KQC9EgHMdygQsSuJgtvAfeRa0hUcrLCMu9BNfId9A2nrcCp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303974; c=relaxed/simple;
	bh=HseCfv+0/ipOm6FSJT5oqvK/wBj59MHU6UTscO70NqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h0qTPW5Va3P+RjjNFnrYANjQcwy7M8Mq1aqOE5O2siCTeYcWMxOv5SkXywpbWdzkNLtLqgIZYOC7vtFSrhBO5lqeHXTJMZ7Rdu2Ou3mtgbfsPo5/R7MUR70gL1o4QTSTqZkysky/bIcmERXVSLMj1K1oeyQ6dVC3U+3zwri5zqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yaf9E13A; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yaf9E13A"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-40f1a1f77a6so3309778fac.2
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 15:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1774303970; x=1774908770; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1n4ZyunnMns5vYFQa/Ch37HfVQD+w0TQd8emnrTKxBM=;
        b=Yaf9E13AHMqXzTFuhPzJ3xHsbdIAbA84BBIMVeJJBGpi/P0shFRO1/f02lFQTyoad3
         ylqFDtyitEh0AYMdAobzudSauS1JfkqPeaiydEQzRcoRGpfq7FR7pgGRTSzfAYd1e7qs
         VhjtfnAoCAdex0xoIz3RTHqSNuIMzFSmDp2Ic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774303970; x=1774908770;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1n4ZyunnMns5vYFQa/Ch37HfVQD+w0TQd8emnrTKxBM=;
        b=VKpTOxXLm9hsrzdXsTx5zz3PZwbjT9vPyQc9bCIkqHk3GM6WvHs+RaCyxOCSd8feYu
         tBh3Ym7aPl4Bcx2A69A9o4tIhBlMDIylL7u/Fau9LFCtowmMklRTFTPUDiajXias3rCp
         v8ZGrWlNQBVrLEff8TH1Og2RfSgQngKlJcvCAz0R4ZVux2nce/cZJNTpqYWlnGKDbCk6
         d4m14yp0ULSR3XEfB4ET+YjbBksiCbwB5Eu7zkGT+vyR8K3EAMi/irsVKq233OXiO21A
         kYEqhf/B5pyv0HQMYSMWSC6W0D9JH6nrfFxplPvncKR3br76hg+QTqXPL8kdNYLHlx6x
         HVeg==
X-Gm-Message-State: AOJu0Yzlc8umKuzEvppxI+SO3p3yqmMcyFfMinUwyr8tOL+eFpmPthg+
	bIGtbCjKhBJRSOZPaBeadp2sQgq3R8ZG0hHXsn3z3lebTAsBLWU4yVJuCggv/U8fztU=
X-Gm-Gg: ATEYQzywGD6eCPdST9s89eDkmI4IK79e+DU0SpruvykZm/dDNt/MbrzKQ8eD+LN6v1j
	pUk9byoeOE008KBoIbFL621W0IBkweJxPN7JEl88aWsQyG9w2r8F6M8TQ5q+UO2tJJnMO97TNvd
	JnZ5+WBHpFSTQw2UnSO0tf3z63BkR4H6sVADsV23sRAiaKaWuHurOOT/bj3P30/l5wOebwKRbjW
	hkYraC3UQEMDTL3ABOHDOauFU0E0Qea1PRKE26UTQcNShjNrDNhAIgVjuHg6olHMsNcWA5XM44X
	vHcJ5hEYCvroeVz8p5MGbxCvHM4llRN9lq3hvc52ZfQdlC7Hp5Yzz1MC99mppoJWwAvxQ7BbLg8
	2pG3f4me6NzRu7vjUmAqhy/M6es1F359Ilpx4carwjc46+PsCWpTLYOrr70e7z9JGuCTDdJbbeS
	VdVq7sjTVzzy3hZQKbi6a0eMh4Wx3iex1t8E0=
X-Received: by 2002:a05:6820:c83:b0:67c:2c29:216b with SMTP id 006d021491bc7-67c2c2924f0mr8673118eaf.48.1774303970461;
        Mon, 23 Mar 2026 15:12:50 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14e45213sm10643641fac.18.2026.03.23.15.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 15:12:50 -0700 (PDT)
Message-ID: <e74f5e07-7a02-46cb-b6b1-ffb7304f81e6@linuxfoundation.org>
Date: Mon, 23 Mar 2026 16:12:48 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/567] 6.6.130-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 07:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.130 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.130-rc1.gz
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
