Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F2A1B808
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 20:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737492100; cv=none; b=WPKPA5M92bDRbSWtAYxgTsFER4LHHGZ7Rh05YrkuWfm/qUnQAnNkL56J+b/saxeAUUe4jMuDYDQJtYgivcJOu/xrFBj/siz1bZEFrwzxEC7tszdltR+GqiP+khHwRd1MgSqrsbPJZEFtkGZMP/UMX1s/ZXGRCoMtE+Cgyu052MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737492100; c=relaxed/simple;
	bh=pJvD0Byg5cT7yNzWI5VwoB2sO2pY+1inKuBQY5s5MTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YRN+7jCkZMffCccO3WTmO8gAUpwgoC8gYlk7sSG2MfCKevOLC8nV0/Sbb0sncgVxm/kisFzoyNiG5gz0ILv3+CQ+AiV6s1GnRITnKdyjXli7TJlxWQnS4o0ip2qoHGHGzBN2AalQyHr+FdcrlE93xHZPWN9tMCua1yUE0K6uQrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TvJqL2la; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TvJqL2la"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43675b1155bso70438125e9.2
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 12:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1737492096; x=1738096896; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gqq0pER5wPkh5iGf1j6nB/PK1FvSTu5KMsWg0fDNlwI=;
        b=TvJqL2la2RC9TPg3m575ndP4GbqUJKiS2GykCPKQvSJGMfY/NbS5DmbYFL4ouXedjX
         KhEQun4zZjCY/aM81ui5iyKxkt+UD1nR29BkFZFLszQ5nBfzhWIumUjtRvmINfFd+abz
         T7hrKiv58ZmJQ032O9UVfirwYS3s+jwqBmIRcLq9f0yr20nRFHM7+rDgWTPk8qQDZp+G
         9xUP1qgkvcpwPn9DDFcr1GHxCK7Q+zadI8ylgzxGoNBGIO9P2jv5WQs7adibz6eph8hp
         ZkI/B1+8n4xK9mNxw4Smb84YUxFtXkjVOoW9WGKK2j5dwKLAMjJPPW3kWdjliFi120aT
         PVAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737492096; x=1738096896;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gqq0pER5wPkh5iGf1j6nB/PK1FvSTu5KMsWg0fDNlwI=;
        b=fpFZmtndYrUhEpeaiCAILom1vTo6TGWqCFKfzYMPX7my2Yhd2bdj1wEDdeBEHdVczX
         PfsIZIQNjpi9sFPR8N6VZ2NcYZliHAILJOZT/ZO9xqvHuuBDR4DKA/6KNwDiaCxewjZj
         PZMALsB7Lw71myuFU96vYOA3lkx6Ni0ZNNQjNha++OGcwnWeXa2POiy5Sf4JnGDIU313
         Nx4RT3cQ/ClI4EJ7wZ23bWX/xURVj8DYSdC+wtMu59j6tCo1QqQmEBI9TtbopFkkfaZM
         +Ls+h1cz5C2M8Q924WByitD80v4M1rgiz//5+ZO498Bm3ETNxQEY5/AXp47KebpFI1ZK
         dBkA==
X-Gm-Message-State: AOJu0Yyhv0imDn3mIBzz5F5MRmUViMuCEtHMvOcK6haDcoRkU94r+V2d
	ikLCSiLsgExiBd7OkmoqYnBSk2IMjET7l9tEs9YSqTlJYNjGqCo=
X-Gm-Gg: ASbGncuDsEK5xbXsVlGVlmm0WmIawbUL7lh7qbt7sZeJYeJfry/0lzN69MSWVmxuyxR
	ShMGZ5F6o0ol2RszCCLzhCjByUzIdNmgWx1/Dw3v0EJMmPR2B/AEQmZF3z+UIat5QQkKsp6iB0j
	iHF0VcA6tbYVqjYz5ygI85OfBiJF2y3MoDN+DduyP86wzDpy6oZipwfxcm4z5JGf4i4KMGGIH7B
	7WpgMuWb9nmJst0De52mdPA1wdig4L3XaDUJa2S2zGAEs7Dk6OLcsXU3HTPAK5mhSL+38bKZgHr
	Storhq7elenVrp3f5OgM7RqK0fv+rOxqS7uuWR8h7on/rK8=
X-Google-Smtp-Source: AGHT+IHkUE/jJDfPnSRgFVx3UNOQex96A0RnCok1gUEbjuI/9XZFAfiBKTtsB/KE1zltqg0GNc+KYg==
X-Received: by 2002:a05:600c:4f42:b0:434:a7e3:db5c with SMTP id 5b1f17b1804b1-438913cafacmr196268485e9.11.1737492096363;
        Tue, 21 Jan 2025 12:41:36 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac60b.dip0.t-ipconnect.de. [91.42.198.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4389041f61bsm190232765e9.17.2025.01.21.12.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 12:41:35 -0800 (PST)
Message-ID: <3bb3ab8b-66a4-4da6-8f02-125ca37cb4bc@googlemail.com>
Date: Tue, 21 Jan 2025 21:41:35 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/72] 6.6.74-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250121174523.429119852@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.01.2025 um 18:51 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.74 release.
> There are 72 patches in this series, all will be posted as a response
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
