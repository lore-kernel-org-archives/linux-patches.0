Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4202215F5C;
	Tue,  8 Jul 2025 16:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992979; cv=none; b=SyK01aFLhghy8DD0gY9GiSnoIIC7J0hT901Fv0ZZ+5ES4kUiHuUWxITn3UUUSBTZH1dVzatSX55tQnIMucRmsmC9cICU3I4uPvDmSN38aT/N+c7i8AVs52+WQthOgFcHF6t40zkVD1Lmt2Pfx24jWi/BMuU+mBHHMQYA6FfO3Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992979; c=relaxed/simple;
	bh=FSRVxKDb2urznTXRNOMIpKjO31C6VJFwl3lG7T1v+tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZYXJ9/fWVWSx5lg9wsQzSubo66V7DZjeekMzlL4hFpbqn0/AkXMvPeZk36v8FT+UX6L3kcoBnqTxl0c7zrKVyN0EPMK8KGUNXW0r5hPtR5Ac6fUnbWJk5nEW3uwTVhfgSS+lvyINKDXfuc8jZ7E8xD7g7wnxylF1gp9R6L17jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exAX8jeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exAX8jeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248D7C4CEED;
	Tue,  8 Jul 2025 16:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992979;
	bh=FSRVxKDb2urznTXRNOMIpKjO31C6VJFwl3lG7T1v+tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exAX8jeIw4tUClycTKT/xJhDU67lZI9BYc3cwgxKhWI1wbqMnSO9q8wP16AQDvAni
	 H2gJN4ZieHEtD6OhgA5B8stwXv9galhzjc/Wj8abITewSHBrKcYGuYjq+vcDyUS5jk
	 r4OBLK5Kq7nTwC5+6qr2hirw0VbqJoUnE4JqFYSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/232] remoteproc: k3-r5: Use devm_kcalloc() helper
Date: Tue,  8 Jul 2025 18:22:23 +0200
Message-ID: <20250708162245.286878627@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Beleswar Padhi <b-padhi@ti.com>

[ Upstream commit f2e3d0d70986b1f135963dc28462fce4e65c0fc4 ]

Use a device lifecycle managed action to free memory. This helps prevent
mistakes like freeing out of order in cleanup functions and forgetting
to free on error paths.

Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Reviewed-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20241219110545.1898883-3-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 701177511abd ("remoteproc: k3-r5: Refactor sequential core power up/down operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/remoteproc/ti_k3_r5_remoteproc.c b/drivers/remoteproc/ti_k3_r5_remoteproc.c
index a9ec65c12fb93..c730ba09b92c7 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -989,7 +989,7 @@ static int k3_r5_reserved_mem_init(struct k3_r5_rproc *kproc)
 		return ret;
 
 	num_rmems--;
-	kproc->rmem = kcalloc(num_rmems, sizeof(*kproc->rmem), GFP_KERNEL);
+	kproc->rmem = devm_kcalloc(dev, num_rmems, sizeof(*kproc->rmem), GFP_KERNEL);
 	if (!kproc->rmem)
 		return -ENOMEM;
 
@@ -1041,7 +1041,6 @@ static int k3_r5_reserved_mem_init(struct k3_r5_rproc *kproc)
 unmap_rmem:
 	for (i--; i >= 0; i--)
 		iounmap(kproc->rmem[i].cpu_addr);
-	kfree(kproc->rmem);
 	return ret;
 }
 
@@ -1051,7 +1050,6 @@ static void k3_r5_reserved_mem_exit(struct k3_r5_rproc *kproc)
 
 	for (i = 0; i < kproc->num_rmems; i++)
 		iounmap(kproc->rmem[i].cpu_addr);
-	kfree(kproc->rmem);
 }
 
 /*
-- 
2.39.5



