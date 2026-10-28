Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216734;
	b=TNY4lR/YiC6Uz/ODB0nunz/NaBPfOWmvzyHWs0UVOImsFMFDjETkOdyO5wCKL1wsaNtL
	 oDkh5R5KTS6g8mGbEKftN2QP0Juc4X49OO9T4mYdVEfOXK5CYAnO07WvxMxH/hWJ7dLCn
	 ufZMWe6ycnOre9bJ51dwdhpXlOqmXY6hhHqKCj0+us3iAhqweaMYQt22QyFXIkPWpc142
	 5e/utiQpEnVzwsJVcJG/WhlvtHKBBke8IlgI+GZF2yH1Crf21jp7d0Amc1D3fr/AJpuA+
	 P6QLRWl87MfkY6K45Jfr45arrTUyv5wpGbsckSvyf9sal+9s8MmWXvWiMP9t7VhRqXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f03uranNGPUdd+i61cJiURgzINNpoFVENZw6IboIbvQ=;
	b=vgzhcPDeEtHZlhVampYrcLrkn3UGo/Fu9rTlb6n5t6eW/LpeZkam1IpCOP6q3SGIpJI+
	 sp+FQ2Wha+rBBeWB40pYL8khyYK5cgjSTwCBGeSVbyNeuyI/43v/lyf2EPoMDluk4GqAs
	 B1pvxhnHMilFY57bXF587zMvP5XrD88pQ+ZvaYNI+SdVXq4yJgrVId0QzbaAlZRH2Went
	 fTBMiTdLEiT1L3Eejpv8omBuhu0fIlUz4TqEhA+HILy9oSNGprq7jjf9zBsyB1hkkqjMB
	 g9zEKw1RFL1NOojKLM4m2BZgJ6zxa0P7O3gFMDA33daJVmlPLuCvXVWCilkhvIpC4Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=szH2AbB0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5C8606A31A;
	Wed, 28 Oct 2026 19:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=szH2AbB0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD231F01825;
	Wed, 28 Oct 2026 19:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216734;
	bh=f03uranNGPUdd+i61cJiURgzINNpoFVENZw6IboIbvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=szH2AbB0kuLmY8KcbuvrMQuQTNEZzNuSSa3WzoDSygMK75eTrAtfBtzjAPB/CMgLr
	 sXRXqEtcw+wLVzEQ5YCSwmMfpzInpBtqtYcZQkjGw5xbM8IgE1KzfZL50fHF8dLYfq
	 bdElqZWhGWmPF2V0OEcbuKubMYo9hu4XhEaFJawo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1661/1887] wifi: iwlwifi: pcie: null RX pointers after free
Date: Wed, 28 Oct 2026 18:02:37 +0100
Message-ID: <20261028170537.257494785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 2c79d7a7b583050c9f58041465cb46fe3483ab5d ]

When iwl_pcie_tx_init() fails after RX init, nic init unwinds via
iwl_pcie_rx_free().

The freed RX members stayed non-NULL on the live transport object,
so later teardown or retry could touch stale RX state.
Set rx_pool, global_table, rxq, and alloc_page to NULL after free
to make repeated cleanup and retry paths safe.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.33e8978d8b36.Ibaedd4b0ce01405b940de7b90223b6d2c5136ffd@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 91b73e7a41134..d4b57fe25eb15 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2003-2014, 2018-2023 Intel Corporation
+ * Copyright (C) 2003-2014, 2018-2023, 2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -1232,11 +1232,16 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 		}
 	}
 	kfree(trans_pcie->rx_pool);
+	trans_pcie->rx_pool = NULL;
 	kfree(trans_pcie->global_table);
+	trans_pcie->global_table = NULL;
 	kfree(trans_pcie->rxq);
+	trans_pcie->rxq = NULL;
 
-	if (trans_pcie->alloc_page)
+	if (trans_pcie->alloc_page) {
 		__free_pages(trans_pcie->alloc_page, trans_pcie->rx_page_order);
+		trans_pcie->alloc_page = NULL;
+	}
 }
 
 static void iwl_pcie_rx_move_to_allocator(struct iwl_rxq *rxq,
-- 
2.53.0



