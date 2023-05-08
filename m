Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03A3168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2429FC433D2;
	Mon,  8 May 2023 10:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540332;
	bh=oC8/QsNoyKVfJ8I1WKXuwfGA8uk6LMoz7H2eIFCfyjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGocS6SP4Jb4QH+SYUhNT0GRoYaULRdDp/VHwvPxqfuyPrbFiJlDCJkIHwD87KJ8N
	 nP8C1bc7PRcZ6rz8ibkezryhdQpsgPxE2hTmYlZg0ZZsOAlsvF+VAGoADjfvK0IhLi
	 KiRrjjmL2EsdLg0dzDYNW5dngd2cK8TRZXNG9IpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 325/611] wifi: iwlwifi: fix duplicate entry in iwl_dev_info_table
Date: Mon,  8 May 2023 11:42:47 +0200
Message-Id: <20230508094432.997750974@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gregory Greenman <gregory.greenman@intel.com>

[ Upstream commit fc3c2f0ed86b65dff4b6844c59c597b977cae533 ]

There're two identical entries for ax1650 device in
iwl_dev_info_table. Remove one of the duplicate entries.

Fixes: 953e66a7238b ("iwlwifi: add new ax1650 killer device")
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230410140721.897683-2-gregory.greenman@intel.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 4f699862e7f73..85fadd1ef1ff3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -565,7 +565,6 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x43F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0, iwl_ax201_killer_1650i_name),
 	IWL_DEV_INFO(0x43F0, 0x2074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x43F0, 0x4070, iwl_ax201_cfg_qu_hr, NULL),
-	IWL_DEV_INFO(0x43F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0, iwl_ax201_killer_1650s_name),
 	IWL_DEV_INFO(0xA0F0, 0x0070, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x0074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x0078, iwl_ax201_cfg_qu_hr, NULL),
-- 
2.39.2



