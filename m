Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6953F8704
	for <patches@lists.linux.dev>; Fri, 15 May 2026 23:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778888681; cv=none; b=VAYGbTXaeRSwdcietKNfJ8V7qezN1n/zc3BDqONcLaZ0QloBKgV9AkuQRMilPu2c+04TYqwrqMorKMfh+J+HJBmhKojxND/Ewc3GJUfg8sLqT7VLAjXsc4t3CVAemfvWkISUpaw3g9yj/oc89iAzxrux6W+yqWCTyB5CKd8PTyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778888681; c=relaxed/simple;
	bh=+oBfv3Oyi1cE8l+4UZm36ckNGUo0fRZSHoWm8MIjkeE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SdUkoPdDK71+7sj+sT+Njg2RDsCG+Yr9+46oBK9BuiquDQpbUP3MOeXnEl5fCBO12Cf5UdVR4l7PAKDozDXU6qhvWijKN08YHkWMAJNj9qMrLS8fUxae/lkWIUq07b+O/1WniFZVg27r9dWEeAB6dddy67JiL/6Jxx8GuT/NZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=B2i/4gEH; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="B2i/4gEH"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43d76dd4ee8so217431f8f.2
        for <patches@lists.linux.dev>; Fri, 15 May 2026 16:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778888679; x=1779493479; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uI/ZMRMMIVV0KXP0JmfSEWHkKDeeO/qgX38oN12IgDM=;
        b=B2i/4gEHnZZaSc/RFfczBaaOQLArbvVxJLedmSLPDE/QqwrojRiG7YB6x1+Xon/BXt
         CbAeLxqrITLmIBT9a4BlN4JWp8xXXMPC6iokz9IsB8ttSJAFwElkmSl1vyXN4Z8t0Kh0
         sYJQKAa4xYPmamI0rWF2D3+3eb5D28d1O1g1iig2jCIE1lScuc6yYJ3lIx+vTJx3dRwa
         U9OlytXKMb13LHQAXgoUyJYMh7iZuqhFEMLn3sPcApFirU2HVXWUXG0csJ9EvLk75gYc
         JYmfjv8HLIl2hPaf9sIuLF5aZZuieZecE0ekC5EScNDpVxU9ocG4lN3uygqaJNnH69ZY
         3i+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778888679; x=1779493479;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uI/ZMRMMIVV0KXP0JmfSEWHkKDeeO/qgX38oN12IgDM=;
        b=oWX37R8PmkyJIUFkRTUqOCHxwT13eHDetiRPM78zlA0o146iRAYo3FdQCkQ/EY9pqk
         iVoo4MBCDU1NSmI/2CIDE4SRT8Hvwhkgk0QN+ST1oMrghWNS/VRtssQ4CDTLiuw4Tki8
         2IckL8D/wmwayNb1JA4V1yJZs8u8iIMktpGBfJTD/h9BpU7QA0OYbmqU4dOIPDoXd2De
         EIcTkziqp5+zaKKjVT7GWOu5fJx9rnXFjsnxb49clPXOj9FC9OLO5uSQPz7Ny532hYke
         Am4tUMMIir5x9i9Qh9eNrPweBb+uvVF341kAXs7kRQzMh9iov66Xjm9trzgZjBnRsVrQ
         n7Pg==
X-Gm-Message-State: AOJu0Yy8iHDh9aVu3I4mhHT8DQpfsxiSY9jROqGm5dW2YtZESyXZg8SQ
	clB/tgzrU2NCYqi1J60Wj4AZofAwAf87JhD8tKzPINDgIgh6fDgm/xQ=
X-Gm-Gg: Acq92OEM7gUw72B5pQM7KuwBUEw/pEO8yMD97tZOLi5UdTVFLoN2Uzqizg7x+7Q0+c5
	y8M/akBh9/aWapmGBSTMy5JzIKLsdmWICsSs0eMcpNkAdd8noxREq4kfDLkj2uH+txEbiEMuB90
	iQOvW328JF+7a7GboNpHf90BzvHvnbdrgHAD5fFu8DOI/ay4Cv+ZOwRmP+mRO7czMZ6Ze7dlZAM
	w0dOcw5ZWTRRfhS3hCs9l23ST2jiX0F7/FGhept8Hm29DKUeiCNiELwHHSv0TxgIkTqFHrUCkDU
	MmP+BBrL1dgrmdaMCnQ50DpS8vsey5j9mYftNuHaINF3es16yM4VjUcAZ3+pW3bYuxsIBNIiSQf
	WuG9kE3U6ONFY2V4hhfsx1hsZPKOlLu54nvElVe3HVE65IaMzrXBTn9qu/1H6geqtD1ErrbC0wT
	YR4LyH90MM7KrNgsiXdw6acg1ZbTBKZHmnNp718KphOMqxtCpa3QUuhSv7gZOBkvAd/APJDqiXD
	tk=
X-Received: by 2002:a05:6000:4010:b0:43f:df1b:9e07 with SMTP id ffacd0b85a97d-45e5c5a5580mr8303821f8f.42.1778888678705;
        Fri, 15 May 2026 16:44:38 -0700 (PDT)
Received: from [192.168.1.3] (p5b057eb2.dip0.t-ipconnect.de. [91.5.126.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe248dsm17476318f8f.30.2026.05.15.16.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 16:44:38 -0700 (PDT)
Message-ID: <d66c3ef3-23c1-4561-9b52-3304c347bb30@googlemail.com>
Date: Sat, 16 May 2026 01:44:37 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/144] 6.12.90-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260515154653.469907118@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.05.2026 um 17:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.90 release.
> There are 144 patches in this series, all will be posted as a response
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
