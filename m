Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BED42E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97869C433C8;
	Wed, 20 Sep 2023 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211817;
	bh=rjyEXmzBHzrlOdyaV9VlkgNNFUlZRT2zJepPQSHUt1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bM5gIWpA1zi8onoXZzIPOoUMrJgWn8ckUiT1alpYsoZ5f1w5qhc1UcTJE/SmQJEXa
	 eF8dS0FyJW0aOUqgvZJkqJslC03Mv3BGjycdmK+eQZ10p/sogl9ZI4TSTHcEHq6Me4
	 LaCI3KFrCmIX6ET96cY9qJZbt7XxUZez51EEcGSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 047/273] netfilter: nf_tables: missing NFT_TRANS_PREPARE_ERROR in flowtable deactivatation
Date: Wed, 20 Sep 2023 13:28:07 +0200
Message-ID: <20230920112847.872366034@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 26b5a5712eb85e253724e56a54c17f8519bd8e4e upstream.

Missing NFT_TRANS_PREPARE_ERROR in 1df28fde1270 ("netfilter: nf_tables: add
NFT_TRANS_PREPARE_ERROR to deal with bound set/chain") in 4.19.

Fixes: 1df28fde1270 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain") in 4.19
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5555,6 +5555,7 @@ void nf_tables_deactivate_flowtable(cons
 				    enum nft_trans_phase phase)
 {
 	switch (phase) {
+	case NFT_TRANS_PREPARE_ERROR:
 	case NFT_TRANS_PREPARE:
 	case NFT_TRANS_ABORT:
 	case NFT_TRANS_RELEASE:


