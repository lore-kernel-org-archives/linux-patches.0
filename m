Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE9C3F5BF2
	for <patches@lists.linux.dev>; Fri, 15 May 2026 22:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778885954; cv=none; b=Iw0DB/jNnYUDoJo4jWbxTxfWev+kREcUdDSvjVjSHs4se49wR/MzEgOPrRrfuea7v6IZ8eIoBnOL8lKnvTZjpQd+1dUtWkBG0T9ftC+Ne++J/Vwn0oHp/D2TTO9iQdlcdz3pLmblcxG4/UtBBWrZERQP5uHz2gvddaLQv1uQyOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778885954; c=relaxed/simple;
	bh=36OVz3yTyMZDLrx/hKQq/D46VISxeIE18gt4d5S+aWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E5J6kWXgbUUmJqIDSQNB06BIQxQBEihSF+bz/nOTCRbOP1MiKCQWcllfeeZ8mWCdFaQKI4dksfIlwqdaDt3IH0jQ+aILhECf7zvrlH3vkvfNYzXjUl1/LIwmuxuHDhPyYSgiYN5+6P/ypjX+WGmhhCcDy1J/6tcTri7cdfLgZ3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ocm6HWr5; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ocm6HWr5"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso2270245e9.2
        for <patches@lists.linux.dev>; Fri, 15 May 2026 15:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778885951; x=1779490751; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v1Z7Gd507AlVs0q9KxG1L8hCgtq1/22hFcI6QXLL81s=;
        b=ocm6HWr58Rtnaw/zFlI4xsRyq45q7kBnJDSRi3HZMYYVNZpDaYUbqw2MU0df/Jjciy
         8DbYdqev4fhX6o6iCkPwaI8mUa4mICjazREw1ZqouACf9q9bmCm0HLW19psVagfSckhF
         1D/Wfjc9yKuzrkbqSMyeIBg9XlolrDYNFhLZt2hdmeFnuzyDhHfoW2dPxpjAIoAgpdOa
         tVw8SdiBVWUAJBMyeeRAZeYRAtb+xc4RRpAERtUTo3w+Xfof1JKB52/OO3m6nttMAan4
         RK8kuJnkMBbcFs+1o0YyCfH03dvNf17DQUhvZixOwR9J4FPr/MbkoyFdHYmF5wPZJhyh
         YlXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778885951; x=1779490751;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v1Z7Gd507AlVs0q9KxG1L8hCgtq1/22hFcI6QXLL81s=;
        b=BwCHLkc44OzHP+mNWC0YYKWB3dZaTw3Upsd/6De9U+CU7vaqrHC3vSUfeDt6t9NkAp
         +STmOP5907u2D/kdTi4DzjRUtjVRAhe25XyA2mw4Zs7szTjKuBFuMGuFHW9xa/vnKJkx
         YBKDekyc7l5xmgESdUCLzG/2lkKuNHjcs329kBQsw4aEQQ2/thET206hgs4CMsCcTmCs
         mybTOj84x/QvqQghMbAFOVH/HlhDSB8W+OKCsDmOVqz2qIFvJc2xPzRDEWKCxo9zXikr
         NtdbtzPC2ZptVX3hDpnTGrvt+Lqz1xL6pqImTYGRAVqZLrZDjLlvCq5fG8FrB7hhj44K
         SrJg==
X-Gm-Message-State: AOJu0YzYJDxyJ5IdX1daCqxrT5hABvWIB014L9aLmpQ420le7CdPfuS0
	DygArZ2mmq5r/DRDuZxlYo65dlKLbNRMI6kiIf8snSNHEnspNT3D3u0=
X-Gm-Gg: Acq92OGSf9+O7ZcE0t4f1UhAZtJUZkwpHryx2ngQD5Rrjz8V+kgQm9YDQhFFBSYtic/
	MAZV5zxCqgmJ87tJvqhvZcvWRP2ee7vNdXqqn7H8NSscL/A2KnsHE22L9DZw79mWr1v2lda0Jke
	BDPXY/yAkXVACdv8iZutXDWcEABecqQ1R1N2z+/Qcroq9HopinTHUE5niIyktKSa4usgPq4mYx+
	UGWWzr9/r/7aZ/Ih8nyWFCO/sjn/BRJl/1aPGlgB8VM8KLe1Wo97NiqOnwnsnwHzuZIcieTdYAz
	zfe/1uBTRgfV3z9yrG5S3eMj6s9Wq8SuppV9k2sitkDeeSX8Y8QExb22owPq3xgvYZWTAlV2Icx
	EHZswME13NQhPRYcuk8A5fqwle+NSc+euePfuyguwM/NUEr6WrcO30+TpN5r5hoy6oZkILBKOL2
	34yXlJKYB20NKmJJSwz7IHbG8WZ5NAGT2HcA0Kw8jg//V5aOv/nvKzZZOko9W+L1Bqvrbot1Y0Y
	1I=
X-Received: by 2002:a05:600c:5ca:b0:48f:e6de:1cb9 with SMTP id 5b1f17b1804b1-48fe6de1dd2mr48916965e9.19.1778885951154;
        Fri, 15 May 2026 15:59:11 -0700 (PDT)
Received: from [192.168.1.3] (p5b057eb2.dip0.t-ipconnect.de. [91.5.126.178])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe537ccf5sm90717535e9.14.2026.05.15.15.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 15:59:10 -0700 (PDT)
Message-ID: <a556e32f-c640-42e3-b951-fd0c1eda010a@googlemail.com>
Date: Sat, 16 May 2026 00:59:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/474] 6.6.140-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260515154715.053014143@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.05.2026 um 17:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.140 release.
> There are 474 patches in this series, all will be posted as a response
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
