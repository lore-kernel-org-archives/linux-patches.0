Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C849503BF7;
	Wed, 30 Sep 2026 16:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784107; cv=none; b=bYPdvkpFjo59HKGxvA3ndABV2mvmH2P7si/rS30+erE+WVhVWpTJoFhuMGbRSpJfs3pzU14VH3ju0W4imSJqgBHKIz/xwPqT8Dfw+56w4lNzeZjoDrUE+GR93bwAHSGa1+/xyPNtczYQB/a+vby3hP0CVVMWp7f/3iVipV+RWBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784107; c=relaxed/simple;
	bh=lkvJM3g1JD8OhmulrFysKDavs2gfCcz6mHo83QRSMis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elttEjwPtlsPDOWUYfvRkErXPU4jD2op2NwftlWz9pXZpCDieAb5uzDuVxAKf2Xnw2eH5dyvrJ+jKLTkDuHUTMWN/EQEQzznfibNRHsNVbVd7cSkQpHt+yA8C+lVgaOzsTmsSqaBcRe1tuz9YIjSiXmeS5l+VFP1x3249lga5Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suaBxwYj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suaBxwYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EC01F000FF;
	Wed, 30 Sep 2026 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784102;
	bh=hENNlrO+HylXRY4gSHHA5hZLuDEV1zHjkIWEHJoUlGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=suaBxwYjiNWQ5RDp6jqenGqs0ppLaxNTA+Q6fUqOhIqw/oNZiwV+M84zsA+zbQf6/
	 oDSe7GnPeyYyUeeRno81P7iMP1adSq4MqFGEADO61M4d0qj/Ldp+/E99vIXsuTFFOf
	 CjPDNZZM1x+j2nmGhzxiIrctDOUYJ7dbUhv53Lq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sophie D <patches@scd31.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/982] drm/gud: Add RCade Display Adapter VID/PID pair
Date: Wed, 30 Sep 2026 17:12:54 +0200
Message-ID: <20260930152417.615558668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8d1630b8edac1..2a382be27fd4c 100644
--- a/drivers/gpu/drm/gud/gud_drv.c
+++ b/drivers/gpu/drm/gud/gud_drv.c
@@ -668,6 +668,7 @@ static int gud_resume(struct usb_interface *intf)
 static const struct usb_device_id gud_id_table[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x1d50, 0x614d, USB_CLASS_VENDOR_SPEC) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x16d0, 0x10a9, USB_CLASS_VENDOR_SPEC) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1209, 0x4fb3, USB_CLASS_VENDOR_SPEC) },
 	{ }
 };
 
-- 
2.53.0



