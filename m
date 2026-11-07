Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062850;
	b=oZk4IjDbXChUEkrqPR1mwC11fNBXRf7nhHJx1WrUA5hNhgOUpalYVKto7JZfBFG3pJI1
	 YnVfMrzmLsgnAS9vRF6w6nVHj2AM3N2qf11kvIPpvM2YIofP80PvpE4LkUIF0vV/8Fd9M
	 WsdVAkAqnM+fyg56zIJnhZabfBcHZo5+uAp7crN303Lkn3DfXXqMyZ1++UdDiIU2Kpq4w
	 Uu2q7l7GVoM7swL83kxV9CB41asHk9IVYt56y2262/lf/JWqaItXG6gzlgbspaWmwDkeR
	 QWbP7EfNJG9Oh50L4ImYpriJ/u5NipniPwPdB/otp/0++A0nFcUD3ELOqt0y4X7T16A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xMj9nZ0GH+qWcJ1HnSdYp1q/aqeW86UMiibWUkIgj3Y=;
	b=DLcicqNyddKcdTMDh+DCTbZiAYKqdaiDpI6fOFCBf+x1W60OskOxg+6gBfWEa5eZxgfT
	 RVQNLrRkldZC669GepK9sPj0JyGj77+XQxDwkL/3B3vkTTxiFOmu5JUAoY3nqCp0eZVqy
	 cqCZJdZ200XJFWuWm6g5o114cFSTFZo41ku8kYj/xqBb0ZYlBz6neZ6paIaVc5iiXd10P
	 BS80sooDVCp0bR1jWSNuaJFOD+NXpBYwJUtYDZGFO7vpOlVuCT21WKRBMlV4yE5e0Xka5
	 GwlGMuUl2764r6dfQ38kBiiQk4j4QbUQvRz0c488piY6nJYqJkUeLW04UYqiN1PplxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h/Tm9q0U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A27E606A333;
	Sat,  7 Nov 2026 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h/Tm9q0U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D841F0089F;
	Sat,  7 Nov 2026 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062849;
	bh=xMj9nZ0GH+qWcJ1HnSdYp1q/aqeW86UMiibWUkIgj3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/Tm9q0UNfNci0Dwn9Zq3Iw2TNrCBZIBVaQTvnIG26T81Kx7BrcWO1BV6lrUNxpeY
	 akbmQhXWODa+fsB2PdMjfAtWkguLSssA9MSMaWSEC2jTXf1OH8vgsBcO+25R36fkuV
	 TGrd6HJI98U+BSW84vdlGIRDHgZblIPkHsUNYpMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/869] media: i2c: ov2735: fix power cleanup on remove
Date: Sat,  7 Nov 2026 08:47:04 -0500
Message-ID: <20261107134857.204939278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 06d4f202f007b160e650e8dd861a5fc223024f34 ]

ov2735_probe() explicitly powers on the sensor before enabling runtime
PM. The probe failure paths call ov2735_power_off(), but the remove path
does not perform the corresponding power-off operation.

The managed runtime PM helpers only clean up the runtime PM state.
devm_pm_runtime_set_active_enabled() disables runtime PM and restores
the suspended state during device resource release, while
devm_pm_runtime_get_noresume() drops the runtime PM usage reference.
Neither helper invokes ov2735_power_off().

As a result, removing the driver after a successful probe can leave the
sensor clock and regulators enabled and the GPIOs in the powered state.

Call ov2735_power_off() from ov2735_remove() to match the successful
ov2735_power_on() performed during probe.

This issue was found by manual code inspection.

Fixes: fa9e6df636fb ("media: i2c: add ov2735 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2735.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov2735.c b/drivers/media/i2c/ov2735.c
index b966002041417..f248fdb352af6 100644
--- a/drivers/media/i2c/ov2735.c
+++ b/drivers/media/i2c/ov2735.c
@@ -1081,6 +1081,7 @@ static void ov2735_remove(struct i2c_client *client)
 	v4l2_subdev_cleanup(&ov2735->sd);
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(ov2735->sd.ctrl_handler);
+	ov2735_power_off(ov2735->dev);
 }
 
 static DEFINE_RUNTIME_DEV_PM_OPS(ov2735_pm_ops,
-- 
2.53.0



