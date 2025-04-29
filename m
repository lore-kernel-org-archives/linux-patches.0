Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A278253345;
	Tue, 29 Apr 2025 17:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947054; cv=none; b=YUtzXGqtTMR5LdkpkD02bZ/AX7I5rmt66EkocCd7DrmGDHXqfYgVGEqSbeRsRZNWJPzdIvz/dWU471cZvvJFGszYeDIM3hX8TInpY53KU3NQQOyKE+HeURiZvPhhKcegxo6z1MYq320/5p9DF/e3/OaGkxpvx/Dyy7h75orhPjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947054; c=relaxed/simple;
	bh=v250DgBIpD/Diz6ksqaOU6GO0lj2OIVH3aEbTH4QNn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0xgW6JQRm6skppKsWxjqjRJeZtlCstKM0TxpTzoJAC1AWvfKqDyFrkhX/rVatANuuUwJRmP/5Os6qE8rPUsB/tMu2tzUN9R3jO08TCR0wrMkbFx6GBN7SlgEOoxtagNC/F3JTLCRYlhiu95rwFY5OEnC1qAUTnITp8mX1PUZ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9Xg8L80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9Xg8L80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C0EC4CEE3;
	Tue, 29 Apr 2025 17:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947054;
	bh=v250DgBIpD/Diz6ksqaOU6GO0lj2OIVH3aEbTH4QNn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9Xg8L80jqVwnB5N4BYUTly06M2DJhGu2mRVtb0tP34It1/fT+nh5rKAVx3yp34L4
	 bcIxcSCF/A91IdvuYOucfJK+dXdSC9nbA5dKiQdWe/x78BVzDDESfgUmiYlY5Rx/3B
	 cYcNS4nit3exiHq5BwwVHlfx2SsvNuGyoBHdNlVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 5.10 156/286] phy: tegra: xusb: Fix return value of tegra_xusb_find_port_node function
Date: Tue, 29 Apr 2025 18:41:00 +0200
Message-ID: <20250429161114.301218987@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 045a31b95509c8f25f5f04ec5e0dec5cd09f2c5f upstream.

callers of tegra_xusb_find_port_node() function only do NULL checking for
the return value. return NULL instead of ERR_PTR(-ENOMEM) to keep
consistent.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20211213020507.1458-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -449,7 +449,7 @@ tegra_xusb_find_port_node(struct tegra_x
 	name = kasprintf(GFP_KERNEL, "%s-%u", type, index);
 	if (!name) {
 		of_node_put(ports);
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}
 	np = of_get_child_by_name(ports, name);
 	kfree(name);


