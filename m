Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC5B5218BC;
	Thu, 17 Sep 2026 17:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667379; cv=none; b=OVBdpJ/+dvBRD93cG9ezhwrHOrZgCK+vp8AFox37eMwg7IPFuJZ4jJRD9/lMxmsNe+2s/Chtp24HQsLLXKzqBMrekJGjxRkV93/zfO/8bFVDlPBrah0K4XCxD08vBodgT/nDJ5+NqT3hOxux1Cdb+IEYTZ5vwUHzR8mEXOEMRcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667379; c=relaxed/simple;
	bh=1vbUIfyWGuqftBKGB8Qt7NzGH5TSsauEmlVt4qRou7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nhm0vk8K/G1lqPi5MsFWAK2VS6fsk4R+3427HdB6dgRvNRedJ1/KmJwwJNhTi/EvbgAmCCE6Lo6n3EjhqOsw4vABzmniXophpjGRFY5xPGI84TtMFEWNYmWWiWCAcfcv1CdI6lhRq/Fq9GEfYr/SnYaHEOsAns2tMpa5tuna1iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5RgrLxV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5RgrLxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FECA1F000FF;
	Thu, 17 Sep 2026 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667378;
	bh=lZitca80e71rt3UUYuuLz4lNiMBKEtkXzLmGd53TWl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5RgrLxVcBzswXBQtKuabK8++Ecu+0x+wEACGiziR2Y9/63GXHUWtQDKpwT6ruidE
	 4103wPlBiLSzFfZJ28BkKptepgvGX/kS+6Tmj6Xo9woS4n0ybUUZKkPKmMQZBqzzg5
	 rFMU4c2gwnxWu0HfeEepBrhp3BcUnXlglmKPIcEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sophie D <patches@scd31.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0073/1102] drm/gud: Add RCade Display Adapter VID/PID pair
Date: Thu, 17 Sep 2026 16:00:16 +0100
Message-ID: <20260917151541.301064739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sophie D <patches@scd31.com>

[ Upstream commit ac5ac0acf11df04295eb1811066097b7022d6c7f ]

The RCade Display Adapter is a hardware device that allows driving an
Arcade CRT display via the GUD protocol. Currently it spoofs an
existing GUD VID/PID pair. However, now that it has its own pair
assigned, it makes sense to add this to the list of pairs that GUD
supports natively.

More information can be found in the project repositories:
https://gitlab.scd31.com/stephen/stm32-usb-vga-adapter-hardware
https://gitlab.scd31.com/stephen/stm32-usb-vga-rcade-adapter

Link: https://pid.codes/1209/4FB3/
Signed-off-by: Sophie D <patches@scd31.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260509025405.4143956-1-patches@scd31.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gud/gud_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/gud/gud_drv.c b/drivers/gpu/drm/gud/gud_drv.c
index ac6bbf920c726..f1200a2ef8801 100644
--- a/drivers/gpu/drm/gud/gud_drv.c
+++ b/drivers/gpu/drm/gud/gud_drv.c
@@ -660,6 +660,7 @@ static int gud_resume(struct usb_interface *intf)
 static const struct usb_device_id gud_id_table[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x1d50, 0x614d, USB_CLASS_VENDOR_SPEC) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x16d0, 0x10a9, USB_CLASS_VENDOR_SPEC) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1209, 0x4fb3, USB_CLASS_VENDOR_SPEC) },
 	{ }
 };
 
-- 
2.53.0



