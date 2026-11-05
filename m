Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793903969;
	b=s/lqAq4VOrhza/n8qdbd085Ao9ODuia1cwAUTG2fjmwgeVszgyg4vn0cndBOP1eqJ54M
	 q33QNyoGsxsP8ynqk93yUZIGB8NKGfN8uXFtPS9evTaMX1+XbCOiaN/KO+0odAhCbdWJD
	 R5CD8dQFy63cFKFDdtG3eye8YPwpfpKVsVtYmwr8Us9/uUXefUO69CqOhnrURnog+cSDI
	 H1ICaUZlEtRz0R+Y91GN5C3Vetj60dbeOEUiQtw+9r/C2jODKA8/Yj5+lzTmw6LBfqb6O
	 J0Vw3mLtRXgDrGejwJVqTlKW/R28YcfpPpDR8i0y5aFamjNaIfIXUK5Fql0nIBb10QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793903969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=kyJKFe+Qufh58LhQv1QPoZOdsh6S5H1jMiL/jMeFUDs=;
	b=tXbpdo4w/4yLhothuMmX59BfTQrCvQD4V0WPOSo7B2SCiHrd+wPS02km3utdDQjHJd3a
	 eOixT2BSgianFBfyPhKofER4Mq5MDiBeYgdAD+RyOlI2Sj2qtOR/bhQU82nRkj2uGYHNR
	 U9NUtje0474wdvD5/ZHR4x9U/SsCaTULD45oQgb2H93oUj5U5t/rIQ+VqavdOBvEfssRX
	 cbjM8GLahFU5Xwy0RUJvcXK6C02tvEL3fLv2ME61qzY4VuAPRNNdfS08ozgcu1mKyl8vO
	 WOFwsFt/6EON67LrCBn9w5z5SibYdoxGirrx8WkDuaKP7h29hB+8VY3qDogAdt6wLng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="KFCPo+V/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008D9606A328;
	Thu,  5 Nov 2026 18:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KFCPo+V/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F5A1F0093A;
	Thu,  5 Nov 2026 18:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793903968;
	bh=kyJKFe+Qufh58LhQv1QPoZOdsh6S5H1jMiL/jMeFUDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFCPo+V/yPd/NgrnBy73Nul/Kx0CTjbWAFZg5F3e/z/gzKwpDHU9ukLgVDFmZHcQo
	 E3xBRcQ2CvercMgKn/qBJqtcqqJOJxlGTG0TSS7z+d/o7p2Li1i6VWuEsq8YMsUP5h
	 6vPNYCQCGNTMXLETDpkdeu8OUa61I2XHPkIYh+oSZ00SGHZRoCj8kWyNX4fNu/cQPT
	 Bq5pOxB13KyUxNuQ6HtS7MACeLKHp+vbhDJhn+h9DXUeAd3qgF1fQ6J9GJ4ehODPlG
	 Bto3YFqA6Uamiaadahp3GgokdcBprw9orWDsmnil3pUEc8TLzzSHu4TIQSpI9ov+nB
	 hsXLHUhhK7cfg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
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
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
Date: Thu,  5 Nov 2026 13:39:12 -0500
Message-ID: <2026-11-05-1-daily-reply-0007-7.3.2-rc1-wx@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <3dfb9b8d-3bf7-4fa2-89ec-6561c1b7b70e@gmx.de>
References: <20261104211038.406938024@linuxfoundation.org> <3dfb9b8d-3bf7-4fa2-89ec-6561c1b7b70e@gmx.de>
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

> I need to revert:
>
> "x86/mm/pat: Fix effective RW computation in lookup_address_in_pgd_attr()"
>
> otherwise I get:
>
> [    0.108037] ------------[ cut here ]------------
> [    0.108037] CPA detected W^X

Could you send your .config and the full dmesg around the W^X warning, and let
us know whether current mainline shows the same warning? The patch stays queued
for now.

-- 
Thanks,
Sasha
