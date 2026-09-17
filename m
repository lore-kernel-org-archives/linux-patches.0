Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A93A511E99;
	Thu, 17 Sep 2026 16:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661171; cv=none; b=Y22v7SLyACXqEhL/N2OoOIWD3tPhkXBkOZ9sF9NNAX0VXVsSmeSeAKo6pT+mzGGFZ1Kxo6yifttZAluKQLio15dBLdtDf3wAsZ7SrhjOf/qPNPJcqdaQRbjiB/fBQMA9dGEg0AYYIMaxG+/JgR77F+tNPrhy4ITRpw+ZHaJ7ZnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661171; c=relaxed/simple;
	bh=xNhNaiifQGx9f8+sOC86KjUrX/RrNSKZnTWNIZo/j0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjrgdJrw9sREWfWmCxkOSfRdzX8BeNSaRcBn2Mt/hhXCQ0YHHvEMt9f7j78bf678+CNTz5xMoh+msdptgDHS5pu1khxSUMjkHavOOwWdjnfa5NTSem1keKdhUlyWsHNsECLj8Djh4/wI5LMRjhzomsxYaB2MdedhN+TsP60BZR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDsmqqSh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDsmqqSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54261F000FF;
	Thu, 17 Sep 2026 16:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661170;
	bh=MsKMcDlKPtDQsY9UBg0Hdts98Sl/9XYyGWOLMZtmHZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDsmqqSh2wHailsdo5MTcsGlNN84wMkjnuBT1iudvlnhH5xZiIcMPe2Xl2cubPnY1
	 uzvVOAqj5m0e6+MffRJp9b9LnaIkdXE2cPA8WyH0fVFAF0ngXQGX7/3FEpWkWwlySA
	 MkDXoq5imWm5omyQjg5DmU/CY3uO5f5RMxKRC9tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sophie D <patches@scd31.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0105/1250] drm/gud: Add RCade Display Adapter VID/PID pair
Date: Thu, 17 Sep 2026 15:58:20 +0100
Message-ID: <20260917151554.846434777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a2000991ecbe4..4f0906f677b2a 100644
--- a/drivers/gpu/drm/gud/gud_drv.c
+++ b/drivers/gpu/drm/gud/gud_drv.c
@@ -684,6 +684,7 @@ static int gud_resume(struct usb_interface *intf)
 static const struct usb_device_id gud_id_table[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x1d50, 0x614d, USB_CLASS_VENDOR_SPEC) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x16d0, 0x10a9, USB_CLASS_VENDOR_SPEC) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1209, 0x4fb3, USB_CLASS_VENDOR_SPEC) },
 	{ }
 };
 
-- 
2.53.0



