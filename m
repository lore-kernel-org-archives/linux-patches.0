Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E02517B50F
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 03:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768016403; cv=none; b=JjAglAsmaqeFnS/svw3jiRL1rpnbIJkvXKWmyRC+TuhAajVtxBuJIvETp24s1jm4qR8ZY1L5kf0HX0QNC1mtRP+gbArZvRNr2DXEzkM/oG1NLSxkHa0MoAgwh6ANJeLlHNtya7jRozE2RRIfeaCYz/za811MvxAAapPtdrNfvTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768016403; c=relaxed/simple;
	bh=ZNxmpy3s/NjQP2qO3L6gN/abYNU9nDdA/hZbIOXec2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q+NPc1jpEp0WUJHyEmhLmqB76k3ZmCYDLUBDkpql0+/li44rFD8aXNFxfA4NeJzZv0M+lkZgj6FjJ+voEvTdQBGYCJrQSg4jNurwzY0FrUp9MISXeLkiHIV6NFjGeCyCd1iOx/ZZeiJaE1KgRPvzISmgvil9jYp0rz47iJu4vOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lN4NWiO8; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lN4NWiO8"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47774d3536dso32557825e9.0
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 19:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1768016400; x=1768621200; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dz4wL0bES5zyIQrDJWjuC/U3KHdx+E5RhZrK+5E53sI=;
        b=lN4NWiO8rgJaIbwuugP1vvof8H5SWNsU9sh7+VpQnY1/VCaR2oluwAG3v54odysKTR
         NsixWTXO3CKfSyBFQlMh3+4YasQfui7H9stzQ8VWMEhFi/6GZvSv80H9VXxQDo5LcEWu
         UMVRuPWln40Vf2M6o1mDMoie/+RR7zEeX9hE0l28pGEZ1MXsgEfuLVoRulqnCVjAh4Co
         Fkr8l5DRakE0WDZ1i5Pd1lY1LCTa0C3H/KtKQpx/+S45FrJlYem55zS5q+QzdfzZPoY1
         KlW3jXtzFOQu8DU8x0aZwI9EhilpF4+sz9wkWT7T8RA6U3HuQj3iYSjdCtyyiRoR8yYh
         n7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768016400; x=1768621200;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dz4wL0bES5zyIQrDJWjuC/U3KHdx+E5RhZrK+5E53sI=;
        b=jz1yeBb/XsotREMoqgKOCGzySjhntzwO8YC1U81qAKLtSOlOAV5J7r6KtZ7WNUa3da
         /DujGa9kX/mrQ37I9zVFVhXNp0TMyUtsgNJ0L+qxT3vLjiKzGbF9XKJH563oQdh6A2IL
         GUfs2IrYxNgtpOq8M9WeDtsnSyFAMPuw1cwlB994ah14s0hX3R1dCFybpAyn/haDD3jG
         nYeUmy9iaNqA3Sh1wmAy5XTTecZp61VT/YEy4JOOGHIrTtdJfBM80MDkS9k5/YvpLGks
         Ra3KQJ57FGpaTk6PqR3WmGCmEEFgL4uH8Gp3XAmSQeDZhf7Ur54gogU/P7vv2ANwVSVV
         XlZA==
X-Gm-Message-State: AOJu0Yzd/7LDrh/Xv7j/PgiEZAeNpT0FTUZ0lIt1Myv2fNrdfCqRooqF
	fTgZdH38IiRZ+vxrsvKk6M+uUm8pIJWqBAK6BvNtPsopTBeIdWSJbMg=
X-Gm-Gg: AY/fxX57hzWk4tZsbHt3ODM0tfVwkQg7t80K5wydOuGEd7kduXenaetEXSx5wnqM1sE
	J2b6ICEeo5C5JMlB0GrSzIT8fr8f136YwHGdeoDYeyCvE3846cZF6IYfiFbJrvoa6A9Ye7oUbo/
	ypTe/WLo3/g/jg9M4LvThGhYi689C0D+EKBga5R+rV/dLWU/u3qIP/IW2H8YZnp7X8Tiox/Wh09
	rDVf0K3+3lzIEK7S/WmYriMpryi1C97fORKY4p06GoMzPqQsyzNF6dBT28wmB3h3kZfmuQOUJHC
	QZT3MIMtgtKLzMHj4bU06skjg0FyZ1raIo1rdxyExjTv1401ArS4JnDImhPfdIxtNGDx6NAP1hQ
	o8vgbgxZYyBVAheq1w3SExpyEU+r4OaszfacRTDLDPwNFKFqLoHrfLE6kIRmyscN9T3k0VNo8MI
	o4PokBW8V0GiNErzs2hOwQgVmF0ZuNVlighyML9qI5+lgrR0ajJd6v8GXs/sJuCKo=
X-Google-Smtp-Source: AGHT+IG+rDevQNAgrZqcIZYHg5z2I6P1jkhCEo3BFirDd5CnreOq6tif91Z5O3HvJZf6UGuI+SHczA==
X-Received: by 2002:a05:600c:348c:b0:47b:deb9:163d with SMTP id 5b1f17b1804b1-47d8484a329mr127583585e9.7.1768016399759;
        Fri, 09 Jan 2026 19:39:59 -0800 (PST)
Received: from [192.168.1.3] (p5b057af3.dip0.t-ipconnect.de. [91.5.122.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f65d9f0sm246426565e9.12.2026.01.09.19.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 19:39:59 -0800 (PST)
Message-ID: <2713dcdf-d459-4e94-8ae6-a5cd1af45246@googlemail.com>
Date: Sat, 10 Jan 2026 04:39:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/16] 6.12.65-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260109111951.415522519@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.01.2026 um 12:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.65 release.
> There are 16 patches in this series, all will be posted as a response
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
