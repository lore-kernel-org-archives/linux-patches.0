Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051067;
	b=uWnD71p63hlxKrV3iDbV3fNOqVFRmjiQP4iYcAN4KdDg+i5vwVK6jgndlUtawyCkvzju
	 45s/OMRruQyulaH9SrnE57p2puHdrNBHnkeAwrazqDnzK8yeoxHD2ZYMR9Fw//B5a9KoA
	 e48ByIeT8/QO06Z/yscsdx8eWkgBI9NM5kTBACgwHiuu8U5zLV43fP+kCtrQxpPuyH3wW
	 XU6CeJhTWjaKu+wOvz6IT7Lf3NDBVANvI5jgsmUcLWNszHvL/mLQbHkZANx9xjrco91SC
	 13kSPyYbgAoVrkFhkmQdBVL7SVjYOeii8UuLjKoGN8fOiTSmb/WhGwncBDPQ9xlgpbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ECfi1BQpNpUCOxg21KuR3lGifVqIOh+8aCmeffvl2n8=;
	b=VIbgAZCvpwRMG1M71/lfYpKNqm1G1DuMjGjFIXdRH8UZrxPS0fpFNdK+Ho+pHMT30G5t
	 lqaZiveF8nGb+L+82dpe14treVwKrIlsYgiP9Q+/SDx8rmhLIKR+eOnO1vu97rrThRS3R
	 YF9odCURFrlpYrBrQl/3wtX9r0nZ6xCKG1g0D55fDFSlzK/jIvnfnI0l+sUqS3XCcKPva
	 dW/8h8c3RGW39Hml9ej8bVfgDV2NyRX4vg0WIjcv5aBfp0d0jz7gZceL9FkmvwZRMz7i4
	 K9r2LmvM4wLo+/GTf7BmH/ArXA6++sJaCxS4xQE99S2GEIUhcuhRrwuqa3y03jVYNLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lkAmWx9D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB1B606A31C;
	Thu, 19 Nov 2026 01:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lkAmWx9D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0481F000C4;
	Thu, 19 Nov 2026 01:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051067;
	bh=ECfi1BQpNpUCOxg21KuR3lGifVqIOh+8aCmeffvl2n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lkAmWx9D9ShKLhVz+8OwIIScEPwfoZwkoMIY9g+q96Dbq6+pU7LWLoVhlS7OA3SKp
	 mxN7RgWLaz0kFg1G7s4MZCTLCrpZaHrzH7m2g+U3EJoD0/AAVirgzJFS2s8hjc5Hop
	 65NHzYqxp/In0Hi8wHWcYyPEI73yKmoa9EkXPOj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0076/2214] iwlwifi: dvm: add missing cleaup for on error path
Date: Wed, 18 Nov 2026 15:29:12 +0100
Message-ID: <20261118150013.015976071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a6999ca75377c..85732448f5622 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -607,8 +607,10 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
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



