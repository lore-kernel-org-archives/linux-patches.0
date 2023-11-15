Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3604A3BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPW5unL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D326CC433CB;
	Wed, 15 Nov 2023 19:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076197;
	bh=k5pvGp1IhzJ7HaxirzkN0dOmWeca1m/rSBlvrfigLrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPW5unL7YGpGkZHhVePnLRICPGGGkT+9SLS06QEgJuzyViNcZmO7iSSc69xvHGAEu
	 szOWE67+Xo/qVcBfw6CRKkvCVkxS9z77wib6HlkBFvgFrorpDPG1aZseGRsaI+zEDr
	 heLPEfzEt1/hARwuLT/jV7LfvXggPKjxX7P8J3gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 136/550] wifi: iwlwifi: mvm: fix netif csum flags
Date: Wed, 15 Nov 2023 14:12:00 -0500
Message-ID: <20231115191610.118846562@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 08365d3b9140c751a84f8027ac7d2e662958f768 ]

We shouldn't advertise arbitrary checksum flags since we had
to remove support for it due to broken hardware.

Fixes: ec18e7d4d20d ("wifi: iwlwifi: mvm: use old checksum for Bz A-step")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231017115047.e37327f1a129.Iaee86b00db4db791cd90adaf15384b8c87d2ad49@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c     | 4 ++--
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c     | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 5 +----
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
index 3d223014cfe6d..42e765fe3cfe1 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
@@ -158,7 +158,7 @@ const struct iwl_cfg iwl_cfg_bz = {
 	.fw_name_mac = "bz",
 	.uhb_supported = true,
 	IWL_DEVICE_BZ,
-	.features = IWL_TX_CSUM_NETIF_FLAGS_BZ | NETIF_F_RXCSUM,
+	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,
 	.num_rbds = IWL_NUM_RBDS_BZ_EHT,
 };
 
@@ -166,7 +166,7 @@ const struct iwl_cfg iwl_cfg_gl = {
 	.fw_name_mac = "gl",
 	.uhb_supported = true,
 	IWL_DEVICE_BZ,
-	.features = IWL_TX_CSUM_NETIF_FLAGS_BZ | NETIF_F_RXCSUM,
+	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,
 	.num_rbds = IWL_NUM_RBDS_BZ_EHT,
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
index d6243025993ea..604e9cef6baac 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
@@ -151,7 +151,7 @@ const struct iwl_cfg iwl_cfg_sc = {
 	.fw_name_mac = "sc",
 	.uhb_supported = true,
 	IWL_DEVICE_SC,
-	.features = IWL_TX_CSUM_NETIF_FLAGS_BZ | NETIF_F_RXCSUM,
+	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,
 	.num_rbds = IWL_NUM_RBDS_SC_EHT,
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 241a9e3f2a1a7..f45f645ca6485 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -86,10 +86,7 @@ enum iwl_nvm_type {
 #define IWL_DEFAULT_MAX_TX_POWER 22
 #define IWL_TX_CSUM_NETIF_FLAGS (NETIF_F_IPV6_CSUM | NETIF_F_IP_CSUM |\
 				 NETIF_F_TSO | NETIF_F_TSO6)
-#define IWL_TX_CSUM_NETIF_FLAGS_BZ (NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6)
-#define IWL_CSUM_NETIF_FLAGS_MASK (IWL_TX_CSUM_NETIF_FLAGS | \
-				   IWL_TX_CSUM_NETIF_FLAGS_BZ | \
-				   NETIF_F_RXCSUM)
+#define IWL_CSUM_NETIF_FLAGS_MASK (IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM)
 
 /* Antenna presence definitions */
 #define	ANT_NONE	0x0
-- 
2.42.0



