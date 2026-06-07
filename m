Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DB432861F
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 20:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780864840; cv=none; b=nlqEYE7tN+1JPKbBJuYwY7Hc4QTnL3TtvbNutdw1P16H4/Aa9kUOGYjDpd/33UI/v7dPx9AsBCDnMw+oojOWikQlCk8tUNv6Uon538e1j9SAEaHDU6BcRlqQqdm3WLvtPyiAi8qXcU2sUENptGuMDvsB1jZGIc74AFA5BARS4ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780864840; c=relaxed/simple;
	bh=HgnHsq88qifEGEQ1MQ7Nxat32gA04kFpA+A6gHJ9QW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jHcvYqcdlONcFCCT1X0NSijoab3r0GH6qemt2D0np25pAthVh5Xq8lLbdrWS0Kh6lx84d6X8aVoE9kOkUNbODdjPjnOXTUg5xBcFihtsxvnKrE7RHEtvDHse0SDsh817ypWfAU+x0c5EGtIzb9L1GeqhHcZlz8zrugf2LymZIYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bgSiTpT8; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bgSiTpT8"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490b211ee6aso27494285e9.3
        for <patches@lists.linux.dev>; Sun, 07 Jun 2026 13:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1780864838; x=1781469638; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+J8fOsUcoDtpPxz2eR0HSOnaetwdRdpVEzm7oNXLqR8=;
        b=bgSiTpT8eeAtH7UlzYKnvSxt1/U7ptkafyMWVjmv4QIpYTc+sK2I/O+N2J0kEZdrX9
         zdjXmIb+nam+IvTefPD43aCmGFdxjeRsQBStRO8puCphbwmaYBGDhIUbqAWeDuN6xQ+T
         8HptFTZk2jD4jylYNwFYP5hFJ205Fw04FPQpKZM3GfabjT9eI+htKlnPTABPOu74HoHy
         dL9trv7Rs1glpP6U4GYl9N+7EOCVHqfHjquiL7r7/WGGhtoP5w0KI4I0iHv2DTJOZBCZ
         X3EVoKTyDG0qdirsvMi+/uv5OZUmQRzYkRBLukEXLWvhaiVMYH4I9VTKH4M5fFvumRVm
         WwVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780864838; x=1781469638;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+J8fOsUcoDtpPxz2eR0HSOnaetwdRdpVEzm7oNXLqR8=;
        b=tAUe48fZ6Ean21rkYBuChuWKGgVBZ2f70IMtKV1o+wYL6H6Jn7UHr10mIx2P/OgYVD
         7wx77MuPGiP4LBKd6UPkVLPXlXDTAKsPCFaPhriDWKFtAkiUyKxA8B2qTM6h1Nj/ompK
         rO6YASa7f9XXahhogNn3aRPRVxRGNCKKa1Hm6zygsRspTc7u4JfvHNTCKkQzd1bNKMt1
         dz0pSveWG2fv9Gv2BCVrfxGvsYwhadeqzCHTvD8jYA0jSQEjG/B3Zs+y6teJ17nYWw0X
         jtcl0L6U69UaveTV6MOLIG5kavpzWnFrcLXMGWv1oJYNA7KQ3inzDHN5L7cRKClBcs7k
         cNBA==
X-Gm-Message-State: AOJu0YzlSXExVIgsdJuBnbs7QbOeqszWsShNfLKvtcC5NDgV5uVmRMMD
	8oTr3+X4fhj3rh81jmfZcM4vS8KNTMGpl6+0xnVmbvtX3q1XuIP+Ago=
X-Gm-Gg: Acq92OHlHdd/cn3DVX1h0sdVd0zV9QKHBFeTT5bM7l9iTiQXFks0wq/LpI7BOhQmsAm
	TWJ1EuXKNsShwoyd5fd6Co/2FvjZHuDNsQUdMNmZBUi6sIjrtm+xXbXl36HIaV2aXV7Z63yGMym
	uFL72RgMSRDOwAHet76xL9oB2STO1e7JEDHddro8t7mzl01pKQaQ5rWGgGuP3gbZKknVSdc4RzQ
	1hbTobPB+isTSmzSJG65lAJRWByeh67HN5xDMR1p6qYJFJcDMMmiGZwGx+q/4zszO8mLRkWzl1Q
	ZCo9axlC+/YJmboe6EVo7ZtLla6uNku9VI5lfl2r87Py9H9n2KB4AjzLvOrPWrmanJxwKlHmZBC
	nDAWujgGraUir+FK6LP2x7XLGF8hJ/N7ieWguVFgZZosgtQkrpBK96mDl9SUCaexbgHXlAsQMJv
	4GfIgdwC/6UCOsr5RK1QfikjorI7l7Rr69wsrOUl7OOniCnMWYDLV51E+Wa3Kl6y3u5N2oNO3oN
	kjJBeTRRBJROp3DMsa06UWx
X-Received: by 2002:a05:600c:468c:b0:490:469c:556b with SMTP id 5b1f17b1804b1-490c257c3c8mr223173665e9.12.1780864837985;
        Sun, 07 Jun 2026 13:40:37 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b48d7.dip0.t-ipconnect.de. [91.43.72.215])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3c15cesm339829555e9.5.2026.06.07.13.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 13:40:37 -0700 (PDT)
Message-ID: <7f75dd58-2680-4d9b-855f-65792dd89082@googlemail.com>
Date: Sun, 7 Jun 2026 22:40:37 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/315] 6.18.35-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260607095727.528828913@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.06.2026 um 11:56 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.35 release.
> There are 315 patches in this series, all will be posted as a response
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
