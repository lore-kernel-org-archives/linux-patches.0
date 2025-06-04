Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473941A5BA0;
	Wed,  4 Jun 2025 01:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999190; cv=none; b=u5qQaORev7a6tnHpGQz/v5rImrhbrlXPIq6u64OyHq19yXPTzBlNReD7lnV//Glk7P9azR7owHvA50WosGRk4o2UcZs7mE6m3XOkxinbbD3vFtkyMsEqbJ/TQgvf428TXnyD1SQ5IyG04BurAhlyisPhW79NnY91vJChQLWTRek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999190; c=relaxed/simple;
	bh=q7JYVPVG2dRLlDqWkJSfnGRBlhdWxwq+TInUPdY3o64=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PFvF4I9ePmimsRJ+UVPqN5JbhG0/yQhQYtv2uXdXq14x04hbBzjFz4bgDja6A7A4+IsnBsESWhOlx0Qqy2hyeHIg2b90CiHtzcx+cWa/YKiEQaqtSf4HjuU+nIjdTkcNghmRb7BOiRlGHK4TjCHHsnhZWFafFfQ22PKD6kMTLKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMhwNPq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMhwNPq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6662C4CEEF;
	Wed,  4 Jun 2025 01:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999190;
	bh=q7JYVPVG2dRLlDqWkJSfnGRBlhdWxwq+TInUPdY3o64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMhwNPq3YNTYhv8Edqq4LTeDb5E92FsdNtPzGxUO+/DpiROetHGS1FIBfB+Z8Ptum
	 +/+pKCgxQ36t04fYQdCxA3ANLFO/gv5E63Nk78mwRyYVp21lCvbin1IlaQ4jD7709q
	 +Om8Itk2jsTobJOHme2LUUujE0647HmtXLQ4u8uFMT7aH5o/RTU69+CcUJ1cbsJUZ5
	 /O0C1VwfF6zzUSmztrDfa1LHVib+la3ckx/UhP7/TsiJfeRdXuOyyeFxWXKhljxnOh
	 Fx9WphGcxFx1LCJomQ40KsZlEZo6g0u/NaTW6EOtf+FQMSVXTviCcgwlviIDs2lmRB
	 gx5tSML0hQPMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Henk Vergonet <henk.vergonet@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	uwu@icenowy.me,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 05/27] wifi: mt76: mt76x2: Add support for LiteOn WN4516R,WN4519R
Date: Tue,  3 Jun 2025 21:05:58 -0400
Message-Id: <20250604010620.6819-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010620.6819-1-sashal@kernel.org>
References: <20250604010620.6819-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.237
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Henk Vergonet <henk.vergonet@gmail.com>

[ Upstream commit 3c0e4f606d8693795a2c965d6f4987b1bfc31097 ]

Adds support for:
 - LiteOn WN4516R
 - LiteOn WN4519R
 Both use:
 - A nonstandard USB connector
 - Mediatek chipset MT7600U
 - ASIC revision: 76320044

Disabled VHT support on ASIC revision 76320044:

 This fixes the 5G connectibity issue on LiteOn WN4519R module
 see https://github.com/openwrt/mt76/issues/971

 And may also fix the 5G issues on the XBox One Wireless Adapter
 see https://github.com/openwrt/mt76/issues/200

 I have looked at the FCC info related to the MT7632U chip as mentioned in here:
 https://github.com/openwrt/mt76/issues/459
 These confirm the chipset does not support 'ac' mode and hence VHT should be turned of.

