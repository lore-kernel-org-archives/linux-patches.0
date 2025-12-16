Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED5232824A;
	Tue, 16 Dec 2025 12:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887233; cv=none; b=hp/lZvcHsUfpIcYzRwN3rDv3Zme5xgv2gQ+jdzbcDaZY3Z08LowziXd9OHEepPBaML7lslnbU5wLJbvWjgc5MtBFu/gw9d6rG/EtGYnZi/BGB46Iod9lNPH5j+vqs5rRtaEL18rNcBchVpRfZ0VI7N9G4KBfOS0FoZJlIjnCQZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887233; c=relaxed/simple;
	bh=g4D1c6jPxrQSGLmsYL1mD6Ovw/k4n4z+w4gfIGz28c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSOyX6dMAYu1WpSRXfGxbtKBeKhbEi1qE8ScnyLW1NKgixDcFtGUiY7jvJ9tX7OqLgL78+aWkg9+ExJpvDOlt5MZMaDIAQw/ufSP17eJxTQ5WKlWf1VCCypsMf3Lkj9rc7q7N3zUI9NV3HlagQUoMmMnYO2dSDns1jhualTPDh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptdRRgpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptdRRgpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F47C4CEF1;
	Tue, 16 Dec 2025 12:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887233;
	bh=g4D1c6jPxrQSGLmsYL1mD6Ovw/k4n4z+w4gfIGz28c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptdRRgpzRZjeTVTt8mchvjSRKCCT+nIRkOCKDo8H5N9OUHI+pCGdHUOpYcu5T2Hdh
	 +jzUimwdEdjdTcw6zx6g78wJgsjXJppJIpFpEl8vAvzZNefJLtTSAdnf8ck2npxdxA
	 VxhB//OzT1Cb1+5HFyT8klKLQQ06ACoQVEJC25r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/614] wifi: iwlwifi: mld: add null check for kzalloc() in iwl_mld_send_proto_offload()
Date: Tue, 16 Dec 2025 12:08:22 +0100
Message-ID: <20251216111406.226840175@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1d4282a21f09e..dd85be94433cc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -1794,6 +1794,10 @@ iwl_mld_send_proto_offload(struct iwl_mld *mld,
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



