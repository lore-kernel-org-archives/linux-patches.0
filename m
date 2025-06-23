Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E8CB676;
	Mon, 23 Jun 2025 22:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716706; cv=none; b=cBDJ8qLBQLJv+ONtdwG5ZKExB4reou+gzODKqIXOPRSrx/z5zT31ld/1QmPTHMGHbOxqnsPR6gXFsy+ysCGDg9433lggU7iIM7eft58FFgOEYxUnmWhLxLjxqGw/LnDYf0pRYgdFn9ldFTelRpfh54PMPXl6IN9Q/I+iePODskg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716706; c=relaxed/simple;
	bh=jlZLmeHuvIckmSSp1HL2LzpDMS3EafdHvH5tKdEM7WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLsZaxKIV42IPCpaA90cFGONiB9YfJg+yEkGI4aBVgRK8FrWJa1fozvckSx8vyDlPzqJK1JIZ62wb27e10nwMAF6S4CfQTNHxKG7W5/00vDIxGmmT+GwnQGvAENcIaQfB2q+xFPomVedp887cINIuSAFDzyYwveN9osoxlyoUbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCdik/Tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCdik/Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C70EC4CEEA;
	Mon, 23 Jun 2025 22:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716705;
	bh=jlZLmeHuvIckmSSp1HL2LzpDMS3EafdHvH5tKdEM7WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCdik/Tl0XiK2aBJ/L7WNM6Fo3V1UC64LmFr+s2OGF+kDtI/U+UBkblSqj36PrNUV
	 gI6zTtj0HfqEwNTTsIV2EgdTgLdWox40tEQId6921S98oJ0IDCDLS5yPJmoQXzwxyz
	 YhM/N23uidjzAwfpLWjyZSHZyuM3p0rlGmzEz8gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/414] octeontx2-pf: Add error log forcn10k_map_unmap_rq_policer()
Date: Mon, 23 Jun 2025 15:06:53 +0200
Message-ID: <20250623130648.923331922@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 9c056ec6dd1654b1420dafbbe2a69718850e6ff2 ]

The cn10k_free_matchall_ipolicer() calls the cn10k_map_unmap_rq_policer()
for each queue in a for loop without checking for any errors.

Check the return value of the cn10k_map_unmap_rq_policer() function during
each loop, and report a warning if the function fails.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250408032602.2909-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index 7417087b6db59..a2807a1e4f4a6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -352,9 +352,12 @@ int cn10k_free_matchall_ipolicer(struct otx2_nic *pfvf)
 	mutex_lock(&pfvf->mbox.lock);
 
 	/* Remove RQ's policer mapping */
-	for (qidx = 0; qidx < hw->rx_queues; qidx++)
-		cn10k_map_unmap_rq_policer(pfvf, qidx,
-					   hw->matchall_ipolicer, false);
+	for (qidx = 0; qidx < hw->rx_queues; qidx++) {
+		rc = cn10k_map_unmap_rq_policer(pfvf, qidx, hw->matchall_ipolicer, false);
+		if (rc)
+			dev_warn(pfvf->dev, "Failed to unmap RQ %d's policer (error %d).",
+				 qidx, rc);
+	}
 
 	rc = cn10k_free_leaf_profile(pfvf, hw->matchall_ipolicer);
 
-- 
2.39.5