Signed-off-by: Henk Vergonet <henk.vergonet@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250418143914.31384-1-henk.vergonet@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: ## Comparison with Similar Commits This commit
closely matches **Similar Commit #1** (XBox One wifi adapter support)
which was marked as **YES** for backporting. Both commits: - Add new USB
device IDs for wireless adapters - Include hardware-specific workarounds
for device limitations - Fix connectivity issues for specific hardware
## Code Changes Analysis ### 1. USB Device ID Additions (Low Risk) ```c
{ USB_DEVICE(0x0471, 0x2126) }, /bin /bin.usr-is-merged /boot /dev /etc
/home /init /lib /lib.usr-is-merged /lib64 /lost+found /media /mnt /opt
/proc /root /run /sbin /sbin.usr-is-merged /snap /srv /sys /tmp /usr
/var LiteOn WN4516R module, nonstandard USB connector linux/ {
USB_DEVICE(0x0471, 0x7600) }, /bin /bin.usr-is-merged /boot /dev /etc
/home /init /lib /lib.usr-is-merged /lib64 /lost+found /media /mnt /opt
/proc /root /run /sbin /sbin.usr-is-merged /snap /srv /sys /tmp /usr
/var LiteOn WN4519R module, nonstandard USB connector linux/ ``` -
**Risk**: Minimal - adding device IDs is very safe - **Impact**: Enables
support for new hardware without affecting existing devices - **Scope**:
Contained to device identification ### 2. VHT Capability Fix (Critical
Bug Fix) ```c switch (dev->mt76.rev) { case 0x76320044: /bin /bin.usr-
is-merged /boot /dev /etc /home /init /lib /lib.usr-is-merged /lib64
/lost+found /media /mnt /opt /proc /root /run /sbin /sbin.usr-is-merged
/snap /srv /sys /tmp /usr /var these ASIC revisions do not support VHT
linux/ vht = false; break; default: vht = true; break; } ``` - **Fixes
critical connectivity issues**: The commit explicitly fixes 5G
connectivity problems - **Hardware-specific workaround**: Targets a
specific ASIC revision (0x76320044) - **Conservative approach**:
Disables problematic VHT only for affected hardware - **Minimal
regression risk**: Existing devices continue using VHT as before ##
Backport Suitability Criteria ✅ **Fixes user-affecting bugs**: Resolves
5G connectivity issues on LiteOn modules and potentially XBox One
adapters ✅ **Small and contained**: Changes are minimal - 2 new USB IDs
and a targeted VHT disable ✅ **No architectural changes**: Uses existing
framework, just adds device support and fixes capability detection ✅
**References external issues**: Links to GitHub issues #971 and #200,
indicating real user problems ✅ **Clear side effects documentation**:
VHT disabling is well-documented and justified with FCC information ✅
**Follows stable tree rules**: Important hardware support fix with
minimal regression risk ✅ **Confined to subsystem**: Changes limited to
mt76x2 USB driver ## Hardware Impact Assessment The commit addresses
**confirmed hardware limitations** where VHT was incorrectly enabled on
chipsets that don't support it, causing: - Connection failures in 5GHz
band - Potential instability when VHT features are attempted This
matches the pattern of **Similar Commit #1** which added support for
newer XBox One adapters and was successfully backported. The
risk/benefit ratio strongly favors backporting: minimal code changes
that fix real connectivity issues for specific hardware without
affecting other devices.

 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c     |  2 ++
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c    | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 82a193aac09d7..95c548f45bdf8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -17,6 +17,8 @@ static const struct usb_device_id mt76x2u_device_table[] = {
 	{ USB_DEVICE(0x057c, 0x8503) },	/* Avm FRITZ!WLAN AC860 */
 	{ USB_DEVICE(0x7392, 0xb711) },	/* Edimax EW 7722 UAC */
 	{ USB_DEVICE(0x0e8d, 0x7632) },	/* HC-M7662BU1 */
+	{ USB_DEVICE(0x0471, 0x2126) }, /* LiteOn WN4516R module, nonstandard USB connector */
+	{ USB_DEVICE(0x0471, 0x7600) }, /* LiteOn WN4519R module, nonstandard USB connector */
 	{ USB_DEVICE(0x2c4e, 0x0103) },	/* Mercury UD13 */
 	{ USB_DEVICE(0x0846, 0x9053) },	/* Netgear A6210 */
 	{ USB_DEVICE(0x045e, 0x02e6) },	/* XBox One Wireless Adapter */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index ffc2deba29ac6..c845e83897659 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -191,6 +191,7 @@ int mt76x2u_register_device(struct mt76x02_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct mt76_usb *usb = &dev->mt76.usb;
+	bool vht;
 	int err;
 
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x2u_phy_calibrate);
@@ -215,7 +216,17 @@ int mt76x2u_register_device(struct mt76x02_dev *dev)
 
 	/* check hw sg support in order to enable AMSDU */
 	hw->max_tx_fragments = dev->mt76.usb.sg_en ? MT_TX_SG_MAX_SIZE : 1;
-	err = mt76_register_device(&dev->mt76, true, mt76x02_rates,
+	switch (dev->mt76.rev) {
+	case 0x76320044:
+		/* these ASIC revisions do not support VHT */
+		vht = false;
+		break;
+	default:
+		vht = true;
+		break;
+	}
+
+	err = mt76_register_device(&dev->mt76, vht, mt76x02_rates,
 				   ARRAY_SIZE(mt76x02_rates));
 	if (err)
 		goto fail;
-- 
2.39.5

