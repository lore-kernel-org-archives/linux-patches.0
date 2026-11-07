Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063813;
	b=NM8193C02VEG9hiQH88+3hehf4s8IuSPnoksvexX6khPC+7UyPsZHDhnntTjCoQZvDVC
	 SnazYB/G3OQijjMUlSPyXxKNHDZ7H6o7ZB32E+PTbXk+JIM5SD/XPK9upHUPyQU5+TQLP
	 PoZM3IBys/ctex1uPffzHFb4JegbX+FsjCyvHiNhtpvVn0JYpu5qIqCKskGopvdCxBmZM
	 dHCukmV0BbLF3zedUYF41ZygyjaC7YcCFM1TQXB4jwspQyoaZKynYLiB5bpC+XX6dsQ9D
	 kXm4sU/u6+Xwql99J8rRy/n9lJEJzJmTsYIfCY+xboFb25ZGLyRjwgk/f6uwdKyCUTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rmJXFWuZXjG7J0ZFqdY+5oudoK3rRF3ITX2HyAISKCo=;
	b=mtv9q2JQ9sW0Zh8LIyxjb/QCY5YqNCF5kIyCEbjtnBdUs8MNJoNrMmOZVTKcoFtI/YJ3
	 BCf3i7Y1KJWRJcVb1MrAUCsPXl9hK4KSs91eWadXJ6Sgq0YR35jscMTwrmu6GzxW5nWUH
	 2/egKLmn35YYf21RgDyQEhFJ7HOXQN1SSr7WbkITO59oQvsFf5RUwhbreRP004ZS7Oim0
	 CM1sjbmUnR1lcTnKSIISrCwV4Thrj/dJCPg6/rzsutHTIlda3IicDz/KoUTqtijLnpeQF
	 /l+Q6cxrVGBF4aRh3XGvnweJbwtii4Do2UzU0DD9p6zBy0JAtCrh3oDW1SFyJhiXSog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWnSHwwk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F26606EEA9;
	Sat,  7 Nov 2026 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWnSHwwk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F08A1F008A1;
	Sat,  7 Nov 2026 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063812;
	bh=rmJXFWuZXjG7J0ZFqdY+5oudoK3rRF3ITX2HyAISKCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWnSHwwk1OTRaIWOIpCzOpJpUG5+13H0RtNEC8TfkTqYd3I9E3Wie6NVvSr1HZv/O
	 GCHaGRbCVU6zwcq4Tx6ppUKDXnvLF4tqJ/MBPSo0Ce0rgTCJM/hldqpOvHWeJyMKpn
	 9j/6oDayjDPppf7blu31jHTF8b0VVcz3vi7QJ/Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0030/1257] media: meson-ir-tx: Ensure clock is disabled on unbind
Date: Sat,  7 Nov 2026 08:38:46 -0500
Message-ID: <20261107134940.240336850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 1517326fcc9dfdb9acb24f42472366ac1b4b8237 ]

clk_prepare_enable() needs a call to clk_disable_unprepare() on
driver unbind. Make it devm managed.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index fded2c256f2a6..6beb9e97453dd 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -288,11 +288,12 @@ static int meson_irtx_mod_clock_probe(struct meson_irtx *ir,
 	if (!np)
 		return -ENODEV;
 
-	clock = devm_clk_get(ir->dev, "xtal");
-	if (IS_ERR(clock) || clk_prepare_enable(clock))
+	*clk_nr = IRB_MOD_XTAL3_CLK;
+
+	clock = devm_clk_get_enabled(ir->dev, "xtal");
+	if (IS_ERR(clock))
 		return -ENODEV;
 
-	*clk_nr = IRB_MOD_XTAL3_CLK;
 	ir->clk_rate = clk_get_rate(clock) / 3;
 
 	if (ir->clk_rate < IRB_MOD_1US_CLK_RATE) {
-- 
2.53.0



