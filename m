Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C822339713;
	Mon, 27 Oct 2025 19:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591622; cv=none; b=DD06PXR5KHiXbfk7/Js26kEsJRdE1ViCdIcC0AJIqjjPKGOrQM0V5QQJzaaP4LBcmZh+LcTFTgHOP8GU5TaDX1LSNu5CLZ59zdro7f7ddEMYbeHYnJb8bon3cyCnL3iwFbmgIBbXLDCl65y+BYrUbte0i661KRVpGCM5UQxP/Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591622; c=relaxed/simple;
	bh=LwLjAg+7ZFqq8/ZvdUwfpxLE4nfOpCg5yxE6uSrL4GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ml3DPoJ/A/owMT70lh+XpneSTtRjAkDl4E22eVW+Mkzp/Ll1HQG/n9lgSmdoVSHisYH8QKpckP87n2GKLPQphqDaE+Z3yacBBFOuC5o5QFMPKIAiJnIfwOsp1/fIpNzdWdCL2oA5uJGGnRStibteGWMcJIgvDXFj4fVTjyBKfss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKGCcAYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKGCcAYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF0BC4CEFD;
	Mon, 27 Oct 2025 19:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591622;
	bh=LwLjAg+7ZFqq8/ZvdUwfpxLE4nfOpCg5yxE6uSrL4GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKGCcAYFXBidBWxGQGYBVp5S+xkYw5UjXUfH+2loUDMWu7OC25I926m+izu+IMJQg
	 8274bm099KKzhYP+xqgzvhE1NdvmY4ZuV2gTxjBB/43gK0tJaxJbaNxY4PEH9Hb4tL
	 XGk89fYi1f45LieFj/gTG0PdJL96Rvap7huKYNR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Kalle Valo <kvalo@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 226/332] wifi: rt2x00: use explicitly signed or unsigned types
Date: Mon, 27 Oct 2025 19:34:39 +0100
Message-ID: <20251027183530.763176663@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 66063033f77e10b985258126a97573f84bb8d3b4 upstream.

On some platforms, `char` is unsigned, but this driver, for the most
part, assumed it was signed. In other places, it uses `char` to mean an
unsigned number, but only in cases when the values are small. And in
still other places, `char` is used as a boolean. Put an end to this
confusion by declaring explicit types, depending on the context.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221019155541.3410813-1-Jason@zx2c4.com
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c |    8 ++---
 drivers/net/wireless/ralink/rt2x00/rt2400pci.h |    2 -
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c |    8 ++---
 drivers/net/wireless/ralink/rt2x00/rt2500pci.h |    2 -
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c |    8 ++---
 drivers/net/wireless/ralink/rt2x00/rt2500usb.h |    2 -
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   36 ++++++++++++-------------
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h |    8 ++---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c |    6 ++--
 drivers/net/wireless/ralink/rt2x00/rt61pci.c   |    4 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.h   |    2 -
 drivers/net/wireless/ralink/rt2x00/rt73usb.c   |    4 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.h   |    2 -
 13 files changed, 46 insertions(+), 46 deletions(-)

