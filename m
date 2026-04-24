Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CF43563D4;
	Fri, 24 Apr 2026 13:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037803; cv=none; b=u0ai9TOEV7O6Sjg7PB5sQVQesHjG8TKZzCUZ140hIMcsfJwkYrRrLMDcAnWBp2XeFj+RAgiAA7JONRbxhiy/iSNKbERKsu9syLvvpFrWMQzZd9Uu67JgonVZtFz2eQtPW50lo7JarTojXtx9xjaN+iqEv84SD1RZo+jJqV92a0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037803; c=relaxed/simple;
	bh=4/92GN0InffHYfIrF7asm8zJvJp0HtEuOSpuRHSWNzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b/JVL8r6XBFkmWENm++FRl9qj0McTEFmnrMwsXePc+VIiLNsJtoOsWW4k8RnnN5pxbmcdz4Bj0bw+H4answUskGkKPtKvvgNoakqRu2i8USqz0y6VBPxsHaEOl/35oENkxqqpkGi5YsbOHy/le/1vHmcBvyqcMC6+rDnR4Whpt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVj2VKM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVj2VKM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC1AC2BCB5;
	Fri, 24 Apr 2026 13:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037803;
	bh=4/92GN0InffHYfIrF7asm8zJvJp0HtEuOSpuRHSWNzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVj2VKM0ksIiD8mX/J0P0UP2O7KF/E6xYJEtfJ8crLBYeB69MQ01pjwV6fcQIsi4I
	 t9KJNORyVLVPeYxlkh3VOyR7VSqhX5glxCr+dwzD+6oiIC99KHpGIiRjkw7U/jHBcZ
	 IhYhckRLXPUwzVslUgsJ8gm6jK2/Q0q4EA+0xjI8=
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
Subject: [PATCH 6.6 075/166] drm/vc4: platform_get_irq_byname() returns an int
Date: Fri, 24 Apr 2026 15:29:49 +0200
Message-ID: <20260424132548.493620323@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2854,17 +2854,23 @@ static int vc4_hdmi_hotplug_init(struct
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


