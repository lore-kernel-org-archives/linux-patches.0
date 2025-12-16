Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DE134D3B9;
	Tue, 16 Dec 2025 11:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885345; cv=none; b=ZqQIgRxk98okaMAin5aJtHdneSGcJ5n/TbS4fzDF70fDo8BT/oDw0I6RJB3xmzZQjp+SqB258ZStXckc/z7j+vh/oixLP772S89wKtR975aBCwv+hNTPYZfLt8XkeDjyMRZy8fCkrmi11xKg8Jj+2Tx7EB+moM/VjNFmOVkRmwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885345; c=relaxed/simple;
	bh=8kSV2/TkAIYeuPKIF4YKa7MyRezeJBKNuB2R11b/yr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lbmg0Ia5GvTaKYgk5Wd4CVHY3mmHk9Ugw12DR25/VYJJOhRdpovigEG6U9JDvqW9Su37Lrk6beOV2Ezxepk22emjnAsnHENoufm2MfTfDrvbAovv54QNyEuy4mLLfxr0xsP0viRrds4eNoly23/H8Uhlw4X4mTLV76wjfXYypi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGQkhpNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGQkhpNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26FDC4CEF1;
	Tue, 16 Dec 2025 11:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885345;
	bh=8kSV2/TkAIYeuPKIF4YKa7MyRezeJBKNuB2R11b/yr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGQkhpNrm1j99ofef4uCOlrhs2rl5j4NJ7+n0gASrVQzUbd9YvFyU3PjIyeCFXXSK
	 Ma8sMSlc9P8qOo/Siq9fcFykM8GHe9kjUzCYE2s5K8HlKXHuspw4oU0HobU/ZhbvQG
	 5mIEMmsYi0EtJdZFdg5fvBJ5V0wFiGhJfYlnlKJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 112/507] wifi: iwlwifi: mld: add null check for kzalloc() in iwl_mld_send_proto_offload()
Date: Tue, 16 Dec 2025 12:09:13 +0100
Message-ID: <20251216111349.592704902@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 3df28496673bd8009f1cd3a85a63650c96e369f4 ]

Add a missing NULL pointer check after kzalloc() in
iwl_mld_send_proto_offload(). Without this check, a failed
allocation could lead to a NULL dereference.

Fixes: d1e879ec600f9 ("wifi: iwlwifi: add iwlmld sub-driver")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Link: https://patch.msgid.link/20251017041128.1379715-1-liqiang01@kylinos.cn
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index ed0a0f76f1c51..de669e9ae55a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -1632,6 +1632,10 @@ iwl_mld_send_proto_offload(struct iwl_mld *mld,
 	u32 enabled = 0;
 
 	cmd = kzalloc(hcmd.len[0], GFP_KERNEL);
+	if (!cmd) {
+		IWL_DEBUG_WOWLAN(mld, "Failed to allocate proto offload cmd\n");
+		return -ENOMEM;
+	}
 
 #if IS_ENABLED(CONFIG_IPV6)
 	struct iwl_mld_vif *mld_vif = iwl_mld_vif_from_mac80211(vif);
-- 
2.51.0



