Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043086;
	b=ZVwTDnbZj56ygEAREcgFhDfrSNrhyNEkZfbzoUG5Cld7i20wNxa/HfB0NtL+6l7F2Qq6
	 JGYv7GwfjnbcB1iXGy0JQb4I1kT/6KkxfXsL7qwXAK5WhMLBoj7tq4p5MwVL038nwy1XT
	 0/31WDPyz2MxApFrcISMxB7Er7VwGepKqjgHeupf6QBPX2/FGWN3ap7NBhxRaYycz03kW
	 UHxRmOx4TLH4PZm+69bkqmWpXgHPO8dTNuhcUoaX2xbhpJsl1NmIrwax7NcPo66rf17hy
	 RiBewnTKy86Zhf9G94eX/lCRqLWN2dfpbdN6qPH4pFgP58U3AflqV5IQNKXc1RzviSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dg2rgcjiVF7g9IpApbovVEN23E5oupkMyhtYRXvmt6E=;
	b=c5k7Ov2SFVch5r2+UP+66uILrd3l6GA2nxCXrTVolnOhH/PewzvoFQBf87yt3Okafiiv
	 Hh/kp7kXv9XjbXvgYjozCSvVei9eSwbtwH1DjPxhMiuTP2Yp7i5QV2ZJVX1W4rjqjDVVY
	 nn1+r1SLveDgGTZb5C997dSsp8ply1E4OViy4w1xcihbpP7PfIw9+3S4PRw2or+lf6s+A
	 JzoAhCRJbxGEMl8OaOV6bYCGQDU0c5fzlVVshoTIKXMeCzPGWSandtMjHFFjtOz5Z62vH
	 Sw4J/UQOGgEfzsLMIfYZVlncSKT7Di8I0y29fbrU+c8k5SJOyI7d9R075FNORx+GmlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qd5kg2YZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6AD606A31C;
	Wed, 18 Nov 2026 23:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qd5kg2YZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59CE1F000C4;
	Wed, 18 Nov 2026 23:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043086;
	bh=Dg2rgcjiVF7g9IpApbovVEN23E5oupkMyhtYRXvmt6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qd5kg2YZGwLiZFSmi6jED/8OXsHsmxzckxdau3iyIoX6iHuBFsvejn1GSjHE9D/+u
	 Cffe3gFEXRHf4AJhR/hON8mJzUCyKhhMC2smv8cWBugvbW394cHA89/wVLJJ3kForn
	 c61GBOR22E1DBKbm7fz7sqVt0rixA+IoN3odFbh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0085/2857] iwlwifi: dvm: add missing cleaup for on error path
Date: Wed, 18 Nov 2026 15:18:39 +0100
Message-ID: <20261118150204.349010896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index ca1daec641c4f..3541193ddbf7e 100644
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



