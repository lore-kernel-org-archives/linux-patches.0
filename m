Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96782346AD6
	for <patches@lists.linux.dev>; Thu, 21 May 2026 21:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779398033; cv=none; b=ECyfpeZ8ZOr0Eka35GCp6x4rHIuhh6DsZjMFcgnUrkusKqV+Fl+iw8IGNrIvpzrHT2w5/sWlUGP4BIRZmlR+UKdF2c+VvZWL9m8NdARJoi81zR5BgzFo1H7GsyI+565boAsisrKlxZXz5Zgq3SNJQF7GcFo3b51y86xRlwxC78U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779398033; c=relaxed/simple;
	bh=FKbR2oAGHLXhTjrwaBOGgE9yH95Bw7MiIRRtQf3R9sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AguRxPzpaMjjL1LbsXhvdPQ3du2/U1eBrU0ynZg9d5nR0p85RpblUucy38xT0caGib4Uw6yuCDSAk7cwO74ckLD2CIU4JYHAFfGP5AyCB1j/kZa6jFUUrKsSyb6779QqviidHQluHGybrbbIDgmzBjlznJQGELX/KGZWqI0cQPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=stKAFdcR; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="stKAFdcR"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48e82c23840so53568945e9.3
        for <patches@lists.linux.dev>; Thu, 21 May 2026 14:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1779398030; x=1780002830; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9x4Q9BYj16KKtLOYDLA0JMcsK0w7ejKE2qpPDsfxfXA=;
        b=stKAFdcRnZYlcC3PLnFGvfScmjWrvZ445sbOkzDSrudo/y8JV11Cn1pYT5Ha8iN/7I
         Z3fLn2nRgFluQrswdL9dltfTxLTo1/hmQcbSaCnjwtiEdVh4QJfyADi5ClcFTQIFqWrX
         kaGoKuNtazKODl3fbsaZ5Adcl+rpWlu8j6hP42RUhaMHUPuRJlWLqYQBOmezqSkP/841
         gEbC3KM8M/HOIqwdyBj21DhjRp0J+dj7mg04rj+hSqqnreGHuR3SIa0aA7aXbo4La0eH
         j3+gmF+3/As8iXKw8TM3EiYw+EZmQn9//YQBBrzpydzFHGSEHv3fq7pejoDQqiYD6gr3
         09zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779398030; x=1780002830;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9x4Q9BYj16KKtLOYDLA0JMcsK0w7ejKE2qpPDsfxfXA=;
        b=Xmxwsm1YjmBoz+LRyaI7hut92t7mQ87YRk+2A0jwnKENo0fHHKA8Y63bUAn+OtLkz0
         ktc0TreCmdXEXdmmYK5iHjEcT8wp10Iv8xwihbyEOHdwIU/rYHUdlUIshFbG6dWc5Hb9
         zg8uTIDHfLxCxot/H4PGSk3ABuFGtB7sVMLLyPfU+kBVLzNHyYMcPxpVKTUNx6WGw1Aa
         V96PCPGJxxqOXSPFkcWgjixOfxADhzqDkvjLCxR8cfvl4+IpJTe9zsCUVxOstFtahMNe
         2OdT3fxIARm+fLWV6Q+OKQ3KNePFFkkPMAaxxY8p43jpMw6Piu1ekrfOouXbQ1xkWqVU
         ofvA==
X-Forwarded-Encrypted: i=1; AFNElJ/rSfYLiWdfjqxyozS4/On4FJFO/IHTadtHRgoP3Zlu/55uYpIb4DUvSubMkuq6Hhta1CGHZlMB@lists.linux.dev
X-Gm-Message-State: AOJu0YzjRayXnWLzVV59Yq6NUCgK9a1SzuwdW76aPdYFkS8f8e+GH0C5
	wCmtHR3rRy5pX115HWwQsyKpB+y/QmAeJw22rYyjlVNZhaJDEEeQt5c=
