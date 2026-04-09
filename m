Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6D52DCBF8
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 17:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775756349; cv=none; b=qBbII4h5k6aGqJ/w/4XhzF6OKpUYqPIJSsuP+ruAXV/gWE7ECjpWs9B5/W7ZDypVDfOvxwgifseFjIJF37TTwK/SBrJWKCjl6WW1Q3/jCaDaC6uPqMUy7C8nbuPyrEbb5OlSFD+g6LKxVkrIYJoV0RWKlXfvA8pmOqSpK0iMOys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775756349; c=relaxed/simple;
	bh=GKvgfkfcj4HQg4NUelc654wAL8Mnaydk/YTIkAyjQhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QqX4t2kYtcGWsYPz3c+bhP1D/u/aF142V2CBwTbKA2XAmsYIgoZ41NMf8uzeJ/T1CTbfBQrYr/H4jpAPHiQrgvTaTLJZ03Ba6XoHi0GYVhefSuqH4VtoFSxjqHUz01erg08FDqBbxrvhWdUkaeaawh5D4QV7KfbTlpezkYTkork=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=MO8OonQO; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="MO8OonQO"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488d2079582so8129735e9.2
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 10:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1775756347; x=1776361147; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oGTNZ7a2d0nEeyyNcI7jhx5RiQvkCQG4QZxwBBVBlMk=;
        b=MO8OonQOocYlIh9yKk/g0m3vQ4VSXBRaXoodOpMIVde3LSPE8WKzLzuszXTC4hj5bz
         WNctLwFCnCAGPeDZ+O7c9/bpBVDZzs1Pyx15g3CEF/oyGO/MiyJ2I9pocg2t62UoDLHB
         NfgEXMSQ5/JRmgJCHD3NTtlR0wbraqx5NzFnpyZGZSwVVA8CRtp3VDuFhJbMSACvEXCC
         BjoWWTiZaRRUoltOZImRMX020N3t9aeSKBWByF5rMx3F8YZqQzO36cLFYJqDo2IgqvLp
         pAvmMML8n0urnDzQcAuyMjs9It5lBWqRcs6vpN0KwEd8dgjkyeqq16Za9+lqD5kZnCMi
         6rNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775756347; x=1776361147;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oGTNZ7a2d0nEeyyNcI7jhx5RiQvkCQG4QZxwBBVBlMk=;
        b=ZNqm5xyuQ9Brvm2Hzu2CoDPMRVNSac5mYr/0kpFVtvPdzKYAI0zaczA4UX5alvMmcA
         43QfZryKNq5+VMXXjOg3Gr+EsgcpQNmJSHjZYxNa01rnrdc1Z0LlLrwWQOqDZmoOEOmk
         JmEuUz4jzHo9w78BIXO9VSgmhcHvkOQCl2gge3kKZCUbkZvwSdMjJVOu6IB8vT66t0yW
         xny8QGvTdBSXGfdjKGj0JN1l0qAa2zmHc0BW3AD00UPO9/94oHCtx45rYN5S0NdX7Qe7
         4nkPpK39//GR1uqQjtF2Tnxp3VXOTnNBCwVe6Vd92fMf/INNLi6KIzaw4cqoBrjWVDMS
         AaAQ==
X-Gm-Message-State: AOJu0YzVREoRCkDHvu0YrpgxJgR9RYhVq0jCa3TcVF2YAVH93O58hnl8
	CJ3fizInePmwYAaclpq7tNGjme7PTpl7ZXhhzPNb262LCTRDgxIAIgk=
X-Gm-Gg: AeBDievIMOTbZRxfZQksX3n3vRSGnUDHpdyEwINb6TvjsDGtw+S9Gp1BATan7Gk/M0E
	1xr6KL4VeV6E5n3G+Y+oyyQw/lhOd2yv9MxkLRSoFuabEkcaJ3Cg/dyCueshAnQndmSOVCfYSiH
	trCm+f6mvqhePsx3iWfkieYwAMkeaDOgrvwaJraP1B+gVqAW9+Pi39XtxqjSC/J2AVoPts93rs0
	Cr49ebYq3XQ4+PdmbYBKWat8yxDAslVJzogRW5CnarH1KV7u81Qt70MObgDUmorzvu/EfZrpp1X
	FUQ9bun85eh27VYqeWuK6v4xiV/hMN1p5K6cOHyJk+v3yfVDo+yzqwFk8fGaSww1uUrVL/GeV47
	VMZtIE1v1MU/o9PyWXeDRzLAZ9PPWQTjHAG+EktH7YKkZC+mwHlyz9z5t4SInV+8k0HioGxjfHq
	8TFgk6qdZYFzHqpNAHw6Wl+M1t+JIJpCW1TVMOPw1uriHoozypKm5E7tS3n0lLMJYAp7xi8nsG5
	nI=
X-Received: by 2002:a05:600c:1d86:b0:485:304a:58cd with SMTP id 5b1f17b1804b1-488997153c7mr310683505e9.4.1775756346605;
        Thu, 09 Apr 2026 10:39:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b057c8b.dip0.t-ipconnect.de. [91.5.124.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5d809ddsm1099735e9.19.2026.04.09.10.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 10:39:05 -0700 (PDT)
Message-ID: <d9450f87-947e-4e25-a9e9-a608939d9043@googlemail.com>
Date: Thu, 9 Apr 2026 19:39:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/276] 6.18.22-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260409092720.599045151@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260409092720.599045151@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.04.2026 um 11:27 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.22 release.
> There are 276 patches in this series, all will be posted as a response
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
