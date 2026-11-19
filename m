Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104544;
	b=PXSFJA4rqlqZnhUvKegU7/RH9+vY2RgnPB9C/gqJzGydgqXfjv7uwUg8jEWGqUCYYwAP
	 rlHO8GxFoIqtMVQ6M6LrFZvfZVbpEdwxphctmZZ+rJGyzI5L4gkNn1aLIGqaG0T3DqXqc
	 9UG6zWMdS1M5Yn3f0zgbuMRYF6g36BvVOE0fNxq4B1nO+2xuuoAX8KVoAAGXp7Oqce3DW
	 z26Hsf3XVoCZdzPJRfZ7mcIWbX2lWpU7qjy2jJnNu48DwmVSq1nzMUYh2MTs6pFXxoDJs
	 jcNhC83bBodzluQpMYTSPJtslP1y68jTIR/RL2h7NMGkOozXBkh3ZPaI88tNePc9dsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XqmKc+XBG1VAK4vWqNSjv6YPlh+RX/NQ7jrBZbtJy5M=;
	b=TflLg5GGHOeUINi52RSj63e1dFPpd+VCr4rQ1kRETtlklGuZtgFOuwR1hqUPBmCz6iGX
	 0b3tWm8gBF27wtxakM858WAJvkcas3yhnTCU5+PoUOjxybFX/o7meJh8CVeH8eCkPdlpz
	 7qBAvzI9yeYxFqt2eotmQ1KVpLHUwGrehULXGbeJLEHbZRGvdrAY/wH0+oPgZYqRdC3ZV
	 nJqnZCtoQ8e+n1MzC3XsRPW3Tp3O7vkcqg7XZhJfDw0Ns3hDcZwg69XacGUxdigh9xCCO
	 3t8ixfof9DmZaiNBzZUs23k8Uxu70oHmi+VwD1cphOHtxk6pePuDIydDrOER+IueF5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nZM2OD2y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01DB60A2608;
	Thu, 19 Nov 2026 16:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nZM2OD2y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B51B1F000C5;
	Thu, 19 Nov 2026 16:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104544;
	bh=XqmKc+XBG1VAK4vWqNSjv6YPlh+RX/NQ7jrBZbtJy5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZM2OD2yckFhye3cYK6Aj85GlLJ9Pyc/7/ah5IsxkFhVl0f9zyWVbEquZA0aYjmQW
	 kNHUAOYON6+b2/KM5rnN/WzIQSMv3RKqyQUSVouZJjx5fJG1sAZjKvVPVh3nRXKUKB
	 QDf5wg6VQa1ziANUPMaBT/sglPnsmMiDum553hGRbuvlzqelYoYi7xBaNU4SfrWpIv
	 Id4MrlAg4Ppn5WHrVjf6vwNYGIqlDslKHbuq2GGqMuMtOaEsmHcbFI4H0GQTAeDVNZ
	 PH4KZ+mka4ZCkftl4NWngyItfUN0rOsLlLiADQkJcNlgBhTdpKK94iGQ9jzl2sHkNR
	 7dZXMKgQ8vH9w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Sergey Lebedev <lsa.uz@pm.me>
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
Date: Thu, 19 Nov 2026 11:08:28 -0500
Message-ID: <2026-11-19-1-daily-reply-0026@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119032558.37385-1-lsa.uz@pm.me>
References: <20261119032558.37385-1-lsa.uz@pm.me>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> One problem, reported separately: 1120/2651 (debugfs_create_str()
> read-only) is queued without the two patches before it, and warns at
> boot here.

Thanks. Queued the soundwire conversion for 7.3 and 6.18.

6.12 does not take it, so I'm dropping 5ec78be95520 ("debugfs: make
debugfs_create_str() read-only") from the 6.12 queue. 6.6 has no compiled
writable caller and needs nothing.

-- 
Thanks,
Sasha
