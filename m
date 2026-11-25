Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618823;
	b=WNGDPOcQy99bclpW57vevqjtbKz5Wvw4uONtbzr8+zpXHBGit3HQ4SSfG8Qjq3tckyuG
	 YBsaWaDjJAPxUiYZuknnCJhBC7YxYygQSXiEwOo1Z3S3w/sMHpyll9foeGhAdBT1XtwK1
	 l3TU5wtQXitv5LqzKz0qEE4rnznDDip+wzQ9gKtNCzrZNjUO3QjLC97T0nklCpE3Ylt2U
	 XTh3meFv7u8AZaZtEw7f3YVy8o937Qh+3xzYGFU2blLKzcmn8AbstIX9/b4FRw0sumE2b
	 h14DbUp81kJrTXdh4B/J68NAAr1/z8W1wOCyutx4PT5mvVfN9Yymu2q9ek1aFeH8qNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OabCfoCrwJJujEF7P2hPrGduZgAnx9DaIuzcZoTIXI0=;
	b=a+JUlSORvebfgEDt47YSC4ktO6VB/ilRiO4lZ0Zk39IMxcw7NOcrNikyL8Is2D+mIo2S
	 eBOTVCkp4vupV6e5xpp8h6TzVRnPOzxp8Ynh6txgteLb5ziB+wkd3UtOdYT3n31OEIuo9
	 h5G9brO+OVLXCNkou3I75GdFizREitssZVRz3hpkQG75vOWwZtfYHTEwdk/30DgG/zxw2
	 MurF9ELC59jJVqzE9B7Uk4eZtpVRBVxbB813UGRlASm1x2B5yaKNViEzg40AhHmZXBkzo
	 n/aGtHaZz5lmRUzkx5Rqe9wBIvrLNgH0N2MhkqsAghzI0hDQ+EL6XV3lTm5YH0jUD0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=olXwZeM0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88625606A327;
	Wed, 25 Nov 2026 15:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=olXwZeM0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D291F000C0;
	Wed, 25 Nov 2026 15:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618823;
	bh=OabCfoCrwJJujEF7P2hPrGduZgAnx9DaIuzcZoTIXI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olXwZeM0CIcbpC8vyelQeX9yX6O6sVH7l5ixJwUCzTkF+ZejYd+6WCNNKFJP0ua1c
	 nG0X4YKkSPmobDVy+5JBAiBy2pxbrQTnPgUxmQFjNrkZ7AAZs7AfzIKOFfM4+SIHj/
	 jO+RlxxOMbB1g09pMrT1DAqYtvuvHRyvstXhoqEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0398/1005] drm/xe: Move xe_device_wedged_fini() registration to xe_device_probe_early()
Date: Wed, 25 Nov 2026 15:28:56 +0100
Message-ID: <20261125143831.068518436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit 031cc955b33b0d171fe50c870a9e601e80f14cea ]

The device can be declared wedged while processing boot-time hardware
errors, which can result in PM reference leak if driver probe fails
before xe_device_wedged_fini() is registered.

Early register the required cleanup action and fix this.

Fixes: a7df563b45b0 ("drm/xe/xe_hw_error: Handle CSC Firmware reported Hardware errors")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20261022051303.282805-5-raag.jadav@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 6599a0eb0990cde96c4e66a4e1e2ae1b172e85d2)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index f161f010d0ef4..7ec5d301f9995 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -760,6 +760,8 @@ static int xe_device_vram_alloc(struct xe_device *xe)
 	return 0;
 }
 
+static void xe_device_wedged_fini(struct drm_device *drm, void *arg);
+
 /**
  * xe_device_probe_early: Device early probe
  * @xe: xe device instance
@@ -828,6 +830,10 @@ int xe_device_probe_early(struct xe_device *xe)
 	if (err)
 		return err;
 
+	err = drmm_add_action_or_reset(&xe->drm, xe_device_wedged_fini, xe);
+	if (err)
+		return err;
+
 	return 0;
 }
 ALLOW_ERROR_INJECTION(xe_device_probe_early, ERRNO); /* See xe_pci_probe() */
@@ -1148,10 +1154,6 @@ int xe_device_probe(struct xe_device *xe)
 
 	detect_preproduction_hw(xe);
 
-	err = drmm_add_action_or_reset(&xe->drm, xe_device_wedged_fini, xe);
-	if (err)
-		goto err_unregister_display;
-
 	/*
 	 * Process and log any errors detected by hardware. Possible results can
 	 * include declaring the device as wedged, which must be done only after
-- 
2.53.0



