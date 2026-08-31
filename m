Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAD6599A44;
	Mon, 31 Aug 2026 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184300; cv=none; b=bOy5PbAu5tdaP/61Yi9cXC1rubtBpNDByh/YTK9QPobAnR3C9nWv+nVMWiLzvDHUGY1jqArf/ZbpM6yjp3UKt9xTDoM5mfJ3WZeXvNVnLEJdhWU6sUJPxEDw9xkkRWekgta0cM1V2bkzTnNUCbVYzMSU5Qa1mFyY04atH2GqAHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184300; c=relaxed/simple;
	bh=y1zPVtfa5ONVNta+fsIaR0G933Ty6okvTXE7fZrZZYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoTcDoP7zL1Zv8oixzFD65YLnaernJCx7729w2C7Gzw7/EiYVtxQqjHANlVHoed7Y1x/brzFqu8V1PEtmDmzfQVC8+uzCQqMpwu15hO7+I3+I7JaoaW6AUE9Y4H2dN1yDXD8aAdfF9sMIY4cRAn1999UnVgfDQwLy+rusGzOEMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MvIHVw2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvIHVw2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C0E1F00A3E;
	Mon, 31 Aug 2026 13:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184297;
	bh=YGKuJKPKD1xeRDuLNgvHlSbaUHfUzbwDWVFfyGFAms8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MvIHVw2G2QJvtGO8Pf08ViUMeTcWt+yThubG/7GwH7/6ESHX8XSdMFGhaDQi//pIt
	 8+i6o5zJGPKZd1QMyQitOEjk/LCRc794sJmz1P4Rre+dCu45hNVxaPztO8OUP8tq05
	 PVEuvqkTp2Rtqm5pOAM1p6XQSiGGkj3W4OxR0I4c/EWbNkrKKuNEu06jyHv7XiuJ8B
	 ulyVZDzQ5un5vFD9PfMY1VflNppEBntuv8SG3rc4IIFwW86fI0vBDspGnkF6dVxNNb
	 o4e1krpHFpIoXohSoltDFTmKFf7iUEotsJmRNKWKgPCrvwAUqNGJUKiwbRwSOPAmHl
	 Qfxp/OfqSCLBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] wifi: iwlwifi: mvm: fix out-of-bounds tid_data access in BA notif
Date: Mon, 31 Aug 2026 09:30:37 -0400
Message-ID: <20260831133314.4125787-609-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background git history searches finished. This checkout has full
history (~11,945 commits), but `git log -S` for both
`compressed_ba_notif` and `tid_data[i].lq_color` only surfaces the v6.18
import merge (`5d324e5159d9e`), so the exact commit that introduced the
bug couldn't be isolated from history alone.

That doesn't change the conclusion: the buggy line is present at
`tx.c:2141` in v6.18.44, and the fix remains a good stable backport
candidate.

**YES**

 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ebb201bd23d85..eab3f7184b49b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2171,8 +2171,14 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 			if (tid == IWL_MGMT_TID)
 				tid = IWL_MAX_TID_COUNT;
 
+			if (IWL_FW_CHECK(mvm, tid >=
+					 ARRAY_SIZE(mvmsta->tid_data),
+					 "invalid TID %d in compressed BA\n",
+					 tid))
+				continue;
+
 			if (mvmsta)
-				mvmsta->tid_data[i].lq_color = lq_color;
+				mvmsta->tid_data[tid].lq_color = lq_color;
 
 			iwl_mvm_tx_reclaim(mvm, sta_id, tid,
 					   (int)(le16_to_cpu(ba_tfd->q_num)),
-- 
2.53.0

