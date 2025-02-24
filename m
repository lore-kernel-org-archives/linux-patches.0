Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F8419F48D
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 21:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740431966; cv=none; b=E7O+0IjiPEt8dq0/jQ10GEinN0F3R9s+pttCwN5xtGaUqBnVQj7TSKHhOra3xoVQ5TB4mka0smx5+eMtpIlUbSGK60DBPe8dvaOO0LRoVP8H/kVCYcR2kQHo+nBuPXwLV1LnT9Mkuc4piyRLn2Xd7wef5D+QnSowyk38MfKzYdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740431966; c=relaxed/simple;
	bh=YoEVxQm7GUNB/Pace/xv1ua8aa3MZ5wuQD3jL7sthmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LuOUiO60S6iUWAr2eqH3iri3B72SUPz+e3le3mgwevjkcc5pF1WSFQ0JG1AbTZvDQpI6M4VOIPr5erbNE36Q57AQgNimVW4k6uNuaro/KuXCAzz2UKJIbUv5/B87XWQPDzS1exzmiHj/pBUm0aH/E2BwHoFhCMyJXrDY86QkjU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=JTB+aIQ4; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="JTB+aIQ4"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-439ac3216dcso27864935e9.1
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 13:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1740431963; x=1741036763; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RpeO2CI36Azm6aM6kCOPxfPUs3dzzjFPJf88qBzpQcg=;
        b=JTB+aIQ4rSTm1vuriraGJurRbUph9UYVB38dDpYPMrOHqxGZJWItYwCKA8uXC0xPYH
         g4qYd865AaWWtOfqzZW4J4ol2ZT/PSCNWzgxhkZPxK/BKt/cPT2IDNTieZKPQBwxpZr0
         yg5piCsWt6N2HH15xOWEGgv+jwNrv4hlo/X5WG5Vt6dOUFL9W1+DsQYFAuhFEQTVVeCZ
         N72gA1L8eYbQ5kd2I3kBB+2krurdtpbMZanRz9CXCguTlyEZizu6MwV+9GEnO4OEc+ZK
         2ktovYxXXcID+iwxqljMKqXsXYMIZI9OecwU5C/sjlrnqvkCIQcX+D39yvSUFhGX/X/T
         Z0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740431963; x=1741036763;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RpeO2CI36Azm6aM6kCOPxfPUs3dzzjFPJf88qBzpQcg=;
        b=bUua78wiFY8W+q9mAkZ4sHHDlDwhcs3yXwLh5EmEHoxz6r00ZIEnmZsq+aZFva4OCH
         LDLMLWpuFdQpOCAQi0OZBiD5vA1CpCW524hit9ZyCk+ZmpI797Svhm+snv2c40QFf99d
         c81GSieZqf+cI6+ybauGc7089gxdcFOYU7n3mJ72Mc3tl3HenMJPar9oU5FkdMjRXRzW
         dlz/2/C0rvC8HFOPO9gbsWW86x5HWiEFjmtC9VdlRPVNptYwNROBGHBgJ+mMedWVg423
         y0f4ovLiOJFyVrjD2VmntgdJsg4Hgf1n/8iqNOOMp2+XfNOTKjs5vqZQZlaLDxkQE8X0
         4ZgA==
X-Gm-Message-State: AOJu0YzVX2GbXrpkftyEvG/1bnFpKbLTbWIZfaArfX1WjCcDbdlKyWf5
	b+6m7wd4VP3iUypsgV6GJfEUmNy49hFuvwWyi7BJd3hC0pfOatE=
X-Gm-Gg: ASbGncuaZGFMfSQYB6fL4FVZnIhRosbxkX3hqrceDQUaiAyQeXLa2v/ukzpzMWbQYP+
	4d1xacmOvURWppk/BoLP2zJN9rnqG2Zefz8honEgv9lKy2vODkRSUm347fjRLUxhgea7jfcJyhN
	OypLs2CvwnE78cQc8+8xe/2SWXa6dIvuYRBMkMepVYDxBdVVysjZxUQnco1VUi7mEGmbgAV8KyF
	EbECLDO605tPEmdXI28gOKVCgM4kTPRJy/ydAs8bnaay4sEYxMdclpx7jpnm9PxxQ/DHRnWDGmL
	IxD3d3HIE+6DobcB1KJchQtUb6Ln+DIJd+2lUNIF7HBaUqPfNvAKrhNdaKvTFyrNeSwCAYZTQ1n
	Vppk=
X-Google-Smtp-Source: AGHT+IEYsevmMEoA+JE6owr4Lom17EkYScyptZxEaM2HX68zip8SRSjflN6YB00vNtpaXesHEnqkKg==
X-Received: by 2002:a5d:6d08:0:b0:38f:4531:3989 with SMTP id ffacd0b85a97d-38f7085e028mr12832430f8f.51.1740431963449;
        Mon, 24 Feb 2025 13:19:23 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4180.dip0.t-ipconnect.de. [91.43.65.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390cd866af3sm154293f8f.2.2025.02.24.13.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 13:19:22 -0800 (PST)
Message-ID: <304185a2-5cd5-44b1-a098-3e193b433657@googlemail.com>
Date: Mon, 24 Feb 2025 22:19:21 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/138] 6.13.5-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250224142604.442289573@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.02.2025 um 15:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 138 patches in this series, all will be posted as a response
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
