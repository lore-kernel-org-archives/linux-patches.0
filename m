Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795140556;
	b=yzTM48SYAvo3W2x/50kmS9Js4b0uZoj3bbONs8WwZlXbewPdRwK7q47XouP0Xg2cFQ34
	 Wxpojupg4zzqYFq3QLTLJssjfo6Fyi55ABwXSK6PYJuk/NfT6c++QbMJu5slrd/sVvkx9
	 TcaWD2YKOHMs+G2MEGg49hKpzpZsLnU3pV14HZm0OfWiBPp5fZw8tjy1mCnR5WYvq8YKo
	 ha+GpwUqyJf1PXJFGqLwGpOXa+3QJDPZkF5byu20AX5Wakg0aepdPSp6CVZ6G7Kp3Awb2
	 eeLj5okQD4Z8pPdpzFkv2klUdnNjeRFIve4FXlPLhRF4/iCw4lZSauDPsLs9bzPiBzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795140556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=JAUMWmcYww0gNXJnkOBUX6UvV/NXWII9ClecizNz0s8=;
	b=SepMbLVPUmvOFIVyPNg3PPUGmMSTvLl7rLiXFa6V5HqPDlQd/rr1qXkVpvjg8GG1g5h2
	 t7uZ/bQBUzuvH15FdeVRZOrxHdY0nkWiDTBmPlrXGQ4oSb2cTfn+ParnZEC5vYDPx4KSZ
	 SSlpy0hg2oC4zbt7+hdEBNgbZT/e/WeMK2i+KtHTS3zxwskyxgIoLQ/4Q1b9zrtfyqP3c
	 bklD+cB8bJOlGsTytQTbAeW9sp5hBe3pPnvBTWCALLu0nAhvIcJKxNzd1o4bI42f3i70P
	 rqWP0FMvq+YzdZFbxVAHtFOEA89SlVWyH4OfeuI/nCRTmibOgSDdwGjGJHdCgBj1hoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eG+8vBHm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEA7606A33A;
	Fri, 20 Nov 2026 02:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eG+8vBHm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B821F000E1;
	Fri, 20 Nov 2026 02:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795140556;
	bh=JAUMWmcYww0gNXJnkOBUX6UvV/NXWII9ClecizNz0s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eG+8vBHm9l0XHR8etc2ipUj/uyzFKiBgotij0swgN4Wt3vJHCAE1d0MRUVVKMj7PM
	 Lq9haYiLgn5vG8RbV290j1DGRZjFNmI0zu1qyGLZ/v7Gcizs8b0b97caOZLUeNuOqS
	 6N9vU7EHmMsWr08n92u1yyRf4pJoVrP+h5K1/8VpLWT9sTzV/KSi8++pG7L4aNc6he
	 kFZxs1WhhRXYAWsJyLyDwyuD2R2jjzNXCLbVZ7cfq8c6kP9nIbo0Sh5VjUQRdXDuAs
	 R1u16tYmzE2s/SSPGirWhM5UnBm8ixRkvyQh6Mkdx4/OCad/jpfnPNQGw7K/17/3VN
	 CehrIGMOPm5uw==
From: Sasha Levin <sashal@kernel.org>
To: Pavel Machek <pavel@nabladev.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 0000/1848] 5.10.275-rc1 review
Date: Thu, 19 Nov 2026 21:09:00 -0500
Message-ID: <20261120020908.2320910-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <av3a38u7mlLN6yJL@duo.ucw.cz>
References: <20261118145911.150052362@linuxfoundation.org> <av3a38u7mlLN6yJL@duo.ucw.cz>
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

On Wed, Nov 18, 2026 at 06:05:35PM +0100, Pavel Machek wrote:
> We get build failures here:

Dropped the whole queued ste_dma40 series from the 5.10, 5.15 and 6.1
queues.

6.6 and newer keep the series.

-- 
Thanks,
Sasha
