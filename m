Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793544241;
	b=Xpp5ue6X8e/y/bb/A8cGf0aFpJc4eaoFZ35ABvvqYPfeAL0o9Z7gzCtO6rVF4wKIr83U
	 FGr7bEN2e09RaWAlvKwDOql5ZJNBEz4rWqozoQ6WOJOKciVcGfcLygipPT25PiEiQp/Fw
	 w5n/S2Wr3BKbWhCANZWFEuDL/96Lihe8zS965/NOD2sxhgFW02vwF6dcWEyGyXTwgITA1
	 9HkMnUr5A4CZh0gWEqnNKvAjV8ZVpc7ZCHN1nylrqWJVD92qwhmYFC0KMmYBY7Imgv1/0
	 8+BtDbcmJAnH+dinmuQhyGQgGmfegTVz/G/7h4DtDjewX6m40mS5HFGiju+DpVgi/EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793544241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=oUyTfJUNz75/QBEP7R/YNu/IVgJrEDsKO2KorAjSqnY=;
	b=36VTFYB3xNQPHFRPvIkwlfbMrN+dPCdZrPJVCW3FBypkdSbf6jPKZJTl7K3g9RYz3HjJ
	 tjo60uObJerrDG5HcVBhaNYKCIQdiYW8SXE+/ikd0xN6C7X7waSkhrYqNMBB/EjpyLCvT
	 mOPGbQk+VcNM1x+rpOGtrvva47LfJ5Dp7XOgTCzq9dCDi/Vc4iB7gMsDkDaVcIXb5Jj4R
	 i59FtoLJandg0amfI8YyDIXOd9Uu5xDhWWpadN2MxwnU3veVbSw4m6tetp70zpc9+UdC5
	 uLaBRS/du5Nmfp+AeeUL4kQDMkkdt2coupvot7TcTzmB1bfbgid0D2kG0CfQEf1vPAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cEjC3pSU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFF9606A324;
	Sun,  1 Nov 2026 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cEjC3pSU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69071F000C1;
	Sun,  1 Nov 2026 14:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793544241;
	bh=oUyTfJUNz75/QBEP7R/YNu/IVgJrEDsKO2KorAjSqnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEjC3pSUU65PYApD34HbwzC2MMmjLmYi6OlWjZaCqRLnkqHw38435lbVOow767vyy
	 zy9AIbrOycA8tktJCpz1ZwTwI1cr2O7rVBiQS0aaKFzWth0JR4Gvblq7EwGZ+FWCXi
	 bfEDeU+C/ozQu2drzvaNV1EcGPLJBv44ENgQmsSLD4ldB+WzUbZanB03tRQfu01gOV
	 nMgPxYFf9Vp9F3qZRdor51md7/9l0v6KdN6EkGZsRWJAZoGNa+ndvD1RpSW5yuL+hv
	 Tg3mpKHau7GJiEhTebcirVwOkrQXRcJiNpeoQnsp9jwMLZSqCLaHAzce3RPQj496Q6
	 MB7WD3KCXUNvA==
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
Date: Sun,  1 Nov 2026 09:43:55 -0500
Message-ID: <2026-11-01-1-daily-reply-0001-stmmac-tegra-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <7e927599-10b7-44f4-828f-e50c0caf5f27@nvidia.com>
References: <7e927599-10b7-44f4-828f-e50c0caf5f27@nvidia.com>
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

> Bisecting is pointing to the below commit and reverting it fixes
> the above issues ...
>
> # first bad commit: [26c5e136ba4e94ad708333c9bd34039a1de397b0] net: stmmac: protect updates of 64-bit statistics counters

Thanks for bisecting. 6.1 is missing a prerequisite for that backport.

38cc3c6dcc09 ("net: stmmac: protect updates of 64-bit statistics
counters") allocates priv->xstats.pcpu_stats in stmmac_dvr_probe().
6.1 does not have 2eb85b750512 ("net: stmmac: don't clear network
statistics in .ndo_open()"), so the memset() of priv->xstats in
__stmmac_open() zeroes that pointer on every ifup, and the first DMA
interrupt on a dwmac4 device (Tegra186/194 EQOS) dereferences a NULL
percpu pointer.

Greg has queued a revert of the backport for 6.1, so this goes away in
the next 6.1 release. 38cc3c6dcc09 can come back to 6.1 later together
with 2eb85b750512.

Could you test if adding in 2eb85b750512 fixes the issue?

-- 
Thanks,
Sasha
