Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1714D3F23B1
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 19:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786994510; cv=none; b=D+JNkKhtSpB7AIw1uYNcQJngpHINwMGlg5C/C8+/geEdBW5f6qWD9irXForIuVLbzZ5oo6dRpZGjnybUhjLduwDoBcKmm0ES/hxr1fVTadxQZzEDb75NHC+0GW2Ys5+ebnye7uPAqpiQPVItbh9e5cwmRxGtN599ZTZ3GdMHb1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786994510; c=relaxed/simple;
	bh=KRC5vjh9ZY0mAYTh/SgInP4F3Xdu2TfS7cFRD0/ai6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CoCNXICSOKnXmqwwWlrcWOboAjKt1C06Nr7Fu32SxSF7GlPZU5XEThgsugbUAJlAWMF5soL5dm0jkpickjX8yrh4XfzeXbSp7k24UdIW8oGJvS3ZmADpd2/4c7bzBUhrXAAXIfimT21t8tbMR+PIL2/jlf/N/gcpoXAPXjP6MB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AQuNcHhF; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AQuNcHhF"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c9cf07d2df6so2330503a12.2
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 12:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786994508; x=1787599308; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cM1SIZAjBdh5eZFlS3AbyknYyI3Q/Arjw1M8NUpX+ns=;
        b=AQuNcHhFC9R+xQxJMnguxvAdAEvCs12eTj9r0S9jC/awiQfw/eR1d9tjtzYFVWlD6d
         9fJXjYjVKBQS/SuKvGMhcs4KyMumkS8VhsNr24c7KIY/D5vU8IbyQ5nb02/rBeKc9mk3
         oUtChEkO5Kn1ZFMbqIXsd6jty53MXA0AIQcPWlw/I6x+PrvghxOtUCcdmZ0qzruoqvS5
         50Xn4WC50dpkSlQiZronFWzJnP7n65EKI6GfMaE/aTu9Lh5/j7E49t5AUVzoNqL3HWk2
         GnSzUKQtqCaWMCCBggpK+Zba2jg6iKFLZRF+oROCybvytGRBu0ZoXgzJZ0IW4fmkYSHJ
         TvaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994508; x=1787599308;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cM1SIZAjBdh5eZFlS3AbyknYyI3Q/Arjw1M8NUpX+ns=;
        b=HROCV+EJAjnmwfdV+2PtG9eAC2P9PcRJzCVzWk1E/4lu+7boYAXwhkmG91u6eBpRDZ
         Fd5BGI3MAJu6gT6vXG0QPQw9ISiz5XeQtVCKeU60GRRUQBCTzDD4z0z32INXlZmuhoaJ
         weSiD7G8uIXcJTQD+6mJnYOUzpv0FtlIP+abB5zUWx0oW6IvIZ/oR6LaU1El358MJqnH
         /p2VS19ToVT4MQ4Q5WOHD7asnf4+3jgGiw3Sio4FiYrcwiw0mS1tZGmP8zTm1iwVUVrB
         5YbPnHXYA9j5oo0AteWIjhDjjS5te5G8DjoouEcNPio+6K7dx+oUkFOLJD9f2XFy0xkB
         6qBA==
X-Gm-Message-State: AOJu0Yy0Hvqz28UYzO+E4H9bx1ZGMomH8h9556y4voxMNKHmRMhYJO2c
	CBd7QrOjvvDVAhE4k8uY/uY/mpnq9sqQn6d+Y/Xf4SF3FRqVCzVsaVkP
X-Gm-Gg: AR+sD12skDdZDoZIwVyOSSAn9vlgvceNnlAX62DDHo1oU05uVMk3UKFXM+hLtOs2oX2
	PDm0pKn1L2QVsrS9wNxoBBuDNuJFQwM71jkQmXIzYLaub1gV8y2ltkDSD3OmuiIMCLW19CiCsXV
	8DRLba8IB4Ma1z/h/wH3kFwKW2K/JxArWfz2MU3WmS5AC4mbpYTVz/nsPIc5Cljn6JFfMe/TD+8
	7Wpr/54pZay6nmcyc2EXgW9fNUug7hN9h7p0PueLgTVPl2RMbV3WcJ+8mSuaTGo205RCr15/mEX
	Niks1odyuQxEZULnAcpS0Q/oVV1KMT/3RnOSJDORVtvRF+urM8fB3Pr72GjywGfg8ZEoMovRf5a
	/OfwqcC1vwxRsL9M1SqyH9y17UXb73IJS+B58aqydipnGriGv1D1W7GYOq0Vc7gjDzWfnHFdQx5
	9d40GvkQ8Bb0LSydlGRP6qQ/PsBu2uagTXfkudkwqrWJOmrGyF4P2ixT7WvH67eqSAD5NnAbwaZ
	2XqsUmEx9Nz0oAgLuxa26iqKFo=
X-Received: by 2002:a05:6a21:690:b0:3bd:3800:7538 with SMTP id adf61e73a8af0-3ccda76957bmr2613010637.33.1786994508103;
        Mon, 17 Aug 2026 12:21:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3267c389363sm8404556eec.23.2026.08.17.12.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 12:21:47 -0700 (PDT)
Message-ID: <b3f3b342-5d4f-4e87-a94f-1bf1da7cbfd5@gmail.com>
Date: Mon, 17 Aug 2026 12:21:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/456] 5.15.216-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260817132539.792407575@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 06:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.216 release.
> There are 456 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.216-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
