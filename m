Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061889;
	b=2xs1QgNV0B6Px5Nem5C+vUpNIKBIpHmAa9Ia2oSYHsPeHAD1GXz1MwOVIegMnO/x1115
	 Jvl23mWmuxiGck5XOFWuYxXDDZkCC/AhCPpvPlagIb6tl3kf9b5ZV6K72cqZIF9Q3gCzZ
	 XLynZ6N9P1Yu5rZi3+Wdd0KEAJmARgCi5PkFy8npLraoTVdPiNB8j6hlfhd2HhujmeyYk
	 99trCDvaLekl/rIjEs0DPKNXkJahdhL39NWinkyVQVXxFb6vqnVOQHRbQUPL1MyKfU1Pj
	 sIxgyUeYGl+7j+OYP30LtZ6n5L7/IhMEwb7va3EKNF4nZ5IY4ekxPwpyFJcatLcgXeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=//SrRlVDx1aijDcgODKxt0rHsLD0piPNDvAyuUexDyA=;
	b=3SJVPy/i4Yj4uET84HbyjlQyc5lkeyOqbGCZsNAg4XRjKp93suNK+gS+wo8CwXh3MAqU
	 qQUbpyzePnz1k/ip9+8t2TuocQfD5PMKl7Tw4BqQTBVj7E0RAqoqz4ivXazEJOaskNo8e
	 fqsQsCe9yzdS4nPBHeSf+b4JhTkbpJ0sgH/8eMF81IBbXFq878kclQ2Dsb19k3bqDKfzL
	 MScYmZj9+6S38KjYKyJwOCRmcL9XKlXsiNKfPw1mosEkOPm0X49Xq6G4BTmSWAPCkouN0
	 ZQkyHmmSjj/uxblMFovXp9OfNdwuj2LTIPR83pVF7Hw8fYoTf56tVU+KYu+DF+K38Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wgwhxKch;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE21C606A33B;
	Sat,  7 Nov 2026 14:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wgwhxKch
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199491F008A2;
	Sat,  7 Nov 2026 14:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061888;
	bh=//SrRlVDx1aijDcgODKxt0rHsLD0piPNDvAyuUexDyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgwhxKch1fm9v1qyXrGlYumR9EE6a4LPJj7fqF5lRXN5fAziIRAj5xc7UwPk1jNRi
	 7m8gfeTlSMjvmOUKXishhI7cTv6aVZw9I4MEOHAvozNSyg/ZThTGyM3ZWAZkRqZBIg
	 7mAP9qYq6rxNf06BMcCq+Fc9YKAS3ecU/vvxK7O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0899/1536] media: meson-ir-tx: Ensure probe error is propagated
Date: Sat,  7 Nov 2026 08:48:35 -0500
Message-ID: <20261107135022.883120881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 2eb8a4cba70f521a8217021e227cfa28ba17724b ]

devm_clk_get_enabled() may return -EPROBE_DEFER which needs to be
propagated else the probe will not be deferred, it will fail instead.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index e8e3c1a303279..1ab898069e67f 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -292,7 +292,7 @@ static int meson_irtx_mod_clock_probe(struct meson_irtx *ir,
 
 	clock = devm_clk_get_enabled(ir->dev, "xtal");
 	if (IS_ERR(clock))
-		return -ENODEV;
+		return PTR_ERR(clock);
 
 	ir->clk_rate = clk_get_rate(clock) / 3;
 
@@ -325,7 +325,7 @@ static int meson_irtx_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return -ENODEV;
+		return irq;
 
 	ir->dev = dev;
 	ir->carrier = MIRTX_DEFAULT_CARRIER;
-- 
2.53.0



