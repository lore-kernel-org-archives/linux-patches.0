Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060635;
	b=Z4HmOIDWAC0nkPLazQKve/UTkFRBZ/mVEsubWvu2XisZnP4rqv7RHbQQCBNXUVi2Sgnt
	 Lhknth+TMyWJ9u50PzfTV3cMcj6++AyKvHjq8MgjiEKcOcJC8cgpjLOkFhe0QjzeDVLRw
	 lHeJwRPoHwQlUDztFO+WohBU9S48H/erPsvLTH3uJ6K88Emd4qBRgXeVpNh47nbKIGZvJ
	 N1+A5nFqwpaUtezM0WCOb1BuIGrLkIUFI9Yax3TZ19wRY/dzkgcZ1L/bcfP3ejNPIRSy0
	 uUUBdd7vcYYEoZpQhWg6nPMlRIeZ7LKL0TrF6ztZY18SLnzq4iH43uR4CXexQgZSm2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=by2VcFd8jh/TDtRcsZ0+3Hiq+swZwMhNSAXyuqSxBrE=;
	b=4oSCq5NZ9F6DaAhLlRheY9tKfOYp8pvjqC7Gyc3sMPbQgxFqq37kGRurRpbKKDp0kCG+
	 8cxn/EZRr/jCk8bytVid3Que7RLNhlczoAYiFkYZO01gmm15/gdx5yQu4Xu1fKHUccLPd
	 U5ELA8t+xDXXhqUs9QuI1SigFqiSm5DUwefw8irmTDgUx89dobgdSCc9o83/O/RhjxZiV
	 0UzI1YEJVv8WyaPW54LgMKgCSHw6WJQJ8bjXys6dmcEm8jY6QhMvlYBx2ZRAKzePXkuSy
	 QGwyYlpjJGzmGhuZusyppRDaRJW7RWh+oSTo4Rfjry41eV19st22EF65f6m8Vl9aORg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RsJmRS+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2B2606A326;
	Sat,  7 Nov 2026 14:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RsJmRS+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084E91F008A1;
	Sat,  7 Nov 2026 14:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060635;
	bh=by2VcFd8jh/TDtRcsZ0+3Hiq+swZwMhNSAXyuqSxBrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RsJmRS+3zxkFlUMr/CxL7eMg9MWnHtAh1/gwuF0+5YjUh9QVkPZ09uv8xEYGJEz0X
	 SQ+2T+8iA5QhaahQ80NUM7JH2ZcvjYnN88/R237sAyWwNpuMac1yUqAqxp+5F19eSp
	 WBevSl4bpcp+M4KNlgVmBzz7RfmEyCSIhkYA+D20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Hansen-Baird <william.hansen.baird@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0077/1536] wifi: rtlwifi: fix disabling of ASPM for RTL8723BE with AER flooding
Date: Sat,  7 Nov 2026 08:34:53 -0500
Message-ID: <20261107134959.839098383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8fb9604c3c533..f9f05252b890e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -156,15 +156,6 @@ static void _rtl_pci_update_default_setting(struct ieee80211_hw *hw)
 				PCI_EXP_LNKCTL_ASPM_L1 | PCI_EXP_LNKCTL_CCC))
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
 	u16 tmp_u1b = 0;
 
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
@@ -330,10 +328,25 @@ static void rtl_pci_parse_configuration(struct pci_dev *pdev,
 
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



