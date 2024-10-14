Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FF41AD403;
	Mon, 14 Oct 2024 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917183; cv=none; b=KLZQpep495L6lqFnAJAXMprOR3errbHBpy+ASbmAG3Vfz4Cfo4OaKK9089+wKkbXNDz6rOtBiyeLyCjlhIAjRArDpKpcRwRpkEUiLXWE0RG0zFiyEKQgHV9bqctWng1xkCgrKmHjsDnzNHMXx8zJWNcHuxd9fcSkZ2EmZyEefEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917183; c=relaxed/simple;
	bh=7m9XTEUqMixPLbua399Mcgcycm50vt1HV4MZZ7Gn0ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcOzLdwAVkdnz++YHPwDHhH6kA6uqK2oenh8TybbWqAO5OE8l+QwOOUhp0GFQcwSEFWbQSW3ry7bBBs4LmwI4THF3qo768Zk9LdFQVaGI9rceHhi5DemgJ1T7kJu8RlAY/nUEAlfY7loYPK/XvR1Kp1SlR3DZo5cIKw6/L5fgKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzWecQ/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzWecQ/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC538C4CEC3;
	Mon, 14 Oct 2024 14:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917183;
	bh=7m9XTEUqMixPLbua399Mcgcycm50vt1HV4MZZ7Gn0ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzWecQ/tNQFN/FAT8aXMFi+1Z55B5Nh3lICCgjSKyk1ppvWC5AOFbOwduSA1KqwX8
	 anBbMyxyNNLI5FjZBNWH5O5R5iPIpMdwQjH4lenw3vnnRCnZT1nqdMVMXzHq2Vty2u
	 2uamCB1evFfTPPUC8d1zViU5zzsXXHXGoSQZ/N3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/213] e1000e: change I219 (19) devices to ADP
Date: Mon, 14 Oct 2024 16:20:50 +0200
Message-ID: <20241014141048.586921304@linuxfoundation.org>
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
index 06d109063c8d8..721c098f2bb1b 100644
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



