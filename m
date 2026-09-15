Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CFD3D3D0C;
	Tue, 15 Sep 2026 02:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437837; cv=none; b=SE4ZdV1nMrxjFctZFABSnKnpfMTHh0QbZv5vUEuvy8vXzdjPFhTvr3hKHfuCpkwJApynjOkI+fwE80YW/ckpnbBnd2r/rFJPwJDLIwazKOKsCjffYpZL4TWz85+xYQXhCnT1PVPz7w6P5DiL6aXY1NPy0YePdc+cHfJC5uK4x0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437837; c=relaxed/simple;
	bh=7nPzRkh543BMGexT5Tr7Q7qa0XfQ39TSnaaM0pY0HFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLqBtICA7U1Bsey14V/X9KO7pt8fU/4i9rHxp+zMzlGifnkyp4sfpD9Tr+fTU1mAz3MYQ1UQHc0xY/Imbai3zvSvBtex3uo7DFbpHhzud98egxWzHCaJoVuRoHtiMUn8pL2cMJKvl/Br8omtteWmCF/iMFH6woiUBF1CfPhzpiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tk/1izlY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tk/1izlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BBA1F00899;
	Tue, 15 Sep 2026 02:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437835;
	bh=z86349zkYz+9G791nuQD+MvthYksTsaOKZbGeAT8Cqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tk/1izlYNZW6R0pYuguL9gGyxZi5OXsed+up9gm8ZlcoAQMSgP0fJgkIfyBMWlwJc
	 ANjTVkLCKoY1wJHk+0gGVlIjGkwm0wgRsXSsXkTilSHJOZmKx05lhPMA5vCl9I0XJA
	 QQW9cHBTW03e74umi7YXV1Ugay++Zy2R6UbmcFBDmGwxSeq8dUbAiY2WcaAfrgReRL
	 8xm3Pfx162kUv6kor0F7tV6yv/GHSgXJDCfTw4USvlkkjzM2MfQJB14CSqV+As9CeK
	 tytGTUp0XouPVQoMmLHqb7tyf23TqUK73kOvoHPB2x9a5qRhyow2fKF2aQrmSeK6B/
	 4BnwSo2Vg4Etw==
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Herve Codina <herve.codina@bootlin.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kalle Niemi <kaleposti@gmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
Date: Mon, 14 Sep 2026 22:03:30 -0400
Message-ID: <daily-reply-0014-re-of-dynamic-overlay-probing@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d601964b-e437-4990-bbdd-0337bba49102@gmail.com>
References: <d601964b-e437-4990-bbdd-0337bba49102@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I believe there is an "existing easy fix", in a form of a patch which is
> already applied to other stables. Unfortunately I lost track of the
> relevant fixes during the discussion so I can't point the relevant one.

The one you are after is 81e7c6befa36 ("of: dynamic: Fix overlayed devices
not probing because of fw_devlink"). The revert went into 6.12.97 and
6.6.145 without it, which is why overlay probing has been broken on those
two since.

Queued for 6.12 and 6.6, thanks for chasing it down.

-- 
Thanks,
Sasha
