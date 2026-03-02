Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A28E47D95D;
	Mon,  2 Mar 2026 19:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772480171; cv=none; b=iqrB/njmVJ1n3jtoMeYruuPoLk28ZSfqd58VpygLbprt8gawTKllq5hC8Pt/vMsAnXBe9I9EIWASpsgL573ojB/ex2AqbZVAr5XFJbrYhNNQFLBpvtE3T7EgaM1V/aPxhj5xUaK7MZjqP5lQXThaebWfZIvSHrVgoP7xuDD7/+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772480171; c=relaxed/simple;
	bh=D6QtHe4YlHW386A63Ro+xk6XcXNexurtw+/+MWgaJZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQj8iTlZipr1FUfBa9lIeYaM0Y2RJGQxtpww7EveYo4t7k4yEf8bWIyQR3NxhVjUAObFQWiBL6IbwjjSJtqSonZGC73F4HU8Rravnu3/ys5CdfJZEAZdiwBy30V+LVs2JNt6R5TQVk9h2yjjZPCKEGV6lc7i1wjR6U4tXB0BkzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: sashal@kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	patches@lists.linux.dev,
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
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/684] 6.6.128-rc2 review
Date: Mon,  2 Mar 2026 19:35:55 +0000
Message-ID: <20260302193559.3432-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260302160934.2521545-1-sashal@kernel.org>
References: <20260302160934.2521545-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results (FAIL)

020/020 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.6.128-rc2-ge6906aa7f5ea #1 SMP PREEMPT_DYNAMIC Mon Mar  2 17:31:27 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Builds, boots and passes network tests.  Fails to poweroff.

Bisects to commit 3ba77c48498f0fa29456e2435d7d49eafc0a279c (upstream 4589712e0111352973131bad975023b25569287c) and affects 6.6.y and 6.12.y. Other kernels are unaffected, including mainline.

$ git bisect log
git bisect start
# status: waiting for both good and bad commits
# bad: [e6906aa7f5ea74831bc56d675e1173abf4d1d5a8] Linux 6.6.128-rc2
git bisect bad e6906aa7f5ea74831bc56d675e1173abf4d1d5a8
# status: waiting for good commit(s), bad commit known
# good: [7a137e9bfa0e1919555d60f9dc0c05a7a5ba75d0] Linux 6.6.127
git bisect good 7a137e9bfa0e1919555d60f9dc0c05a7a5ba75d0
# good: [4f052e01c0df1f3dc9d89125466b3fa8ee4373d6] hfsplus: fix volume corruption issue for generic/498
git bisect good 4f052e01c0df1f3dc9d89125466b3fa8ee4373d6
# bad: [2f93eb27e8efeb0002eba89a82778d569a336279] thermal: int340x: Fix sysfs group leak on DLVR registration failure
git bisect bad 2f93eb27e8efeb0002eba89a82778d569a336279
# bad: [8a4170ff96cdf6899b63a78bc588e96ecf0d6063] wifi: rtw88: 8822b: Avoid WARNING in rtw8822b_config_trx_mode()
git bisect bad 8a4170ff96cdf6899b63a78bc588e96ecf0d6063
# good: [51de6101987dace2f4a6235f5b6bd57dc4487a46] media: dvb-core: dmxdevfilter must always flush bufs
git bisect good 51de6101987dace2f4a6235f5b6bd57dc4487a46
# good: [21129c98b9191dcb1590084871266ab228a8daf1] hyper-v: Mark inner union in hv_kvp_exchg_msg_value as packed
git bisect good 21129c98b9191dcb1590084871266ab228a8daf1
# bad: [73c2788b3f488c6d559abb2a4acce54fc6108530] ASoC: sunxi: sun50i-dmic: Add missing check for devm_regmap_init_mmio
git bisect bad 73c2788b3f488c6d559abb2a4acce54fc6108530
# bad: [059f60a78995ad5f3dea512a1b8d31067f3cce42] drm/atmel-hlcdc: fix use-after-free of drm_crtc_commit after release
git bisect bad 059f60a78995ad5f3dea512a1b8d31067f3cce42
# bad: [3ba77c48498f0fa29456e2435d7d49eafc0a279c] drm/amd/display: Ensure link output is disabled in backend reset for PLL_ON
git bisect bad 3ba77c48498f0fa29456e2435d7d49eafc0a279c
# good: [a7953ccb0261ccb358d15f9d51cd85eb6e7fdbda] virt: vbox: uapi: Mark inner unions in packed structs as packed
git bisect good a7953ccb0261ccb358d15f9d51cd85eb6e7fdbda
# first bad commit: [3ba77c48498f0fa29456e2435d7d49eafc0a279c] drm/amd/display: Ensure link output is disabled in backend reset for PLL_ON

commit 3ba77c48498f0fa29456e2435d7d49eafc0a279c
Author: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Date:   Tue Jan 6 11:11:19 2026 -0500

    drm/amd/display: Ensure link output is disabled in backend reset for PLL_ON

    [ Upstream commit 4589712e0111352973131bad975023b25569287c ]

    [Why]
    We're missing the code to actually disable the link output when we have
    to leave the SYMCLK_ON but the TX remains OFF.

    [How]
    Port the code from DCN401 that detects SYMCLK_ON_TX_OFF and disable
    the link output when the backend is reset.

    Reviewed-by: Ovidiu (Ovi) Bunea <ovidiu.bunea@amd.com>
    Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
    Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

