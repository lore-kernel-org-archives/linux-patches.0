Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE08C41A937
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 09:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784885168; cv=none; b=SIhZxDe1M7Jzcj2/E7LBmzLkDH8RHArS3ELWOatkSb33ag7gYsn4KX5HWiShckmP5MAtj8bAlUir7S2rSvGNnCSjKQkNjmoY3aaWqxxRkF/3EGc2znDrgnmtnvS66Q6dqiLinoW9bdOfVJkbL3AL924plXkVxH/yXvrkoGyFpHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784885168; c=relaxed/simple;
	bh=l6PN7eTClMmQz8WdVrL7d0xSZ6F8GlKd+XTA1d988QU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E714zzPZPV9Ia81A8YLd8T0XWaTEiam3QonC/OI/cN4bXYU0fDC6anNEhUDmMgtt0kQ2k/i31lQqwFZZRv/rax996oNH4koz16I668+hIWrfMw2ITA+oQTIqK1Jr9OY+/H/pxN6OIy25N9ocqgPbriF2DyK3GP9Hmsg3zZyBMXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IUP9dW5l; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IUP9dW5l"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4957eefd361so1952805e9.1
        for <patches@lists.linux.dev>; Fri, 24 Jul 2026 02:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784885162; x=1785489962; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5ZHKMMt8oTtwJlTUsjbOEuseImGiJNsLoeBqzOce+qk=;
        b=IUP9dW5lFT6CXK7Q34pXEHsYEsP5unKyX5RFqQZWRcBDp25kIUjREcv45kHli8VQMS
         oXXm6z75In8TE4ku+df530fUH+c6pv9E6hQgwlwW9P6wKwcDjt0VX+XrkdlQo1E2LaqK
         Uv3yHb338lZGuF1/jCcG50S714yyuELss5U/D2ArlIULHRShndQRAbTCzVu8h5qzRjBB
         y1zZjnxcYzobKNGQLxZQKe1eXEqvE6ZV2gdJO7jnvjIF9H6XDTaEzElvupcNK2NErAh2
         lJKIkMJve8StAoNTY9wLnoUNcdnFVvfIQC5D6iEzVUnywCUyWZ+GN+LIQdv3cFEM+rTh
         Z+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784885162; x=1785489962;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5ZHKMMt8oTtwJlTUsjbOEuseImGiJNsLoeBqzOce+qk=;
        b=Rvsg3PTlm6V5oAeeEjMSpCcaUXjx4IkFpSuRtNLKUCczRg1S4fqdNzgOGenUatMxpy
         0bwK0fiyYG/9kxFq30Yin9DTbKDNDI0bzit3jjdbxXyBSU9ardAO0Rpy7Erf8VHtDylG
         6HUZEAuN7OXjuzbG13E6Px7RiMV1/nrVOQSnNseHkUTl6nep3xMUTf1wZxxKQoLsJj44
         i+zouMuk9hmIB1ADkIZJaeptkNflzapv/vaIldVhuHDDR1G8PFpALV5/EkoIn13tFHss
         jtVHvBXyDXSpcSruEbzdyhpoXoWeIKxLqN4n7KpDHSAM+ypnHWbGDR4XI1SfMndjbRmH
         HdpQ==
X-Gm-Message-State: AOJu0YxoKClilOPvN9+w4epUyaOXxAW3baBAqBPqiCl9fG0RflOPldIw
	yA+3nkF6lSv1hwDmBGkh8Hvgjds1HRLQU3v9arYyt7xX+Rc9HVBfs08=
X-Gm-Gg: AR+sD12L9Hn4771h7U9h2mFD2M5nRHwJAnAOgELVZQkfLyeCpsEWAWvthE5fUYXU28Y
	26QORZNQD1pOn2aLhxbRjteFDE0Fu7hXXTh5NprxS2ksuWJdjqnYmZPilw58n0+sRT0t+m9j/uS
	Yi0H29hy45r5uz0nNPzHHWF7v160owueDlaE77yj3w0Q2fgmQfvsZW/v61lf50XGfxgSbW9Uhiz
	5CaFSTk+hR//v89cBoCPMla4+Nhw23RoKPoqkgVj7AwBBiKDfvx6z3NOR5F+siVrwAnw03bntr5
	ioMPS62+aZt8evQSgOjfqOg5S3PmhN0oGdMk2IA1Dm6R9PUXE7MS3fzmPadkZXtcjT+IzuNKvq3
	EIu7W54PyLwfJ2Mo/69GFDGd9MSpM6xp2Xx0uBOcl4DquzuQVTt3OyxW6/Yq7foKpkc2fEQmARm
	lSrNEYxkMDRCE3rg5zHpACtuXD3TVN4ZQVLNZKHJqxm1mrgH7lRM1Tzj/x1KPZyDIM
X-Received: by 2002:a05:600c:2d8a:b0:493:f318:3bc6 with SMTP id 5b1f17b1804b1-49573c9d709mr48196465e9.13.1784885162143;
        Fri, 24 Jul 2026 02:26:02 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b42c8.dip0.t-ipconnect.de. [91.43.66.200])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957af89be2sm66856525e9.12.2026.07.24.02.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 02:26:01 -0700 (PDT)
Message-ID: <55819d9b-7eb9-4ea7-b100-7628806c6d15@googlemail.com>
Date: Fri, 24 Jul 2026 11:26:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260722143258.264584003@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260722143258.264584003@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.07.2026 um 16:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
