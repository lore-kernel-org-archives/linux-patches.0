Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7056426ED48
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 21:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770673179; cv=none; b=qJpQyDJikkY8Aqcnk7ewhevORhw+AsJ/Uu+0pSPPckHJ2jPEai5jrvhxix/kY6TA2MaMNCrX+mzGZbNr7LylAV3XvOg77KzbOBdC+qJkpaFgwacbrb+qNucPNMxnkiV2p5z+9/4B+sMXROb0fd/BGnSAnWrSa4TkC9Z1/pvWmB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770673179; c=relaxed/simple;
	bh=1bdJ9a5hOo2hC7LXIuPxAu+2IpE7T9vXNdTP2NOjHDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RlAs7tjqfGLlXaribXFdM/NfSm+atsPZ3qk7M9FRhCjog5ynh+SILnuWk3c+cneRrOFYDZTORfFFddYDmbZq4BQ56w2veMZ93YFyCCSKIeFzL9EWpN5vovcT5gcTkNZisSEwc4yRo1SxuYFL2UP8tAz1UqR4vcqehV2jiA1RAFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=fqnHMALx; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="fqnHMALx"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8838339fc6so469838866b.0
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 13:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1770673177; x=1771277977; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=06aZZ3LuZ+7cHgv/dVPUPB7t0TkKgbXYUSz+5ps7j2w=;
        b=fqnHMALxzWt4KQi75aiONiBofJQzbWCgwvICqXAyz7L2tk79ZUxEl7SS2kG/CZeCoK
         SOCBWGVSUKuE75Fc3ZHJbISWdzLrmRmzwt1bAsBZLsDWqYAdcVAS98Q/57HoQulGuNZz
         rJ5DrnB6wvEya/ElfWxnOr6ctmSRwA0AvX5b9ddMlA+mWzXtD2H/KWejOXX9mc7qY31T
         Cp/sbsQRTgn84Bs0yTDDAsTxFlZn1Hrh34cGaBTJr/okjpAMM5j16Eab8QuufkCJklo+
         A6rqKpd0o0wlepeh6SjH4YKGgDSRka8IMfhbz//OqqSqRMaDj/ORiPBggNGmx/UFJyjW
         j4ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770673177; x=1771277977;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=06aZZ3LuZ+7cHgv/dVPUPB7t0TkKgbXYUSz+5ps7j2w=;
        b=KzdksQZazA3+/eNsWiaAtyxSrIlgiDUhHoO8j0n35k50zsbFMliJ4IMKZ0rGAvOGbg
         IIjoYgz/uOfNjFjUVtmapMibrgznF0LcVvUFSilfyN6TCljM7HTaAmVUuFiLLjT/sp8L
         bxiQAnxfoMSbYT3OHa0sn3G926JOyFZ09irfTZJrrjDs1RbXC01qaJij5JilK19zsEiJ
         Gk7YzbHhZ7m/Nu8z6ub7YX4pIq0uD1YU/F+LDbIqHlh+CAxQYH5Cu4RfA394ZtXYvaeY
         M/+LxUGcNV6TadXax0MJowy5iaogrQxbs5gkJNrMnRmUr3PhNcwfte4PDzLhgVkZVbk8
         jguQ==
X-Gm-Message-State: AOJu0YxWewlINySlNyMsBg2oeKg6VhCE8z1HjKBt5bClsG4fY8mak1bj
	11ubok+k+ngLKqE4JRmP3lqWdFlNBy6lgv4GCqYk6YHxZ9G2xE2+F7Y=
X-Gm-Gg: AZuq6aKcpNlD7Fws6tUACskDgcmwawpPK1ZjAqvYt7pdSFcG0iCgIm2LExioOW/RRxb
	uml4BPTJGDtxc8oUZHKr99QtMJ3yJ+W/OIYqN6PtQySat1a15Jz5WVwdhY1iaWL+D9t4Qg3t7xr
	QW621Go8hTN3KdCGjyNAUeDhSM3URalHvq6JRrJ2QXrG3teGhqGk9cM7NGMhBiDLMeVTmgHzxYM
	PJaKfC/cn1oFuAxz3nnYik61RbkF6sxz3i+IbQ9YXGKOpyPXyYPKUhU7NiUuv0gycruGM7832eK
	pC4aJGjIQNTrccu088N5ZiLy9fNYG1Yyphb3xzMOObyEKbJuaz4ugkuUYcAdjpkQWI4N2tNpfef
	p8QpOdDtVorOlCR2JCT2cV/eUKaCoiIPzmSnuBQAUsovhQpfr5BT1KI0ggyBRGV/oiYbtSsRPod
	tEtY2yDHGijfj8WUoTnXN7HgLWm3Eb0JCxxFbkpWcBAcJKyTtN0u0fAhhoqPKxZ1s=
X-Received: by 2002:a17:907:9281:b0:b79:ea1b:f13d with SMTP id a640c23a62f3a-b8f510d4cf6mr12724766b.2.1770673176727;
        Mon, 09 Feb 2026 13:39:36 -0800 (PST)
Received: from [192.168.1.3] (p5b2b41e3.dip0.t-ipconnect.de. [91.43.65.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8eda7e6577sm428005166b.30.2026.02.09.13.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 13:39:36 -0800 (PST)
Message-ID: <26d78bf6-870e-45df-9154-ee24a30d6653@googlemail.com>
Date: Mon, 9 Feb 2026 22:39:35 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/86] 6.6.124-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142304.770150175@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.02.2026 um 15:23 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.124 release.
> There are 86 patches in this series, all will be posted as a response
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
