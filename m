Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102A53B3C15;
	Tue, 21 Jul 2026 20:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666632; cv=none; b=s1Am3GLLwe5GkvFO0v8ltqVgezG+3rlJSH/wag+lSMmHztGPCvevddq8WexYVNvr2qLJTMaY2ovn0H+KmkMzKwocKjetFeJjRfBVMZ3RMtD2dTwqGUKrc98VrO9u1a3uYAW9dqPwsa2BR+KFC1/3vWfaqtAeqa3JsTFLFu1wwxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666632; c=relaxed/simple;
	bh=pNT6CpAX1iOb3fFuqTRwfhJzxFyagmqlVCNpEpWZLVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSpPxEYATtIY+W2QKAwDhg56aJE0BCBmiZFpLAWCmqVhzCOADNHRBOQudiqkDMnebSaxLlbggdAy1CxFX5YTxgZ34/Wnqxe8duSaWCrehs8GGlUFR3eSoHBxAECRJjqyYo8nlYoE4ZVcUlPyLIBQHbnZiBYIwj8xDrRBLrS11CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz9esg82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz9esg82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765EC1F000E9;
	Tue, 21 Jul 2026 20:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666631;
	bh=AKUsmc4X3fgQ9jf9m0ZGPTCzv6q0v29pKHjcjM8G7JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vz9esg82gOpKR7W0bG9nTPPybVqH1gXpw4BB1XYXg6Yk//JXPWBggWIxYeG6pyeqv
	 qGbWW4IHL8TeGxJAlNa3Lx10SMF//8yki2NPLTiyl7Mhpv6L8vQdF+D0sc3zIzm6v8
	 UH2S0coprSGfZpLhCJCn4+YNua9f9zS74MkiVCgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0756/1266] octeontx2-pf: mcs: Fix mcs resources free on PF shutdown
Date: Tue, 21 Jul 2026 17:19:53 +0200
Message-ID: <20260721152458.784994703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 450d0e90b10393bd9f50c127875a9fdd4cc81c30 ]

On PF shutdown, the current driver free mcs hardware
resources though mcs resources are not allocated to it.
This patch checks the mcs resources status and if resources
are allocated then only sends mailbox message to free them.

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/1781636420-19816-3-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c    | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index b288edd9e22db0..8f07d19819cec8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -1808,11 +1808,16 @@ int cn10k_mcs_init(struct otx2_nic *pfvf)
 
 void cn10k_mcs_free(struct otx2_nic *pfvf)
 {
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+
 	if (!test_bit(CN10K_HW_MACSEC, &pfvf->hw.cap_flag))
 		return;
 
-	cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SECY, 0, true);
-	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SECY, 0, true);
+	if (!list_empty(&cfg->txsc_list)) {
+		cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SECY, 0, true);
+		cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SECY, 0, true);
+	}
+
 	kfree(pfvf->macsec_cfg);
 	pfvf->macsec_cfg = NULL;
 }
-- 
2.53.0