X-Gm-Gg: Acq92OGkibw7pYFKoS6zVpP38CHU+AWKzygeD+9SyckqiLJCmwnEcCtAvlFk3NhyAjT
	5672wlWk82w4Bccp9+L6QtLcpbi3yozBusqBzVN6yg3LfCNmMGJmVG3nKYyUUFcM0Cn1EzTxBve
	KcbKB4uIqk8llpOazJiNlG73V2am3dmh+u/z2nPZyFdHHCoAfE4kDeL5zIGw74v/6x5Z2p45SZE
	Gu2B+WZqbQz3RRykyil/24c1b4Uxzln8hazPC631gaKILTiMO9nO25gFEetYUoJRWKLphIpUb7H
	WVefVRIdn3ucZU1CUE/p+qhmJ1nLO68ZV1O5Z6egpmk7gu0p3SpRMFUQgVihk4d9hqZx2IK5/fq
	5XkU2eHrzw7aNx6gNoGQcZ7/erKgsmOK2m5L5Ex4Gz3HD7RaIdXCV2+7S3TjBTfhw4AcduFKqZT
	IIldcgnRWCO7/6RvE3+gVa8ii15Ij7PpvDbd4a8tTMK1c1BrIJhhvy8PRlf5qMUfOj4azlZDkno
	hX9+QCZ4nWhZA==
X-Received: by 2002:a05:600c:4fc9:b0:490:3893:c71 with SMTP id 5b1f17b1804b1-4904248839emr5370295e9.5.1779398029819;
        Thu, 21 May 2026 14:13:49 -0700 (PDT)
Received: from [192.168.1.3] (p5b05786a.dip0.t-ipconnect.de. [91.5.120.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d3514esm99284585e9.3.2026.05.21.14.13.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 14:13:49 -0700 (PDT)
Message-ID: <1b10f085-9eaf-4291-bb00-7baaff61627d@googlemail.com>
Date: Thu, 21 May 2026 23:13:48 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 354/666] libbpf: Stringify errno in log messages in
 libbpf.c
To: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Mykyta Yatsenko <yatsenko@meta.com>, Andrii Nakryiko <andrii@kernel.org>,
 Salvatore Bonaccorso <carnil@debian.org>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162118.906982302@linuxfoundation.org> <ag4vSWzIUCsRlpKv@eldamar.lan>
 <20260521-libbpf-stringify-drop-sashal@kernel.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260521-libbpf-stringify-drop-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Sasha,

Am 21.05.2026 um 14:55 schrieb Sasha Levin:
> On Thu, May 21, 2026 at 12:01:45AM +0200, Salvatore Bonaccorso wrote:
>> This commit caused a build failure while testing 6.12.91-rc1 to
>> prepare it for Debian:
>> [...]
>> libbpf.c:1538:76: error: implicit declaration of function 'errstr';
>> did you mean 'strstr'? [-Werror=implicit-function-declaration]
> 
> Dropped from the 6.12 queue along with its two dep-of companions:
> 
>    - libbpf: Stringify errno in log messages in libbpf.c
>    - libbpf: Prevent double close and leak of btf objects
>    - libbpf: Change log level of btf loading error message
> 
> The errstr() helper would need a larger libbpf refactor (c68b6fdc3600
> and its prerequisites) to come along, which doesn't apply cleanly.
> Thanks for the report.
> 
> --
> Thanks,
> Sasha


I get the same build error. I tried, as you suggested, to revert

2e81d08459c32c57d037ad160e755bcfe6d5003b (libbpf: Stringify errno in log messages in libbpf.c)
5c758117c381172ccb60fe9a0313705794ccdce2 (libbpf: Prevent double close and leak of btf objects)
a8061c6ed62cc94a5e19f0e31d03d23ff65d638a (libbpf: Change log level of btf loading error message)

but no matter how I do the revert, I get a conflict and I can't figure out how to resolve that.

Will wait to retest an -rc2 once it's pushed out...

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
