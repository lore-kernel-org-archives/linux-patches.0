Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1482B3B530F
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 20:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785444691; cv=none; b=afb76ONfOeH5oW1c7wnP4oPbNVcGpLg+xyiD7i5BmGbg43qjtZpIZRaUUzEDt9V0sBYyU5JAGWVGbgmYaoWMLDgBc4fKbl8AbSTSz5D1RuZp+GS2Wykft2vISk8PM4D64TRXCXizelGiNpWSHiA+fIcFFE4N82cr1anVvROX87E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785444691; c=relaxed/simple;
	bh=3osKIOz71fEH7drKlZVQWfTV2HiUZP173OwTV9Tfi0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LwYlikppOU1ae3XaIn0paVuj5DYdumX7a8QtCV9j44rWy5+3fqu/MCQxs8zcUKlUHBm6RQiZd3MPEtdgeIhmdYOzaHm9vCK1+7mizAoouOaKsxauunv3e5XcOqeq1YX/MaanOYIQLmgIF5lRr659W4o2m01iGbAQ0dg6zbvpyRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=BtR9VYZX; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="BtR9VYZX"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so1456725e9.1
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 13:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1785444688; x=1786049488; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vT19L21SY3sGABPS5hjyBZGXr2hM71x9vS8xE1q/k5s=;
        b=BtR9VYZXcWnZtgpS7lyjU7sbqoGbJkTFGuFRObMVZFpBJ5QTXEgLKBpIROMKIZn+9n
         ZmhI7NtBThczzHbcPDKcRe1HyzSJ6A/IoA3PwiynJkmnauQOHMfmaSvyAngUVNq3UUQk
         3Fi4F6frQSxVPrNBwjwCLbYV4Vk9n2IiGy9lVtk7A34U8QH/BNjRoz56cBjDlC7531Pa
         92AV2YhV4G9P2Ll+gOOykXYnGXiK66I1brZOtaD4aIla2c+WF9Jk6eAO5BZPAzbfyRAc
         9ZlyeEQxhJlDa7v7QKO/AvvTW8jyUCw2R5F6cdE2qDmuVIFofw+l9YI3AZx5fsTJURWn
         tndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785444688; x=1786049488;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vT19L21SY3sGABPS5hjyBZGXr2hM71x9vS8xE1q/k5s=;
        b=US8lZ9uYjKiju8dTpY92v+6jUv0UHEx9tLCM8BnJX4pBbJpaRINYhrrj09hGMeq2mt
         l8t74tQkRQIff2BaJ2x+yx8vBGO2pKvPikqokneoOeCyIXk3CWdm2M6vUovmWQydV9eF
         ZqUqaDvghwwW025LIP6QI1UbxGellDg6dG5RYtMgdkNQmrRJYlmcj6qHD9gu8dpy2FwW
         lTP8W5U9LgcD/vhBS9PMfpAgVMKtI9g3k0Rv8qhXUjiMX033plk/iGdDCUi0ll+8JzP7
         WXVXjQybUAjgM/8RjaUHzvRhIWjQTWlvrXMrRlVk4cEA1DlNeVcFyddLmmjWqtMJMUWQ
         zAyQ==
X-Gm-Message-State: AOJu0Yy8PDus6NVX8YlDkY+EMPAYxVWgb8GjhXDJ6qBspEaD/pt0kQqC
	dpEraQKa/YZmfqkAW6S3n87fJlBV4MYjn3aZooo36u4Z7GLtPeZzFWw=
X-Gm-Gg: AR+sD1097Rly7KjufWtH7kuOmY/HhBqHI2rAddponN5bCBpKkIMhogT8goU1fAx/EqO
	Q7nuXlmh2RFSy/ExHlrmCu3h+CUo7x3Myy5rUo5/s7yE6HeEDzktDqD9CKf5Wd0d7T8vX7CS1bL
	G03sOPDlLk5ePaV8TME0+jEXhgPYFxzZtQsPeZh5z+63rz/C35fMvyKQ9D5NgFJvEoGEm8ex6zc
	nrzHem21l9Uu1KzQbf4ic+yfPD0rvsjY0lkwzuSom3DsenjIP9BrXCWeVqsRnV9D/K4uaV8oowp
	QcnIsBG2RttvC51q4Q8irWPNRxINtK27BCmBSFbV/BexzP5/p3cCiroXU/w1zy7oAMkKkDyBeCN
	sltzElqawRqVS065TUNyrD5CB22l5usKvMyLuCgVtmqEhOOoecC0RbhXhevN1zFBITCDwjhN52h
	UzKciv2UybShptd6+DR7kSli3hxkQUFp2tR9TKCt+ZU0FsrB0qbEy9HS/RMr5wPSeEwp2gLau1c
	vRWn1Te/TJ3SdRbaP8xIuxg4AwmsqBYgHLIcjvMI2UsDWhPDdPoqQ==
X-Received: by 2002:a05:600c:3b04:b0:495:4e12:6ae5 with SMTP id 5b1f17b1804b1-49800eae370mr58059455e9.26.1785444688145;
        Thu, 30 Jul 2026 13:51:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b2aca7f.dip0.t-ipconnect.de. [91.42.202.127])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-498010aae15sm91717105e9.13.2026.07.30.13.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 13:51:27 -0700 (PDT)
Message-ID: <2e8563eb-71e9-4487-a881-3792e791f47e@googlemail.com>
Date: Thu, 30 Jul 2026 22:51:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260730141444.267951807@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.07.2026 um 16:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.6 release.
> There are 744 patches in this series, all will be posted as a response
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
