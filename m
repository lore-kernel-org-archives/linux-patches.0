Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD08FFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEDEC433D2;
	Mon, 15 May 2023 17:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171162;
	bh=27g2vgxqINtT8uuTeQ1y7pu9Ae+rFAVsj5M8tcoNWSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiSqxGLEyjnvc89S+RURNnT4ib7REr/gO1YULVZWaU97F+hSpQ/qjKd3viH6Xc1/X
	 sNiFhQGnU8J9o2pxUxc+fDyDiCwMjquD8y0x9EsBGCfsVc1z6ZQA7OY/pQx26AWsgf
	 pr+z0F8R7rXLU8KW6C746afosbqgSaTOQEqTRz2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 121/242] wifi: iwlwifi: mvm: fix potential memory leak
Date: Mon, 15 May 2023 18:27:27 +0200
Message-Id: <20230515161725.536651964@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 457d7fb03e6c3d73fbb509bd85fc4b02d1ab405e ]

If we do get multiple notifications from firmware, then
we might have allocated 'notif', but don't free it. Fix
that by checking for duplicates before allocation.

Fixes: 4da46a06d443 ("wifi: iwlwifi: mvm: Add support for wowlan info notification")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230418122405.116758321cc4.I8bdbcbb38c89ac637eaa20dda58fa9165b25893a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 29f75948ab00c..fe2de813fbf49 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2715,6 +2715,7 @@ static bool iwl_mvm_wait_d3_notif(struct iwl_notif_wait_data *notif_wait,
 			break;
 		}
 
+
 		d3_data->notif_received |= IWL_D3_NOTIF_WOWLAN_INFO;
 		len = iwl_rx_packet_payload_len(pkt);
 		iwl_mvm_parse_wowlan_info_notif(mvm, notif, d3_data->status,
-- 
2.39.2



