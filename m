Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057256;
	b=pRejDuvsRvMQZhOB/4SB4R5RUB2kBzPQ+AOrTJqw0iR4Mky048rAWcpKHErz+6Kxb8DF
	 /PEGGXvNLJaoE8w2/8fBhL4WKx5dZ2MgHNlerwyaH268JAwSG3aN6Zos4Z8bPNxvKvkgx
	 nDFHKuxKbc4rMJhVH61dAZCEAVtqfDeDtll1lYpLkmdTF1/YyzXRyMoPy6fXdrlTpQ04Q
	 X5gF3EmzA45uJP+4LI/x+oxxU5wqZCPkfe+8Nwx4IkVw7CxXdxZoBycVM+/tCSXx1ucsD
	 i8vKw7WnxuKHEhYHKDz7RWR40+B/mYJnDPND7lcrYcKc2q7ZImlTCe1tqOPvizoK2MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pj0yanhP9jg2rrctX9AAnGQS7oEkE0wtwH+dePJhGKc=;
	b=M2n3FoHL4PLXKJm8f54Ltgo0ypbVKpgeidw0fv2THUMDTnYK52kclQNbcxOjlnX1rhAY
	 aCZJj4EFqXaGzQlpS5HWq6MRtqcRUNzBngOk8N37wBSpefBIA2BL33Hag2HnatLCpuwBS
	 5KNfgn1PtW9NkwHL3FpY8HnrIddtBlaIH+aQdo0nqWfiKV3SEMtCZEtKC6HNIA7rtB5nD
	 3C+NJIACAlvkkFFKOXFDKvTkAgG1lufpKe4Y7KEIb4K7FQ0BMtC7tTAC/vQijWkt3LnNM
	 Igr1knqr4ZDHSDor4XL1YVoWsdbZpV/2ExAN1kG0RCdJnUzmBYrb4qsztuuJzFG326Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axAZx4N3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4889B606A33D;
	Thu, 19 Nov 2026 03:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axAZx4N3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D8D1F000C9;
	Thu, 19 Nov 2026 03:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057256;
	bh=pj0yanhP9jg2rrctX9AAnGQS7oEkE0wtwH+dePJhGKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axAZx4N3+ISid6zfof1vYEQUeM0ZUiJDSPLXQ3KOij4Ke4Ubl8h1q3IYPXmt9z/iI
	 iLuhlsfx20SKYVhB61KFcvaFmQN9+ksF262REkYUSC1MmmhLnpeRyPNhgvvhAAzXUT
	 fAYPdaU5zq3RhLtlM6P6xr8/J+X+mV+PmIUAvyb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0067/1848] iwlwifi: dvm: add missing cleaup for on error path
Date: Wed, 18 Nov 2026 15:35:05 +0100
Message-ID: <20261118145913.935184860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e3962bb523289..c6f248e83c2f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -606,8 +606,10 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
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



