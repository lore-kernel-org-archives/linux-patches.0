Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A4927E1C5
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772378111; cv=none; b=p/sETouYQFJ7V0BRSi506zh9RaDbf9g/F6UXJDm6LQ3RHCN0uVcWSds+svuGemTzNJ658NU66q7/O9pOWR3nAooJ9L3x6fWmuGK3zFDmOCCXJeLFsS5MTP0szBArIn6RMTFNvpoEgxY9BjCtIgntzshawOgZrnXH/9XPr8Ka1mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772378111; c=relaxed/simple;
	bh=cwO9tOE+8MirhEpgXP8lGH0Ktq2Yc4e3jnAjyAWdFzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F6Ln+QGo1eY1VXBgu9T6jbx9SMzvOW0ahUOLKMTjL5uJito3x/qVUKrAStkZXnqEuIqutzLkPFAPotik9mCaFP+BpHM6GfhcsLA8iQ6hbTIfht6sxEP5ZNlBPn0ZOQmiorxdzEo/MHw9C0/1DKY3tHJzFXzcKEz91ScoLudlc7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=MaMoMymh; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="MaMoMymh"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4399851b14bso2526105f8f.1
        for <patches@lists.linux.dev>; Sun, 01 Mar 2026 07:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772378107; x=1772982907; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x1G8+Os9t+BqCaUX3Sxcb5l9IVynJwal1EkLjI/4S8g=;
        b=MaMoMymhTzq93pWee6Dcld3Fz6TNdQBzkTVvBWmCl6pBFpAeFD7K5NZirvWHy5frwA
         VVkZlNI5sCbkT9thZrWe0ddW9P+iqel3OE5odn675/KVH/jdyvkKIWjQtAPHO/Qb8lOk
         OLoYv8DR72fNQsE8CXbfDr3GzoCtwCgd63K5sCx6sNk6eRowPyORUPZOYq5U8oKAl4fr
         0X7YAZHg7Ku64RNCyALyh0KEvkxOgC08BrG1paN6VZ3QtvGRatlvFip0Kp6sSwL3Uy40
         IlkrUCWTsrsRvdQhzBFg6mkkzeCg6EFLdif88+NhEiNZgq5vewPjJFjVfAJW9aGEluZW
         /0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772378107; x=1772982907;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x1G8+Os9t+BqCaUX3Sxcb5l9IVynJwal1EkLjI/4S8g=;
        b=fqykTciUFVx4joSHcIluQjiDA7ayHCkSR3czApgRwKILthHkvz/yTsCXEuNPQiDZVE
         9wbl33DpwVcOmkLoAZkS7xIMcPXfx+u8kTtkjerhfqDZZPGoyWSIwS7DUPR4FP3cQFw9
         75cOthFMiaM3RMzUWi9vxV25A859qmV45rTnh0TFN8jAuxP6YpuAUA88i5TELHv3T3Nj
         T+F9tFH6MX4I5FBprrG6KXnwXqjyBw/1Jt2fnnM6ALx8rrc2RCThhjv3mNNU2EMMzv3e
         d3Zt4ADE/vATyL4B5yunU0YFmAQ5g7KLnmZyA/LuRJ+N1gpkHrufn8PthDWwWhaoFA/w
         7DWQ==
X-Forwarded-Encrypted: i=1; AJvYcCURmMrTxU1Z3X5tMRBtn6HLnT7Vl9a3cELH6C8/WfA6NW+5kZRkR5lgxM43f6Oc4thugjju+Haj@lists.linux.dev
X-Gm-Message-State: AOJu0Yxziz3J0qdAEdUFVxBMPwiqbUdtYw5eKSiJXNQyWN5T5aGDyrxT
	6/KbIfE5KP9jdsqmZwfWImPNQGYTmtaz8DLPAyLQUVwu1tgwVdsBuHE=
X-Gm-Gg: ATEYQzyz6il7NCqhuDUNflCI2kUnE39kOgrXTDuNTvzrT/vaO5U2CMxhuRRfpKPvtBv
	9zsmRwi/iaaYq5l6/UHeXv/cA3yqTcA4gOp1KGEzUmrMfnCtK8zwpi3yEofmIGcFZJcHsjqVw73
	xmEBIePJ1LzZnZk0fpkqYCr+XDXPEnULm+aiz6RPCThVwL6DxmCTsm31cdBrtqxOAsVc1WyZ+OV
	nsIqotQXanqb+BcK6W9u16R5hTDYcE4lwzywJtsADTKV0iisL3KgO8PnzB8CnWrHh7kiRntPq82
	51p/vtxWE7HTWiIG8ABRK6X/4YtJ+Qy+RpjKPRmfY3KJ6240SOejV7MIW8uylbypyBwCWZfnkSw
	Cqk4UBWQhPjcdoRYCJ8fRaRteuqOz9cRlu7XayV4AZA3C6RQXsQY7IpJtI1tVuGoFj3El2kPZp2
	5dP3/QguYc03u4YOgKlBtQZD/9Lim1VzG1kf7AOQ5VxIJoSNmgBmTo+RytIxB+pH7g1q2qQWlNT
	4I=
X-Received: by 2002:a05:6000:220c:b0:439:ac8f:5db7 with SMTP id ffacd0b85a97d-439ac8f61afmr6264905f8f.9.1772378106539;
        Sun, 01 Mar 2026 07:15:06 -0800 (PST)
Received: from [192.168.1.3] (p5b2b446c.dip0.t-ipconnect.de. [91.43.68.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c60e40fsm21128269f8f.7.2026.03.01.07.15.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 07:15:05 -0800 (PST)
Message-ID: <055deed0-4b00-422e-8afb-5c3e577a6046@googlemail.com>
Date: Sun, 1 Mar 2026 16:15:04 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
To: Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 patches@lists.linux.dev, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, achill@achill.org,
 sr@sladewatkins.com
References: <20260228173244.1509663-1-sashal@kernel.org>
 <aaQriDS9IOr6tI4x@sirena.co.uk>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <aaQriDS9IOr6tI4x@sirena.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 01.03.2026 um 13:05 schrieb Mark Brown:
[...]
> I've previously noted that releasing -rcs on a Friday afternoon isn't
> good for ensuring coverage (this was what happened with 6.19.2 and
> related releases...), the same is also true for releasing them on a
> Saturday with a deadline that's very early on Monday for a lot of the
> world.

I second that, and would like to suggest that when a stable RC release is done on a Friday afternoon or even on a 
Saturday, it would be better to extend the response deadline until Tuesday afternoon, so that people who want to help 
with testing have a chance to do so without having to "sacrifice" weekend/family time.


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
