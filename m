Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB4D49659;
	Mon, 14 Oct 2024 14:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917160; cv=none; b=WQq9Ah06nKrSiAQuITdSqJkltOdCDmbJW5mWziY7vl2EJ9ue4Zdw0KNEjLoZ477lE9kYT4VC1+mH8KQy1bct8deVMQZQ/NLfnyIW/LC4VKZL4BUshFpy/wBTaz9rNJoCel8yOF7KOGtbH+jRs0p0xhK3sBAEC//swHbr4DbCoCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917160; c=relaxed/simple;
	bh=62udQv6OXX8ECYAB2PQ7WmsQ71ZlVwbYkwpTqdyXvA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lm0LRGtgaa+uEPZs/DynhiFjqLaqj7XzxsFoqCKXin+9CxUmqtPSjyjKYsJtPBN+6X/deAOKNWSb3E3N8L5OdkJb3zCkLWvKATAQ4pOIziLCCE/Q/QekSWzn8UNbZkb5/JR/229W4Wz4kH0ZUYX4v+HW1N1hwWWLLe7Ss8dg0mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSa/8FGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSa/8FGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F357DC4CEC3;
	Mon, 14 Oct 2024 14:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917159;
	bh=62udQv6OXX8ECYAB2PQ7WmsQ71ZlVwbYkwpTqdyXvA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSa/8FGjb4Q+SOgAv8PJ3MMFjIugzwR9p7vmYJJ55JlHAZZk/EA9jFEPkbR2GDWa3
	 OyQaNXoDYfmIpQGv07etdP8MPpI52rZgzmUqjsKMmKTmUYX1pppLr62+zHeMe966x0
	 YNfyxSV0ym+PcnByxObNpb+xT/IhmpzUXWt2wlXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/213] HID: i2c-hid: Renumber I2C_HID_QUIRK_ defines
Date: Mon, 14 Oct 2024 16:21:14 +0200
Message-ID: <20241014141049.526352090@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7d7a252842ecafb9b4541dc8470907e97bc6df62 ]

The quirks variable and the I2C_HID_QUIRK_ defines are never used /
exported outside of the i2c-hid code renumber them to start at
BIT(0) again.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 26dd6a5667f5 ("HID: i2c-hid: Skip SET_POWER SLEEP for Cirque touchpad on system suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 59dececbb340e..6f1eb77cbcded 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -44,11 +44,11 @@
 #include "i2c-hid.h"
 
 /* quirks to control the device */
-#define I2C_HID_QUIRK_NO_IRQ_AFTER_RESET	BIT(1)
-#define I2C_HID_QUIRK_BOGUS_IRQ			BIT(4)
-#define I2C_HID_QUIRK_RESET_ON_RESUME		BIT(5)
-#define I2C_HID_QUIRK_BAD_INPUT_SIZE		BIT(6)
-#define I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET	BIT(7)
+#define I2C_HID_QUIRK_NO_IRQ_AFTER_RESET	BIT(0)
+#define I2C_HID_QUIRK_BOGUS_IRQ			BIT(1)
+#define I2C_HID_QUIRK_RESET_ON_RESUME		BIT(2)
+#define I2C_HID_QUIRK_BAD_INPUT_SIZE		BIT(3)
+#define I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET	BIT(4)
 
 /* Command opcodes */
 #define I2C_HID_OPCODE_RESET			0x01
-- 
2.43.0



