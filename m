Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360C246C4D2;
	Tue, 21 Jul 2026 18:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659880; cv=none; b=T5m7KVrkB8GhMYF568pahAYWxTvrrN8yjG0hWyfmZYbGvSPITWhJsc5oSyhgIeV6Kq48z+c5NB91rq7sPznM+O0xFCaO4ygZYp0WZB7kdg77/R6GTF8M5msQGm95blhL9EjbOn2N29FiFnLQU/ncJq2BZ9HEEolM97qk01g1NH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659880; c=relaxed/simple;
	bh=lK8ek8FC0ZzVNNXRUcNvwL6bJZqmYspmIe+hggTZ64M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFOnQEEF/bkoF/L+OC3JVwHxlD6Q3Ks/JMdFmKidJyqMdy0LIXbKE1QZ4GmXKfGFU7C70Tar/cVZ4f4uYYW9Ohi6HjI7oDzaQkdUeGSnE4oJdy373Gh10TY8y1LcTccKj8rF6xILRg/8IbiQHOnf/eB3+5wkdPOv5izHHP2fv70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pve8N3OX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pve8N3OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E411F00A3A;
	Tue, 21 Jul 2026 18:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659876;
	bh=E2a4MwZluWOdFgVrrny60xMJ/cRRWDMv+3AW9NYhbgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pve8N3OX42HfRlrYcflhRP1jzJ7LuS9iN+6Y95r0sLWGN40AqrMUzv3GwYAbS13rs
	 1GH0X5gc2mGzL/dFbUCuiper0wNuod8paH8HADXSK7GY7YfeM5BJeWcpZ3Uk8RvBm3
	 RrVEMChZ9il8sSRlWv9oAgFH0eRDHYDwsqzpqkKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0766/2077] octeontx2-af: fix NPC mailbox codes in mbox.h
Date: Tue, 21 Jul 2026 17:07:19 +0200
Message-ID: <20260721152610.864650407@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 925551c944a1de3058dc3fb55a517eea7749835d ]

Several NPC mailbox command IDs in the 0x601x range were assigned out of
order. Renumber and reorder the M() definitions so each opcode matches
the stable contract expected by userspace tools and applications.

Fixes: 4e527f1e5c15 ("octeontx2-af: npc: cn20k: Add new mailboxes for CN20K silicon")
Cc: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260611083330.1652181-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 31 +++++++++----------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index dc42c81c094256..44fdd6ba7307c8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -283,31 +283,30 @@ M(NPC_GET_FIELD_HASH_INFO, 0x6013, npc_get_field_hash_info,
 M(NPC_GET_FIELD_STATUS, 0x6014, npc_get_field_status,                     \
 				   npc_get_field_status_req,              \
 				   npc_get_field_status_rsp)              \
-M(NPC_CN20K_MCAM_GET_FREE_COUNT, 0x6015, npc_cn20k_get_fcnt,		\
-				 msg_req, npc_cn20k_get_fcnt_rsp)	\
-M(NPC_CN20K_GET_KEX_CFG, 0x6016, npc_cn20k_get_kex_cfg,			\
+M(NPC_MCAM_DEFRAG,	 0x6016,	npc_defrag,			\
+					msg_req,			\
+					msg_rsp)		\
+M(NPC_CN20K_GET_KEX_CFG, 0x6017, npc_cn20k_get_kex_cfg,			\
 				   msg_req, npc_cn20k_get_kex_cfg_rsp)	\
-M(NPC_CN20K_MCAM_WRITE_ENTRY,	0x6017, npc_cn20k_mcam_write_entry,	\
-				 npc_cn20k_mcam_write_entry_req, msg_rsp)  \
-M(NPC_CN20K_MCAM_ALLOC_AND_WRITE_ENTRY, 0x6018,				   \
-npc_cn20k_mcam_alloc_and_write_entry,					   \
+M(NPC_CN20K_MCAM_GET_FREE_COUNT, 0x6018, npc_cn20k_get_fcnt,			\
+				 msg_req, npc_cn20k_get_fcnt_rsp)	\
+M(NPC_CN20K_MCAM_WRITE_ENTRY,	0x6019, npc_cn20k_mcam_write_entry,			\
+				 npc_cn20k_mcam_write_entry_req, msg_rsp)	\
+M(NPC_CN20K_MCAM_ALLOC_AND_WRITE_ENTRY, 0x601a, npc_cn20k_mcam_alloc_and_write_entry,	\
 				npc_cn20k_mcam_alloc_and_write_entry_req,  \
 				npc_mcam_alloc_and_write_entry_rsp)  \
-M(NPC_CN20K_MCAM_READ_ENTRY,	0x6019, npc_cn20k_mcam_read_entry,	\
+M(NPC_CN20K_MCAM_READ_ENTRY,	0x601b, npc_cn20k_mcam_read_entry,	\
 				  npc_mcam_read_entry_req,		\
 				  npc_cn20k_mcam_read_entry_rsp)	\
-M(NPC_CN20K_MCAM_READ_BASE_RULE, 0x601a, npc_cn20k_read_base_steer_rule,       \
-				   msg_req, npc_cn20k_mcam_read_base_rule_rsp) \
-M(NPC_MCAM_DEFRAG,	     0x601b,	npc_defrag,			\
-					msg_req,			\
-					msg_rsp)			\
-M(NPC_MCAM_GET_NUM_KWS, 0x601c, npc_get_num_kws,		\
+M(NPC_CN20K_MCAM_READ_BASE_RULE, 0x601c, npc_cn20k_read_base_steer_rule,            \
+				   msg_req, npc_cn20k_mcam_read_base_rule_rsp)  \
+M(NPC_MCAM_GET_NUM_KWS, 0x601d, npc_get_num_kws,		\
 				npc_get_num_kws_req,		\
 				npc_get_num_kws_rsp)		\
-M(NPC_MCAM_GET_DFT_RL_IDXS, 0x601d, npc_get_dft_rl_idxs,	\
+M(NPC_MCAM_GET_DFT_RL_IDXS, 0x601e, npc_get_dft_rl_idxs,	\
 					msg_req,		\
 					npc_get_dft_rl_idxs_rsp)\
-M(NPC_MCAM_GET_NPC_PFL_INFO, 0x601e, npc_get_pfl_info,		\
+M(NPC_MCAM_GET_NPC_PFL_INFO, 0x601f, npc_get_pfl_info,		\
 					msg_req,		\
 					npc_get_pfl_info_rsp)	\
 /* NIX mbox IDs (range 0x8000 - 0xFFFF) */				\
-- 
2.53.0



