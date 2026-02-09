Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CDA2D5C8E
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 20:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770669379; cv=none; b=soEbdYiL5P5sb16XAUQFnVd6OSh5QAVm7C68DObHb8YWMbbBxXd7vo5D/+hnXWEnn0DK4jhDD2HPzZyo3o9FK20CxGWl4nMyTRkunGyj4YJiarq3U0Nqr3QDjoiAtImK452RYudMayfZd6qM2z8TEe3TiGgBohTV2SPr97oHix4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770669379; c=relaxed/simple;
	bh=G5yAthuLMlj5VcCwLatzjyaRHf58IhoSZgi7XXRpJHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B6cbWtnxHBMWiAKcxBJZLazA9AnbmfF7dPG/OL/f8gzI47Ph4bNsPp81tv8/IsG709KwZPgalbQygTt+9ju3ZKGwFbrk9xThePnWu51wXcLZyR7woe/kCzlwG7S/8tqPj7DGa2AD/RGTk8MQnd7Nzr3rjcAXjNOgNzDrlL5HcQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=DuR9sOuc; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="DuR9sOuc"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so1325965e9.1
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 12:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1770669376; x=1771274176; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xp5mIgo85m3cPl5hAY6Tpwi0IhuWF4UQl9PiK/lWB3s=;
        b=DuR9sOucSdTU/mCAJVBiFikU4GryEEyGMnYaiijCv/Zr7bdvPeZa6BGTFj74lKqQ+K
         BbYztL/GZFEV1BaZLjUQPns1cRuMVp1pCm0ouh2ZnIMCgmkPrsDjKwc0kzeOqe7qC4eO
         L6fUvgFIjnr7qkyh+s3aSlG5Ynpv0grERh3QO9VY1+1Wi5+9kM3FhJvrk1/NtCcLGYr5
         ydy3eNIfSTKbCW5K3rjoXg9xVz8wa+AgGUdKWhDaoWw8NMlDVt1GD+CHoomHZUlhcUUh
         1bEGctJhoAsfyWgIkRxFzKazLXRBbGfO6eNknxacLfgdHadX2MZHVdOUNdLqH1/NMA8e
         vrFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770669376; x=1771274176;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xp5mIgo85m3cPl5hAY6Tpwi0IhuWF4UQl9PiK/lWB3s=;
        b=hWtjp4oir/9IqCbp6LrZPW9SjP5DBQ8JD0ZC88eo7JdjMjkkM6tR4vckG09TJMANIs
         dWc+9AiAaFrlbnyPLaNK6mOf9wlDYoB8etu6oys7QWMpDAdoXc7AnUVmEvQvCqGwdtfM
         r+FtfzHRVKSvegfsLAj926zZ0+ojTsf8JGoB/xV/2c/z5yf6QzA8FW/mb0R3wCo1kwQi
         mEVm1l2NVRio1tx1hEEBGpZ8F/SQnsKyvDkT01MjMXJ3LZ+4+XL+fHTgkf/mm2S1ONrH
         HsiAVcvtYD/TKZL1d/6BgGGN5YopYFqaeX6EYmW5lpMArdwYtw0XxKyl230qS/77iE8I
         7Trg==
X-Gm-Message-State: AOJu0YyjHEcp/vnirfVi+BVwTDzhzzsq5zdm7VWvpk5xE9ZssUn6+yl1
	cH4h+ZGd3/JSJxPFcOA/5IynEnLfh2nWc1DFIdy8EA8utkstMpkq6H4=
X-Gm-Gg: AZuq6aJASEL+3tAOneZZN0ivgjnkl0ca7/j+Dpk65FAI4C4qoVBnvs8n/Dfoko3hqfR
	cuNB+7kbZn4iQmjkCKKEigF7+18tmhEkiexqmmNcSwPnSOWcbSJOQ2MZtNddi/X8+rV+hvzlb9F
	Xelp08E64BuD5WaIYrY3vNuuSlNsj4e7ufkPQb1d4NxOQ542PPBmw15O9HSpXr0cJ7bUvNYEan1
	l64pSiu42rOerjdwe0V5z3iMOqXjMLwdzrxfNoSJlqrO2Ovo2wpvNy9RX8gkVI9uwfjfTxFoQhw
	zK1fd4pp1KBK7hi0uAI7zxUuqf9MXu1NV8O1k+Rri9zRgNZPgiKulyCWoxanbxIqeD/M+i/jggU
	Hir1gw7Sn3R2DX6rOYwc+kKiDIhtbQrfWGCc7ZzzdeoOwU/YC5LQZxM+8YEkvz9KJ0EXDtElvCv
	+OrxApnx8dcSNrGAW1wl6277zJYiirRLmRXEsvKzwb31hQVlEmRioQxOahnBORp98e1mJEAo4er
	g==
X-Received: by 2002:a05:600c:c05a:b0:483:456a:514b with SMTP id 5b1f17b1804b1-483456a51dbmr36417475e9.12.1770669376163;
        Mon, 09 Feb 2026 12:36:16 -0800 (PST)
Received: from [192.168.1.3] (p5b2b41e3.dip0.t-ipconnect.de. [91.43.65.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48323c12d74sm179764475e9.2.2026.02.09.12.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 12:36:15 -0800 (PST)
Message-ID: <8fdd9182-1aeb-43c6-ae90-3452f1a69722@googlemail.com>
Date: Mon, 9 Feb 2026 21:36:15 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/113] 6.12.70-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142310.204833231@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.02.2026 um 15:22 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.70 release.
> There are 113 patches in this series, all will be posted as a response
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
