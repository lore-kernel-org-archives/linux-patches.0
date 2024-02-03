Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844E710965;
	Sat,  3 Feb 2024 04:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933650; cv=none; b=iqr3fOd2WZYTZUrQ8bRGsrwZbkQRH/jH7X6PPyzL2zKHZcKEFLEtoqk0ht37yk+SjSptl/zvhlYUZxj9Za1LNKSq335sgtigniJx/6u+ZTX6Wit2grgeocpbkRLFZ9Hy4gePSafJWinBWmk0iq7eUKG6m0c/xiboSm40hHdEhFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933650; c=relaxed/simple;
	bh=+HS5+04230q6Nz1fQIDggyJ1Qab5pDOnEyebAUvrq0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEyJHIqM/IKZNV5X7hO3EVCJE+3vxcQNObHAE16P3D/dPKUNNvOhi82vku8IPmKMIKabJTtx0p1JDkavlQEzCZm2Qsq+5v7QafmIRRwN+BuDZEEFMuNqegSXOrU0HYhDaheukK16jZtxRZm77XCCw7JrZhyoX8vHU0BydILvZlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cb6hclhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cb6hclhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAC4C433F1;
	Sat,  3 Feb 2024 04:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933650;
	bh=+HS5+04230q6Nz1fQIDggyJ1Qab5pDOnEyebAUvrq0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cb6hclhr1o9DjZglfJkOzEkqoR2vjqlChrXUXeJw+Y99Oj1/Z5q7P+fJBih2ooSnI
	 UNiSVjr40zjg+iLOa1gv1+3iTyzNnSajsskSL8Y/ipNDhjXF3EUNcwEaZoliGxhs2e
	 9QqS0EGGhef5/aEcKkwTT2KuNNj46dbUOX3ldVY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Gajjar <hgajjar@de.adit-jv.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 234/322] usb: hub: Replace hardcoded quirk value with BIT() macro
Date: Fri,  2 Feb 2024 20:05:31 -0800
Message-ID: <20240203035406.749395140@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dfc30cebd4c4..f5abfba68e69 100644
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



