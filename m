Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E361DE4EF;
	Sat, 30 May 2026 16:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158664; cv=none; b=oIaarNovto9wE5ydwfxzX14c1lOsT55J0gFLgGYYW1H0dAqSw9nlFxPmxHGllAy367GdjTQzgbOICjABNozh4mfRsPAEsetIMAqrpq05K6/yjy/OVk40C24ZgPeydDlAoR/ujMRDP+0+vTRacSkMJ7Xt0bzfecthRdcwrbSL5v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158664; c=relaxed/simple;
	bh=84ehuYt9KAam/TSbfGT4U2oWcUI0vzWLrNu9c+oqyXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LkWaVM6+XqLG1/g5mRrXElWeKZYpz/iGOb/ZuYfbQac09cqbRwbVWlDsU+LLf5mbr4P0LptS4HKPPbmjxVxlhzr8x/c8nFjYCoZdOtbVVjNvh6J0lXCcS14i7z17H/zaH1MApVhQRyDKgQytKX94vSwjUFJsGvjaNpRjQmaohVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1IlIjiF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1IlIjiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83E31F00893;
	Sat, 30 May 2026 16:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158663;
	bh=+mQGl1HuVfA76+N32j24d+/1fce1IWFI2hdZg1DKNlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1IlIjiFoOzEQU/iXJXm1bFtMQwllOkSv4ficsf0ENOpHWagynOue2su1PF0hFUCG
	 AhZ60ctcsmihdAG7VCBjFats5N/aIpquW4JPxIMvoPqrKCSeCan+2eHslOyX/1gTuJ
	 jsLZBUsFYDZ8VW3bhEqL/HFcX2xSu/enQvteJJ2w=
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
Subject: [PATCH 6.1 064/969] drm/vc4: platform_get_irq_byname() returns an int
Date: Sat, 30 May 2026 17:53:08 +0200
Message-ID: <20260530160302.151015629@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2614,17 +2614,23 @@ static int vc4_hdmi_hotplug_init(struct
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


