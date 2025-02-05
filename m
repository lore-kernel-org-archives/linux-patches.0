Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BCE18BC26;
	Wed,  5 Feb 2025 15:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767657; cv=none; b=mnPubaUWHQVx5Px2E0ZJzalgo4YlS+nbrgMiJo9Dbya3zFXSgQF3ny/uo6Qar7Ql64Z1YnmJ3Ul/VFIpsVZwNT2UNZ5IBNZYj9fWL3Vg+1IzT8sL3OtsYjnPAshz51T4uhzlIP4AJiy/iMTHLh1AfoFmkPwwyXUdPlzjxDZjB+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767657; c=relaxed/simple;
	bh=M+snCi8vgaqHKZaWU/vGo09WzziPuWVuGKbkp/QuVRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qa2ae/mi65Sk9KUbaV8TgSlNHVn4yEWiiPhA3KkgnuMNsZSug0JN58EEm+0Y428CNJD+7wGgqcE5uepoHg70GNwkr/SMEyMp6fow4x+CEaD6+ZKNOWK+zjlC3ZNgejlpYDsquofF46IJsumPFWZ4mj843umFNBgXS4s2efMrv6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbvr8arp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbvr8arp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5DCC4CEDD;
	Wed,  5 Feb 2025 15:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767657;
	bh=M+snCi8vgaqHKZaWU/vGo09WzziPuWVuGKbkp/QuVRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbvr8arpD4ogZ6NJjeXDpjGIbWI+sqy8OaGE6cyNlD0I/AK61upcbPD7e/bF6o2tV
	 hZ981Uthz+MU2HQXUx+Yj7yUhYTfdkPwETH0RJCbC6x08zo7FqhKecmAz6VAWBdKoq
	 p1/fLk436Nvq1i/YI+Yv9A4uW24XcLp4Kfqp3sx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.12 488/590] ice: extend dump serdes equalizer values feature
Date: Wed,  5 Feb 2025 14:44:03 +0100
Message-ID: <20250205134513.936071883@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Polchlopek <mateusz.polchlopek@intel.com>

[ Upstream commit 99dbcab0cdd60e35d9f208b2f7515a19ba523ff6 ]

