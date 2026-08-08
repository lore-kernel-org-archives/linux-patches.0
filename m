Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF38D2DB7B9
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 17:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786211226; cv=none; b=GQyCKEeoPYbSa5SRVFOE1M/0Vkwkcy7o7irApaay3yk6PucHbM5FAqo2SWlWIxxzmTZQ7Ni1iuV1mxKzWLxV5dKI+Luw2STWTKNUCx/nRGyZoBHm0XvCHMNPx30hh1vt9tW5/hMsZq2NJZnjrdLSqGez8+7zWTLgUafbuxZVitU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786211226; c=relaxed/simple;
	bh=hoDzowH9m9D/lxk1FPWoE0ndsBBYP6tCemVjnlxWSl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mw0ZO6Kb2kePmhTQzd26UAwREZnSRBobttA0I54s/IidErhMbC60I1n13LVQkXhnt2Ab7I0aLuxA6HvPTl9qsVdAroidXHinKJz1yKFRWqmiOEAsPYXAW1aRPaeloTG28yHF7x+AVWL3JZCuuITc3+KY3KqdiEVxn5iKNPttTIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Z5J+9ufE; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Z5J+9ufE"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso255516f8f.1
        for <patches@lists.linux.dev>; Sat, 08 Aug 2026 10:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786211223; x=1786816023; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c83vyyP7VTrLntrF65mKEgjXNcKXt6fz922KonX9hLI=;
        b=Z5J+9ufEJMQqJrSMQZe6WnQSG6lWOZ4nc0X69Ftxo0VdUaGWP2uLF62Z0BJRrTKaJ6
         3cwE/T2qom7X3ay/X0BgLKBurQAoEcO7x7esdgDNdVjXKMv5oUwfGXHzZjxr6u+kpJF1
         dBfQyRiAdQqmK+PXhs3Sk4UV1ynT6cV03fvJ0H4TP/Ut1gZWopgWYnZbq/kb94bWuujM
         VB5pOXanweKGXb1t1dCPCXUz7LvWLQdWKfo46KHggVt9CQeWidHn8iSJzxjfptgONR0V
         K69inVounhXeNFe/jiBkgkNliDjhHVCkR/MKrfCgei+hi/MMQRntHgf3MFsPxVUnTQS4
         6vgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786211223; x=1786816023;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c83vyyP7VTrLntrF65mKEgjXNcKXt6fz922KonX9hLI=;
        b=ao0h/nZV+aQqDHVUffp2vuH2wUaLUtsQD9oIvhqXky1D1LBKcJX9D+nVMCUZKPq/my
         aVW0CyESoF9UYRnNVu0C2mf6rHJky6qOArrECiliuI4oHYG/uHumlLPZKCVk7q+p+R9v
         MmT3at8BpJdlX4bux2AQ/T9OdkIhHxZjMyNb5g669aAnJbcHTMQarX+4hpKaQ11Oqsnu
         T9X13zco2xAahx8OfIQkPnk069kUXgj268fMb8nXEplSxvx2nhOwk44g157sYT5OrS7O
         1p1XBgv8PYpMZFgiROuh5NFsX5w+PcIfQX0x4/SDPDgz/r2ibSUZXJGaQcA9MS25YhZe
         r1kA==
X-Gm-Message-State: AOJu0YxU7JxwqGkzhUYM9m3s4gDcgXR8NYSCaMsdN7ODynMkI42sJHo9
	WfwMgEbGyhByZiknfrMmyGE8csAyqva/N8t5oy5niglMWNgLlhnEc8A=
X-Gm-Gg: AR+sD13reVFuB62I7GJQfgdcKXQl7tGwYcPb9fJPjx+W/oKQqLsAFXeNYvamExnlQIN
	c4w37yw98kPhniUWMqQuVFFKHzwLfbL2zLqZnhWE+A0icd/+ebDhHwwbe/8uHOE3QpyGE/C1Q3h
	13Cax/+QaD9IeRvNa7sFU5FX2UfviUUZisH2WEBw962Jjxx8wto7HjZJMJRcskBllj3f+2/FP2M
	TcntHqbna+/Zs5RF83fGw7x/0jzHXwwtSoerIWd0MnUefGKV6y4cSINRNC63TFeXzjSa8MFq3KR
	LK5GzIwkwzQlRn5Y5npembsmjoyXh+f1yd1PeppG9j8nuXEXtUaflLUuTFALW6CdQMOjFC1hKy1
	qh2obYGWASNyi8eOT5Mu1qk2AEgZ/U+odjSvcUhY/tQ2HcfWdmInstw1Sn4XW7cRFnbEbrESPB0
	70ytsmxc/5+rYIOgaT7G+pzVrEE5/SDzewF/7HGQMye30wFm1T+8C81K2jITqFjFsvfuPwgM/KF
	LFFGO0pA6pJSAZb4iTcxlc69X2V4Inbe3MvRrOg
X-Received: by 2002:a05:6000:1449:b0:47f:d072:87d8 with SMTP id ffacd0b85a97d-48130c287d6mr11952692f8f.0.1786211222870;
        Sat, 08 Aug 2026 10:47:02 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4d93.dip0.t-ipconnect.de. [91.43.77.147])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021e8c5asm18133982f8f.18.2026.08.08.10.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 10:47:02 -0700 (PDT)
Message-ID: <b6881519-230e-4d37-ae1f-de46c3d41c24@googlemail.com>
Date: Sat, 8 Aug 2026 19:47:01 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/396] 6.18.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260807143424.272339768@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.08.2026 um 16:32 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.44 release.
> There are 396 patches in this series, all will be posted as a response
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
