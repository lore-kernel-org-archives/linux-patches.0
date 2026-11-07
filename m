Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060747;
	b=4o9OxqhJl3/oOySCt8l1pKrQVqd24cVJlR12t2AeEdhipr9siXnxw79392NMO96DCroU
	 86h0W5XQMcRxlZPqoXtOk6k+qOtBCuamXJdDfAKbb6dZclktvicqQhLauVwhaNwe2YFzx
	 Zy3Pr2tbyTZAHkybJBT+i+Npoi2w6zZEZ3eYr9tUEJXpYoyfQB120n4o5u11UshKJJ/cs
	 hSZqO8XAetTBULqoVB62HiTmSymS9VpvrzihAx0zuK+HteYBeYchLL8Owm5iFsA+y3bCT
	 jHjyIpmbAia4ap7BQ81mr4V9E7rah3B/3rHJdZJMh2bxs8N51mhcI9murT33dpGfxeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bb6brkvYDhdh8zl/MsncO+9PRwby1gd33W5kSGrr7dc=;
	b=qHLb7JYzmtOBlMRgEW8yOg8hsUrEy7Ju0b82hfuXXZQ5TNYIpNFv+7zCmaBHTMhiofWP
	 Ivo823VqxwddZFnfNNajtp05YgiLkSdaYxnmR7lh94uqufwySmBPuArklpXiQH5zeWINm
	 ZRIFy7ngzcQ6etl1hwqN5/692Xog+P2u+B7foP73dLqSraTT56QKWBG6RkPoh5NLXusou
	 sNuscm/1jpTp/nL4YPARPY7gOszG4+xw4fnjLGGyKK1vvO58a7MvbUQMRMI1VUYnqlAg2
	 y89lLdKRgosvmUqH2syuF2hmkvYRoUFVexO1Qz/0hJ9nXDQEwjjZ3qviErWhCV09SRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWw86A4C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFB2606A32D;
	Sat,  7 Nov 2026 14:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWw86A4C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A795E1F0089F;
	Sat,  7 Nov 2026 14:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060746;
	bh=Bb6brkvYDhdh8zl/MsncO+9PRwby1gd33W5kSGrr7dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWw86A4Co3yWt6LiBrMEOG2AbZTUmXXJcmdmJPfvuTWEkZXOEbn+tfHoaS6cJ0bMS
	 esC5BiqukugTyG6T/glvIqG9+2nASxwrqWZ4cLCrcWPoscxnJazhqsyG4fwbzaTTNu
	 Aq8bF7lkbbGWnkXTUh6k6qo0z3UwundEhlm5A01E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0125/1536] iwlwifi: dvm: add missing cleaup for on error path
Date: Sat,  7 Nov 2026 08:35:41 -0500
Message-ID: <20261107135001.199430793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 94280e6e0c69a5327e377803732f494d8b5a74cd ]

In iwlagn_tx_agg_start(), call iwlagn_dealloc_agg_txq()
to clear bit on error path.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20260401030555.541685-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
index 111ed1873006e..474d9187bbc43 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -602,8 +602,10 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	}
 
 	ret = iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
-	if (ret)
+	if (ret) {
+		iwlagn_dealloc_agg_txq(priv, txq_id);
 		return ret;
+	}
 
 	spin_lock_bh(&priv->sta_lock);
 	tid_data = &priv->tid_data[sta_id][tid];
-- 
2.53.0



