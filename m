Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F419A4E77FD;
	Wed, 30 Sep 2026 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790678; cv=none; b=KnhXDBsWY1tlhcmi0syzQe7Q/IJ+Z9OThPql2hH+j6cA8niRZLKbPj5eNh4I1IwvGV2E8JW4/SSwp2l/aWouHMnsl6YO8p1UJBevrCIV9j4rBZ49P5eL0+T4DyqhkxdYy/1LKBHvpGIlbm8cQ17cCPyRSeiwP38bNIglJA9PUO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790678; c=relaxed/simple;
	bh=DVJwi8iCsM2H248LrNDjpUV4hiYMGOwODjUnvc8m/PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCZNyMw368gfowVjRvhNopb18bMChJ4IwUarmu2srI19oSOwobWsARRkyPeyFK0QmyG4tYkqx1OPiuUVlQ0stFz7w0F94ZY02K0JzwtReP6J/yMyUjWB9LPgLRrCv/KzMlyb0l18vlAvWiM2PAiTPvzq60uBXFH9a7QqAQJRa2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSTn0vHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSTn0vHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A1E1F000FF;
	Wed, 30 Sep 2026 17:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790676;
	bh=X13jPzQ5LIVSGdDqFjAaAsIYCF+UWkFT4IfPiwvqMqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSTn0vHoasIC553b8IiiNvPW5Ry8rGZuylck6C52fQOkheObf/lN+e2NPnWbRLjIG
	 ySW+iWc0rFgXKBFudVazsOsJzVjkCOB78P1drQhfd6wffQ6vRJ4lEL48JhqRHrt4jL
	 coIwDjXkmN6GpI/N2CaQEQVrTDNpQLFVbxHcCkLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sophie D <patches@scd31.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/752] drm/gud: Add RCade Display Adapter VID/PID pair
Date: Wed, 30 Sep 2026 17:18:18 +0200
Message-ID: <20260930152358.759165191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eb4e08846da45..705f9b9945552 100644
--- a/drivers/gpu/drm/gud/gud_drv.c
+++ b/drivers/gpu/drm/gud/gud_drv.c
@@ -661,6 +661,7 @@ static int gud_resume(struct usb_interface *intf)
 static const struct usb_device_id gud_id_table[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x1d50, 0x614d, USB_CLASS_VENDOR_SPEC) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x16d0, 0x10a9, USB_CLASS_VENDOR_SPEC) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1209, 0x4fb3, USB_CLASS_VENDOR_SPEC) },
 	{ }
 };
 
-- 
2.53.0



