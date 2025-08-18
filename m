Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F4433A00E;
	Mon, 18 Aug 2025 14:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525719; cv=none; b=AsABHJU5hX28UJ8ZPVa5GqKjAvkB/iIhvg56z3dcDpdIoVIIddsxJOG3VqHuJ9eFf9Qe4QMKauq9TwudAE0a2NSiUakB8IFahhzJMeTx4x0/A9M9BdUdRPVu7qc6uBMETS4ug0AiicmGOIx34pRcFO1qbD4uP/QtWcPqFMPmoQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525719; c=relaxed/simple;
	bh=eNUUdnXxne5mlzshCF5uYNeC+BR2pQIKMdVK4caGEnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGloxbWnj9vALhSNLgL7kidV8NIrrbQ0G2eN6b2Bjs/C6pWwmDRRRDbM21HDckI58CfqE9q6QOi66T5h/rQo0k5CV3fB5x53Aa8DcYFBqwclbdzJTUVsny5fMGyLQVFVRJ1wa09GYMpsRVU42c2IxQ34zgGH5MFQIN8LtXpMriM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndl3IJn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndl3IJn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBB3C4CEEB;
	Mon, 18 Aug 2025 14:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525719;
	bh=eNUUdnXxne5mlzshCF5uYNeC+BR2pQIKMdVK4caGEnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndl3IJn7UVjIyHl7+Xr0rZcaA9MmAGQ6VhHZxW5loS6TnTj+5eLf0Xo1n9WFmSVpP
	 EgFCGETj7L1YYEqDq16d9SycEYnTWcBsYGDgeRlhE/KpiCrOgR0viSKiRdQIjcPzpB
	 oqvLY5a31ZCC8tnHaBmfdHzQ7cKCaCcr3K1l1E3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 304/570] wifi: iwlwifi: mld: use the correct struct size for tracing
Date: Mon, 18 Aug 2025 14:44:51 +0200
Message-ID: <20250818124517.572186338@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit b2c1f9b6e3aac9567c84208b73d716cc5d456404 ]

For the iwlmld driver the RX command is using struct iwl_rx_mpdu_desc
and not the much older struct iwl_rx_mpdu_res_start. Adjust the value of
rx_mpdu_cmd_hdr_size accordingly so that the trace data is correct.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250612144708.688d95d99ff3.Id3055ca6c19cf8c821cbbd80c09ca2a21d9acec7@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 1774bb84dd3f..2a6088e8f4c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -357,7 +357,7 @@ iwl_mld_configure_trans(struct iwl_op_mode *op_mode)
 	trans->conf.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
 
 	trans->conf.rx_mpdu_cmd = REPLY_RX_MPDU_CMD;
-	trans->conf.rx_mpdu_cmd_hdr_size = sizeof(struct iwl_rx_mpdu_res_start);
+	trans->conf.rx_mpdu_cmd_hdr_size = sizeof(struct iwl_rx_mpdu_desc);
 	trans->conf.wide_cmd_header = true;
 
 	iwl_trans_op_mode_enter(trans, op_mode);
-- 
2.39.5