--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
@@ -1023,9 +1023,9 @@ static int rt2400pci_set_state(struct rt
 {
 	u32 reg, reg2;
 	unsigned int i;
-	char put_to_sleep;
-	char bbp_state;
-	char rf_state;
+	bool put_to_sleep;
+	u8 bbp_state;
+	u8 rf_state;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -1561,7 +1561,7 @@ static int rt2400pci_probe_hw_mode(struc
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power;
+	u8 *tx_power;
 	unsigned int i;
 
 	/*
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.h
@@ -939,7 +939,7 @@
 #define DEFAULT_TXPOWER	39
 
 #define __CLAMP_TX(__txpower) \
-	clamp_t(char, (__txpower), MIN_TXPOWER, MAX_TXPOWER)
+	clamp_t(u8, (__txpower), MIN_TXPOWER, MAX_TXPOWER)
 
 #define TXPOWER_FROM_DEV(__txpower) \
 	((__CLAMP_TX(__txpower) - MAX_TXPOWER) + MIN_TXPOWER)
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
@@ -1176,9 +1176,9 @@ static int rt2500pci_set_state(struct rt
 {
 	u32 reg, reg2;
 	unsigned int i;
-	char put_to_sleep;
-	char bbp_state;
-	char rf_state;
+	bool put_to_sleep;
+	u8 bbp_state;
+	u8 rf_state;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -1856,7 +1856,7 @@ static int rt2500pci_probe_hw_mode(struc
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power;
+	u8 *tx_power;
 	unsigned int i;
 
 	/*
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.h
@@ -1219,6 +1219,6 @@
 	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
 
 #define TXPOWER_TO_DEV(__txpower) \
-	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
+	clamp_t(u8, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT2500PCI_H */
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
@@ -984,9 +984,9 @@ static int rt2500usb_set_state(struct rt
 	u16 reg;
 	u16 reg2;
 	unsigned int i;
-	char put_to_sleep;
-	char bbp_state;
-	char rf_state;
+	bool put_to_sleep;
+	u8 bbp_state;
+	u8 rf_state;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -1663,7 +1663,7 @@ static int rt2500usb_probe_hw_mode(struc
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power;
+	u8 *tx_power;
 	unsigned int i;
 
 	/*
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.h
@@ -839,6 +839,6 @@
 	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
 
 #define TXPOWER_TO_DEV(__txpower) \
-	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
+	clamp_t(u8, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT2500USB_H */
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3297,10 +3297,10 @@ static void rt2800_config_channel_rf53xx
 	if (rt2x00_has_cap_bt_coexist(rt2x00dev)) {
 		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
 			/* r55/r59 value array of channel 1~14 */
-			static const char r55_bt_rev[] = {0x83, 0x83,
+			static const u8 r55_bt_rev[] = {0x83, 0x83,
 				0x83, 0x73, 0x73, 0x63, 0x53, 0x53,
 				0x53, 0x43, 0x43, 0x43, 0x43, 0x43};
-			static const char r59_bt_rev[] = {0x0e, 0x0e,
+			static const u8 r59_bt_rev[] = {0x0e, 0x0e,
 				0x0e, 0x0e, 0x0e, 0x0b, 0x0a, 0x09,
 				0x07, 0x07, 0x07, 0x07, 0x07, 0x07};
 
@@ -3309,7 +3309,7 @@ static void rt2800_config_channel_rf53xx
 			rt2800_rfcsr_write(rt2x00dev, 59,
 					   r59_bt_rev[idx]);
 		} else {
-			static const char r59_bt[] = {0x8b, 0x8b, 0x8b,
+			static const u8 r59_bt[] = {0x8b, 0x8b, 0x8b,
 				0x8b, 0x8b, 0x8b, 0x8b, 0x8a, 0x89,
 				0x88, 0x88, 0x86, 0x85, 0x84};
 
@@ -3317,10 +3317,10 @@ static void rt2800_config_channel_rf53xx
 		}
 	} else {
 		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
-			static const char r55_nonbt_rev[] = {0x23, 0x23,
+			static const u8 r55_nonbt_rev[] = {0x23, 0x23,
 				0x23, 0x23, 0x13, 0x13, 0x03, 0x03,
 				0x03, 0x03, 0x03, 0x03, 0x03, 0x03};
-			static const char r59_nonbt_rev[] = {0x07, 0x07,
+			static const u8 r59_nonbt_rev[] = {0x07, 0x07,
 				0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
 				0x07, 0x07, 0x06, 0x05, 0x04, 0x04};
 
@@ -3331,14 +3331,14 @@ static void rt2800_config_channel_rf53xx
 		} else if (rt2x00_rt(rt2x00dev, RT5390) ||
 			   rt2x00_rt(rt2x00dev, RT5392) ||
 			   rt2x00_rt(rt2x00dev, RT6352)) {
-			static const char r59_non_bt[] = {0x8f, 0x8f,
+			static const u8 r59_non_bt[] = {0x8f, 0x8f,
 				0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
 				0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
 
 			rt2800_rfcsr_write(rt2x00dev, 59,
 					   r59_non_bt[idx]);
 		} else if (rt2x00_rt(rt2x00dev, RT5350)) {
-			static const char r59_non_bt[] = {0x0b, 0x0b,
+			static const u8 r59_non_bt[] = {0x0b, 0x0b,
 				0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0a,
 				0x0a, 0x09, 0x08, 0x07, 0x07, 0x06};
 
@@ -3961,23 +3961,23 @@ static void rt2800_iq_calibrate(struct r
 	rt2800_bbp_write(rt2x00dev, 159, cal != 0xff ? cal : 0);
 }
 
-static char rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
+static s8 rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
 				  unsigned int channel,
-				  char txpower)
+				  s8 txpower)
 {
 	if (rt2x00_rt(rt2x00dev, RT3593) ||
 	    rt2x00_rt(rt2x00dev, RT3883))
 		txpower = rt2x00_get_field8(txpower, EEPROM_TXPOWER_ALC);
 
 	if (channel <= 14)
-		return clamp_t(char, txpower, MIN_G_TXPOWER, MAX_G_TXPOWER);
+		return clamp_t(s8, txpower, MIN_G_TXPOWER, MAX_G_TXPOWER);
 
 	if (rt2x00_rt(rt2x00dev, RT3593) ||
 	    rt2x00_rt(rt2x00dev, RT3883))
-		return clamp_t(char, txpower, MIN_A_TXPOWER_3593,
+		return clamp_t(s8, txpower, MIN_A_TXPOWER_3593,
 			       MAX_A_TXPOWER_3593);
 	else
-		return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
+		return clamp_t(s8, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
 }
 
 static void rt3883_bbp_adjust(struct rt2x00_dev *rt2x00dev,
@@ -8473,11 +8473,11 @@ static int rt2800_rf_lp_config(struct rt
 	return 0;
 }
 
-static char rt2800_lp_tx_filter_bw_cal(struct rt2x00_dev *rt2x00dev)
+static s8 rt2800_lp_tx_filter_bw_cal(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int cnt;
 	u8 bbp_val;
-	char cal_val;
+	s8 cal_val;
 
 	rt2800_bbp_dcoc_write(rt2x00dev, 0, 0x82);
 
@@ -8509,7 +8509,7 @@ static void rt2800_bw_filter_calibration
 	u8 rx_filter_target_20m = 0x27, rx_filter_target_40m = 0x31;
 	int loop = 0, is_ht40, cnt;
 	u8 bbp_val, rf_val;
-	char cal_r32_init, cal_r32_val, cal_diff;
+	s8 cal_r32_init, cal_r32_val, cal_diff;
 	u8 saverfb5r00, saverfb5r01, saverfb5r03, saverfb5r04, saverfb5r05;
 	u8 saverfb5r06, saverfb5r07;
 	u8 saverfb5r08, saverfb5r17, saverfb5r18, saverfb5r19, saverfb5r20;
@@ -9960,9 +9960,9 @@ static int rt2800_probe_hw_mode(struct r
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *default_power1;
-	char *default_power2;
-	char *default_power3;
+	s8 *default_power1;
+	s8 *default_power2;
+	s8 *default_power3;
 	unsigned int i, tx_chains, rx_chains;
 	u32 reg;
 
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -22,10 +22,10 @@
 struct rt2800_drv_data {
 	u8 calibration_bw20;
 	u8 calibration_bw40;
-	char rx_calibration_bw20;
-	char rx_calibration_bw40;
-	char tx_calibration_bw20;
-	char tx_calibration_bw40;
+	s8 rx_calibration_bw20;
+	s8 rx_calibration_bw40;
+	s8 tx_calibration_bw20;
+	s8 tx_calibration_bw40;
 	u8 bbp25;
 	u8 bbp26;
 	u8 txmixer_gain_24g;
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -117,12 +117,12 @@ int rt2x00usb_vendor_request_buff(struct
 				  const u16 buffer_length)
 {
 	int status = 0;
-	unsigned char *tb;
+	u8 *tb;
 	u16 off, len, bsize;
 
 	mutex_lock(&rt2x00dev->csr_mutex);
 
-	tb  = (char *)buffer;
+	tb  = (u8 *)buffer;
 	off = offset;
 	len = buffer_length;
 	while (len && !status) {
@@ -215,7 +215,7 @@ void rt2x00usb_register_read_async(struc
 	rd->cr.wLength = cpu_to_le16(sizeof(u32));
 
 	usb_fill_control_urb(urb, usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			     (unsigned char *)(&rd->cr), &rd->reg, sizeof(rd->reg),
+			     (u8 *)(&rd->cr), &rd->reg, sizeof(rd->reg),
 			     rt2x00usb_register_read_async_cb, rd);
 	usb_anchor_urb(urb, rt2x00dev->anchor);
 	if (usb_submit_urb(urb, GFP_ATOMIC) < 0) {
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -1709,7 +1709,7 @@ static int rt61pci_set_state(struct rt2x
 {
 	u32 reg, reg2;
 	unsigned int i;
-	char put_to_sleep;
+	bool put_to_sleep;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -2656,7 +2656,7 @@ static int rt61pci_probe_hw_mode(struct
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power;
+	u8 *tx_power;
 	unsigned int i;
 
 	/*
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.h
@@ -1484,6 +1484,6 @@ struct hw_pairwise_ta_entry {
 	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
 
 #define TXPOWER_TO_DEV(__txpower) \
-	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
+	clamp_t(u8, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT61PCI_H */
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
@@ -1378,7 +1378,7 @@ static int rt73usb_set_state(struct rt2x
 {
 	u32 reg, reg2;
 	unsigned int i;
-	char put_to_sleep;
+	bool put_to_sleep;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -2090,7 +2090,7 @@ static int rt73usb_probe_hw_mode(struct
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power;
+	u8 *tx_power;
 	unsigned int i;
 
 	/*
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.h
@@ -1063,6 +1063,6 @@ struct hw_pairwise_ta_entry {
 	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
 
 #define TXPOWER_TO_DEV(__txpower) \
-	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
+	clamp_t(u8, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT73USB_H */


