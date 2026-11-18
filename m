Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027098;
	b=l7/Wv9/w5xPBU7ts3ik/E8GNU9igJU8Dq4IYNdNj69aEuvG2ZliuD+VXiGGZ96jBDSf/
	 8D5dposf/X/jVRSxAz9BDpKvQj4kr1JR6vS6qScuv5mn2TuPVnGXhL4oUWNDiR490itia
	 6vYMoM1KEDOLsjt1KPUYpSMhmVKHv877yt6w0+XEbzW83dRLCW+8S1QUXNhtlvoXIoFjs
	 YX8XXsziVeQtspoPj9yA/RsV23vRkWIRLxfhr6PkICp0ibxwqErOVEOYhPjkuxEk3gl/R
	 INDTFZzx0o9GYEqqtvTQOIETNPn3Na0AYNLE3USPVdorLgvn5CHaVy2ZX6kx1TBaWTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ST+ccO4ETHFmL6ExrvI9IfSzPXlCYWhgiGB/9BVJzI=;
	b=1C9b/dpTmsns1048QpzTKrD9nqCh0Nwb3XKGV4T84O7XuyH0PK4akoQJW8z6GKE+RuDU
	 EQxrFa+2KOy+SM7waia3+kj9wAvYJs1Tc+v0kBbFPMaMZO/0RDM58UjEtUcr2HBCUTjvh
	 AYZopU9ixkKAFa2fCMzAB7TaufJ7OeosbXhfWNvgZZjl6z6kM2NS7QC3vXfbv7a3obDbB
	 e9dlgUNSpcHHQKliPaxW7lW38gSqvUFSqBzbqnIGbKKoUcjiNCY3IQUBMjg/rBjpZAgI3
	 geOaQ++/l1zvYSCfJrVYh6yF7hjRahu6J3BJXiUb/K2D44RR5/Tt1MjwXm07+IJBULA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuSm0Qua;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4324B606A31C;
	Wed, 18 Nov 2026 18:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuSm0Qua
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939C41F000C4;
	Wed, 18 Nov 2026 18:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027098;
	bh=+ST+ccO4ETHFmL6ExrvI9IfSzPXlCYWhgiGB/9BVJzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuSm0Qua8oiMNCw+91Unnuhs6b0GJWyLWhBxP577fjFj7I7SLVhbpbtzx0y6RO5uZ
	 y2sWWag2+xqW/C6/kEFcE5Gh/DwcGkt7ttVcjD7cmU38fxAnkSDC8HGhjFnSvchjyW
	 hf9UhE3y49nhmZrrTdgDa1A3h6zgF03fLZ6z+coE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasilij Markin <vasilij.kernel@tototo.si>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1669/2151] drm/appletbdrm: Add suspend and resume support
Date: Wed, 18 Nov 2026 15:56:44 +0100
Message-ID: <20261118150222.636464349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Vasilij Markin <vasilij.kernel@tototo.si>

[ Upstream commit 6f6a6b9ae0b481b97dac141ae86becdf7bd0b471 ]

The driver has no USB power management callbacks, so the USB core
unbinds it before system suspend and binds it again on resume. The DRM
device is unregistered and registered again on every suspend and resume
cycle, userspace driving the Touch Bar through it (such as tiny-dfr)
loses its device, and the Touch Bar stays dark after resume.

Implement suspend and resume with drm_mode_config_helper_suspend() and
drm_mode_config_helper_resume(), so the device stays registered and the
last committed state is restored on resume. If the device was reset
while suspended, repeat the probe-time handshake first.

Fixes: 0670c2f56e45 ("drm/tiny: add driver for Apple Touch Bars in x86 Macs")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Vasilij Markin <vasilij.kernel@tototo.si>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://patch.msgid.link/20261015-appletbdrm-pm-v3-1-47377176619a@tototo.si
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/appletbdrm.c | 46 +++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/gpu/drm/tiny/appletbdrm.c b/drivers/gpu/drm/tiny/appletbdrm.c
index f596e9637a7ba..9ad1a9b895224 100644
--- a/drivers/gpu/drm/tiny/appletbdrm.c
+++ b/drivers/gpu/drm/tiny/appletbdrm.c
@@ -30,6 +30,7 @@
 #include <drm/drm_gem_atomic_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_gem_shmem_helper.h>
+#include <drm/drm_modeset_helper.h>
 #include <drm/drm_plane.h>
 #include <drm/drm_print.h>
 #include <drm/drm_probe_helper.h>
@@ -814,6 +815,48 @@ static void appletbdrm_shutdown(struct usb_interface *intf)
 	drm_atomic_helper_shutdown(&adev->drm);
 }
 
+static int appletbdrm_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct appletbdrm_device *adev = usb_get_intfdata(intf);
+
+	return drm_mode_config_helper_suspend(&adev->drm);
+}
+
+static int appletbdrm_resume(struct usb_interface *intf)
+{
+	struct appletbdrm_device *adev = usb_get_intfdata(intf);
+
+	return drm_mode_config_helper_resume(&adev->drm);
+}
+
+static int appletbdrm_reset_resume(struct usb_interface *intf)
+{
+	struct appletbdrm_device *adev = usb_get_intfdata(intf);
+	struct drm_device *drm = &adev->drm;
+	int ret, resume_ret;
+
+	/*
+	 * A reset puts the device back into its initial state, where it
+	 * expects the same handshake as during probe. Resume the DRM side
+	 * even if the handshake fails, so that the state saved on suspend
+	 * is released.
+	 */
+	ret = appletbdrm_get_information(adev);
+	if (ret) {
+		drm_err(drm, "Failed to get display information\n");
+		goto resume;
+	}
+
+	ret = appletbdrm_signal_readiness(adev);
+	if (ret)
+		drm_err(drm, "Failed to signal readiness\n");
+
+resume:
+	resume_ret = drm_mode_config_helper_resume(drm);
+
+	return ret ? ret : resume_ret;
+}
+
 static const struct usb_device_id appletbdrm_usb_id_table[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x05ac, 0x8302, USB_CLASS_AUDIO_VIDEO) },
 	{}
@@ -825,6 +868,9 @@ static struct usb_driver appletbdrm_usb_driver = {
 	.probe		= appletbdrm_probe,
 	.disconnect	= appletbdrm_disconnect,
 	.shutdown	= appletbdrm_shutdown,
+	.suspend	= appletbdrm_suspend,
+	.resume		= appletbdrm_resume,
+	.reset_resume	= appletbdrm_reset_resume,
 	.id_table	= appletbdrm_usb_id_table,
 };
 module_usb_driver(appletbdrm_usb_driver);
-- 
2.53.0



