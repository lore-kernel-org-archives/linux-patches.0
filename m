Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5746C27733;
	Tue, 16 Jul 2024 15:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144998; cv=none; b=THGbHZZbv8YyrkZFXWxDvlFjzJdf0ByBaAsP8V7jORcC0+I7/M7T2pOJAGxF9C4Npkjhry3oh5c8WVgLM25Qp9qn7TZBIB9a6Z2PppEmytYlwSfm8N8UTkpLDvA+wVNFti/LhSeI0L7Fxx5eGfP9D3ozA+4SR5JVgRiQK5Rjeto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144998; c=relaxed/simple;
	bh=m0q9bOy0jgzHiWk+Gvq916U1ri+Ko9xMWmLMRecWLQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4ifaTSaLghuwebL/jmFJRnBRp1l9xY/141CFWQvpcQO3a3ZcdHm0NocoIAgWNC3qjGiI0a+XDFVewFwBfHgDwh4I78LmkIFstB36L08v7LElVwjrJtG195DIuo40T7jvGSQfCV3s2ljWe3KR6ov4kiHV/5HFQexMQSRRtuhubM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ahrx2Xlf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ahrx2Xlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C714FC4AF0B;
	Tue, 16 Jul 2024 15:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144998;
	bh=m0q9bOy0jgzHiWk+Gvq916U1ri+Ko9xMWmLMRecWLQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ahrx2XlfWa78NxcYFxyQ/1S5JIONHd7RPotRbh28qwlubzn0+nMWB1v2Y+I9wtYav
	 KGpflHg3q4WdkqNDDueR2MhXlW+nutR4J+h5WcfFPZ0T2U6gX8lbPIvBwOHl5lBh0Y
	 CJCTUQQsSjS0GZQ98w2j0NmfkApSSe61lNXNXVB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 024/143] octeontx2-af: Fix incorrect value output on error path in rvu_check_rsrc_availability()
Date: Tue, 16 Jul 2024 17:30:20 +0200
Message-ID: <20240716152756.918496810@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 442e26af9aa8115c96541026cbfeaaa76c85d178 ]

In rvu_check_rsrc_availability() in case of invalid SSOW req, an incorrect
data is printed to error log. 'req->sso' value is printed instead of
'req->ssow'. Looks like "copy-paste" mistake.

Fix this mistake by replacing 'req->sso' with 'req->ssow'.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 746ea74241fa ("octeontx2-af: Add RVU block LF provisioning support")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240705095317.12640-1-amishin@t-argos.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index ff78251f92d44..5f661e67ccbcf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1643,7 +1643,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 		if (req->ssow > block->lf.max) {
 			dev_err(&rvu->pdev->dev,
 				"Func 0x%x: Invalid SSOW req, %d > max %d\n",
-				 pcifunc, req->sso, block->lf.max);
+				 pcifunc, req->ssow, block->lf.max);
 			return -EINVAL;
 		}
 		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
-- 
2.43.0



