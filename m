Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020322;
	b=1uU2+WIld16nzRxulWpHt///AF+qGorjejeZ4a5hvtedgceE0twmYViqkH8Qrxs6D1MH
	 cUQvIwwIKtt77iPkR9Yx3icCsaNpjd560M1Kf77o/YdBSpdP8kWSx6h/3M/Oq+iJWaESo
	 gxjxE2HBqTDYGzOUx+xXVcTnzfgCfbHi+1Z80x/Mgdtk2PFeHktDhs4qKAwFMBIxtCNZj
	 XgYXtAPPomMjXeXkV4W8dEWLGqIHOsIOITPqwmIDf9aHFXrSBUUshNBz/9zp4iZ7A0f67
	 khEKp7Q3uSLNO5ZMkzubEN6GxFhKazfFcaASi5mkXjyx0NnsWHkmuXgv+9G/qzP3WpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lufbXEyJlomHAxNxhjZulvhdEtQvfXAWTlCm1Jbo2Lg=;
	b=S4rkzSVIt1glX2bBRDxq3NC/DGqfDebNr6MdIGZQ5JIP/jlQH+mEZKNoxnX2T81kDvEo
	 3Kh10Xoh/tzzRKudVaWeA1NAlu0QJ82dC2vZg+phup2GiazZfHVWFr/9cK4Wnk08Lj4RB
	 PfB9e1Kec72PP0NdSaEWIktgcs9wRoEDQzStMvNgPY89xZtKmnMy8mWObM6luuSirHyHG
	 lvk/4wtb9rdf5xZU5jQFnbCbpPfKhOV5lBDL+W7GatFg2eCx4UiZvKFdfPYw89Xma52Zk
	 9WlLfJaW0UxrUizRwDCOtvk7cN5IUWq3GU1Y/9CrZcg1DXakNGJ12P9vPI/ZFdZtdWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oogfb4mL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833B2606A320;
	Wed, 18 Nov 2026 16:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oogfb4mL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41DF1F000C4;
	Wed, 18 Nov 2026 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020322;
	bh=lufbXEyJlomHAxNxhjZulvhdEtQvfXAWTlCm1Jbo2Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oogfb4mLUuiXbFkgdN/vbWHSEVeWlMCFwHP2vGQnRg3epqWAzgqYDXSKjrGxepdAB
	 4IxbFA7cOiADcrUblHtGYJuW1flXMLOyUiSEC4+J2n32tCIzJgevlxrGz3Qbrmxp3j
	 20orQ4yWI03ah3VP1JoZBgviYZS7gii6i9zRToO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1909/2651] clocksource/drivers/timer-ti-dm: Handle runtime resume failure
Date: Wed, 18 Nov 2026 15:52:29 +0100
Message-ID: <20261118150355.520481524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ae8777d032154..8012d3f3e1a3f 100644
--- a/drivers/clocksource/timer-ti-dm.c
+++ b/drivers/clocksource/timer-ti-dm.c
@@ -1095,6 +1095,7 @@ static int omap_dm_timer_write_counter(struct omap_dm_timer *cookie, unsigned in
 {
 	struct dmtimer *timer;
 	struct device *dev;
+	int ret;
 
 	timer = to_dmtimer(cookie);
 	if (unlikely(!timer)) {
@@ -1104,7 +1105,10 @@ static int omap_dm_timer_write_counter(struct omap_dm_timer *cookie, unsigned in
 
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



