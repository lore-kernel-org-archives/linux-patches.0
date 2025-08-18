Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB9C2E228D;
	Mon, 18 Aug 2025 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525394; cv=none; b=YjOpMDDywAq6cElfQxzF0X0MNcq9x+F22dCgj2oI3Umw0P0TbLCs7aXFjP8UP3ffqjE2bWdq9/TpnBUZvfA450Klgbgr5mwWtb6LBZwXj3MUwAo71PVzqgD1NodcRX7Nd1U6iOdnqsF6J34zS3h+Uee5WtKBjtRax7q1w1pa/+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525394; c=relaxed/simple;
	bh=9c2QgFXapHK6grmOXcLMTdx0+G/gwWDgYW9VeUW63yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qd9NDVzX3aenukK79KcxQnETFjqqBqg4RIpXcd7pRc6lJAvwQnOukHKysWGaPZW+MKiiZlyU9sIHlNXKPZg98zMNDykOK02SqXsTHshrfMNKPpj7aIOwMMKcXgm+D4VYvJOwuneLgmGp4NHTBmh3MaiWQjSRpd8SaniYL8hzbSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9xERuex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9xERuex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C307DC4CEEB;
	Mon, 18 Aug 2025 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525394;
	bh=9c2QgFXapHK6grmOXcLMTdx0+G/gwWDgYW9VeUW63yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9xERuexhHZlBMwDG3AhQt3ZoJJYenOyv2Jqz4pLbi+CLKIhRpXpIVN6W/FmI8m4v
	 IHwjQ3wLMcXov8eGuL2QyNQNNstB/kjlqE5SJbnHkaCstAwPDsYyZjipQ7wzdgZOsv
	 waUOgoXIlgYGT8m5wKPZxrMrT7rR48OklClRYeLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 250/570] wifi: iwlwifi: mvm: set gtk id also in older FWs
Date: Mon, 18 Aug 2025 14:43:57 +0200
Message-ID: <20250818124515.453359468@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 507c03198c92..a521da8f1082 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2385,6 +2385,7 @@ static void iwl_mvm_convert_gtk_v2(struct iwl_wowlan_status_data *status,
 
 	status->gtk[0].len = data->key_len;
 	status->gtk[0].flags = data->key_flags;
+	status->gtk[0].id = status->gtk[0].flags & IWL_WOWLAN_GTK_IDX_MASK;
 
 	memcpy(status->gtk[0].key, data->key, sizeof(data->key));
 
@@ -2735,6 +2736,7 @@ iwl_mvm_send_wowlan_get_status(struct iwl_mvm *mvm, u8 sta_id)
 		 * currently used key.
 		 */
 		status->gtk[0].flags = v6->gtk.key_index | BIT(7);
+		status->gtk[0].id = v6->gtk.key_index;
 	} else if (notif_ver == 7) {
 		struct iwl_wowlan_status_v7 *v7 = (void *)cmd.resp_pkt->data;
 
-- 
2.39.5



