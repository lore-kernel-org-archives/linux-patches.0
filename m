Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678A520EB;
	Mon, 14 Oct 2024 14:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916272; cv=none; b=MugDa+SZgeJFl+NcHT/9342YUAXRVymWA+/RfygSPmcW9Nr5S7CwhBmWAY44F1CBTFcs3WmpTQcJf9z+IA0iUPxayDi8MTKB6WRFlYZAIYi6zLTF30ltSndBJxHCf1T6z4riAHNkOgBa07MK8Ut7/o0nykvt+21S/rYSbJG9F0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916272; c=relaxed/simple;
	bh=IhYjOJC4XTLrutNnyMv3Uj8NrWC0pNSjYW8Fks6eL9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poPhdvj/AP1Wo23OJvt4Ch+r5JhsKDp7Yg59NnpPMajpQvncFJDHvIbmhTKquR6Rk8MtgV5IU5z54da2+frzo8oa5/wEldaxB0ApiRmJ+/0HobiwBxgjBxjEHXd4pUt4f5HyVK3WoM9ZQ0/KjB0iiTNVSQ0EEqF2uuRIb1zHsaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJ2I+lM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJ2I+lM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F79C4CEC3;
	Mon, 14 Oct 2024 14:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916272;
	bh=IhYjOJC4XTLrutNnyMv3Uj8NrWC0pNSjYW8Fks6eL9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJ2I+lM1XI9CovkwnLXw14f4Zgz4kB3X9uWB2t2btF5MZ9N4pQ5YJQOPBTFz1M+xt
	 DPheHi8n6XdIXQl2K1hqVM3KF6rsXGEyUEJURhlOi/HIuou0Q0Bvx77oA41UbReHHu
	 lBlq0YAFGk1kxNaZ0PQ7/SFrzY5m0WZtPMWYElHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 126/214] e1000e: change I219 (19) devices to ADP
Date: Mon, 14 Oct 2024 16:19:49 +0200
Message-ID: <20241014141049.909710627@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

[ Upstream commit 9d9e5347b035412daa844f884b94a05bac94f864 ]

Sporadic issues, such as PHY access loss, have been observed on I219 (19)
devices. It was found that these devices have hardware more closely
related to ADP than MTP and the issues were caused by taking MTP-specific
flows.

Change the MAC and board types of these devices from MTP to ADP to
correctly reflect the LAN hardware, and flows, of these devices.

Fixes: db2d737d63c5 ("e1000e: Separate MTP board type from ADP")
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/hw.h     | 4 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index 4b6e7536170ab..fc8ed38aa0955 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -108,8 +108,8 @@ struct e1000_hw;
 #define E1000_DEV_ID_PCH_RPL_I219_V22		0x0DC8
 #define E1000_DEV_ID_PCH_MTP_I219_LM18		0x550A
 #define E1000_DEV_ID_PCH_MTP_I219_V18		0x550B
-#define E1000_DEV_ID_PCH_MTP_I219_LM19		0x550C
-#define E1000_DEV_ID_PCH_MTP_I219_V19		0x550D
+#define E1000_DEV_ID_PCH_ADP_I219_LM19		0x550C
+#define E1000_DEV_ID_PCH_ADP_I219_V19		0x550D
 #define E1000_DEV_ID_PCH_LNP_I219_LM20		0x550E
 #define E1000_DEV_ID_PCH_LNP_I219_V20		0x550F
 #define E1000_DEV_ID_PCH_LNP_I219_LM21		0x5510
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index f103249b12fac..07e9033463582 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7899,10 +7899,10 @@ static const struct pci_device_id e1000_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V17), board_pch_adp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM22), board_pch_adp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V22), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM19), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V19), board_pch_adp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM18), board_pch_mtp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V18), board_pch_mtp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM19), board_pch_mtp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V19), board_pch_mtp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM20), board_pch_mtp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V20), board_pch_mtp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM21), board_pch_mtp },
-- 
2.43.0



