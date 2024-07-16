Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57328CA40;
	Tue, 16 Jul 2024 15:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144396; cv=none; b=Sxj8MZA9MyrU4M4+k3Ar8WPzR8ZsRRanlp8vamQUq2plaUo5M2nPBQki9x9l3vU3umQlkYqYaoEcDDlIOE+KR4Ae3NiYBpoYYmvhRLxzZhC7xyMyp+6BkdGMtXu8hQ0pvZUml8QGWuFYhKnpAmAitCEbac2aVdqbTokkNv/AAIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144396; c=relaxed/simple;
	bh=depshuhPIRKg4x2nlyUIDX1S1SlH9/lC25FtY4j0ZT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zsav0T4s7mHZbW/O8ZjtorMF0OEOIBbew5VO9BhFwnhn0/RlMgcBSrfwGwhDlQJGVmnh4/zjWLxnA5trVeJ9n+iCSS1T8HzhJrUc6nSF83m1T0yh0IWaUfq+5jha+HiWHJ9DE8UbNGysXebaUYAT0NZcdP0fYEscu1+C6H2dsI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzOJk3cK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzOJk3cK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0978C116B1;
	Tue, 16 Jul 2024 15:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144396;
	bh=depshuhPIRKg4x2nlyUIDX1S1SlH9/lC25FtY4j0ZT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzOJk3cKJ5tovWJRzn3hxopHHwoZpsgnYX0qRQjJYQpkUrUKHRC74m7YAGcRFGwbH
	 gFrXr/cnE1CK6MKUlYMDtYwY0SHsBk/FEOGSKDGnfMQc4tOn71Ku6pp1mq+HGMODME
	 6yB7WuTrRcFc6HUeCUTTa2wnfGnZ6NLjUoGzkq1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/78] octeontx2-af: Fix incorrect value output on error path in rvu_check_rsrc_availability()
Date: Tue, 16 Jul 2024 17:31:23 +0200
Message-ID: <20240716152742.614197654@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9c6307186505a..f569a98e35a02 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1124,7 +1124,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 		if (req->ssow > block->lf.max) {
 			dev_err(&rvu->pdev->dev,
 				"Func 0x%x: Invalid SSOW req, %d > max %d\n",
-				 pcifunc, req->sso, block->lf.max);
+				 pcifunc, req->ssow, block->lf.max);
 			return -EINVAL;
 		}
 		mappedlfs = rvu_get_rsrc_mapcount(pfvf, block->type);
-- 
2.43.0



