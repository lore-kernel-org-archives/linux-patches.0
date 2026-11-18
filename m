Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026770;
	b=IZAcUnIBodmUyMItcDbv3IO/I1Wd/Dmz+c+dL9SAHKJIm4pCp0jC64MfCVJnqIUYGVk4
	 myWiejp/iE5/9AM8swgb2hTevwRtJ0aIUdnK4XFyR29F6LTIh3r79N81Y55yNGtZSs022
	 B/KXT6V35yVi4eNutlPz0TvIQFSIM3y0zyHWaExGIVgqscN5p3YjeblBcT19oGDBo+Cdb
	 2cH3M2bzR37iJzQZspyn2HGGnwoSpRvAOshrP8H5Rb7T2OMNGx/q5sXvEaTfGZ7zuHghh
	 ASB9P5YCHSvQd9yCs7DDuErkgcfKIzNaLXtNjAJMUk7hv9bM4HNOBEuQdDC4jOf0/tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QbTfnVp8Jw2TOEiIbiCv2Bom+5RiQm5DNNgVFzpapNc=;
	b=iFLEDYDMNbs2XBwiV0f6htSLlOW02EievkCpxqjZ3NJGuXoBKS2y9PM8DJFEALeEgYSx
	 gy9yW+JfAg3eWLn4tqPc5b13QuzPPUn8V07zGn2up707lpnDAFMevtax7E0Mz4Ttp9O3G
	 xiggisvCdI4ts3hbmAJ68YQ0PyRYv9TyMekGX2k7f7ylOhEaTSrtwXcirLwf4UyjS2eGu
	 4XImKLG0Pwjyl5uJDv3ekHNH8kl1ZRQbw5QTIz7zW8hBuNAFR+kBLYvDHYL03yWu1tfsh
	 eFJaN7yCFpcld0ey94D/4dIXePMRoqIJGvCrxQdNZkxVzhgr2o9vi2zmSPW5/86iRzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bsemuoaE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A537A606A32A;
	Wed, 18 Nov 2026 18:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bsemuoaE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071851F000C4;
	Wed, 18 Nov 2026 18:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026770;
	bh=QbTfnVp8Jw2TOEiIbiCv2Bom+5RiQm5DNNgVFzpapNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bsemuoaEDjpxA5/w1yxHVYHVOa1pR62ju6ipZw12Ez95y6r9iVWt1APV8wvzjjUhY
	 Le3aefG8/17ngUE/ZgGE1LhYOAujJop+cpt18EQGYEU+rywWWE7Y1HqQ8UhnpVe4PM
	 VzX9lostVHt1sgLpEIkEXWKM7azO1P8m5fd2cCOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1551/2151] clocksource/drivers/timer-ti-dm: Handle runtime resume failure
Date: Wed, 18 Nov 2026 15:54:46 +0100
Message-ID: <20261118150218.405778375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit c40b76c8cf580466d9e56223f7f74beecc165480 ]

omap_dm_timer_write_counter() accesses timer registers and updates the
saved counter value after requesting a runtime PM reference. If runtime
resume fails, the timer remains inaccessible and no reference is
acquired, but the function still writes the register, drops a
reference, updates the cached value, and reports success.

Check the return value and propagate an error before touching the timer
state.

Fixes: 0494fc345b37 ("clocksource/drivers/timer-ti-dm : Capture functionality for OMAP DM timer")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20261003080812.429386-1-yaojiale02@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ti-dm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-ti-dm.c b/drivers/clocksource/timer-ti-dm.c
index 793e7cdcb1b16..37508d5a1670d 100644
--- a/drivers/clocksource/timer-ti-dm.c
+++ b/drivers/clocksource/timer-ti-dm.c
@@ -1076,6 +1076,7 @@ static int omap_dm_timer_write_counter(struct omap_dm_timer *cookie, unsigned in
 {
 	struct dmtimer *timer;
 	struct device *dev;
+	int ret;
 
 	timer = to_dmtimer(cookie);
 	if (unlikely(!timer)) {
@@ -1085,7 +1086,10 @@ static int omap_dm_timer_write_counter(struct omap_dm_timer *cookie, unsigned in
 
 	dev = &timer->pdev->dev;
 
-	pm_runtime_resume_and_get(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		return ret;
+
 	dmtimer_write(timer, OMAP_TIMER_COUNTER_REG, value);
 	pm_runtime_put_sync(dev);
 
-- 
2.53.0



