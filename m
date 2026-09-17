Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE043CAA47;
	Thu, 17 Sep 2026 18:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670836; cv=none; b=TOuQp8A6Vjl8duUrFvPdrTD/q5rP1RZ6peJwbK51Ir/ew9OeH8TrSAnCfxhGrEj1zrQXggcMO7KhSucGsqxGajt8C1tQOy9GmWxhqyAAMZIIbIwBLIGwc3+KUON9OnlmvKn44cBYoqmmlEhFUsaUEQctJS+0eMm96Vdnmg1iOUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670836; c=relaxed/simple;
	bh=bZ3bMYvZPy/IGq16vQO3ZdxNVeFgZsQyxIf9hBpF33Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaHjipXssKZbxZ7iqQWEr3xu69QDtwjKyospnxY+7T3HG/hkgkypp0R4+VQ5EEXuMbWPrE+/4FHT0jHTFldc88SZw8znl54muj8olbSe9tDy0PeNlYpLAercfkApCsniLomsNMwP6Vv/E435RwFgqKVjXnW6jnKJT8ksAz6tj1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiOSc0Ou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiOSc0Ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DB71F000FF;
	Thu, 17 Sep 2026 18:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670835;
	bh=Wt69N+HEhE5Z34dK+98Mg1iPs1h9JZRCqmdx6sV8fA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiOSc0OudaHTgE5uXtYeU+K8E6LNyzSJc1dereRR3zkb27NA2Yn6hlPZh65DuU3ly
	 mWxmyEfftDnnRwIFNCWK9YeTyqncbE8lD/aEP7pseTPgIpF1gZLuVfdyZ4EwPaDcVP
	 B+5Wv8jupwdDcx2q+9+iRfrw5FMj+flWVvV8vwjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0785/1102] cxgb4: clip_tbl: Fix spelling mistake "wont" -> "wont"
Date: Thu, 17 Sep 2026 16:12:08 +0100
Message-ID: <20260917151600.172664969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit c824deb1a89755f70156b5cdaf569fca80698719 ]

There are spelling mistakes in dev_err and dev_info messages. Fix them.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ccbe7540e4aa ("net: phy: mediatek-ge: disable EEE on the MT7530 PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
index 163efab27e9b8..5060d39988890 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
@@ -120,7 +120,7 @@ int cxgb4_clip_get(const struct net_device *dev, const u32 *lip, u8 v6)
 				write_unlock_bh(&ctbl->lock);
 				dev_err(adap->pdev_dev,
 					"CLIP FW cmd failed with error %d, "
-					"Connections using %pI6c wont be "
+					"Connections using %pI6c won't be "
 					"offloaded",
 					ret, ce->addr6.sin6_addr.s6_addr);
 				return ret;
@@ -133,7 +133,7 @@ int cxgb4_clip_get(const struct net_device *dev, const u32 *lip, u8 v6)
 	} else {
 		write_unlock_bh(&ctbl->lock);
 		dev_info(adap->pdev_dev, "CLIP table overflow, "
-			 "Connections using %pI6c wont be offloaded",
+			 "Connections using %pI6c won't be offloaded",
 			 (void *)lip);
 		return -ENOMEM;
 	}
-- 
2.53.0



