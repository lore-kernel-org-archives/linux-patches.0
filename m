Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CE546D2C1;
	Tue, 21 Jul 2026 19:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660905; cv=none; b=K6ZFS7CkP2SGsh9ysGVcHbl1oKng4mTBWrNA8h9ZjeEqsmz9ePLZfw9jWelVAlweTtOyL+BL2ID9dzWjzwqqZYZtWBSF25XfcpmMcOosorZzVSBpML3SV0doAyLb74WH2HNsebm+AKLszzKb94x3g5N3JndLKE3CS1HgWZ9/RLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660905; c=relaxed/simple;
	bh=YXuiSRpEGyCerJgYk5bOKtkU+WXnrUQ1cBtkV7Q0IN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mz4maTIjP50HG3fsS6Amcbj+m7mCSvaoPiXdLTIhBdBSuWwq11hU0h61hEDcYdAGqlrGYZ9R3YLpiBh6RfoOWvMUkMsHqqIGYjLSRXuiQNPLGrHmAP/6QztYDvC14meaQvVkPdPpSvL30twkZhjKFosi7uzu5Kc0JU55zy3CLBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXENKn11; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXENKn11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898111F000E9;
	Tue, 21 Jul 2026 19:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660904;
	bh=2/SJdvr/JxHr7ZLTny5ica6yx9OMsGcu9oXY/J8ZSR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VXENKn1122e88uqvUsjeTHVk/X9k00VUGLBO+C1U49zM5vXIXOwW3eYN1ml/g0zOJ
	 08llWSH/SWNKwIW0q4tXgY0RLO0mN9XhLn9QYlAFn6QXIWZaY3Tem66PFpeGWn8/tf
	 ajM+BNRiTnCmbOT/tLx1+dQSn0p03CCJub/a10Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1112/2077] octeontx2-af: npc: Log successful MCAM drop-on-non-hit install at debug level
Date: Tue, 21 Jul 2026 17:13:05 +0200
Message-ID: <20260721152619.048821725@linuxfoundation.org>
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

[ Upstream commit 4f6ac65e81625165257131ec2574bb6bb09bd7d8 ]

npc_install_mcam_drop_rule() used dev_err() after a successful
rvu_mbox_handler_npc_mcam_write_entry() call, so normal installs appeared
as errors in dmesg.  Use dev_dbg() for the success path and keep dev_err()
for real failures.

Fixes: 3571fe07a090 ("octeontx2-af: Drop rules for NPC MCAM")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260615033157.535237-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 34f1e066707bdc..3d4d3ab5183b83 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -2215,7 +2215,7 @@ int npc_install_mcam_drop_rule(struct rvu *rvu, int mcam_idx, u16 *counter_idx,
 		return err;
 	}
 
-	dev_err(rvu->dev,
+	dev_dbg(rvu->dev,
 		"%s: Installed single drop on non hit rule at %d, cntr=%d\n",
 		__func__, mcam_idx, req.cntr);
 
-- 
2.53.0



