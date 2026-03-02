Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBA047ECCB
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 20:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772482355; cv=none; b=NnFyTE/dxdEIh4/Rv8vMAD03F3tbAomgfj3y7QN7zuQgH4DUptVES+jx3iulGnxHrkbtGh+5Cp6Vm5JoZcKMZa8gDJ7T2n6kq2LirMHtW7dADsZTWoaFh+oKSV9tc7gGNb1Lijt6iEhaheth8sYVVKh5cdHrTvdqs6bMbTwJBY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772482355; c=relaxed/simple;
	bh=nkQ4TOdKqe2grQHh2rFu9FQJAR+Mk8lyoYODT+K9MrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DSKKXYHBvK8tZZ77h3e36rTVu4IYzCr/WGsDuipuEhvfAJxtvOy2pt4H2qDAHcE5FmZMygpUV+fjgnqlvrtyuqSrKd2aIoR0c5MLDZVwTNA6/mPUohsO3c8Xnuy7VM+ePNJHW0aZ++2BF4zDk7LaaL8Cn6esZpdpUI4oZh5kJiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=L80M/2/B; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="L80M/2/B"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-439b6d9c981so1031163f8f.1
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 12:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772482350; x=1773087150; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CT6M+zIrjfi806RKghyF+8bSKG3Upd80TvSyvE6FN3M=;
        b=L80M/2/BygtKL7GNddubYFyqv04mvkObFP7cK5AbjOw2LUqdSmxIzBeEw2at/OCyc3
         ICqL6Bvumc78UWXIR+xHPkTv16+SnNBm9YKTLFY4ajEtluD4Nmt8NcxxTC2NW1K2ATaA
         99Dp+0+jxKbNbRa8rUvn/rLL+krD52VauS//fbPh4nwj6xKUco8saEWvA+/zkYvzQVNa
         ae8vl74a2AyG91sRIJeAhAaJ0xnhPd2r1rjE1BnToZvaO5xIgBgn/FB/e1BbT64gY83R
         tn7ko0PKwxHDyesP9LSGYnqXAgT8B1coyVIDCeG3dWL9qauiHHb1AB0CYoJxbQ5K7Hlr
         EA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772482350; x=1773087150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CT6M+zIrjfi806RKghyF+8bSKG3Upd80TvSyvE6FN3M=;
        b=xLFPyM2I5evCHx5T96aurYHV88keUDtm5Jqm5YWZWs3crUbTlYUKEXB/Pj04MYqIrQ
         3VJDc82sKp2nR2PN8mUMJlvzDbE5fNSzGFL4p2oE+VTyhTT1RMGltKdTFC65tzgNNT1Q
         XGDsb4SpF8Iy0Oj1NQb9Yi3hPeGlbwXgLCClvsHpgpir2r+bLNeg+bgS7v8QFiPhK99S
         RSibedpcuGPofdnVWekaOHZ4vqt2N+e+6YXU2+nY60Ctp7GqAqNosKMztsc1my8dOTsJ
         9bk+JqHlvrpEEQeOEJuoMNj/NyYrwQ9woTYV/wEeIIHEGVpkEehhxic427o2Nw6CAtvg
         wtqw==
X-Forwarded-Encrypted: i=1; AJvYcCXDZymM2aHY9Y5DZ4VVFvJnaI/LO9OLXgVWqo69AAvU8p4fg/LCEc5J9AOibTJ8wtC2QUuNZ2tT@lists.linux.dev
X-Gm-Message-State: AOJu0Yyu0Il3PWfFGntSUYJ+r5cylcUFoPVGeTlFWWFfWV21MwDiXXfa
	2iRZ7ipdgKpPpqiwnUhAkcq2jNc1Rus/YNnAMQ8W+4ZZqvY9DVFrz+0=
X-Gm-Gg: ATEYQzwyLaupr8rTjBRzowj9uX0Xh1dSgPJcf/rr3oZnsTsfkmDpCkIlg0gcx8rV+JZ
	nB+5owqN4A00Xy7oIBQZkfScP+qPNqFVjcY38aKPH0+ioTUjqcuErH4yLy36SJCvUvew8G47CBF
	fw7Miscj1Xv5NeaMGX5FgY+lev3d+PEjTECsfmQzySx1dMvo9iCGPnK/5X3TFwMsCzGfo2RXZk4
	nrmyvcGyUCs4KVbjKzaGkrWGwNAnlDDnnELOypbJD51g7iU462uxq+nIECRWapdUVt+FExQGhZJ
	aSRkWzD//6Ggzv2Et2MNdRIxHYGNU8hGx9rWmKb9YRq4dwPvt72tFVx+QlMTpTnx5AXm+tWqp4u
	J3McEwcYdpBF5HKoJ2UBRtvqx3rlEb/umnYAOTpCzfMZSR8JesR+L99AurwENpgySunIQTcB8ib
	BS73XQYLOjLlgWDKg6Dwc5spTBFsDN7vK2/1yV+fY+CBq8h0P2PF+OfE8DazA4CqF3GV9/6d10m
	QwhR1RJAy7L
X-Received: by 2002:a05:6000:26cc:b0:437:7300:eb1c with SMTP id ffacd0b85a97d-439972042b7mr31329041f8f.26.1772482349654;
        Mon, 02 Mar 2026 12:12:29 -0800 (PST)
Received: from [192.168.1.3] (p5b2b433d.dip0.t-ipconnect.de. [91.43.67.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439abded86esm19125732f8f.6.2026.03.02.12.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 12:12:29 -0800 (PST)
Message-ID: <2f3484dd-2259-4a7c-8798-0c38f9dff22f@googlemail.com>
Date: Mon, 2 Mar 2026 21:12:28 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
Content-Language: de-DE
To: Brett A C Sheffield <bacs@librecast.net>
Cc: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160943.2522184-1-sashal@kernel.org>
 <66461c13-1bb3-473c-b57f-adba9db4f756@googlemail.com> <aaXNiwFkUEy8SaTm@laps>
 <abe2fb5f-61b3-4597-b27b-c6c61f5efc7d@googlemail.com>
 <aaXpH1EiNugoQwaD@auntie>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <aaXpH1EiNugoQwaD@auntie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.03.2026 um 20:46 schrieb Brett A C Sheffield:
[...]
> TBH it would make life a *lot* easier if RCs were properly tagged as such.
I agree, and I've always wondered why it's not being done this way.

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
