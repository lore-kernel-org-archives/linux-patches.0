Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795680775;
	b=pgqt1Ep/EL/T3JkSl5CQXpMlcgN9MpO4HiFRullk5rc6vo7yxU6QLgk18mNrr+xxQWhu
	 MaqFWol3Yitb393V22mWiFrSu/ISWy2fE/e/9Z3BWAl09SYsqtgxpWV2fPb04RINF9whe
	 mox7r2xlfd4zfxjYaz/FJGAvRDuYaZzzDo5RngYG9Orfm20oGyevdlgnBiOC42p8ZGv8R
	 DzqgnvTtnhzJ8zgJXu7knZnpnKV8KXhbtS/p0fqMTo1ar2qGH09va2u6uQ9vxvpwcP6uk
	 cdKZFOTfAu/yApZ4dicGEb82bTLQxdO0goWUoTjT5IwS0bWc7XV45yOYbKIc0FATQLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795680775;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=HF1NIA9YcotgBX4Xrtg69ziwH7IW313XtsQmHrwnOgM=;
	b=x+oP2awqzmlTcGZ2jBdmXGPhO/g+btHytamx9VqbOyKN6x4z5M/4zgxSe6y6/zGCsTdi
	 /L/Y+MR3lBdgv+J4LdC25bQJSpNnB45G8eUv/Jj24906c5c43RTuI1DYSuDqPfy0bYfhN
	 /HpisqlgBUuBUtxBrYp62KGhGKGzpgqLN0XOpB+LEXsiHoK6aHDgjbsy8RGBWXDPhmqFc
	 4QJ/KHknTkTQaP8nWtNCeW1HwXoI0fGhfrACkKkaltkK11RPC2Mx7CaUfhD+NsZgZOrBz
	 WLQSaAXHJawkDYNLIT9k0K00Z/0PeXBRNxDYe1j6AiaWegd6t0AJh0xjqSRuM9JiNbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=W43GU14l;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496BE606A31C
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 08:12:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 496BE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=W43GU14l
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4a7b8abe209so5163970f8f.0
        for <patches@lists.linux.dev>; Thu, 26 Nov 2026 00:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795680774; x=1796285574; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HF1NIA9YcotgBX4Xrtg69ziwH7IW313XtsQmHrwnOgM=;
        b=W43GU14lR37O2RE0C0XrUH4abDiflUnpuh8hIoEnkCJb6AichFCObOl9XLJdVH2VOZ
         FA05XFi6yKbfbuKyeOAzXeW/UC9mwQRXeNF/ZXfoP5uBsyp7P0aWTKnzDEBD45JUsNfR
         +3tRIqquRJTxrDxn9APit1lh29HvnBJ1vtXHAN2FCZAN2lND4oDDN2nZG6JcnSeUszAt
         5r4hVtQpDq/5hFt185KJtP/WeyXK4z53/bPCRnbR1ZE9tPfFsc3jXwgEHCiuzHJ+L1nw
         nzdLuN9D8I6YvQPD3wjpJAwC7+8HtpJuNlSU3sea4X81GVNCxuaol1i5Q2aVoszB4P63
         3mVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795680774; x=1796285574;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HF1NIA9YcotgBX4Xrtg69ziwH7IW313XtsQmHrwnOgM=;
        b=qpgeEYeY34Dhxe8UMkOHmXhcmWFNWvasUNEqPTe1iqaWhRooW3TfFXMJZz+y1qjJoY
         /M0WI55Zfhxx2vCoGFx/mB13gExbBwbvvU8e4dX7qigtbz3SgvZge1U+9ltncuNW2O19
         AEG0DlSrZECoXhn9r2bREDEExoN56RwhzRzvC/A1SgG+mfhK8GTVuokbflk2LxNxughw
         N1kCrn6mP0lY7TemNWPFupqYHGqKugvpJIJCg1o0+RLOzY5r/akqTQNZavIrSQj1pq/t
         UjrzjctGiPvoNyVind/foDkqFJTff1re+VitomR/yZlSC3VFDJxymWm+nb4CKM3spN/f
         0Mvw==
X-Gm-Message-State: APuU4Z8Y5f0a8tJwyQO01LEzU/wtn04EgqYOaUOqrycpTPDvgDWHcCIA
	SHYCQ1jjvwa0hs6eCNKFe/+tmDaVWabkaTbYHHPwTgu8WwgJ02+4JHc=
X-Gm-Gg: AZFdTZctRHHIxHsQiJ5Rpj49FCp8itFT0gpSqvu85DAGSqaGSKAC0sU1RJG8Q2Ml8OQ
	64sa29qdyUs55IOVTce1V8D3W7vszgkxOtxCO033WRvgucsi0mBpuSBcJSrdGZovWV7NJLBOF5E
	fwv/92lTy/DWiTuoKfBKpZmZxCCnGXDxdenDUwfibgRgZoNeXYMOskZ/39yhN2+mpWPp/bNGCka
	s1iUg5Zz8e67S/jdbL2v3XTkjX2H0+jP6V8KZXrmBks6fqWD5Ft6qSHrQlydQzL+MLzoBPXYKsW
	3eeKap44TGWt1ph5zMicO8sg7paGt9AFQBqdwPDdYC6lHoOcIOI7NK1yPGUJuk5VJOlJSNHKSCG
	knrpcTwjMqQ3h3Kh4QFMO4stJqkQFdOisET9MI3TRd4KAjRDTXxm16l8KrNMmif1udGlV7CceJv
	lkQP1DZiA1Et4wi6RRONA7bE5YG3Fx6sX9GprLckWQuvVXA/nAePT+7dR4Evn3ntCYxEKil38mn
	KOZGx5SXgh2VBVfiAzLICGfWhHarDkBM8gUq9bXirB17vcLT7IvaheSEfh9bTGAZ2HbgmNbYBEW
	En5CW652H7bQ06iG8UmHle/FwoH6uKk+6n0sqL/dLvR6GKmdbYf3942WeFfxx8F+0iJfWFr20XD
	xXEbM
X-Received: by 2002:a05:6000:420b:b0:4a7:518f:bec2 with SMTP id ffacd0b85a97d-4abb2ce47d7mr40551231f8f.28.1795680773406;
        Thu, 26 Nov 2026 00:12:53 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac210.dip0.t-ipconnect.de. [91.42.194.16])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67f281sm36790497f8f.22.2026.11.26.00.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 00:12:53 -0800 (PST)
Message-ID: <db3d4f41-d0c3-44f7-b601-770031fcda5c@googlemail.com>
Date: Thu, 26 Nov 2026 09:12:52 +0100
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
Subject: Re: [PATCH 6.12 000/816] 6.12.120-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261125143849.205329330@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.11.2026 um 15:25 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.120 release.
> There are 816 patches in this series, all will be posted as a response
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
