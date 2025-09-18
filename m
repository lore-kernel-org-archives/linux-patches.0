Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD9728B7DE
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 18:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758219741; cv=none; b=bThfvHNZFq/zMt0ZOqY4N033cgwd62L/Uy6ljrwgEmqarshZCdegTYbALwwtAm/kLWi4Y86CRtKNjXF7I/XUX2fWe7IzcE6BbxmcfKOtPh9lVbe6UOZdOlUIFPbpwrbSfy/S1EQC0thKA/k2ezsTOwk4UDGrV3GodMp9BvXjJR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758219741; c=relaxed/simple;
	bh=rezYPpZz3X4W9ApFbHhJThBqYRrd9DvtahKpXyRXxlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bj6CfI4Xi7n9flsrL9jmf5CaBS8zqXlp9aUUmdDCdnv9iLy4dUNbGpqY91x6ef3j1V7aOglJQ7CnnTk53aIMMf/UqJse2FXrNEwdUt9LrR9OFp+5IlkrXKABkBMuTUwpvg1qdAkeY/Nr7+3KBB+tuOJ00SFSCp3EGvbIvHXIeaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PczCinKR; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PczCinKR"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-32e34f4735eso1296628a91.3
        for <patches@lists.linux.dev>; Thu, 18 Sep 2025 11:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758219739; x=1758824539; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BHxteDGNosyzWKc+zOp/6XpISmYb+dhvuSpnMwep5kg=;
        b=PczCinKR3siEfCB8tlq/NF2zhpVFIr+cZFSJwc/xlMI4sKPnB9ZIDUkx8UaUS6gb6F
         XY0jjJPbb1mn0z6u+RmzfRYSzWSlbwsSKo0TqeMmrODyJdSFExeJ6vtoSLVKwqkgEkQh
         u2Txr/FYJRdKKcs4FpJfZKtVbB0XY0yIKPHlyFIFM8zTJbFLQS8dWzBVpIa5uX/SUtd7
         klIcj3bXRHR/TZelZbr06BiBPVTn9wgBRKTyIeQLE7J+j8GpjutgAh0S5yw4g1clL5gh
         0jcZGigPZ2kKO49wDACStMu4Kxze8mMQnoMlpPglz6JcGyQWIVfZLd2Hln+I3bDujsHY
         q4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758219739; x=1758824539;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BHxteDGNosyzWKc+zOp/6XpISmYb+dhvuSpnMwep5kg=;
        b=TiL770K2WhgNvUjSnREoK5MzHdFhj4wjDPB5fHoCmjT119v8thDt00fL7UxdMdpjp5
         E5QPCdMwLJHrOtvhMWb9G/qceScxKqdhuKaxwuPDFI/UeD4wzGsoxFOz7KvMY7i3Mb7U
         eXY7FX+uUoXbmcGTsd+9yVhlU2Kmjnp4HLBCKniaGEfWVNh5L4wteXcZbuxRjS6RepMD
         AfX2bB1Mz7AbXVvPzrp3ckUGwVaif0eG214IEXMf4OmrJ8k4BiH0gDxhKNua2fAqCm9C
         g+12/7FG7oP0kUEXdIYNRiWiyHDtNCLj84ig5erKNijiRvwY8WtVl5nQi+B1ILe755JY
         0w/g==
X-Gm-Message-State: AOJu0Yzhp8GbRz2OR6zzIP0K5CWkM3z74yzpDV143DoBn54irANtqzxs
	QqVIYI9f05lPnEoVTReExabWSH2CUt0X42JiUMBxbp8x4/PAruXrKtW3
X-Gm-Gg: ASbGnctJMD+9FJ8RuX4eOXDfYd2dOG+wvBQONgpmaEdq7T/lTHdZ4CmwN5DbJKsKXhU
	E5WepyskuZ5WYs38HiaJ4Q7mo3V2fzJz0XuKQFsJag1ay/ycxqzozN+XjoAwwg3iE1T76wDoQlC
	FHd9kGKKQXn94r1mGM5cwPfqiVKZpYN005jIPg3xw2EnS7AUG2K6/UYSOlBU9WatHXdUOfnDNHT
	NgLfpTfC9qC26HKNI6xBAYpY6eVlkcfaWsuacaMGm235BMk2g2L2Xef84tztOensCG3Qv3of0vp
	e7bSY8O9FF19bBgAyItSB2tfj3AP5X4sOsrmb6jt+KpwEOwjyeNdUSLepWmRGmPT7u+MvlP8nvG
	Qel6iamTHxQq8TJyQ35bZURYUzNBH9i1JFP6HUsWWjYODu/Lx7l8ra5vMK6R7ltaSPrBIIyTcbC
	ScAQuv/zQ=
X-Google-Smtp-Source: AGHT+IE4MTForfXoRCJyi82LZstZN5nhOX6O3jVdL7jLH6I//PGX95RW3s/Me4+dx+KgwR9BKNHpXg==
X-Received: by 2002:a17:90b:288b:b0:330:88d7:961f with SMTP id 98e67ed59e1d1-33097ff703fmr443479a91.14.1758219739445;
        Thu, 18 Sep 2025 11:22:19 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54ff373ffcsm2928582a12.16.2025.09.18.11.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 11:22:18 -0700 (PDT)
Message-ID: <1560a94c-a5a4-4769-887a-23d954d7639a@gmail.com>
Date: Thu, 18 Sep 2025 11:22:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/189] 6.16.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250917123351.839989757@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/17/2025 5:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.8 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMST using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

