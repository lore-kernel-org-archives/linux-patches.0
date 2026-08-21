Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E112C1CD1E4
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 12:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787315091; cv=none; b=sJkHYzROq3kQPRTlASfYlxE4j1Cq/30qX/aqSXBK2+A+AUyxqGMIaQ+r4OzjRHIy/gx/BPipmMQmnKLCc993zHBkjQHqZkD/hq9aQozusz99c755lVqbjHTPgtpZlSpWdebSKWi3xrWZfQmP/90J6jIVqVDb9HW71/VTIiuQIf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787315091; c=relaxed/simple;
	bh=kzUKGErSXeFhGcKEXAfHLLGBFtintv5H5k+rxhgNBck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NRUv7hoJN8/3Yy6fpXY2Fhlbd9FrdMf8wgvPQ5oIb6GNAO+IyhMD712GM1e0j5/Sl6VVTrxsz5er72N81TOMvY0xzbP5U7pmwdwTmY5otIEXnErDEO9ZV4TIplJaI/j2lYSqElzrXkBixIkzNDsJckjkS+gomT+D6hIXLW6QJ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=WI2RrZlt; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="WI2RrZlt"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15e2dab83eso188239866b.1
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 05:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787315086; x=1787919886; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6PDXaXwtv2p+1+Durrc+bPegBn2jN9nnuU2DeJAAOzU=;
        b=WI2RrZltPkgoRv2zyGu4KrcRK+X2nCHTZhnERB31gTxoZJZMf/BItoAcp6m7yNt0Os
         hcOdGTq+sKYSFzBaDCARP6CSEovxsxVsWn0GGfSmW1hUJL10lGIQkuW3Qrf0fv07ikyg
         lfC/zYW8jQkaHY/jF8BkHBFtDjLmgm+CNBNN2FNQNoRnhqk0lvY0awraDr/zXjriUuVx
         d7Vj6Ox5FhJCim39fbgjAGc9eifUt/dS2Vu+wrlhwqawiQ8rYFvQT2EcLnnXVRr1wN8o
         M7Pz+CZXad40zxR3zF+z6k9vVgQr5WPj+DFwvEzI/Y5s5OWlveO1Rws9x+UBzlS5q7En
         yyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787315086; x=1787919886;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6PDXaXwtv2p+1+Durrc+bPegBn2jN9nnuU2DeJAAOzU=;
        b=q51Yw+n9mKGbZz7yarKPO1GPzazp5d/+ZqKfFbRgNLq/82H9kjxqDM+GwH3AUcfRN6
         D5DTEIqbeUlp7agseBwy2oxKDOKAkxyx5trKczsglDVQcOYLSjTcb3eKkIMI7BL04To6
         DHs3IgG3RcM+3KqAh2wmI/OEsT5L9Fwc/5YS86w3O9iZtTU52wID2AMbWM0zcOTXghvg
         32Po0x+2FMqyPh18PKKhnCdGzhVpA/JtNRGxeFrw0AMRNPITLEKhiYc0psEai7y2HXw6
         MBvZ8rdVYldvyPSPVtGxoK69EsWRgF5Lx+KjeUS3uWocAynFhcb7AV0RsY3yp4mREAnq
         B6uQ==
X-Gm-Message-State: AFuF++nC5waj9meH4RCFq4N+gtgaBs1eYrSLjgYXOECyvSFZAYgGXDj2
	e7bKYk6nC88d2CNf5W0NkCYcsOvioxURPGgE/PSyRhXrUQlo5DDqGnaO2Yt6
X-Gm-Gg: AR+sD13it9cn5Pa7DEK8uBdKcP0laDX0DT9UjjjrGLh+L+LuegBxBLkEep1kr9Q3GCb
	OecmK0ZKzGQKCM2fme8ZcUutMUssS25lShXHJ1kuD/SIB1cbfM80ew4NVu0ZOE57ADvsc1h/tpX
	sFjdJyQvW9Mj1AFG6FP3NLC2U1r2GONKpNJsMHtxBxLrrwyrjh+fEkPgdbS9sYOi0fMdlr6EBx4
	0+sRzTMJ17+DGMAJ1juEMmMvTxKxlDoYNKf6cOTncj/i7+Z7p7QLKEmzF664ye9GYiMPntBhQSz
	QwgO/OKM3J8bB4MGxKqGCamU9OZLqBNKoAZFMbWjXj3tRpbfELH1KyaNLsNDqEvdGefcrtKxqjQ
	iNV3mtrb1z7yHAOAnWIgyaITuLQd/0A2HBE4b9HH6Q8QYpPuiFUtYNEU6Hfu51bHRg7bQJjfdX6
	h7rjWAgFOv9BdWOKDddRUXExkld2q0sSZt7lH1HtF4kZk5UPogMNVbMeUTIO+WhmF9NQvLwq7AB
	sNP3RcjYU1H56/KXg5hgmQc/vUtpGWSdKSADMODx/o=
X-Received: by 2002:a17:907:7b9b:b0:c1f:bda0:a771 with SMTP id a640c23a62f3a-c246a68427amr634334766b.13.1787315086010;
        Fri, 21 Aug 2026 05:24:46 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac6d4.dip0.t-ipconnect.de. [91.42.198.212])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff177970sm5983397a12.26.2026.08.21.05.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 05:24:45 -0700 (PDT)
Message-ID: <75eab6c9-5440-4c63-ad10-164d6f8e53ac@googlemail.com>
Date: Fri, 21 Aug 2026 14:24:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/220] 6.12.105-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145223.480031205@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.08.2026 um 16:53 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.105 release.
> There are 220 patches in this series, all will be posted as a response
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
