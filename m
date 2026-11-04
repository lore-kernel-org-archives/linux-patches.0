Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829556;
	b=fe8+WwIrP2ZwczA27f/1Tcm23l2gLZ4B4SDsE0vPRr75kvSnnRu8uHV6y2+uqS4HO75k
	 GSCB6j/dk+V3jm9BzB4VL5eF6yhWrYBDvIQjvGYjaILUdtW2V5FWmn7DzfjSTZtggPRMs
	 brCfR0nj2y2GJ9xSjdYRhjzeAbYHl2QJnSy70l3qqLxs1GuwhbFLijKkR5Y1D3mD80HBP
	 45Xr+lzs5cryRYpQW4ApbHvwY/zoTxQvvc3SPWoL8mSe64T8js94suO1FwVkw7Si+6527
	 jgaBfgvyJRihWh+U4bH170ln3vDBn8yXjxzUj4JSr/RWj9po2LQvR0WcEiZ3gdPpHgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9hsIm7y8Qvq6DWYvd/ud2QgRkzJ0BAiuomCVEu2VKrw=;
	b=UAiuG0HQqpyzWRxj3qVG/E6GbaGWrPzRsJ+tmvrKN3rBzibDVfCdiqd8abZCN2mI6J8i
	 XfBJHjpmpTQAhMiKeTsfggudlzdhiXpDubneuMxrteDmBDe8w/AkboLKwWAue4AFzXg8p
	 YQId4L+uL2EOrmT2PbUAq8NDaMNlqhRt174DNB0sFt/VAhxVxYqy91sgkCGu5sCVlJWDJ
	 4ikn1wMRsPX6mRkyCUysVs/bfGIF2g+jkMazwIca9ft7pFLkx30carICqwCJQlNLF6WhO
	 NcUCdwd4Yy1lOcVfKnexJ2xRbCTiKtFftAkl36KM+kSUjLCfD7ZPTaW+5i1TQuRQNqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1eypbzdO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE7F606B385;
	Wed,  4 Nov 2026 21:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1eypbzdO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CF91F000C1;
	Wed,  4 Nov 2026 21:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829555;
	bh=9hsIm7y8Qvq6DWYvd/ud2QgRkzJ0BAiuomCVEu2VKrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1eypbzdO9CLwzQPMyQkL46yNyKTmCTD+v4MCboaPwXo/cbD9MlkyzrxzKtfeQGD51
	 LgsJYOwYZWWmWdHxGn/hnhEF28X0M/3j3qXAJ0pZDQzv7392s0Tk9P9CEo76pDedkc
	 Omv/nW9m9VcOg277gkYogNo3CDja+Xk0k3TDy6Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0200/1005] wifi: iwlwifi: mld: drop connection on D3 resume failure
Date: Wed,  4 Nov 2026 15:58:53 -0500
Message-ID: <20261104211049.397082326@linuxfoundation.org>
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

From: Ayala Beker <ayala.beker@intel.com>

[ Upstream commit 4f5384b58b483e4aec576ce461dec45b41df18db ]

When FW crashes on D3 exit, iwl_mld_nic_error() sets
STATUS_RESET_PENDING and queues restart wk, but mac80211's resume
callback synchronously calls iwl_trans_stop_device() which clears
the flag. As a result restart wk skips sw_reset, and the FW error
recovery buffer is never read.

The new FW boots with empty BA state and initial sequence numbers,
while the AP still holds its A-MPDU RX reorder window.
This causes MPDUs to be dropped as IWL_RX_MPDU_REORDER_BA_OLD_SN until
ADDBA is renegotiated.

We don't know how long the firmware has been in an error state
or whether the AP still considers us associated, so keeping the
connection alive is not worth it.
Call ieee80211_resume_disconnect() when iwl_mld_wait_d3_notif() fails,
and let userspace reassociate.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260717172958.3e10c8498f53.Icf5644b42d79e984ecc16abfa873bd37f611e778@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index b75936125b46d..69d8afda9fcd9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -2077,6 +2077,9 @@ int iwl_mld_wowlan_resume(struct iwl_mld *mld)
 	ret = iwl_mld_wait_d3_notif(mld, &resume_data, true);
 	if (ret) {
 		IWL_ERR(mld, "Couldn't get the d3 notifs %d\n", ret);
+
+		if (bss_vif->cfg.assoc)
+			ieee80211_resume_disconnect(bss_vif);
 		goto err;
 	}
 
-- 
2.53.0



