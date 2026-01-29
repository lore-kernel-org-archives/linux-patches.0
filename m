Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E70872634
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 05:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769663584; cv=none; b=cbbjPksvWT/dclOkVNn9dHSmUbByPcz9tqzzfHzHwKgDf7twO4NpQ+kkVdsHNEVjpodz/O336EYH+s30KwW77ujPbogJCwckCZSOYYhUDYMi+k/Zfym0W4lLcA86Uf0J7itWrAXTnA6Yok2FRl2HjsnsnmuEpL3SpSGzcSl/TRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769663584; c=relaxed/simple;
	bh=twj9HVXi5JgmZJ/An+Ey9dyRnvp7b80/zScLMvpPeuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lrPSHxwzFI4CT1W47Zhy3pfk73dNBrQixomwHJ1Tp0czE0ETyklUydCCTh9ib6eFym1U1Mdl2t5u+G+wynN8YKJA/pzGxhAFiS6PwhUiluOyM++q1qIeAxCbeVy4RcND/JSLCjOE7xizALSv+NN83vT8JzUSWS+KyjXY8bXhiGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FSvtRxhl; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FSvtRxhl"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43596062728so970131f8f.1
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 21:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1769663581; x=1770268381; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2O4PzWrxGkpRsKO0Gq+hkTx2A2ETtTBfb1xW0BNp1LQ=;
        b=FSvtRxhl9Chb38vKQBcilf0tXXzBRoMXP4TgzAY7/j2Pt/EiEcXFHAS1x2X/0oOnkR
         WtsuAJ7SXd4BdyobV0Oj02PKHSwlzfF33ZHanIDw64aHvTyA6fpUxk37dXOsG34Npfzk
         HnVTNj9uJ2pDioA2tCf52UgDe41UFa/lCrGqcYt/C2zlbllcnIHKabB4hjotC77rncYn
         haJrggb/JnK3XmpgT8/kTKRj7tFcgRK9PiyV2CJR7YM2H9si8HAt16Q9i5kWRt6/1xBm
         Btruwcg7RMVvxctboOvJHD+58U9/3uWEM6domDx/TZy1ie/yaRi/vQvx4b+Vh3Dr2mLz
         f/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769663581; x=1770268381;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2O4PzWrxGkpRsKO0Gq+hkTx2A2ETtTBfb1xW0BNp1LQ=;
        b=YdUkzHcY/jZXuLpkY3qM7hY2rWA+FfZxvEdkM2wuFcdEdBzb0Qi+a4x+pYveRFP0cv
         1JfIphKikqNAbZsV3sYjGbzU5HI4x5S9c9k6cQotmySEz9KuQl1VWHMHWm/XRiCblPuB
         BW7hcokh7We7QeZZLKA4TQLjdzeI5TkDzLGv71WJrtlJYV8X7AsRnsqBnUN+yXacqdGN
         N5Bvg1fcl5Gi+6jXxNCKXhQ3uu2VGkI4mFSJ8In0SqSgr8DNSoFU2AyIlJg4EzOZouZo
         CdLFOW3zipBKxyQ26pr9FiLwwgF4GSXMg6M7JB9mQHOS/l6mHzz6u7aqf3nnvCtm34QT
         r2iQ==
X-Gm-Message-State: AOJu0YyGjNENYH9XF0oWvINkNjNLXTnpN6NkJyDWF4IYpopyy+R6cOBV
	HB4KKXRwhEBRoJcy1wKpKhi/sodCZy6U/zZYnLEJbmKAS79fADvHhn0=
X-Gm-Gg: AZuq6aJX1NPN9pVAQq5PZ2Avo6RlCDaru6csMGf1hayl6BZewBkNeoFQ8V9gX4NBgyw
	pkTvY3beuq+408jmLciB8XitazUmlg/5OYZg4RpRtzTXSiXT6I4ynt1lBvdOZAImWRZ7MJUHJ18
	BVIUV7/DAavMh0fSNQof8Lx3VkZIuZjdS6PIhILm3ABJkAdGCq2erwge+VNTOaSqfqDPODKgzct
	PQ+JIFSGW4roLcLGR+GoAdr6uC5Dj4BfyRFhMVhTDVbpQEuS3sNL9KP2hBB2fzuKeg6yWUoeHsh
	4i5mS5x93jtlwbHbgSANoeBBXfBitTpMgvvmesGP6ioUriBfUcF5thA2IfzGWzRRA2RlBCA69mw
	jGHe5oZM/jUvlY18eucmpgaW5u/fEWA2Fy49NZw4u8hI/GTL13yRAP38P3Gusl6RzCIZe+9Kt51
	9zDl0CHV/YHlLueSY91ifl++yVBpfbq4Pl3mACn+oJWCerFDzOWVj6BAvgU62Bwg==
X-Received: by 2002:a05:6000:402a:b0:435:932e:f924 with SMTP id ffacd0b85a97d-435ea0645cemr2263027f8f.2.1769663581185;
        Wed, 28 Jan 2026 21:13:01 -0800 (PST)
Received: from [192.168.1.3] (p5b057921.dip0.t-ipconnect.de. [91.5.121.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e135422csm12005090f8f.40.2026.01.28.21.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 21:13:00 -0800 (PST)
Message-ID: <2ff467fa-bfca-46ae-834c-7ad02a23985c@googlemail.com>
Date: Thu, 29 Jan 2026 06:12:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/254] 6.6.122-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260128145344.698118637@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.01.2026 um 16:19 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.122 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
