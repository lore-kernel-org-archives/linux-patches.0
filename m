Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216720;
	b=RfoAOVvO+D5ppU2wOC2hjAlKp0vi2BS9vM6nHZK9oBlCFc281lo5lQIxIay9PGWKeexJ
	 MJ2+d7/+TyxnKz/L8Pvd+xyj3GIJy/LGtrMSbfom+qtgIDvdTZAsLwAkVxA3Ld8Auev2W
	 OyqTh7iA6AsbTdCd6UDH4asFOlP28Sk8zjSnm8zLRRxwswfoQdiSIEUIJH8D17/e82rAI
	 IryBQk3RD0PkIwri3mBgFp396fgJZUhz8PY2yC6Xqv9R+FBNfIW4pmQrCqBc2K2sW55j6
	 qZ0Rsm8PKcRVl+5WtLhu7Am6pe0JRVovWVlTBgNN+fQuZdJ4t4DvdTPobHfaWTB3ajA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b1omBQO2m1qRFOPN7glVlkEuzYqP00OhMfACoqxiB+Q=;
	b=l7Te66/k41k6raxbwKIeVP+Xlkcqg8SfnpjC/t4UN8TRtNDNpqlhKj87KcFnmrxlR0+N
	 JWiXkoAVGA4EEXIRMxQKyryTxx6VFMGzs4n1I7Mcbc5TVrUlp+IdJnXMbNp/3uOBh05iB
	 RGqPnBehq2deiTZshWlGmVcceKXm4wR+JCAztLZwgY84GvtAu1MxrCMTFe8nQhM/HAEkO
	 M5oe1WHRkxfHPmLnzDNgHdxP2Uw3OX7PBZQq+ArFDo3Yiu4eTKx/c+4IVzNDuXEjRN7ie
	 KfG+iikMPKRHBl7fp7D1l0zD7UfqmCzp2uW7ocLFzZ0VVfRWUlsyMiyc0eQ9TqnZrPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NOuh8kOW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF4F606A31D;
	Wed, 28 Oct 2026 19:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NOuh8kOW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B6D1F01825;
	Wed, 28 Oct 2026 19:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216719;
	bh=b1omBQO2m1qRFOPN7glVlkEuzYqP00OhMfACoqxiB+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NOuh8kOW5MfFuEFVweadMsv/gNEWHXULvtXsroH4sLbUWldSC4w3PTp4Q8ueUz2a4
	 LaJRypeEHJd7STtD2Dq6i/p5+2xfvb1zO84NjMpQryQC57H/8yytMyDfVCmbrD6D7K
	 n5B3RHZTb5MDQioemGvUOyD4JyAEUFr2s+bXdJsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1656/1887] wifi: iwlwifi: mvm: fix out-of-bounds tid_data access in BA notif
Date: Wed, 28 Oct 2026 18:02:32 +0100
Message-ID: <20261028170537.143652798@linuxfoundation.org>
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

[ Upstream commit 94d3982806c7f194b23484befde12934dda23064 ]

mvmsta->tid_data was indexed by the TFD loop counter 'i' instead of
the actual TID value 'tid'. This writes lq_color into a random tid_data
slot unrelated to the BA entry.
Since multi-TID blockack is not really in use, 'i' was always 0 and no
harm was done.
Add a out-of-bound check before accessing the array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.919edee567eb.Ie85c350e3afe2b39709d0039072740d86660f8ae@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 43a732b0c1683..d04fa56e645e7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2094,8 +2094,14 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 			if (tid == IWL_MGMT_TID)
 				tid = IWL_MAX_TID_COUNT;
 
+			if (tid >= ARRAY_SIZE(mvmsta->tid_data)) {
+				IWL_WARN(mvm, "invalid TID %d in compressed BA\n",
+					 tid);
+				continue;
+			}
+
 			if (mvmsta)
-				mvmsta->tid_data[i].lq_color = lq_color;
+				mvmsta->tid_data[tid].lq_color = lq_color;
 
 			iwl_mvm_tx_reclaim(mvm, sta_id, tid,
 					   (int)(le16_to_cpu(ba_tfd->q_num)),
-- 
2.53.0



