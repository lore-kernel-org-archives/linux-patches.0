Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976D219E7CF;
	Tue, 16 Jul 2024 15:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144857; cv=none; b=ti11/shE9neaatsp9N9+nrHxET+4ZB0p+xEhXtsX/+fYBWPO2u4QI5Vka5zCxeLN6Ak7XX3UKnadtZfWJ3KSW5T01i9iD3jaYMBGUYq+inbMCeEIygwZS6SV9F5H8qbkSphgu6Rhsc0a8j0Gg/2M9LhCtaK3GtOzqrDRUFIOemc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144857; c=relaxed/simple;
	bh=1oQzoklkDo9LzhTIePB8MBLVS9RLFcuNPY670ej2UMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVV6iUJvAuEc43ZaPqer9rK3ZRQ8sq8KcUvs66tev5oMBaE+3Q8kvvstk4KZgc7sA0/7s8SSVE0ZVD9WIEqgTUfAsjG+lxmalvaOAS9PzMbZ4VOvqw2cXQxD8l0UKnhpfVWUhBxc8EZlZ36GOoBzFmJRhO/tzIvTBaFlwSWKqpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNCUQvFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNCUQvFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38A2C116B1;
	Tue, 16 Jul 2024 15:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144857;
	bh=1oQzoklkDo9LzhTIePB8MBLVS9RLFcuNPY670ej2UMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNCUQvFziYY3WsBtaSRCiXtkTVGhCADdCtrVYqfRg04yyi4qSpsLG4gZZI0yAHpS0
	 s50Q96/FP7HEOWDrZrEOWsKo8FA6Xr9QKuvE4bVX+AOWoovu64JgSTjLpk6vCyoKWe
	 ACjK7WyihRlEY7IxmZPcgKmOWjyzWpWKZpIcdk1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Justin Chen <justin.chen@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 019/143] net: bcmasp: Fix error code in probe()
Date: Tue, 16 Jul 2024 17:30:15 +0200
Message-ID: <20240716152756.729739770@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 0c754d9d86ffdf2f86b4272b25d759843fb62fd8 ]

Return an error code if bcmasp_interface_create() fails.  Don't return
success.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Link: https://patch.msgid.link/ZoWKBkHH9D1fqV4r@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
index a806dadc41965..20c6529ec1350 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -1380,6 +1380,7 @@ static int bcmasp_probe(struct platform_device *pdev)
 			dev_err(dev, "Cannot create eth interface %d\n", i);
 			bcmasp_remove_intfs(priv);
 			of_node_put(intf_node);
+			ret = -ENOMEM;
 			goto of_put_exit;
 		}
 		list_add_tail(&intf->list, &priv->intfs);
-- 
2.43.0



