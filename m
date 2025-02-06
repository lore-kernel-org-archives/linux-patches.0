Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468F5198842
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865257; cv=none; b=iIdUsYhwWi8lU2vhoonXh27F1ooJOIZaiKTzfomK/JFWcWoFrRbm9Fxq1e2q3mAjV2ZK0le753zVC49aHlJiZBF+t9NQMowAaYn2N9qqAf6unA25jcxgzj+ViVcc4KKJ/2bGWtAgkRZsJfNSS6TH00erQFphkwdSdjQb8oJRfhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865257; c=relaxed/simple;
	bh=jMuvhUKLqZNm/NID8WYuGFhPA5+By/cKOCgJa0yRzus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J2PqghH/p3cne8I0BFu9xrUxbsBPULaXUsY1TEqQFJxvtjUzzEzLcXWnE1y3WFGNd/yPWvbMF9LOdpMV4HEEczFcuSXH9q7RBjps8qunJo/o6c2LJgngFJEf/HuFtuPtjnpKWKVZ3KsBat/DRMvjU3C0Dts45Lbz0mERZ9FTkzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=edr5h1g8; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="edr5h1g8"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-71fbb0d035dso749271a34.2
        for <patches@lists.linux.dev>; Thu, 06 Feb 2025 10:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738865255; x=1739470055; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=u/pJDW/eJDOfTkN6r44qxtsR0qaMVVuKMoOa/io0dHQ=;
        b=edr5h1g8U9a39ZvMh8r2YTQOhzsVRo0f71Dg8zxWoN59LYJb87zCwxA6GF7ebdcf2w
         JTm1CBiTc/uV5en39n0YjkUhYzX6jIImwzj9KTpfADcNWIMrA7848Ao3KitQltGH4wDu
         ghAqnlvZooPj9hClt/y2SCckDsjp3QcPUMVhIxTS+erxGctb+QfZ3CBxnpKGIAD+bctN
         VDAZyACALNtxEf/f5oDbUZmKYiGOUGIKVycbVCpFvr6Tt3lrA3kYYlhQFMXrMdBdOLJT
         s+HoM9fBA8felJXaBdzlwJOn6wDmyU89aSteHUY/mpG2kZ0Ks+p0OqjrnIyctFL4G32I
         dd9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865255; x=1739470055;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/pJDW/eJDOfTkN6r44qxtsR0qaMVVuKMoOa/io0dHQ=;
        b=OpkkRcv4N225Q4o48IeW/3TjUaCSDr9i7QeTOjPB0v3EHQGTVkxA+DiFSpLKxlGj4O
         dpqNKHhlb+wPjdQbjBamx2FASucqoNApy7DZz2qDpjbFcw2X4B7PB9ykGUQZ6e/KjkvE
         Px+0tU5JgGFA4VfbtxSWAv56wrhGFFWSjlkj5jCIl2VeSDQ5KCQ9BWzcfRg4HdsCiT0y
         cHZVeZ/MPYl03g/GxjDaZeeVbi2HUpQ1HrknWeUvZ/d/CTb6OTr63hlr17mxedYWH+8d
         HOT1GL3Vg1dH24ktxwUKk22tASGGGdw0RSYCswsbYWsBTDqGXrwWks+XQyMZVwz/YB8Y
         M/DQ==
X-Gm-Message-State: AOJu0Ywnd2pBjNEBd/M6xpWu3nqbpPMzU1BCRu+2cEPNuvcdXi6N94Yd
	X2asoAmyaR/lT60udLvRo+ctFJlgZ7CkZGUFQnj1RNBY5J8XhjLT
X-Gm-Gg: ASbGncv5ZaOtLMWP4PJYYYdnD4Vs3JyrFILiPGRqDc0U5b5nfVjktCmeKQMteJ7mNVI
	jQt5/YoBTNmp6SmdIgC0t4cGXvgKMBWbmPmnfvm6s6oz5P9xD9bJHbWicXc4pzP3QPJkmZxZWNi
	ZRwhy+VZ6nmQBNhtILD1TgyFxc1655Z2IW++pzbT1HHlPXa0urWqXpA8uCvq+M5/QBZuRxDbF2X
	5Ts6rtggK/AKr7cPUrA842Xd4THcrMSf0PliLWRsL2ykhKF6W9sMjzYX8PICOTNLaGl3XWn3ooV
	Xh7D5sJdYoGcrlw6CPluRichrOhMAkNwfcQ3HpsaBQU=
X-Google-Smtp-Source: AGHT+IFqiRN7vtbQnLqrA2aPCvxFCOAk254jjb1g49vcVV/z+6bJFQMSilqUf097jiFTU7wk6Xr+nw==
X-Received: by 2002:a05:6830:668e:b0:71e:48b1:ad28 with SMTP id 46e09a7af769-726b87b3665mr63069a34.4.1738865255036;
        Thu, 06 Feb 2025 10:07:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-726af914859sm397298a34.6.2025.02.06.10.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 10:07:33 -0800 (PST)
Message-ID: <6c11c5a1-872e-4109-a144-2d7e9f8fc60d@gmail.com>
Date: Thu, 6 Feb 2025 10:07:31 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250206155234.095034647@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250206155234.095034647@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/25 08:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Feb 2025 15:51:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.76-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
