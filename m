Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033583;
	b=OGSTQrBcmIA7P+cqP4mWzVqyguwjc+o0AVjQug5VdJj0J+pQUY2NCHFp/YLuKQYMslBV
	 sOm9WE8xJJ8KGyYryzy9w3Z5phTdrVnLfEIbPFz9sMFLRY/xJyvkIBx0niOGBQHC8JeSg
	 U+6SeGTJ+vhVwaqdYgjAylf1ZQ+YsOHbVyWDFk8WG71pEi1Gn8IxGzNFkQ3JbMKwpmCSU
	 //GxhEqebda75H3rTasakYENqeWm4e7G1jAUZTKy0Vg23d0evlYqsCM4j6vAZ73xMvk1o
	 5o7H46yWeGCbK6LeHi+KCoVk0gB78rFavg03JYbT0EN//GXC3goLeVTCBOotCTwJedw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D0fm0sEQhdqzTZnpmVziGI1ujACb7GGjDiyg5EgnlJQ=;
	b=zmCVUeCyddkiXa0iWIjjgcUxILiY5zZtMgepkZHphmJdtT9wm7DsDeUDiY6FORv2Bjfe
	 uQI7eMXFQ3tvKYvfJvqTU5Ezbj8w/TzbJic4k4BkiNNDXKYB6IlqRY8NLOB6JlmrTwrEe
	 tHdOCKTnK5EIjGNO5BWI8WP5f7Imxq8T9WxrbByq1VcgaHF1rcNnPydJiOhJKkjypOUBk
	 YtG/HZeIcg9mAohkU7YgzZokZvbSvx0OcyS+mGYzvm4J8YIwA9BUXkIqFIMmGZMB8BBkS
	 Lv4Z0kuO/sdg0dgSlgnIA/vyRIwQI6k9vT7A9+eN0Iuc5vibhWK/zuLXXVOuSrM1nCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="trdoP/tm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD49606A320;
	Wed, 18 Nov 2026 20:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trdoP/tm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DAC1F000C4;
	Wed, 18 Nov 2026 20:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033583;
	bh=D0fm0sEQhdqzTZnpmVziGI1ujACb7GGjDiyg5EgnlJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trdoP/tmQvScySAiruOk3VR7WY5ZmnNshpY7Y0TKifzV+j7uXW6YDWuDkYJpjso7N
	 NV6zc2usKsSeyF+Pvj9NabE0CMD+k7Zm9uKe4XnpXZwD+pXUdnS1z0A4MkUMoxqquI
	 poxbdcEEnaCi1IItVs5gPbk8adOGVuQUoRj4Fw6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Hansen-Baird <william.hansen.baird@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0064/3318] wifi: rtlwifi: fix disabling of ASPM for RTL8723BE with AER flooding
Date: Wed, 18 Nov 2026 15:11:26 +0100
Message-ID: <20261118150315.913195648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Hansen-Baird <william.hansen.baird@gmail.com>

[ Upstream commit 04a46c2dbf3b516c96a1d19b72917b56055ad6c1 ]

commit 77a6407c6ab2 ("wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 11ad:1723")
adds code which sets ppsc->support_aspm to false in
_rtl_pci_update_default_setting() in order to disable ASPM.
This does not, however, disable ASPM. Rather, it disables driver
control of ASPM, and blocks calls to rtl_pci_enable_aspm()
and rtl_pci_disable_aspm().

In some cases, the pci device supplied to the probe function has
ASPM enabled. The code would therefore not disable ASPM, as it means to,
but rather just leave it enabled.
This was discovered through testing on a Razer Blade 14 2017.

Implement a new __rtl_pci_disable_aspm(hw) function which does not check
ppsc->support_aspm before disabling and call it from
rtl_pci_disable_aspm().

Then move the code added in the previous commit to rtl_pci_init_aspm() to
allow adding a call to __rtl_pci_disable_aspm(hw).
This makes sure ASPM is disabled while still disabling
driver control of ASPM to block it from being enabled later.

Signed-off-by: William Hansen-Baird <william.hansen.baird@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260630141553.785769-2-william.hansen.baird@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 39 ++++++++++++++--------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 7bd72cc1f6626..25c166e430e00 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -156,15 +156,6 @@ static void _rtl_pci_update_default_setting(struct ieee80211_hw *hw)
 	    init_aspm == 0x43)
 		ppsc->support_aspm = false;
 
-	/* RTL8723BE found on some ASUSTek laptops, such as F441U and
-	 * X555UQ with subsystem ID 11ad:1723 are known to output large
-	 * amounts of PCIe AER errors during and after boot up, causing
-	 * heavy lags, poor network throughput, and occasional lock-ups.
-	 */
-	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8723BE &&
-	    (rtlpci->pdev->subsystem_vendor == 0x11ad &&
-	     rtlpci->pdev->subsystem_device == 0x1723))
-		ppsc->support_aspm = false;
 }
 
 static bool _rtl_pci_platform_switch_device_pci_aspm(
@@ -203,7 +194,7 @@ static void _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u16 value)
 }
 
 /*Disable RTL8192SE ASPM & Disable Pci Bridge ASPM*/
-static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
+static void __rtl_pci_disable_aspm(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
@@ -215,9 +206,6 @@ static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
 	u16 aspmlevel = 0;
 	u8 tmp_u1b = 0;
 
-	if (!ppsc->support_aspm)
-		return;
-
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_UNKNOWN) {
 		rtl_dbg(rtlpriv, COMP_POWER, DBG_TRACE,
 			"PCI(Bridge) UNKNOWN\n");
@@ -240,6 +228,16 @@ static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
 	_rtl_pci_platform_switch_device_pci_aspm(hw, linkctrl_reg);
 }
 
+static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
+{
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+
+	if (!ppsc->support_aspm)
+		return;
+
+	__rtl_pci_disable_aspm(hw);
+}
+
 /*Enable RTL8192SE ASPM & Enable Pci Bridge ASPM for
  *power saving We should follow the sequence to enable
  *RTL8192SE first then enable Pci Bridge ASPM
@@ -331,10 +329,25 @@ static void rtl_pci_parse_configuration(struct pci_dev *pdev,
 
 static void rtl_pci_init_aspm(struct ieee80211_hw *hw)
 {
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	_rtl_pci_update_default_setting(hw);
 
+	/*
+	 * RTL8723BE found on some ASUSTek laptops, such as F441U and
+	 * X555UQ with subsystem ID 11ad:1723 are known to output large
+	 * amounts of PCIe AER errors during and after boot up, causing
+	 * heavy lags, poor network throughput, and occasional lock-ups.
+	 */
+	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8723BE &&
+	    (rtlpci->pdev->subsystem_vendor == 0x11ad &&
+	     rtlpci->pdev->subsystem_device == 0x1723)) {
+		__rtl_pci_disable_aspm(hw);
+		ppsc->support_aspm = false;
+	}
+
 	if (ppsc->reg_rfps_level & RT_RF_PS_LEVEL_ALWAYS_ASPM) {
 		/*Always enable ASPM & Clock Req. */
 		rtl_pci_enable_aspm(hw);
-- 
2.53.0



