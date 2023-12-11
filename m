Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740855102A;
	Mon, 11 Dec 2023 18:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfQPt5wV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E799EC433C9;
	Mon, 11 Dec 2023 18:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320484;
	bh=gBZseWC/6O89pYQ45W+x/Oe73vJlOa6kdyXZ7ulbFsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfQPt5wVpXMRIT9cfPxvvColy81ICBlwfqZHyEvfZosjkLqxQ/sGC3EnSH0lDE1k4
	 PiNvHn5HEcAyZHraeubBSxfU6ru04XY33SUr8M1HrqoP4nVB9XSkBFED6hEZGBtFIw
	 6fQxjgVh6ZRcpYhd0Emjpv5TybRt1+8NiFTPXW5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/194] octeontx2-af: Add missing mcs flr handler call
Date: Mon, 11 Dec 2023 19:20:40 +0100
Message-ID: <20231211182038.805722046@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit d431abd0a9aa27be379fb5f8304062071b0f5a7e ]

If mcs resources are attached to PF/VF. These resources need
to be freed on FLR. This patch add missing mcs flr call on PF FLR.

Fixes: bd69476e86fc ("octeontx2-af: cn10k: mcs: Install a default TCAM for normal traffic")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 733add3a9dc6b..d88d86bf07b03 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2622,6 +2622,9 @@ static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 	 */
 	rvu_npc_free_mcam_entries(rvu, pcifunc, -1);
 
+	if (rvu->mcs_blk_cnt)
+		rvu_mcs_flr_handler(rvu, pcifunc);
+
 	mutex_unlock(&rvu->flr_lock);
 }
 
-- 
2.42.0



