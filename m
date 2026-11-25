Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619138;
	b=XQSMC0Xkwv8QNnZTDwSA97f1wh0wxZN4FQdYLUwRSYRSMb3T9OVTjaurWVO/g0FhyGt4
	 slOhUqOd0MGH4rb78BtH4U5pfcQUZSZ49Q2gim7MPyn9E4Nb2224WHWnFSRFh0vPgGtjh
	 FvRWcn2rH+JToVeP63IOgM1RL84Y+GkzpA8/2C7avb2Lm2ixfiYD7ssHG6XWHNMSeN1mf
	 GiZTxVmxKXmxiAcj9ynadUd1vbDQeY/NYmGc2C5rVY28rVzcmzYfUqoqTqcbR+3TUF0BK
	 pa/DCUzlQ3sukCgDmsSsoWziq17MPXwGtgfjp2LbJyAedPwlznIKIRRxjvm2uZ0vmsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x1VwoCWmARScuQlhsdQaYtZ1lqLRQuKzDp9rdOW2E/E=;
	b=dz7zarc1Zf7DZiifHjH7vyJUPv3Q6Nf8PoCS/A7MvPXLKXeXePACgaqLfZDiZKt30Hob
	 f+GKmecmkBrgN2SbENBHbzPeaVCog6JG7cBRBl3WQFtKTUraWkYJvZbxjeyd8ic6F9A+7
	 emlakzBWEJs99uFq2F8C/88VT03ZF1hl3jgOTCvdDV5lDkCscTxMg8igf/3R8M2Ai+PYW
	 BIdmvuZRO1h1xOpt3kmvo54d0U94LHR2hFm70JKyOemL3fWaXWSmiqCzhyJ0q9ckoFdIG
	 gQNWxlprtuF4edlABtrnkck9rfq7DMF8xfjVZ/tdpPYDwZEet0a8DUfzSd408n1Vifg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O98CS3cN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70280606A323;
	Wed, 25 Nov 2026 15:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O98CS3cN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04CF1F000C0;
	Wed, 25 Nov 2026 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619138;
	bh=x1VwoCWmARScuQlhsdQaYtZ1lqLRQuKzDp9rdOW2E/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O98CS3cNOb/zFdNtiieXIKRM/IxJNHKSVlbf7sJ6Cfzt6OLRMH3nIORv7FZph2Wa+
	 te3F3yfAgePg2RU8nJJTecBmidpHOKbUspvDrJKQZdghqOzM4xtTEmIgwJ2rmLc3H1
	 Ig3UziD2qciu3Aoy5sMcbSX6rWdxvb7WPmA0O+bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0458/1005] net: octeontx2: fix building without DEBUGFS
Date: Wed, 25 Nov 2026 15:29:56 +0100
Message-ID: <20261125143832.475138951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2007f7e37142ebdb341949dca8098f898cc871f7 ]

This error came up on my randconfig tests this week:

drivers/net/ethernet/marvell/octeontx2/af/cn20k/debugfs.c: In function 'npc_cn20k_debugfs_init':
drivers/net/ethernet/marvell/octeontx2/af/cn20k/debugfs.c:392:55: error: 'struct rvu' has no member named 'rvu_dbg'; did you mean 'rvu_dl'?
  392 |         debugfs_create_file("mcam_layout", 0444, rvu->rvu_dbg.npc,

The problem here is that the rvu_dbg member is hidden in an #ifdef
block, but the reference to it is not.

Remove the #ifdef and waste a few bytes in the structure in this
config. Note that the debugfs_create_file() call end up ignoring
the arguments, so the actual debugfs implementation is still
ignored here.

Fixes: 528530dff56b ("octeontx2-af: npc: cn20k: add debugfs support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20261105161945.1658464-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 094227404ef9f..f91478f656615 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -75,8 +75,6 @@ static inline int rvu_pcifunc_pf_mask(struct pci_dev *pdev)
 
 #define RVU_AFPF           25
 
-#ifdef CONFIG_DEBUG_FS
-
 struct dump_ctx {
 	int	lf;
 	int	id;
@@ -111,7 +109,6 @@ struct rvu_debugfs {
 	int npa_qsize_id;
 	int nix_qsize_id;
 };
-#endif
 
 struct rvu_work {
 	struct	work_struct work;
@@ -648,9 +645,7 @@ struct rvu {
 	int			mcs_blk_cnt;
 	int			cpt_pf_num;
 
-#ifdef CONFIG_DEBUG_FS
 	struct rvu_debugfs	rvu_dbg;
-#endif
 	struct rvu_devlink	*rvu_dl;
 
 	/* RVU switch implementation over NPC with DMAC rules */
-- 
2.53.0



