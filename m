Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA66012DDA1;
	Mon, 18 Aug 2025 13:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522039; cv=none; b=VwOCHiVCLDr0WdZXAFobbWTFLVl0KNEip3GW/Ge5rSt0Clwr1PoYYdnspe56qTbcVZs0kwT+oWrvdn6KZMyno34qGjKmxv/VQ84j4iPuR02nAJZXuv5djcrO3OzL6y/27F1GwlWEh1dy9X4o8LWMCjCWtQpavAl4XCTw3cNyCy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522039; c=relaxed/simple;
	bh=WTTEFXX+6FN/45qpm/Jus6G8yL1wbqj0yQouDG1V86o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMKfD0TT8XyKIreNimv4DDd2RQSAOjO0UFr9ve5yOSvFVADXuhiqPaBY/v8KbYurSxcHmr6WH8SxqrCXZsfl0l//lJ1Igh7Vdx2xBkR65v0fRtsUCmwXpZafBn6nkcPTSkN87FNYd1gSyE6V6SUk5ZAVz+qRHDXyP9UrVbfZai8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7qykB8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7qykB8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD1CC4CEEB;
	Mon, 18 Aug 2025 13:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522039;
	bh=WTTEFXX+6FN/45qpm/Jus6G8yL1wbqj0yQouDG1V86o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7qykB8k4xqrWER/HJ7no6tf9rVvkVVFSWiJSBK5XMkvodgPjU6WuCrbZqIX3MQ8G
	 FFMGcEVTMfXD4Rxbf1odybcCG8EtgrLsEw7AZirXCu2wQEV+q6pQ4JnQS4BOwe6MNw
	 MMhYTXWXYC2N8BY0Ij+fghvi/frvK9fXgc48/2kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/444] wifi: iwlwifi: mvm: set gtk id also in older FWs
Date: Mon, 18 Aug 2025 14:43:43 +0200
Message-ID: <20250818124456.253772306@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 61be9803f322ab46f31ba944c6ef7de195891f64 ]

We use gtk[i].id, but it is not even set in older FW APIs
(iwl_wowlan_status_v6 and iwl_wowlan_status_v7).
Set it also in older FWs.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250710212632.e91e49590414.I27d2fdbed1c54aee59929fa11ec169f07e159406@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 6a4300c01d41..7e258dcdf501 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2375,6 +2375,7 @@ static void iwl_mvm_convert_gtk_v2(struct iwl_wowlan_status_data *status,
 
 	status->gtk[0].len = data->key_len;
 	status->gtk[0].flags = data->key_flags;
+	status->gtk[0].id = status->gtk[0].flags & IWL_WOWLAN_GTK_IDX_MASK;
 
 	memcpy(status->gtk[0].key, data->key, sizeof(data->key));
 
@@ -2686,6 +2687,7 @@ iwl_mvm_send_wowlan_get_status(struct iwl_mvm *mvm, u8 sta_id)
 		 * currently used key.
 		 */
 		status->gtk[0].flags = v6->gtk.key_index | BIT(7);
+		status->gtk[0].id = v6->gtk.key_index;
 	} else if (notif_ver == 7) {
 		struct iwl_wowlan_status_v7 *v7 = (void *)cmd.resp_pkt->data;
 
-- 
2.39.5



