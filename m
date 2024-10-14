Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB52481B7;
	Mon, 14 Oct 2024 14:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917156; cv=none; b=FiUBvqYWAmPJSVfr5xM7E6rjtVv3it72Oo/WqIxW3Iu31vxzWhzEHrhbEvHKFODMjx42+ZJ4t7m/yWWNIFoNLa/SMMCrfRhQU7ML2pQqHttYDKKr1w0Xr+BR88Lno9kIZ9vKnvmRD7uyYAS29LsM+LlN36xqIgw+oqj3XLimhzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917156; c=relaxed/simple;
	bh=RPLtWdfXMbFV5Gf2LtaTxJT/6DbfWAg1Edv5Lgndnts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvDVE/Shlc0E17FoIvOQlqj2NerJ19AdL4VpHXQ/w42liBG20YZPv1FeoNdaPwhUWHBwAbbtp7AdB1XAdvpz+ugsBincZx1q18SqjFQDMuGcwrNKj6JszLt/cGTqQCujm2Yos5ephU0//KEf9w/Bt0Fpd1wHQsOhPgpq62t3l2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efKM5XWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efKM5XWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828AAC4CEC3;
	Mon, 14 Oct 2024 14:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917156;
	bh=RPLtWdfXMbFV5Gf2LtaTxJT/6DbfWAg1Edv5Lgndnts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efKM5XWGEdg2n6Vt4CqENDO9ZKpqdajcwIz7wPt3eLaeDvwOqaWeQYGOwtfZnwAVk
	 u1ZkxrXv20e1djd+CVCaTy328oqL7fTOYTwmutMwlfxLO0fXjPytHv8HaK5c2Fp1DC
	 LqwxR7/a+uKzfJeVc7YjdaPJ00dpcI+63cKy11jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/213] HID: i2c-hid: Remove I2C_HID_QUIRK_SET_PWR_WAKEUP_DEV quirk
Date: Mon, 14 Oct 2024 16:21:13 +0200
Message-ID: <20241014141049.487474973@linuxfoundation.org>
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

[ Upstream commit bd008acdac45011f2246ec2518ef19c2da9e6008 ]

Re-trying the power-on command on failure on all devices should
not be a problem, drop the I2C_HID_QUIRK_SET_PWR_WAKEUP_DEV quirk
and simply retry power-on on all devices.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 26dd6a5667f5 ("HID: i2c-hid: Skip SET_POWER SLEEP for Cirque touchpad on system suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 799ad0ef9c4af..59dececbb340e 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -44,7 +44,6 @@
 #include "i2c-hid.h"
 
 /* quirks to control the device */
-#define I2C_HID_QUIRK_SET_PWR_WAKEUP_DEV	BIT(0)
 #define I2C_HID_QUIRK_NO_IRQ_AFTER_RESET	BIT(1)
 #define I2C_HID_QUIRK_BOGUS_IRQ			BIT(4)
 #define I2C_HID_QUIRK_RESET_ON_RESUME		BIT(5)
@@ -119,8 +118,6 @@ static const struct i2c_hid_quirks {
 	__u16 idProduct;
 	__u32 quirks;
 } i2c_hid_quirks[] = {
-	{ USB_VENDOR_ID_WEIDA, HID_ANY_ID,
-		I2C_HID_QUIRK_SET_PWR_WAKEUP_DEV },
 	{ I2C_VENDOR_ID_HANTICK, I2C_PRODUCT_ID_HANTICK_5288,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ I2C_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_VOYO_WINPAD_A15,
@@ -389,8 +386,7 @@ static int i2c_hid_set_power(struct i2c_hid *ihid, int power_state)
 	 * The call will get a return value (EREMOTEIO) but device will be
 	 * triggered and activated. After that, it goes like a normal device.
 	 */
-	if (power_state == I2C_HID_PWR_ON &&
-	    ihid->quirks & I2C_HID_QUIRK_SET_PWR_WAKEUP_DEV) {
+	if (power_state == I2C_HID_PWR_ON) {
 		ret = i2c_hid_set_power_command(ihid, I2C_HID_PWR_ON);
 
 		/* Device was already activated */
-- 
2.43.0



