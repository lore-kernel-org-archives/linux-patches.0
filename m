Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9F5343D7F
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 11:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787743210; cv=none; b=qd2NXsJieW+ochluzUdCq+i5tGGKACq4TNRPZKlAsBiluE81IOrwgtRCxAdEwatrz3Co9aMHPwcjUyM0pK03Qnp/c7cYaBH1dWW0sg0RAfsFbONGJjpOxUvYwLaE+E3DNuO9YlLyObO9aooNzp1doboZdjueBFtdC/J8UE4sfdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787743210; c=relaxed/simple;
	bh=fREDOjC/rZzD8mmhDib12jsIj3RCLQKntJ3tQjInWlo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HkjLfJedqp5GBNLpSK4aRRiz2BKC32b7R6bsBlXSsUQv4nNQutr4HCIGSHux2WGoKeCp8M06UMBg1qr5Hk4c8FSyje4+Y+8Mxnn30+YL7doBCy7ljRu+BXoCYYzScN57q+43a7ELOTPHC72abQmDpB4abJ5EFJ31eTI/dWZVr5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=eXs68Yhv; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="eXs68Yhv"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a3efa2b38aso1489619a12.2
        for <patches@lists.linux.dev>; Wed, 26 Aug 2026 04:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787743207; x=1788348007; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vdF8Pu7WrYTwQxk9ZxP/oVuw63AUNT/7Y+iY+aB9HzA=;
        b=eXs68Yhv+/vkp8VIUGFnaElNV2+zwXeLpZAe5JYVdBXB1wPUMV5L9lkM6HEZGC9zSu
         Xet7TUt+9u/VLiX/KUo18fUnxwlVjwRa9+rabCpO54xojJtOCFgeAJ/acF12+6uAUrQM
         IXGznY+TwGJJadk/4+p4ncXvsPQnEmp7mPpFjkWTan7BJh19c03N7HVqu3A8ksiBYsCv
         gRMDrh0qoOOT4bOoovHKivOSlHDM3lMapg3LfcyLyxf6rsHn131xMOjpJYMLepX6d8CT
         dkN/IbJhqquUiy88X0lXxCCV71WZDdHxauTDhvRirzfMjWK0Gu2LFgRhCG7sIgaXKU23
         9JLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787743207; x=1788348007;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vdF8Pu7WrYTwQxk9ZxP/oVuw63AUNT/7Y+iY+aB9HzA=;
        b=mjNedb+mIqjNDosZc8FDH/l0yiGwJOlNYhKgQeDO3xNAUZg/AI8jJqxtV0Zwv7kZnx
         dSsmpGwY4QZTbwScm86lZ5XOs/G5Xe2dWOnJvdeycWEqALDu+ftZez09KX+aTLoA7Ife
         Q6ZSOXbm3rhoQMXe7ddbrbmo5O9oBF9PyDOiJrJAqOcxo5cMbrLtTnyXpogyzyzMu1dL
         Sowc8T3md9szBMnn5Elc7+n7pmUVDt9N0oBmFHS0PWhjvgZzanA4YSIP0I7QgIPj1PLB
         Xs4VSFjdFp2ma2EWS/oHhyLIQypbJeVxMIzcAqAmc4p0FmbcI0VUBrCJGs13JB26WoNo
         gFUw==
X-Gm-Message-State: AFuF++lUZJdBa85HVQOzJpE6CLNMc5hH23K88lZDYQ+0vxLDx87v3kfi
	2G/bEiooVSVelICJECdrSAwmN1kG8Mc8F6mZYLGY3vTZ4D2D7S2O4b4=
X-Gm-Gg: AR+sD12HV+p93BtmY55DMxtjNjizvR8Htg18P12dzF0cH4F6UzuPoruXv6UbGMVUIZX
	HY6HoAUy0a4fOuJYTnpxZ/P0rCIiusRjwVf+oXsGWEHTKzrdc4QIgoOe6eW3e9Nvjntb/Ia1LxR
	olOpHiay8TlZUpsr9H0gYqg/teinr7c4zR4nzHg4IiQCT5go2/BmiaCaXmJHORfAi9Ckv8LIEuA
	MU7jKpx5VEjERN3IIcp/zivPI+P7mQwJwi98ZsnOaFiEwVfv9LfXHo6oZ7M04hBPdNjyXvffXgj
	xtUv9TZkCDLVIUW8Ku6b79Z63NQ0pWR2FSs8W31Du8ReY2v8+qeFjCsUyPd3vC+boGPjawdn2fI
	Hy4uSeEJKdrN+LfOmVKD2NvjHjA6gnaJMZn8owQVFh+7vE/eHrRiz70+pQbSYmNDxg+Toq5SndK
	zB5dGUtM2YUrQQuF3xj0nsEL0u8+NNpCh9JGzuLTfvS6c2d1WCeOn7IRLTDsWhYg6H2Os44tyJU
	UX8EqigIT9IVeDW51F9dZJDmqPdF1xZ2WsYAvE=
X-Received: by 2002:a05:6402:21cc:b0:6a5:d58a:9640 with SMTP id 4fb4d7f45d1cf-6a5df61b209mr7656568a12.9.1787743206552;
        Wed, 26 Aug 2026 04:20:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace5e.dip0.t-ipconnect.de. [91.42.206.94])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a5deb030bcsm5163127a12.31.2026.08.26.04.20.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 04:20:06 -0700 (PDT)
Message-ID: <4ffa1d11-993a-47b2-90fa-07e1c8f623c7@googlemail.com>
Date: Wed, 26 Aug 2026 13:20:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/79] 6.1.185-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.677185791@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.08.2026 um 15:25 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.185 release.
> There are 79 patches in this series, all will be posted as a response
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
