Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73438224E8;
	Sat,  3 Feb 2024 04:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933918; cv=none; b=XqIxxWz0vhJS5Vy7ErWOhwS3SZalx3nxAXWoGZOa5GHay/Ln25jDk915Z378D7/dw5Ggi/JGX9byXlCoyyvnn5j//+dMIq7eWcB+Vsj9p6WqkbejOdB7SMu9juhaibG4nD4FV+BvVLf57j18+QxArV7D7O6Xnc6gXnHzIQAqEJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933918; c=relaxed/simple;
	bh=NTj6ntT8C9dFrT0o/VBT9b6MXbsgtCxu/ZS4+qX8r2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcPbN/amhmVRGJ3XAc90AvLrxb7Ii9DSm7dK5tVlJYiPlvaeVNZzkxHobj2z/uyzcafFCR0/9TSVLG0VnMadnEQjg8sMEihtolBuxNdX2uwCClHA0oUejWHIDp2Zs6J5xyFSAbwbTtB5+q8KP/Nr08LNPd3uVdHXBheuP6SNfOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oP5TFrm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oP5TFrm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39868C43394;
	Sat,  3 Feb 2024 04:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933918;
	bh=NTj6ntT8C9dFrT0o/VBT9b6MXbsgtCxu/ZS4+qX8r2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oP5TFrm+Jj4tePseq0UNEi0vU8NqC4Ia9VMiYenb5UutKRbPqpJC3bpt0bZywD/vH
	 0h/4dTl8GjrpxFS+81BG2EEkpue5KQfjT9N6e+5sJADxGNxwfXAsEueK/kt/JRzB7f
	 Y8UjOJmGappSn7u9LUcX5tGyIC5XifjtOwAktZ08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Gajjar <hgajjar@de.adit-jv.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 255/353] usb: hub: Replace hardcoded quirk value with BIT() macro
Date: Fri,  2 Feb 2024 20:06:13 -0800
Message-ID: <20240203035411.810907210@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hardik Gajjar <hgajjar@de.adit-jv.com>

[ Upstream commit 6666ea93d2c422ebeb8039d11e642552da682070 ]

This patch replaces the hardcoded quirk value in the macro with
BIT().

Signed-off-by: Hardik Gajjar <hgajjar@de.adit-jv.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20231205181829.127353-1-hgajjar@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 87480a6e6d93..7deeba174858 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -47,8 +47,8 @@
 #define USB_VENDOR_TEXAS_INSTRUMENTS		0x0451
 #define USB_PRODUCT_TUSB8041_USB3		0x8140
 #define USB_PRODUCT_TUSB8041_USB2		0x8142
-#define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
-#define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
+#define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	BIT(0)
+#define HUB_QUIRK_DISABLE_AUTOSUSPEND		BIT(1)
 
 #define USB_TP_TRANSMISSION_DELAY	40	/* ns */
 #define USB_TP_TRANSMISSION_DELAY_MAX	65535	/* ns */
-- 
2.43.0



