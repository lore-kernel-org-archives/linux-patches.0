Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326392C190
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 00:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744245574; cv=none; b=SvGeBDFVGuCqcp8IUxy4CjJT0eH/93MCu8o4rwRxKiDqIKjzwIT+2+CCIuLeNZexW3iBvsLXR9e7Z3xYwrfd60eX1CBKFAVpI9B/mq5Au2POBEVcWdtdrrBQPLyH0HUbZVdB1iV9ccqJX/euZYzul2enLTB/Dv0KyeTlLt5XCCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744245574; c=relaxed/simple;
	bh=v1xTqYyQGjrdHdfqnJMCy/GEsGpvzq0zxz4dc1BbO+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uEtblcp4Y8UqpWlPmwucrM9VG219j1ApL2f0Nzp6zFLHM7rdrrvIQTnZfRRHEplbpSfGlJaV6gVH6IZxn1GhiOCl7NQy/ZTRb34mZSE7ptubYiOuYA4HnhKrkoNq9gwP4DjZBHSIbxEVd4hD/ivn+bBbT0rlBBzyRAhF+Rv2fos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=CnFju3Fm; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="CnFju3Fm"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cfecdd8b2so2185495e9.2
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 17:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744245571; x=1744850371; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WR6EtZhgqa4qIvzL5KBbZ/Tlso86MFa8EDmz2drhxVw=;
        b=CnFju3Fm+rIxj9p9RNR5zqt3ywY60BO78qpljLfB4ij/o/3JlV1ZwTT3AiTj0Nj6pL
         oF5S3EhANeuWZWHEe5P3PzoDfEkjNATm6TIFX0Z4A8iM7rOxGoc2gEjY7/jEw4OtNgVG
         6jCS1Hfzl/WwHmIWBaB/G8CngNttum6C35qWVw98xWGKFSMa/haeNpQoL773kjknar0k
         9UY6ZsUPQweh0LfjZTqho3TAYc1tGmKDtu7qgC/0fZWgb1IGKE0u9d7f+TKGfqw664RW
         DsBymV+BLABfnor2C+4eezicmuxAU1CcfbfKsEGqDZ0GkKsUM5RYxyTUXumsipUgCvhX
         k2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744245571; x=1744850371;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WR6EtZhgqa4qIvzL5KBbZ/Tlso86MFa8EDmz2drhxVw=;
        b=DCiwY+NYmg2Hnqf3FuP1KypI8Nj/xllTjlbiVmZno5oMkW6jLyGuXygUnn3jX2fcjh
         xU+K3fjj7GWQzBLomhbTXefgYrGO3u9dI9mnLxAHXqORKRK+nrI10glpapGagQqyr1yz
         eGr3JrSRCHIqGOu6WkxJ85ovBO9xVNxHiuFnF1PN+RrSsWUplBmMsHYR7/rdOmmqb42j
         IFy1OLs2B1tQh2p8bKIT1tXVoPQs/OseK+ebGZKLJnXO0w2sSbXqMaqpbGkI5WxsONkA
         Iq6zTBvpq0hM3M2zvRpDIV7LlE9RiKlYMmbKE9qVobsgudmPYRa7WIi+/DDuc0t8lmFE
         JlLw==
X-Gm-Message-State: AOJu0YyurTiReHtMx+YFoAbZQWZgkIZI8Eot7FeSM1xjRHOM/qa/a0bm
	zMivwq3p4pMT+m+nD4L0jUdN3dLBKtmGgwnCNi9SRLLFvMxES0o=
X-Gm-Gg: ASbGnctiRELdCsvvt6IvAc5J97N26BZ9Yxj/avzFD49sdHyytOLBaHCBQPwNtqV+MUC
	ljE67bAbAtgExHW6yFbHD2qCLF6/tzenEw30c+YjW9k+xmR5N/1Raq+epIBED1Ezkq8/GDVe7j3
	aaZjYqMd9Me/g4L4s+n0mGr4iNeE9u+8uNorvX0kTGBJbiWFbsFlhjrAJlADCjBPU9m6Fz+FBjG
	bRiZ1CFxWEAYKI8qVAs4OLwf7mSLUBRLhfo+uldom2411BfnAVsMo7KHoFuGwBaJ+L65BtIgZ60
	EIxz0UCfL7vmE9AEMdIceFv/PtxeZoArUfYitazbTlpMVpmV61/o3JTwTTWvmci/cgDRPVYU5Ty
	OLdbeW130SOaZbn+smsEIJq8jR6s=
X-Google-Smtp-Source: AGHT+IEGLlOEVjD0cfNCMZEAvQK/rkLT6cKka5phhDaoU/N8I3k1WGhfmz01KwcDGykFj9fymvC63A==
X-Received: by 2002:a05:600c:3b19:b0:43c:fb95:c76f with SMTP id 5b1f17b1804b1-43f2fedc137mr2644815e9.9.1744245571303;
        Wed, 09 Apr 2025 17:39:31 -0700 (PDT)
Received: from [192.168.1.3] (p5b057855.dip0.t-ipconnect.de. [91.5.120.85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f2075fc6dsm36304595e9.28.2025.04.09.17.39.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 17:39:30 -0700 (PDT)
Message-ID: <3747935d-8e6c-4971-b7b1-b53ea9dbb6d2@googlemail.com>
Date: Thu, 10 Apr 2025 02:39:29 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/502] 6.13.11-rc3 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250409115907.324928010@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250409115907.324928010@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.04.2025 um 14:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.11 release.
> There are 502 patches in this series, all will be posted as a response
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
