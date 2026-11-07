Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062231;
	b=sKyalSkqOz7j/UNvPBMtqE58lQi/uBR7iM/LLskoIgjSi07nPOVR1+Ogc2b8+W6dISVy
	 3eQzmss0QQOgUB2vMfuy2foBckrwicLZXH+b+6XEO0HIstq/LaU6/JBiIDY6ukb1wYLES
	 sFHdrMy6pK1USGQJOjmpPadg37+vqIwgYkM0EfOyRNLQzHkJZcgbUXrGyFxOorix0wWeJ
	 dCX+AWyRrspm1XlOa4eERqMHFucv7gv5JMqkDhl6PR/1bGxoOR7wsHx2zf4zuEgEDDnrS
	 uVxOBunZBfVhYMYmK6aTQaPTMLp7vvAMKre24AH3pgku44atwK+Z3AfZ93QQ1GXkNWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YvV16AKqXqytm0Ulm1uKvBvGtcp2uuvHV6hG4QGReXU=;
	b=EmJdQPGPM94FJXWVaTXBU+a/apHNguoshj70tIc5YYBAti5aLSABy8ZsV6FXEU+YDKNJ
	 mHeABrNlqLFjQQA9JM6oU76/NaCif0jEpY5+L03eqliLVtRBFLow7PfyHNfbR7Cv7m+c/
	 CUONhIIFZMLJa2dZafLZM5ZZoQnew364yPOQ4qEN9LtFcYHaUBwBQOCI4C0oNP7OuJuxX
	 hHHqsgxHX3RDgbmK/Lq6ykADjgHeFbDeRuUij0Ek+C3KyuWKFSwUy906jIL5SufJOD8+2
	 I7dat2mJxjMgmJM8d7MbjXJBXV+Ig0E5KMlAo8ySuWJlG9tG06orFriKE1dX5Xegnbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p176hV9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CF4606A332;
	Sat,  7 Nov 2026 14:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p176hV9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325821F0089F;
	Sat,  7 Nov 2026 14:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062231;
	bh=YvV16AKqXqytm0Ulm1uKvBvGtcp2uuvHV6hG4QGReXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p176hV9VlrDMSTwX4h9Oj5gcM7Rqmx2yURDRak7wY1A/qmEh642ga03XD7LRDqQKX
	 CG5Wk5bHA0IA11VYAWZ4vaGHaNvkneBitJH28mNNhywU1C7pRqMx498jvvbY9cHvQq
	 Ck3+iuwPjyE9qLt1EkRSadKp3kt4KTz3cHEXQZyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1155/1536] media: hantro: disable runtime PM before hardware teardown
Date: Sat,  7 Nov 2026 08:52:51 -0500
Message-ID: <20261107135030.165360070@linuxfoundation.org>
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

From: Tharit Tangkijwanichakul <tharitt97@gmail.com>

[ Upstream commit 8e26d4c20ed218db6c3123480a4a4e2545680566 ]

Removing the Hantro driver may trigger an SError on RK3588:
	SError Interrupt on CPU6, code 0x00000000be000011 -- SError
	...
	do_serror+0x5c/0x74
	el1h_64_error_handler+0x34/0x50
	el1h_64_error+0x6c/0x70
	regmap_mmio_read32le+0x10/0x20 (P)
	_regmap_bus_reg_read+0x6c/0xb4
	_regmap_read+0x60/0xdc
	regmap_read+0x4c/0x80
	rockchip_pd_power+0xe4/0x600
	rockchip_pd_power_off+0x1c/0x60
	_genpd_power_off+0x98/0x198
	genpd_power_off.part.0+0x178/0x288
	genpd_runtime_suspend+0x210/0x300
	__rpm_callback+0x48/0x1e0
	rpm_callback+0x74/0x80
	rpm_suspend+0x10c/0x580
	rpm_idle+0x134/0x1b8
	update_autosuspend+0x30/0xc4
	__pm_runtime_use_autosuspend+0x48/0x64
	hantro_remove+0x8c/0xa8 [hantro_vpu]
	...

hantro_remove() currently asserts the device resets before disabling
runtime PM.

Calling pm_runtime_dont_use_autosuspend() causes an idle device to be
runtime-suspended immediately. At that point the Hantro hardware has
already been torn down, while the generic power-domain genpd code
still performs the power-off sequence. genpd regmap_mmio_read causes panic
subsequently because the reset lines were asserted.

Disable runtime PM before asserting the reset lines so that no runtime-PM
transition can race with hardware teardown.

Apply the same ordering to the probe error paths as well.

Fixes: ea71631b7129 ("media: hantro: add support for reset lines")
Cc: stable@vger.kernel.org
Signed-off-by: Tharit Tangkijwanichakul <tharitt97@gmail.com>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_drv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/verisilicon/hantro_drv.c b/drivers/media/platform/verisilicon/hantro_drv.c
index 01d6ab67a8bf3..9e5334ac3d0dc 100644
--- a/drivers/media/platform/verisilicon/hantro_drv.c
+++ b/drivers/media/platform/verisilicon/hantro_drv.c
@@ -1215,7 +1215,7 @@ static int hantro_probe(struct platform_device *pdev)
 	ret = clk_bulk_prepare(vpu->variant->num_clocks, vpu->clocks);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to prepare clocks\n");
-		goto err_rst_assert;
+		goto err_pm_disable_assert_reset;
 	}
 
 	ret = v4l2_device_register(&pdev->dev, &vpu->v4l2_dev);
@@ -1269,8 +1269,11 @@ static int hantro_probe(struct platform_device *pdev)
 	v4l2_device_unregister(&vpu->v4l2_dev);
 err_clk_unprepare:
 	clk_bulk_unprepare(vpu->variant->num_clocks, vpu->clocks);
-err_rst_assert:
+err_pm_disable_assert_reset:
+	pm_runtime_dont_use_autosuspend(vpu->dev);
+	pm_runtime_disable(vpu->dev);
 	reset_control_assert(vpu->resets);
+	return ret;
 err_pm_disable:
 	pm_runtime_dont_use_autosuspend(vpu->dev);
 	pm_runtime_disable(vpu->dev);
@@ -1290,9 +1293,9 @@ static void hantro_remove(struct platform_device *pdev)
 	v4l2_m2m_put(vpu->m2m_dev);
 	v4l2_device_unregister(&vpu->v4l2_dev);
 	clk_bulk_unprepare(vpu->variant->num_clocks, vpu->clocks);
-	reset_control_assert(vpu->resets);
 	pm_runtime_dont_use_autosuspend(vpu->dev);
 	pm_runtime_disable(vpu->dev);
+	reset_control_assert(vpu->resets);
 }
 
 #ifdef CONFIG_PM
-- 
2.53.0



