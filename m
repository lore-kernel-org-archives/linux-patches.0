Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091C530B514
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 23:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772494040; cv=none; b=dHvrbDZRJ4s0KlwdYVMpysw+9IWPnY879f//UgA1MJB/jiICjJ1TxYylTjqKi3yK9REUWYnjbYl7woqJ1kFVo8j3gSDT6EbWklSXe8cnXOYQFyUKnvN0DW2Gd5G/cEkOeaalYDloN1IxRRRDJPsizi05eSfIE7AVV2V8X/9tQrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772494040; c=relaxed/simple;
	bh=U6V8Fel0bOcVeEQxtM0YpeXdQsoLB2uGqs2/i7w22d0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NZoYRv+3Q4pQpFFe/9xtoPqR4dJLu8G3q5VCiU974AgApdRyzd/Ab3elbk3KyeX0CIkGa0VB713UEcyPjdEwjQ1Pk7QnlUJleYp81DgxfxqqH/jGk/HVizq0oToCpyzvhNjCpYlUqdFsz9P19fuD/tCslhgfNbbwKXKQ50fcCWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=a38dBxg5; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="a38dBxg5"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439bcec8613so793706f8f.3
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 15:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772494037; x=1773098837; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DyT50lSq/TxPs3SvD7hUAadU9vPIFJe9pUjPzmdxzjU=;
        b=a38dBxg5dkQeEG02nzq5X5t0Ixi4ttkTRwTl0gXNZ6kR+FlEBE9R5D3EN21rIXrNoB
         3J9ZmrIg/EpE/WNtwomjKpFetlu5s6h9lTLsl8NTZ5tJYgbALdndTmvjd8JqnuxAz7aY
         lBupvujPo2WbVxic7dgHYtfBL6WSfEhhbJLzWxcpBcydAzn+d9DDuBouDe1ky0eCJfj+
         iRIhwX54i3Hruu8ztZjgfDoc8epencEOq6GHeAp6cJR2hASIhgW3gZ3hlkCk78Yk62hw
         uM/5+8Ls1g93K82m0T/X8yseoFUis5k0WZs3n6FaJcBAOkPQWgtMN3uBfx9yK8I3D84I
         YI4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772494037; x=1773098837;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DyT50lSq/TxPs3SvD7hUAadU9vPIFJe9pUjPzmdxzjU=;
        b=K87YiCWqjl8jm7qRMtx4957x8JLbewKp1SyhFi0z6bVmxLWWBIofoQJUwWE+a27cqS
         dmus2AMA++rdlZV8u9cryTtF6/xQuWWX7TXWFtgY1pc2w/mcx8e/2AkxyXtlTUt9zJv/
         y0uQEUaWW0n+oNSB9YqOuZzuejYjVl7US54ebskDD+Wihvy5LzTg9u1z9aMW7nI+hT+M
         zsTGQXJwTfF//mlU2Llevr25T3utr29ydNJLw8ccDrwJN5cPWdubb23sF3FI2T1C2CPl
         UZqVbU+HBDFgpjpaaJBckHukhbQ/IcBPGVQU8+LZFYZOjB8cUGwDeYYisb3J/XVVrzIt
         C0LA==
X-Forwarded-Encrypted: i=1; AJvYcCUsMpw/chI4nhNU2JTqAyqGUtkQmzsEg+AT3aCyG2rZtY3I2/8e/UR/02XaA8JY6vHwBHWDykWz@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/doWmIZzBbs/yqX53hDzKAm0nbHJ3bcwuj4WQtwT1F76Nafp5
	DfXyPJvBl3VT8nfhaUrLWRQIu8AzUz22RxBu5KPvLtfGMYVDrwPygd0=
X-Gm-Gg: ATEYQzx3m3UmghuXNz+8QAAhGEHps6bFNFpmArLGoJJWIcwDEcpASP9Ifnh2rIXuEDi
	2nwLIWHS0aDp8919uc7wQHS5ljMNpyNrbYphrS3Hd3J2ugX6qMryo3e1Px/dRgFdrFq6d+eDPDq
	Ek2+uihDms5U3FsJPxk/K6YIXDzQir634uroht3NBAGsGQGo1iE0mUrXEE9SeiQ0iAOMaLFpuYv
	OJxZmxkImnutrBuv0KsOojG4wRkEumfoRlOVx2ZDDAEFwYjry3CBVvDHXPLkUG5sxS9D/l/7NUa
	BxsqQC/+wHy9QXPaN3sy+5mXjeKdHkIlKXx5BT0AVpAiATAOCUqgzbNysolU06hX6RX1fXwvhJe
	+uPids0xRlgl+0r+4a+rRWwsEun33RieUBpIDS0hy4slEenp40TuIl59+TG3cP1jIbfq6p0CUJO
	JWEOPVaBsSI/kvX6ok8Wj1yZyoWOGkutpo/vNLHcz9zcX6hdPREGwZj8FnZqgmCmz3SJZ3vNuEz
	g==
X-Received: by 2002:a05:6000:26c6:b0:439:b79d:b9ac with SMTP id ffacd0b85a97d-439b79dbc35mr8579811f8f.45.1772494037115;
        Mon, 02 Mar 2026 15:27:17 -0800 (PST)
Received: from [192.168.1.3] (p5b2b433d.dip0.t-ipconnect.de. [91.43.67.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c60f764sm31130437f8f.3.2026.03.02.15.27.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 15:27:16 -0800 (PST)
Message-ID: <eab01aee-cf11-414b-b9d0-fec2dc2126f0@googlemail.com>
Date: Tue, 3 Mar 2026 00:27:15 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
Content-Language: de-DE
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160918.2520730-1-sashal@kernel.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.03.2026 um 17:09 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 956 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found. Again, 
no issues with poweroff on this machine.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
