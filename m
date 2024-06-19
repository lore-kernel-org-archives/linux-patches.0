Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1914A1422B8;
	Wed, 19 Jun 2024 13:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802810; cv=none; b=YUGcBO4mHz3a7IRS/QpIzItfUTZGDwaIZ2qb0ptPUOWDutDfaXi8HVAH+486Mqh69DLZMYFJ985T8Kx75SSLePigQQkfQp4LM2YA5LyHvkBq1QACFz9n/8MtRW/d+VjGI8W2r+Pjw/8Adox5iGMha7me+DmYdhUOhdDleVkOuSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802810; c=relaxed/simple;
	bh=1bRK4qhz3NnVoNhz28cDzTouz6s5fAVnU0OFGRFPjwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsxkgXlBXJ1E1fk/Vu5X8U4RP/SijlW3s3fakhQYeOIKZMFDY1aKBjjHi2UCF6ILp9I3DBVxysU6VgsidqLhKmQCYUUFU9D5touZYcq1ON5Dvrv6twCIijTkO3J9QEd3OASLRgGTYomLis1+OyDERJoKQKp/onhSkUKPs3JvHLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEz22MPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEz22MPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5E7C2BBFC;
	Wed, 19 Jun 2024 13:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802809;
	bh=1bRK4qhz3NnVoNhz28cDzTouz6s5fAVnU0OFGRFPjwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEz22MPIXIYLREv7vEm4PNbAg8wdYCcbrX/Kuve2+KQmNV3mmOflgaYKeqrp7nJGy
	 ff9j8+X3VEATUTt0CYTGvhkoRX8GiRYxlkhcPxdULCM6HRzPDTwvN4Cj/A4TBsucOo
	 Faa0xABG0Arqa/hkNI9aTi/7kwwiF0ykdBMqg7x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dima Ruinskiy <dima.ruinskiy@intel.com>,
	Sasha Neftin <sasha.neftin@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 055/281] igc: Fix Energy Efficient Ethernet support declaration
Date: Wed, 19 Jun 2024 14:53:34 +0200
Message-ID: <20240619125611.968569626@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 7d67d11fbe194f71298263f48e33ae2afa38197e ]

The commit 01cf893bf0f4 ("net: intel: i40e/igc: Remove setting Autoneg in
EEE capabilities") removed SUPPORTED_Autoneg field but left inappropriate
ethtool_keee structure initialization. When "ethtool --show <device>"
(get_eee) invoke, the 'ethtool_keee' structure was accidentally overridden.
Remove the 'ethtool_keee' overriding and add EEE declaration as per IEEE
specification that allows reporting Energy Efficient Ethernet capabilities.

Examples:
Before fix:
ethtool --show-eee enp174s0
EEE settings for enp174s0:
	EEE status: not supported

After fix:
EEE settings for enp174s0:
	EEE status: disabled
	Tx LPI: disabled
	Supported EEE link modes:  100baseT/Full
	                           1000baseT/Full
	                           2500baseT/Full

Fixes: 01cf893bf0f4 ("net: intel: i40e/igc: Remove setting Autoneg in EEE capabilities")
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20240603-net-2024-05-30-intel-net-fixes-v2-6-e3563aa89b0c@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 9 +++++++--
 drivers/net/ethernet/intel/igc/igc_main.c    | 4 ++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 1a64f1ca6ca86..e699412d22f68 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1629,12 +1629,17 @@ static int igc_ethtool_get_eee(struct net_device *netdev,
 	struct igc_hw *hw = &adapter->hw;
 	u32 eeer;
 
+	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+			 edata->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+			 edata->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+			 edata->supported);
+
 	if (hw->dev_spec._base.eee_enable)
 		mii_eee_cap1_mod_linkmode_t(edata->advertised,
 					    adapter->eee_advert);
 
-	*edata = adapter->eee;
-
 	eeer = rd32(IGC_EEER);
 
 	/* EEE status on negotiated link */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 4d975d620a8e4..58bc96021bb4c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -12,6 +12,7 @@
 #include <linux/bpf_trace.h>
 #include <net/xdp_sock_drv.h>
 #include <linux/pci.h>
+#include <linux/mdio.h>
 
 #include <net/ipv6.h>
 
@@ -4876,6 +4877,9 @@ void igc_up(struct igc_adapter *adapter)
 	/* start the watchdog. */
 	hw->mac.get_link_status = true;
 	schedule_work(&adapter->watchdog_task);
+
+	adapter->eee_advert = MDIO_EEE_100TX | MDIO_EEE_1000T |
+			      MDIO_EEE_2_5GT;
 }
 
 /**
-- 
2.43.0



