Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829470;
	b=pA5kO84icNDsgxuHQAoolssysxsZ/U3avpotms2foVGLgq7WN9S/TouFKemOi5xMLgaU
	 RZGkjSqsmEnJt+wjv/Y8Fzh7OxOQ6GZdRdY1V96mfGDRaYEHJ9YYUZ0od3l7qT7tMdWmo
	 Z8cLWbXd7yIy+S0qawl2WSw1XZ2/HDJPrdzBrNbM0MRuUZKxGtd9zoHZYe7C0bGPVsjKw
	 4SmYPqxRQS8EK/jOLsNORYT/g0gZkSMcFwKcuXAXyIzpp1O4VbgnEAvLsKRWU3n/CqP3V
	 3+6ovj6uVRwEWJfVd0FVn0NkCncxLbd1xTQrLnBD5olvi/k0QZU0rQn+PaojpevDPxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S/YwBV2YdKgv7s7xuHExuGGH6xAXf0IwCdW5wheZM3g=;
	b=pvCsi4Rf2vND4Vqixn4f4AnRp74VymvgRjoy3IWltlNdnzondSiY9pOHjpKytYgh14sb
	 BP4o8VaRCXgoEJTguh39SYGbrorbA+xcnWSaI4u4andNv08MgZsyXBv1IwUE4pWfzWpXd
	 S7a420NXi6xDdYzWRPEJlvdqm6knhhuMc7FUJYvm238drIUcMEMgJtPClNHsygV1EIxI6
	 qlUbgpmkkSmkdHX1oK4m8mbM4tdHs2rxmCp0fjH042bCfd3BBsmRqSVm263zHh+IEqdQP
	 8Rj23YeesKrb+El7KtuuUozNmLibI6PugLWZU6fXAtoOFPZ+0Q8Q5e8Zf0ZghdIiS/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dLiDpRUC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE6E606AB0B;
	Wed,  4 Nov 2026 21:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dLiDpRUC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15841F00A16;
	Wed,  4 Nov 2026 21:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829470;
	bh=S/YwBV2YdKgv7s7xuHExuGGH6xAXf0IwCdW5wheZM3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLiDpRUCyts+1gBMmMf3UJJ5QqAhXR+LMqDlP80ob0ZoGC0a93amihs63IaS40ywd
	 a/khSosu69nN90WJ/UVPBJMyBuBRT/JF9rGT50o1QSuPW1ZxAkz0Ll71YF3ZoTTcQe
	 6PePFS3Cr5bfwexL8AZZrEKUNJeKSAVQEbH8QbvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0146/1005] iwlwifi: dvm: add missing cleaup for on error path
Date: Wed,  4 Nov 2026 15:57:59 -0500
Message-ID: <20261104211047.797572829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a7806776a51eb..1a0167f67c7bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -604,8 +604,10 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
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



