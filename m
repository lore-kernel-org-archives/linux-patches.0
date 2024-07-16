Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4C01DDCE;
	Tue, 16 Jul 2024 15:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145283; cv=none; b=VWwblQMe9DY6lNGkLcehOduuJkhxgRzyAngBbgIqM0QbKOza/jizw7JNY0N6njdieSb4pMkikZiFamgUgXZTiJ5jsIzTqp11/mUw49tQ94NBcWhggsjzNNLO5VnVBmlKVavVIvln93GYWSA/mBrIc7Hwr1mQWk5AmpQUOi5uUb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145283; c=relaxed/simple;
	bh=giWuJDvHTuppXJtlWIX/Hh0EEeypCAu6691/+FwJ4T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FczqDSOyMlArrETKRBwp7pS5zWh04l1KVAuSKtIe9z9vgLOMh/5DJq7NYe6F2mDbC++j0Dpzd+kSInofLk6/3TQ6oAVQ5YuiXcmvbLJlFpzDk8d/MaOY/TcGE/IvAwN72uA7FhfC3RXCJpck7yGLY6lju6cZW3D+qglJXf8USeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDQlvi9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDQlvi9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B36C116B1;
	Tue, 16 Jul 2024 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145283;
	bh=giWuJDvHTuppXJtlWIX/Hh0EEeypCAu6691/+FwJ4T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDQlvi9YllpFr34EsaiTjSMyPwI+WXVzCA/K3EGwRhw4gDknkwSkImxyNwMR2WmJE
	 JgUXyj8nOSMjE+wiLUmrh4zwyphORoDTcRVPEe26eInqnkj7ivQP6j+WX1U6RGUGzR
	 5LKman8P8LtU5+6WIQFE3oiGuihMdLMdiGiOYPCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/96] octeontx2-af: Fix incorrect value output on error path in rvu_check_rsrc_availability()
Date: Tue, 16 Jul 2024 17:31:26 +0200
Message-ID: <20240716152747.103380638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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
index a7034b47ed6c9..c7829265eade9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1638,7 +1638,7 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
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



