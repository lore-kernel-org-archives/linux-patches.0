Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6869D1E9B0D
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 12:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740141201; cv=none; b=ezl+r/Jwfn9wyk9CxJgcTlDfmMbRKeRtuuLzORDEAM2sG2tx4Z/G6JSdpuFyzHkVl0ps+AYZ5tsDaz8pdq1BQyj/r5Mc8Xtz9GnooTAG8kifrTJQoEfHI0PF+YJ4U/e4G4ejA3dJfCNwdvwcd2ZegARu7oAXf2U81GnVWk0JtWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740141201; c=relaxed/simple;
	bh=7h+xKsbMfStig+XlYD+UdroH+uVoiqQNnDneazl/cf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qWQVGVOcKfcMMgOqfX2MpeL6mRp/UiIQVwgYP9mv82KkqvqDG1aXYCCVQUeCSciXMe2/QU9wVtsNtAQdt8anUNrUX05Qst34RK9nUTq0LEjNatZOvhYxsfKb5pSZXBK+su13QSckqQVq2qtUxkKsFTAdxrV+mFyMWqXnEwiTfPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Q/cLWkYr; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Q/cLWkYr"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-438a3216fc2so19932445e9.1
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 04:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1740141198; x=1740745998; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ukGOvykZUEzCZzFlDm/VHVrIH7A0BbFaLwBfx+r//9s=;
        b=Q/cLWkYrTUj2ub9XMui7u7Fi/6JpRM8v4Sxh3osmO40RNBVC53X7R23gzhigo7UQcD
         z7KFzJglcplkPAPW3lQVTNqGWgEUaIBihEcB7l+WsjkGYTttGb8WKR72h4P31qTvLhlN
         msvyo3H6T12ah9d5H3OfreQVU/tyIb55FS60MbDUIS9d+C9zhGRI5akbMZzkd/+pE+DO
         /OXAkW3JjzfehHcpDXnSVpxfll92UO6pGngLaJX/uJyGxihNjBP6TBRbjfD+km9iJHMO
         xk7Lu5a9koxo4l12sIRuA5TxTwygDPHeMAO2IUcLYNlOq3QHJhJAYwKHO4VDieMAJ4s+
         S4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740141198; x=1740745998;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ukGOvykZUEzCZzFlDm/VHVrIH7A0BbFaLwBfx+r//9s=;
        b=uBdolZiCaSSAEHP3UIBJyS5ZagKQuHkMvIqs0BifDNAGpgTH8cWOivPrvklfQBfhh1
         emZG+Hzj5O3MQKUEnAcLkPuZcy+ytFAYh7qrcfs2UhubuOUCrQujx1Hq9RMnU3l6nXb+
         7deZuxsRCjGMbR5e+kZs1mp2EAOejIDW8vRZKO3S+C64GOD1Mqg9ZXQkFOURFtmmSQST
         iB4D5YWhS5xbA9IoFOSs0wwCAoK3PcesSN5NdvEL+OyP6HvxLMC2i7yEkUnUEjjDPXCO
         R+Ajq5J+idOoLqAfGCTmv07RjWYNiVxClL3mWQLGsTVn0o3S7XnCFpNoRduYXCaq96sk
         EyqA==
X-Gm-Message-State: AOJu0YwmWxxgbbrrZclHBkY9nPZllM15MBqX9dO11MEwIjP5Z2Kh6VD4
	9EV8a4ybehubSADh5PUPi/mipLSXPoo2WH+DyRlGbuSGUT/1gTw=
X-Gm-Gg: ASbGnct0SVZpzs++24LTZ9w4lxDpM5DJZXmKrx4rRwvvYyyumbkLfnVrnZu4E+vsKey
	B6Y/apjo44+jnr5ofmAM8OcoP48XRIifScdgvkUau+SbOlBoK3dzjbrjzeGfOWJx85ymivkJnpG
	2JFEgFuPOiyTMNeRmevINxYBgk/wpLwbQ7cj8JjwQXk09By2NGpOWX4sMvZGPt2eE6Pcj81yHfw
	DbK5l0idvzqmjMc8hD+jjbuKKTIU+2WiDzVBdeZVjB4rM3ta3S2c7bbAP4JLb5eXWth3BGGi0JQ
	MjozP2F/QfHqkerzOFqTs66xggtvd0JUF9pBAuowglNvnk8nOuSd2L7I3DLCht4hXD49dYxiUUa
	Gg1M=
X-Google-Smtp-Source: AGHT+IHi+9gA7iLuLNRjwkEHuSn4XLZGb306Rvq3LF2wd97SMFpiWRkCm0uOoyNBvbMFfHBHoywnnQ==
X-Received: by 2002:a05:600c:4687:b0:439:9aca:3285 with SMTP id 5b1f17b1804b1-439b6ad5cbfmr4543865e9.6.1740141197480;
        Fri, 21 Feb 2025 04:33:17 -0800 (PST)
Received: from [192.168.1.3] (p5b2b437f.dip0.t-ipconnect.de. [91.43.67.127])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f85c2sm24045464f8f.91.2025.02.21.04.33.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 04:33:16 -0800 (PST)
Message-ID: <9344125e-f18a-438c-9e50-535c7e5d1c3d@googlemail.com>
Date: Fri, 21 Feb 2025 13:33:16 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/258] 6.13.4-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250220104500.178420129@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250220104500.178420129@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.02.2025 um 11:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
