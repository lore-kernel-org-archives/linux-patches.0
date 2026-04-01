Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B797C1F4176
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 03:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775014304; cv=none; b=kS98gQXEeTDlcMq2xK+DJ+BycRKrSbzCwgY5EpfhEM5hOexR3MAFIwRRm58Kzzow+DKnanNEyES5cW+o4nwTdS10MQvtcmaTL8KPbIuj4TF5nNF4Ih7FB686ZjS8MipgaNran7PDB3gNzuyx3iJtTPF0rdeySRwLyzeHaqGZE24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775014304; c=relaxed/simple;
	bh=nO14oiQt2F/NU607cPayKjljDeYFrCw3R76LgRqCxP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fycUwmaiVABXeVzYCxmMaI7zHI+9EIrbMBBhEL/OTzgZMwZPWyiikF3FbHLfCvOSNQWf61wPskJExAY/G6G7BEutxiqpll7zhMpmJ2VawieP5RC0PlEy4ttZwPGUX0fU5vAPUF3Nu4xBwNzRNcFddWs/qP5KZ5bXarZFvUjm6DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LRf516mk; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LRf516mk"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-486ff201041so62447585e9.1
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 20:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1775014301; x=1775619101; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=omVmBIJbukSL85weewQTvjHzY8THepsy7QTLnDVM4Dg=;
        b=LRf516mkkpe9V6pIDLEKaFTRc629uncjAszhVNN39tllWS4zwpTOLfThhUn4cCIFCR
         /a7n2mwO9O9tdBq3nrMs+IedmbeabywZvCntUE7Uog0Moh1CgOqe/8FjXMWlFo81+SgP
         zNuKbF/XDBYH5uGKI7mhhFGaIbvRyoKKhaVMcU8tSAOYqlwzko1259i85btzrVcOXNHe
         3gUK1oPDuuFEFBskgn7FrZaAWlCo7vdivFzeCMIzw4w8yHN1oy+5MqyaS0pEzMTGSR3/
         nJKmS4fJS2LVT/kLHN4pKuSGvnxKqE7PtzDofX4amPKWHi/hn2W5Z3isi/3K5hwlPuwP
         dkbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775014301; x=1775619101;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=omVmBIJbukSL85weewQTvjHzY8THepsy7QTLnDVM4Dg=;
        b=AIUrI1ZkGNY7N3MZrjetXGUMiCGr0kLQgQIH4vh2nn8/KtsOZ8UCY4XRYG/sDDE3TD
         MC74K5NVYsXi4rXOAowk3D74yrtdwH6NSS0ULmxi2YJdFVbBOjz46707qsRC2As87ps6
         MZq726LSBZWUurxgNIElXYm5zLCQjDEGoLbLu21dZGXlhaGMpj5LdUZrU16syUzNAhRS
         amw6XtuqysrFoDzvRfRd3MxEPoZb6JgPxSTJp3WbHJj40dOErCxN/mW5iAz8m2JReg+U
         Yv6MnjvQG3o+phXRMjGJZm/6AAiVhgc/wg0gqm7nCikbC02FiZ0avgtYaLQaeZt6vv6I
         IX/g==
X-Gm-Message-State: AOJu0YwEpXebHRire8mtdYrtXEaT/YyQ2QFznxpO7a+oWISMZTU4DBeD
	PDm7jnFO/r59vhibwC1c5yiimF7fQPtreKHzr0KbyFO8WZHZR2mP/nM=
X-Gm-Gg: ATEYQzzkkWiFmowlIGcBmAuPQYQGhwaaWasBrYpUigckFyUSVlGDM4pdq3cdCq9ahFg
	Gr2uAniVFzftoSCWFc3j3ZjDjl+Ibsee7Z4kgc5P5jhv19z307Bl5hKTCBwXWYRP7lfSX1UR25m
	/UdakKaWxUO8jYAcARRLRf3cGtY4uhev+sLUo+FkPZT4P4RAGR10bpxnYOZq/Wuq5Rc9EiCbnyC
	FN+mGBz6xutmBn807jJGe0th4XK59sI3dcvB80ctiAT88tMZ28DckRjicDYcRP44FvVqr2MFY3a
	FL4SXWbz9feFx2JpR2xvDaMlSNQsDzw0CSZ8UjCSK9OLyernya3bYSgzY3awtmp9qby3ltg/7wZ
	fy/NYYMzwP7kh0nzcLU1yS69toZQEqMfbtZdYPGHps7vjknrnRsLoxQ9iWR+J3yJUbhtuRnHSg0
	0cv7QFWAoivF6ndICsp5JWLyFtsd/+uJcyuLOUk5/9bwiYLns8orDsnSEMozUGFRckObICkubRk
	Q==
X-Received: by 2002:a05:600c:818f:b0:485:4bd1:4c64 with SMTP id 5b1f17b1804b1-48883596fa0mr28458315e9.31.1775014300712;
        Tue, 31 Mar 2026 20:31:40 -0700 (PDT)
Received: from [192.168.1.3] (p5b057048.dip0.t-ipconnect.de. [91.5.112.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887a630922sm115480355e9.0.2026.03.31.20.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 20:31:40 -0700 (PDT)
Message-ID: <c71fbbc2-10ca-4865-b5c7-f17cbfe4044f@googlemail.com>
Date: Wed, 1 Apr 2026 05:31:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/244] 6.12.80-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260331161741.651718120@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.03.2026 um 18:19 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.80 release.
> There are 244 patches in this series, all will be posted as a response
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
