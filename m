Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033691;
	b=sMPwkO1ec/YJCnxUGWhEHiyB5iKs22cWj6+OtcdDgdI6ssAvvB6Q9kAgj07xR3ZmfOSY
	 gQNnCWB6esTMzsNuRwe96NC2LG+c0wlxvCh+5IxD86xbOhnrn9fDo5zmEZjI8pqKmUOS+
	 bYYV+Cwxb94vlwsbmdrA4F4V5K6oa7U4/d6FBqKVRoODqYdgYmd4tISF7L5pUgKUdQ902
	 kpUqC5j7mVK3pMVyu0yGsEmdSEwc1lPFg/eB58Ie5v+crGsP+1FLpDIzn4fBZF2fZMXan
	 G17z2aWhZX1wMVPIMUaKUlObb8EQLfQrHvXVQrHOBQ0KuEq4zFR1wkq1kBPdan2lh1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CfE51z3iEif6iLnfZuR0pM0wj8EhaXgjTgo+/Y86cr4=;
	b=R07XGTQpRKY5hPDun1jsR+ybhClK+SwlFXTPDoySqNK0QkXwMqQxHgA7gILT+/RBF+sM
	 FeW0ms6W0Jho/rOP3jtVXVYInjApCGcnAZFFZAUQhOWONHY6DpGzQuAqh18XgtW8kqWaw
	 n5ZBe/0tHU5AgwgajJHE2XphsnqAanFsdaHEPtoBF9FAqNpcSMUYbrMtDUhRJqZ0lmtdV
	 fJgnDuzHc3T8pd0sWF50XvfZTaEJIWAnwsFb6xnLhKMIHyCSUJgqak92UuqhCyhsZ/NpX
	 Ey8zHROYKFX3C3zTSnqSNXldZ48enq+z4TWQVm4MdSFx8oj/7IfJSK+eqmG6uRYRlEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMIcOrBE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C38606A325;
	Wed, 18 Nov 2026 20:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMIcOrBE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA121F000C4;
	Wed, 18 Nov 2026 20:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033690;
	bh=CfE51z3iEif6iLnfZuR0pM0wj8EhaXgjTgo+/Y86cr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMIcOrBEUedhlgxcBd6g49ed2B6Hy7+IkF+2GY7tzi4EMQRjae4PFQg3RryyU47IQ
	 HbksW33mphNthtfg36TU678uBVRvsqIJOoshc40ONgnpZLsIaqLRzVfK87hF909JOF
	 w3pbyuYDiu3p9hnrtdivwrGq1bFw5yatwMPoJems=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0103/3318] iwlwifi: dvm: add missing cleaup for on error path
Date: Wed, 18 Nov 2026 15:12:05 +0100
Message-ID: <20261118150317.324493161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



