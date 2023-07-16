Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DC88F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA03C433C7;
	Sun, 16 Jul 2023 20:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537633;
	bh=J5Bzcrh6i5IMS2a+emzyTRQYnG4sHVRJCtVem2QY/34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJ5A4PBNwiB6DqOhpu8pVNXzkiWuQRp0eQ3EHK6ZAVuoQBzF41a25fTaNvvwk4SxX
	 5n0erYzvWs5uo6laSWML0g0hVFIOi+KV+gp7WdlxRdlp4euyGnNKxhTn5hLQOC0KJd
	 fvwv05FJixI+eu0zvLcCPlupILLjj8V74ooa6iqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 165/800] wifi: iwlwifi: mvm: Handle return value for iwl_mvm_sta_init
Date: Sun, 16 Jul 2023 21:40:18 +0200
Message-ID: <20230716194952.941928083@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit 8d507812cb4bb3c3b05404a7dda70b32a1fc1324 ]

sta_init function can fail and if it returns an error then
driver should not send the request to fw to add a station.

Fixes: 69aef848052b ("wifi: iwlwifi: mvm: refactor iwl_mvm_add_sta(), iwl_mvm_rm_sta()")
Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230612184434.1ecd293539e8.I5ec6aab387bb2fe743a7402581beaeb9c801d31f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 05a54a69c1357..b85e363544f8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1859,6 +1859,8 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 
 	ret = iwl_mvm_sta_init(mvm, vif, sta, sta_id,
 			       sta->tdls ? IWL_STA_TDLS_LINK : IWL_STA_LINK);
+	if (ret)
+		goto err;
 
 update_fw:
 	ret = iwl_mvm_sta_send_to_fw(mvm, sta, sta_update, sta_flags);
-- 
2.39.2



