Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F014333F5A9;
	Mon, 20 Apr 2026 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700970; cv=none; b=I1g/R2A2lQvqDSqtzNpaHhd9vF8kidRREyM5n3Ig/vJs5pNwt5r2ttZ471PjuRcNNOZ9Ql/fHFn+kclrTErkvTVo7VLP+u8F0L7AY9saVH0l3XHOdqakgxAkMQaJo4G95swNQgMOJFhzxdNIvzIRvswUsJCu1Nu9eqPPX8vF2VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700970; c=relaxed/simple;
	bh=G9JWN02bVzKbzC2GPIBBuOg/DODh+hh3n8+hUFm1kU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GuPMuJ3NLpjgN0GVZN9+rlAzUpFqKSJvFlC31eM2y18002bg3OFvWD3GbNO9lnhulBFKbR2RNXVEjaDxAcZ/0qB3a/GT1YgZgPmwBHOkFGwWZaiJTzK7VWe5OTNRW+y4A8xLa8vLsw63KifkTS6i1SrMfQPlmJNNAaHpcs9cJgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O02e3vi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O02e3vi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805CDC2BCB4;
	Mon, 20 Apr 2026 16:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700969;
	bh=G9JWN02bVzKbzC2GPIBBuOg/DODh+hh3n8+hUFm1kU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O02e3vi0690Uzb+qtIEx9aPBIpVaySdq3xZGraJwFNSDLbxkMN3h1WYKeLAOVDca7
	 6eHqfp/4+IYE+/kuCfrUZD7Zmkr34ClKctrJTbZIvkxqiTrGaZ8+kQUWqCIwEb8KT6
	 xdyUvYkpHEdGFaWiUkBd/zaTcj3R6Y+/gvICCZCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 130/198] drm/vc4: platform_get_irq_byname() returns an int
Date: Mon, 20 Apr 2026 17:41:49 +0200
Message-ID: <20260420153940.289000895@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit e597a809a2b97e927060ba182f58eb3e6101bc70 upstream.

platform_get_irq_byname() will return a negative value if an error
happens, so it should be checked and not just passed directly into
devm_request_threaded_irq() hoping all will be ok.

Cc: Maxime Ripard <mripard@kernel.org>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.com>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022339-cornflake-t-shirt-2471@gregkh
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2355,17 +2355,23 @@ static int vc4_hdmi_hotplug_init(struct
 	int ret;
 
 	if (vc4_hdmi->variant->external_irq_controller) {
-		unsigned int hpd_con = platform_get_irq_byname(pdev, "hpd-connected");
-		unsigned int hpd_rm = platform_get_irq_byname(pdev, "hpd-removed");
+		int hpd = platform_get_irq_byname(pdev, "hpd-connected");
 
-		ret = devm_request_threaded_irq(&pdev->dev, hpd_con,
+		if (hpd < 0)
+			return hpd;
+
+		ret = devm_request_threaded_irq(&pdev->dev, hpd,
 						NULL,
 						vc4_hdmi_hpd_irq_thread, IRQF_ONESHOT,
 						"vc4 hdmi hpd connected", vc4_hdmi);
 		if (ret)
 			return ret;
 
-		ret = devm_request_threaded_irq(&pdev->dev, hpd_rm,
+		hpd = platform_get_irq_byname(pdev, "hpd-removed");
+		if (hpd < 0)
+			return hpd;
+
+		ret = devm_request_threaded_irq(&pdev->dev, hpd,
 						NULL,
 						vc4_hdmi_hpd_irq_thread, IRQF_ONESHOT,
 						"vc4 hdmi hpd disconnected", vc4_hdmi);


