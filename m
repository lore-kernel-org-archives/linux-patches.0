Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCF31EF36C
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 03:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760411936; cv=none; b=MigkfMWYyYL9Li56g9l36A/ZVbp7ZG/3T8CYyTYfJtSBB/ZFkU6hZYlKsL9hoMifjFjsyKcLtfFkJ3TAcTc2vFd8m19FMVTeqFKR+YW3ZpBXO7T8Qnc4ilzRjLafrnIV2gbKTHDhh9IFz+rdb5vynUkEZdXu4fMQ7v0CbYxJMkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760411936; c=relaxed/simple;
	bh=6lR/TQju9ey0aOHm4Um+2HHuV8O2PyLs66AmGS3EoSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t980RnDbiiSa8aPiMzPzE0yVtTE3mK/rQhhwq2F/1HqWA3WG9qqoqkGPAQbNlMuzni3qJleaQqTFk3mkPZxuPFNnnz1Qwwl9srj8rhWUjBsuBrs+aPOGud6haUYzNSLs1EPO0ga2sM1KRSVM6ViagjPcBQYpT5SkjXSXDncMSGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=mrjWSCTP; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="mrjWSCTP"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e42deffa8so45435085e9.0
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 20:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760411933; x=1761016733; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RZkQk8i8I+bz9BlzrbCcwSCImHhYisNiBNVjldByEI8=;
        b=mrjWSCTPSJaKFzQzweHfnX6dsj53v10q7orhCbasVCxzSxnol/qKegGz8xGhvUYnkv
         myNOpYLTAGl2XM+4xgU9BuTS5xbT7It7CGq5ZbNPzEjJMES1/PMrsVX/wXoPm+OrrDn3
         crfsRa9lM54uPKGJ551SIotBjdmaW57+oDDMzC+oOx2i7ZlUHE7EHebmXVNz5sWiYaFW
         dybrfLLn3aBpzfKm3HjLVUdFVJH73b+tU0WAXJWeuqKvbdAj21HlP6iQVERefg80Z3Ue
         eca86NIyEHoRb63DkaHk/mN58dNHq5VAezWCYIB27thzoKo+HAxJQ8jbFPVeQRnlTent
         vANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760411933; x=1761016733;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RZkQk8i8I+bz9BlzrbCcwSCImHhYisNiBNVjldByEI8=;
        b=Kj7/wRIi+cA85D3hSJG/TqS+rAhTuxiIjM7FZkGCxANzfJoz5CVWGzLzU+fMTEeEeP
         6ohCSRAaUi376QOvCZPj2q5KjJGu+ELpUgvQHJVSUcLLauO4n5Y5UXKhoQkhwBBZlzcq
         gPAn5xnc67L4ubpVvDo6saC0KWzltHvNChI/Gf/8HdlWj4RcK0S2bBt/gHRH2JQ0A+yg
         KxPvrJtXJFsqd5ibim0vpm0GwRhnNdkmCx3GUAzcEU7Ng2oyioyuIx67I54qB/ufi2PD
         TpGRvId3ANCX9o321mbng6R0LjtJZzbKYa9mmoEpFO1k4507dJlXJos8OjmWNnFBd4m6
         ig9w==
X-Gm-Message-State: AOJu0YytL6Gix9NCvegHnG/iTAyJKoW348OwCaAjV6XPUT6Pi0fQ7c8+
	IJjBeU1l9zRE/B8qv9dkd2HMKZfMHwgTPYoyD2bkQKKPIgav9Tq8JaY=
X-Gm-Gg: ASbGncvtQiJDtU62c09k7qBgWCvcd3t2w931ZpQ3AQzVIT/IznYImG6o+WJN0Qc9eD1
	/qhfWplhSrvwXRJlzzOmvjI3UA3DzkxoPyCHcvoyiznaxza4Y9gRRiKm9BkxuLl/Ae2DAtSRilj
	uMYcmYuyz23gcGspaIqfic2jX5j3M9qUuWw0p6Nese7nrKZYIIX4DV+waeOmn9SD0u5akpe5x7P
	JFcijoNiNzFGRGc5RzMOnGc9GWrwX1WjAOnPHsLSEuDEf4XDi97dH59FRj4Tk+0OZfPiSFk3yej
	9fwd6TYKARIkZjez0d4wjIGUVU+6Ni7VGPV4jA5sNDt9I1+PEGQiwb0hrtam8G+yFsfuKquXL8H
	7DgoQEYAaeiQWHzu+YQb7pl4TYzW9TRHO9HuZRU4BpFV0KjdDmjlP/nAXcIYcUBfFOg2NL1t2CF
	ttAz7xoGOb6332gg9hxatLcTeLWk0=
X-Google-Smtp-Source: AGHT+IFREi6+xE8As6AfUHzhnF2zI2x/unVzciiXYX3NqYh0HkV9t5cMcjOgt5siISL+FR37Jj9fVg==
X-Received: by 2002:a05:600c:37cd:b0:46e:59dd:1b55 with SMTP id 5b1f17b1804b1-46fa9a8b3e3mr168711425e9.2.1760411932553;
        Mon, 13 Oct 2025 20:18:52 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4413.dip0.t-ipconnect.de. [91.43.68.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e13b6sm21160015f8f.44.2025.10.13.20.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 20:18:52 -0700 (PDT)
Message-ID: <8e7c9b48-0809-4678-8747-313f2bcb5699@googlemail.com>
Date: Tue, 14 Oct 2025 05:18:51 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144411.274874080@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.10.2025 um 16:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.3 release.
> There are 563 patches in this series, all will be posted as a response
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