Extend the work done in commit 70838938e89c ("ice: Implement driver
functionality to dump serdes equalizer values") by adding the new set of
Rx registers that can be read using command:
  $ ethtool -d interface_name

Rx equalization parameters are E810 PHY registers used by end user to
gather information about configuration and status to debug link and
connection issues in the field.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: c5cc2a27e04f ("ice: remove invalid parameter of equalizer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 17 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ethtool.c    | 17 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ethtool.h    | 17 +++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 80f3dfd271243..2a61e1da993ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1492,6 +1492,23 @@ struct ice_aqc_dnl_equa_param {
 #define ICE_AQC_RX_EQU_BFLF (0x13 << ICE_AQC_RX_EQU_SHIFT)
 #define ICE_AQC_RX_EQU_BFHF (0x14 << ICE_AQC_RX_EQU_SHIFT)
 #define ICE_AQC_RX_EQU_DRATE (0x15 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_CTLE_GAINHF (0x20 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_CTLE_GAINLF (0x21 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_CTLE_GAINDC (0x22 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_CTLE_BW (0x23 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_GAIN (0x30 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_GAIN2 (0x31 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_2 (0x32 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_3 (0x33 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_4 (0x34 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_5 (0x35 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_6 (0x36 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_7 (0x37 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_8 (0x38 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_9 (0x39 << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_10 (0x3A << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_11 (0x3B << ICE_AQC_RX_EQU_SHIFT)
+#define ICE_AQC_RX_EQU_DFE_12 (0x3C << ICE_AQC_RX_EQU_SHIFT)
 #define ICE_AQC_TX_EQU_PRE1 0x0
 #define ICE_AQC_TX_EQU_PRE3 0x3
 #define ICE_AQC_TX_EQU_ATTEN 0x4
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index e011966e94502..f94b6bddbeaa1 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -711,6 +711,23 @@ static int ice_get_tx_rx_equa(struct ice_hw *hw, u8 serdes_num,
 		{ ICE_AQC_RX_EQU_BFLF, rx, &ptr->rx_equ_bflf },
 		{ ICE_AQC_RX_EQU_BFHF, rx, &ptr->rx_equ_bfhf },
 		{ ICE_AQC_RX_EQU_DRATE, rx, &ptr->rx_equ_drate },
+		{ ICE_AQC_RX_EQU_CTLE_GAINHF, rx, &ptr->rx_equ_ctle_gainhf },
+		{ ICE_AQC_RX_EQU_CTLE_GAINLF, rx, &ptr->rx_equ_ctle_gainlf },
+		{ ICE_AQC_RX_EQU_CTLE_GAINDC, rx, &ptr->rx_equ_ctle_gaindc },
+		{ ICE_AQC_RX_EQU_CTLE_BW, rx, &ptr->rx_equ_ctle_bw },
+		{ ICE_AQC_RX_EQU_DFE_GAIN, rx, &ptr->rx_equ_dfe_gain },
+		{ ICE_AQC_RX_EQU_DFE_GAIN2, rx, &ptr->rx_equ_dfe_gain_2 },
+		{ ICE_AQC_RX_EQU_DFE_2, rx, &ptr->rx_equ_dfe_2 },
+		{ ICE_AQC_RX_EQU_DFE_3, rx, &ptr->rx_equ_dfe_3 },
+		{ ICE_AQC_RX_EQU_DFE_4, rx, &ptr->rx_equ_dfe_4 },
+		{ ICE_AQC_RX_EQU_DFE_5, rx, &ptr->rx_equ_dfe_5 },
+		{ ICE_AQC_RX_EQU_DFE_6, rx, &ptr->rx_equ_dfe_6 },
+		{ ICE_AQC_RX_EQU_DFE_7, rx, &ptr->rx_equ_dfe_7 },
+		{ ICE_AQC_RX_EQU_DFE_8, rx, &ptr->rx_equ_dfe_8 },
+		{ ICE_AQC_RX_EQU_DFE_9, rx, &ptr->rx_equ_dfe_9 },
+		{ ICE_AQC_RX_EQU_DFE_10, rx, &ptr->rx_equ_dfe_10 },
+		{ ICE_AQC_RX_EQU_DFE_11, rx, &ptr->rx_equ_dfe_11 },
+		{ ICE_AQC_RX_EQU_DFE_12, rx, &ptr->rx_equ_dfe_12 },
 	};
 	int err;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.h b/drivers/net/ethernet/intel/ice/ice_ethtool.h
index 98eb9c51d687c..8f2ad1c172c06 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.h
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.h
@@ -16,6 +16,23 @@ struct ice_serdes_equalization_to_ethtool {
 	int rx_equ_bflf;
 	int rx_equ_bfhf;
 	int rx_equ_drate;
+	int rx_equ_ctle_gainhf;
+	int rx_equ_ctle_gainlf;
+	int rx_equ_ctle_gaindc;
+	int rx_equ_ctle_bw;
+	int rx_equ_dfe_gain;
+	int rx_equ_dfe_gain_2;
+	int rx_equ_dfe_2;
+	int rx_equ_dfe_3;
+	int rx_equ_dfe_4;
+	int rx_equ_dfe_5;
+	int rx_equ_dfe_6;
+	int rx_equ_dfe_7;
+	int rx_equ_dfe_8;
+	int rx_equ_dfe_9;
+	int rx_equ_dfe_10;
+	int rx_equ_dfe_11;
+	int rx_equ_dfe_12;
 	int tx_equ_pre1;
 	int tx_equ_pre3;
 	int tx_equ_atten;
-- 
2.39.5



