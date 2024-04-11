Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FCF13C9A5;
	Thu, 11 Apr 2024 10:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831747; cv=none; b=g4G290NiARMA/qtxTx0/o48sAKA/s+cs2itkWbN9QPC9C693PBEEuxfGe0peuGemcdLS66k3GQVq8aiNr+1isr5C6uvh3Up+sP01E4TlzG7SbNDSL3yqLe6HDZzbdWYQH2dJpB2/A+olg6nB3YTGut6ME6LX3/Iisq9j+cxRiYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831747; c=relaxed/simple;
	bh=ZUKE7zLJ9iv3zWzyha72+drnzsuFaXujV64aR6VdBgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9N3/K5IsOj3SZeHdwkFQlG5tw89GRn2i5TQkEAgxFHrSCrLbjXnlFWyJfdmZIa0tu+tUJ+aGbl5jvW/yTGMREelkF5EbOggfMu2pVVNFsZnZmCt+IPWhHBRkm+8foa6z6IXy7CUpY2PfvXeWpnPz1m3MlPif3m+ONJEGYIO8YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mt4Z4Gcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mt4Z4Gcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F9BC433F1;
	Thu, 11 Apr 2024 10:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831747;
	bh=ZUKE7zLJ9iv3zWzyha72+drnzsuFaXujV64aR6VdBgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mt4Z4Gclc3qP+G/HKhX6G/2n7y3RJEl197gLPOYoXeQwF6dyAYRUyIbOffxs+QrQV
	 YozIRP+nloNqlb0YFPDR02GLkMbYngWyYsUL5j4Xzfopeys8Sq76UhaO9lRlwOO5uc
	 2hlCtSj099SwJ4HjyA4aD2jwazGzSFP+ButtiBbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Wang <vulab@iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/294] vxge: remove unnecessary cast in kfree()
Date: Thu, 11 Apr 2024 11:54:36 +0200
Message-ID: <20240411095439.070982337@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Wang <vulab@iscas.ac.cn>

[ Upstream commit b6bf4776d9e2ed4b2552d1c252fff8de3786309a ]

Remove unnecessary cast in the argument to kfree.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20201023085533.4792-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e3f269ed0acc ("x86/pm: Work around false positive kmemleak report in msr_build_context()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/neterion/vxge/vxge-config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index f5d48d7c4ce28..da48dd85770c0 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -1121,7 +1121,7 @@ static void __vxge_hw_blockpool_destroy(struct __vxge_hw_blockpool *blockpool)
 
 	list_for_each_safe(p, n, &blockpool->free_entry_list) {
 		list_del(&((struct __vxge_hw_blockpool_entry *)p)->item);
-		kfree((void *)p);
+		kfree(p);
 	}
 
 	return;
-- 
2.43.0



