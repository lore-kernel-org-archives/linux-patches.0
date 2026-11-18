Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020659;
	b=t14UZNIk+nz2hy+lM5BfwoJ1HjiyG1SdhMyz1KrjPQs0dC/a6Ex9jq2uPk0iBHiPvuJv
	 iWW3MTsRI8qVvN7g/g/Q5C1X9OK/4P7l+GPOHgTCulJU+JhLmbUn2ZezD5T9lM6GeY668
	 8ES9zdU05mE5Axk3OvbIn2lh9L9HaMQKLgQcHVjsy3oQRbm/DTyafdET0ciRBcm/6SMVZ
	 FC4Q7LiXgwDwRzhQBuQoIz2Y+Kbh7Dfb9rKKbQZVdWfUXFJc5oQvoUnhPVgTH+wcdf5Za
	 JzTHCr9HTX/A2aZLWu7ewWdv6vGu2D/x6eHwT1XKrV+NGNxAkt4UkWYTKNx5YBmmPIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hm++TGU/eDLJvOz3e9ufXWgPuqdw90V3j2fRVq4qFGM=;
	b=iWvIhk7LOmOoyRFefV42hnrEgSixQUSjcSOGgITgJPbguJA8JwKQZ9WppyW3wE//3sqM
	 JBRPW63GCEoYYbdg2xVgBC8RUYk2gsBWpV3ZBJqed8ftXfF3+r0Q6pSNiNxZCecatGAwC
	 28G3EVaadsBA3iJI/48syGm0Mn3BbpPi26VgCoF+eYdVzxcIom265IQDTZhblzmKjeyPl
	 VIj7HuPVSVdrcubJdN1FFPn8OaKS84ZBI/Ckm/TXq7sQ/uRvL7Y4uiqnE4oXhyPrFM3xa
	 sJ+DRdW287G62kL/YVI94WWK65KRNRJ0ZH6ypJhTsFT0doamUJLGOG+GNLEZ3Sum1YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uqRrsbeB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEF9606A33D;
	Wed, 18 Nov 2026 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uqRrsbeB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4341F000C5;
	Wed, 18 Nov 2026 16:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020658;
	bh=hm++TGU/eDLJvOz3e9ufXWgPuqdw90V3j2fRVq4qFGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqRrsbeBuZBwtuc0rg/UyaAU+i6ZqJQ0OfTYz1YD07rlGeEUJRgCdDYK+z7BnnFYS
	 aib4Xux8x3Qr1I4sgNoHDxNtFfbAehdPtBPv9E3wA/NsQTVdlHITqAFVlBEGHpJhIO
	 2oS/5UmGhZQyyB1yg1EY91OrQ5yxthrfOuuD2H7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasilij Markin <vasilij.kernel@tototo.si>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2030/2651] drm/appletbdrm: Add suspend and resume support
Date: Wed, 18 Nov 2026 15:54:30 +0100
Message-ID: <20261118150359.236650479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index ef71b99579619..9a5288acbffca 100644
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
@@ -821,6 +822,48 @@ static void appletbdrm_shutdown(struct usb_interface *intf)
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
@@ -832,6 +875,9 @@ static struct usb_driver appletbdrm_usb_driver = {
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



