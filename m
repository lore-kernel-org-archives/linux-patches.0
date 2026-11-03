Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717536;
	b=ozvyOo1X/IWpp2CD8dex5dErfHuuR6siT7frnvEWpxDcYDQ0piv9yMx2YVQMlZHh778Z
	 u+B2OHnH8omX6YKioBg0C6GGzAOUYUqgAFxAOnBbLBvqPDPDxKTiEy1kDvJ53dpqq/R5R
	 x397Wjgh1gNMCCeAektjPM8m6hIbXqoXcnXtedGz+merCyyL+Bt34EITl8jkQE8bHi+nG
	 JCRoJifD0RzVzOLFGOAHQLToBg0Zy5hCx3Tlrjxdnvk4gD6nEH15Kc82zKbFCP85vMWj/
	 D6EcTgp60SKMMsm1tvOlML+uEi/axxKzNfAPDSnRgzhOHJJbdjpcNue9g/Ez/Stg6XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=vqtldXMQZ1dp8gutvel+gR2ZaMSMk3LkO6R06nCcmTM=;
	b=arvqmO0ARuMzYWbHw+c9j2ttyGk/lGL6PutBZiAXpGbi0h9eoQyKSo9sAX02mjVj8EIO
	 NVUYVJcgXvE7iASg4c9WACBDO+fhi8fckKSli7pIOdX3/+dmXI1aPJea6fiH4M3+YF/Ki
	 KVHYYCuXWYnky3CL6mvzYNCjfCEm/sBJjMHh+SYjSUGpHkozATJ0bJZaPyVlZcd0PByIG
	 J3L+KJsHVLhTz1gE/q6ovSfvQ0HF7MGRu2cj65K1AgEPBWLxL6yFT8PtUpsEkI37hkWyM
	 bWu4qprvEsk9xOubFJ594MlWP4YJoT9ohh2pzKXpE1UAv4P3tv9P0AuHIj4MdLbupKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ov7aGQ5a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A562606B268;
	Tue,  3 Nov 2026 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ov7aGQ5a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDF61F00919;
	Tue,  3 Nov 2026 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717536;
	bh=vqtldXMQZ1dp8gutvel+gR2ZaMSMk3LkO6R06nCcmTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ov7aGQ5aDSEPVJPnNKa5PvGT8AtPUk9WaotbMMK3QnggihKkFJrfxv4MvkdnClSp5
	 8unx1gkNIH/6fG86TEFjFW2KnjYG2n1yZFshFY89nwRCk3xVUk3b+nvG1BwcKiSvEs
	 BwuoDS3w9fhWGBjjVu6xRQRmMQP7D0U8k4A4SsOEIovUN2AUkOHRHtx6CmEIrHkSJc
	 X91fId757gewzIxtKjEFjj2Qcjy1BcLfb+IxwJ13m+BA0w59uOXYY4eOzQ98YellP7
	 TNduhKXZ6vekk99DdgGt1HjFAASCDQbK7LJC2Yjg3UXBI9Ln1ZewWoB6ehsmlLitET
	 eT4iYrR7ytWxg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	linux-tegra@vger.kernel.org,
	stable@vger.kernel.org,
	Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
Date: Tue,  3 Nov 2026 09:51:52 -0500
Message-ID: <2026-11-03-1-daily-reply-0004-re-6-1-191-rc2-stmmac@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8fd15777-fc45-4293-8255-c8d3d28a8156@nvidia.com>
References: <8fd15777-fc45-4293-8255-c8d3d28a8156@nvidia.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> > Could you test if adding in 2eb85b750512 fixes the issue?
>
> I confirmed that that does fix it.

Thanks for testing. Queued for 6.1: 2eb85b750512 ("net: stmmac: don't clear
network statistics in .ndo_open()") followed by 38cc3c6dcc09 ("net: stmmac:
protect updates of 64-bit statistics counters") again.

-- 
Thanks,
Sasha
