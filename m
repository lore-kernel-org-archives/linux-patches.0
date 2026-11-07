Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064313;
	b=nreBz0J7Rx6Xzly+jowEGigKLzQxAy7ru4C2bnZj1gi5o7jg2SyCkS3kE8msxfFY/I2U
	 Y9x7SHwZBxv00u9FYWwr2xeZrKGK3GbKTZJwoTDyORPSUswLzryyurzoZymIK5DSvJaKz
	 dcf3AqiLph6g1eWBdLGooi03EpEKLwwsDFrYwiXQ4RI8MUwXHdVNklwsbHRD+wg4ljLV+
	 bRLo62TJp7FTiQAOyrPmZXMVU6fatQXGO0ivbW1UnYfHnkEKHd4/Wex6yFgWDo6x+o2uB
	 Jz4MpuFfmKGDnK+jGcrC3BX2ycLw48ctyR+IXyMr5LJdKXFO9mvlt1zOWptzdpXidcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1QgCEOdA0ZDn5dHR1SGfYuzies2xBzX0dfd/9uky7KU=;
	b=vqCkkxeBeiZF/RH1K5wzP5MTwvmDYTrTj24AxotL86tRlWoNeBVvo8QrP4WxVucU+ZHe
	 quGZ9OUUWpKuT9yFJaFy5s4bPV2Fc+Trtt8j/+k6B1j2LbeKhrIgOlw32B7AGxsi5vI4B
	 fEnpvHaLgXyK9z4f36YZ/n/nzST5fbBn4VDS1NZlopG3lCgiUFoL7PUA7G90ahrlJPYlj
	 iSfCJjrquGant32UTDX8U2DCby0bzEiqH0s/887vwXGulp3lKNOQOndTWiBW7IHp/88pS
	 d9uBDIna+BlOSCkchj2wUh/3UMIgc8EFnZie6+NZU9ZGVGHVK80HcqiJmZ08AtLA0Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MbFgqfg6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170C6606C02E;
	Sat,  7 Nov 2026 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MbFgqfg6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B989E1F0089F;
	Sat,  7 Nov 2026 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064312;
	bh=1QgCEOdA0ZDn5dHR1SGfYuzies2xBzX0dfd/9uky7KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbFgqfg6tsxkYX5lJpfwmZviEizB9h82CJP0HgrS4WfGn0xEmX/4qIQVm6xrQ9biX
	 6uI8z6ZbBxVo2Wl2Lttsayva5ve0jvOeomEVnBBSdDZBmKPMYPE74G01FC3bnUX1mI
	 bY/KBCAhDlHKkJG9pG0w8kfdFl2DQPxGYx+fnaQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0403/1257] media: renesas: rzv2h-ivc: manage runtime PM with devres
Date: Sat,  7 Nov 2026 08:44:59 -0500
Message-ID: <20261107134950.660520197@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 64e07ebcb3d054672cff678edb5344586d2d3286 ]

Runtime PM is enabled before the IRQ is looked up.  If that lookup
fails, probe returns without disabling runtime PM.  The subdevice
initialization error path disables runtime PM but leaves autosuspend
enabled, while the remove path does neither.

Use devm_pm_runtime_enable() so the driver core disables autosuspend and
runtime PM on every failed probe and after remove.  This also makes the
manual subdevice error unwind unnecessary.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: f0b3984d821b ("media: platform: Add Renesas Input Video Control block driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/renesas/rzv2h-ivc/rzv2h-ivc-dev.c  | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-dev.c b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-dev.c
index 355842abb24b8..48f9fd818bfff 100644
--- a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-dev.c
+++ b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-dev.c
@@ -202,7 +202,9 @@ static int rzv2h_ivc_probe(struct platform_device *pdev)
 
 	pm_runtime_set_autosuspend_delay(dev, 2000);
 	pm_runtime_use_autosuspend(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	ivc->irqnum = platform_get_irq(pdev, 0);
 	if (ivc->irqnum < 0)
@@ -210,14 +212,9 @@ static int rzv2h_ivc_probe(struct platform_device *pdev)
 
 	ret = rzv2h_ivc_initialise_subdevice(ivc);
 	if (ret)
-		goto err_disable_pm_runtime;
+		return ret;
 
 	return 0;
-
-err_disable_pm_runtime:
-	pm_runtime_disable(dev);
-
-	return ret;
 }
 
 static void rzv2h_ivc_remove(struct platform_device *pdev)
-- 
2.53.0



