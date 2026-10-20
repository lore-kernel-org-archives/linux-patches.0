Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792521010;
	b=zmG03qbrcoY0apalPX6k6S9qZSD791dMuRicia8L8v8rIQcVl2fHdhUgECm33w6KhwsC
	 4GWsMRtL9cOobpvloerhJRGtK7cUSKLwWgQ10RWnAwqKmAutD3iR5oLx2bLqDNf+ifQ8w
	 aStLfKmFeEHWUhV8l3t4NswGmHCc55P/hqZjJCzBaYXR98WR7VmKRdj1BeL50fMv6FxR+
	 4G5dfnPWSWCwMU+3pHL4sHX1pcumS0kPxJEs75x6vugI0vH7csYehi1wXtOjiH8+NV6Ze
	 l3Q7t2EyFX5HfOsv3inVv5O8PN5CLHUhS97bsNIAjTTD+0gzIJ+j9emnMY1S8XYYmSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792521010;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=g9NG/WDjidNQ/9hryLb6uUMucaHueMCbu4TKIHP0Lys=;
	b=ZIfud+xeaCFYtf3iBD0SfzmeKqY/jdDBcTF7hMB+GWLfZyxRpZQhGaGdu1sD0GUd6BKf
	 Mx9o6b2uJL6oWuejEvuVSo2D7Y0ENUDzmueoBvQ5j2gtHuLVlP6aSfORmJ6HAN6xTN620
	 bZu98YkdDdBI1lRYZnuUBUp+dy1hoXYrx6TCxlBA5xKZRAOBQzlFtdiTODlVAKgX0i46a
	 Igyubq6FbaB7GSNO2Sx38fPptvhbgsf3sB0oC+S3f11bJqhrx8CqUMEEfLG/bsY14QqTy
	 luIQJIgXr1UzI7k3575L4d+BEHNXQHDrnp2+VyXdNqeEBp1QOj4AEy/040KsSUjEK/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=JSsaU+Cu;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5592606A31E
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 18:30:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5592606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=JSsaU+Cu
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1dec056ddso20208255e9.1
        for <patches@lists.linux.dev>; Tue, 20 Oct 2026 11:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792521008; x=1793125808; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=g9NG/WDjidNQ/9hryLb6uUMucaHueMCbu4TKIHP0Lys=;
        b=JSsaU+CuCBp1yiBU1ufywPjyRBANPADTozZCGnRGNiMm6WsLtc3RcBzcd7w0Yq8La1
         L/+73ZBM6Qkz+ZI/5aeGtHmaKTae6oBZCTksVs+LqQp2dukvbbKXA5N8h9GjJTAOWp2l
         VpKxKxKMzht+Pgn2pN2t6BCJ1mekaEtiIs8FvywLC2bpc+tbsoV86ubOvKIgKUYMc7ib
         2OjzB+uxcvIjXT49+dTXMcqBJWRD0EcQHwRKjBOwJ3uic9+dE5/8T9tXMB9Ffenuc23k
         irq1tFCrbgGXoCTC0EQ9JA4C853sAxONQzpcEdtnnESllLWSS+vqx3W1M9qer/+uJGpk
         TJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792521008; x=1793125808;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g9NG/WDjidNQ/9hryLb6uUMucaHueMCbu4TKIHP0Lys=;
        b=dLsSag3ICZz2agvqYXM60K16Zn/RqE1fdM99X2kj0yq/7+FCKbt05eFbut1AuChm/7
         9ppBGK7uEO9m2OEviJgpnop6d97WJ/DYDMVUwJ3Rsl54T2mOiqF7HmR9xWk4/jTiBbyu
         sWtDUpEuj73YHdpJZEO7d3xEOh56BMMX0+Vofs3vZfRVzFfToZaEkh0sw1oKWl/1oo2N
         P+1aM7MXtr9LHNOFb89cxhZonC6epUYA+lIu345VlxyEEhqizeAbmkI2kpwL4wliDtFo
         tADn6d/5PHVYr/MV9QNMs3Gj5Wcar+Y3/L81ipS8BOaSGuikilhjZMrZ8X1VAV49DKsX
         TzFA==
X-Gm-Message-State: AFq9FYI1e/37WcBllZazSC7WBdYFFvfAKCrdTvLaLeS7YhCmWwZX2mNX
	wCEC2038bJIv+76VbjMMZe96IugoJBDNpKteIyYbUyY9x7ObFlGX7ls=
X-Gm-Gg: AYBFou3o1+A6Z0nGssHlPuY6fz2He1db99DR9NWrFYNaEG5LZ7oZ1LMQ4p4AG/AH8yg
	Jvy2+RAG4DSVVAPiqiQdVNqV1fuRulbWt+IvLH+kKjafV5wsIglQfFjyQFm1thaXZ7AuCItXfSe
	wkQz3EkB6wjdV83F67UD2+4OKtRDweQJvIX6tPTcMsc1LxuJOEqgv2j2ufrM0iN1ei0e37/TCls
	C23biyemNmIoVczTtWEtA9ujq18RLmdarRoX7fq0sJEyOk3Oc3xR20/Wz11v5CbwLp8qzP5mczO
	w09CmK9+mHSoVA13DkOHYraoEHBPBNdJ5pCzEyG7OPKOjq/DSgPCCcrcRRQ3Cbq2xYmzXcuULI2
	0jSHzG2pRn9exNejc+lYbqCVMp1ggqH2HM16m3X523aMa8MrYMClSHZmakYv4dAc5A3NMi+yYtr
	v0Smuw1QHRLf29vLhBzrPez7RrqUrj+o9KVHcH0mQXioWB0nUeZpT+ZgPCMDfmtlOPEp28e719f
	I7PmQFQly3h+Oi8uIohAp5JNebblT0Nzx2R/hdBEG4lt6qSkPAxonPvOglgLfk=
X-Received: by 2002:a05:600c:6298:b0:4a1:96cd:2f60 with SMTP id 5b1f17b1804b1-4a1d75ce285mr240610515e9.3.1792521007772;
        Tue, 20 Oct 2026 11:30:07 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace83.dip0.t-ipconnect.de. [91.42.206.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc12491asm2902185e9.3.2026.10.20.11.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 11:30:06 -0700 (PDT)
Message-ID: <5ab8054e-c6e2-4073-a92d-0cd971a7269f@googlemail.com>
Date: Tue, 20 Oct 2026 20:30:05 +0200
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/858] 6.12.114-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261020075246.861837975@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261020075246.861837975@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.10.2026 um 09:57 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.114 release.
> There are 858 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
