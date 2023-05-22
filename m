Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FF0171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9FFC433EF;
	Mon, 22 May 2023 19:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784550;
	bh=7pw2k/aoWz/sDA7md6M0mJsM5pAkVuOBZaveA7L2DI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jA1gosTzDR1+CVZpumi19a1f+A493m3LVFxVgbre0BksA5EVumv/YObGgfwS+6NBT
	 Y0hPAYLpfTzj0IXVQRQvm4WEsGsQoxuRVUOYPuDlmr6jgROy+xUJgT3uv9ekUFH0Pk
	 ddGj/SRLaEJen4gAVHhufBGFzvjHMqrj4OhSTJe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 121/364] wifi: iwlwifi: add a new PCI device ID for BZ device
Date: Mon, 22 May 2023 20:07:06 +0100
Message-Id: <20230522190415.820035841@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

[ Upstream commit c30a2a64788b3d617a9c5d96adb76c68b0862e5f ]

Add support for a new PCI device ID 0x272b once registering with PCIe.

Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230414130637.56342664110d.I5aa6f2858fdcf69fdea4f1a873115a48bd43764e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index f83ae0d301d0e..25b2d41de4c1d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -504,6 +504,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 
 /* Bz devices */
 	{IWL_PCI_DEVICE(0x2727, PCI_ANY_ID, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0x272b, PCI_ANY_ID, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0xA840, PCI_ANY_ID, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0x7740, PCI_ANY_ID, iwl_bz_trans_cfg)},
 #endif /* CONFIG_IWLMVM */
-- 
2.39.2



