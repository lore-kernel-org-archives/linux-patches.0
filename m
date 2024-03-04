Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFDA8F58;
	Mon,  4 Mar 2024 21:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588581; cv=none; b=AypGaOHVAir6+ZSY2q298tP6GjkZ/ThdM8tgeZHA/FUVWPTLX5I7g8p8Dsd4Si1YqTXHwBiQZtSxwtYKpETYGQ/Zl4W4/aKUsdvIbikCFrsYwT1H6vHCZWd9ubycvgRQnaqo6UoGeFRSsyvpw/7+NAPaIY/5TKq3MWpmxKQBYaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588581; c=relaxed/simple;
	bh=+Qx0WYLhXPvs98/WwTJRKwTEokrcvf42j1yfSQPEaQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9+fXVi4msnrrmBtjbARiRDoAg7fu1q7+UeOtkHEJfVbxdqoOA6+TlorioVYAxkHCYRCeAXM9GO5bmNSB5KV4iApIqm/dnQwhfq6IEEmK8nOz44WH0BKuoHM0lxsFRDxat15bLVEXpvuX+eXuIGe+1u8xtyggyjcQZ+xI/NeaN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFAzjcPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFAzjcPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73227C433C7;
	Mon,  4 Mar 2024 21:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588580;
	bh=+Qx0WYLhXPvs98/WwTJRKwTEokrcvf42j1yfSQPEaQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFAzjcPEjQUtoALivYsK89fiyAT69UTErz9v5vswZGVESjZieZNLTEOv9hLsmSspi
	 m0ZIO0xorw4rIAItqVeUo5M/wbnk676BeX7I2q6TuXPcGkxDWa5eFziNlWB2ZOd/lp
	 kJ1uE9/cXKOH9WxpS8zx+oVVfbl0v5At62ENcXsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/215] of: overlay: Reorder struct fragment fields kerneldoc
Date: Mon,  4 Mar 2024 21:21:10 +0000
Message-ID: <20240304211557.237824932@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5d007ffdf6025fe83e497c44ed7c8aa8f150c4d1 ]

The fields of the fragment structure were reordered, but the kerneldoc
was not updated.

Fixes: 81225ea682f45629 ("of: overlay: reorder fields in struct fragment")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/cfa36d2bb95e3c399c415dbf58057302c70ef375.1695893695.git.geert+renesas@glider.be
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index 4402871b5c0c0..e663d5585a057 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -45,8 +45,8 @@ struct target {
 
 /**
  * struct fragment - info about fragment nodes in overlay expanded device tree
- * @target:	target of the overlay operation
  * @overlay:	pointer to the __overlay__ node
+ * @target:	target of the overlay operation
  */
 struct fragment {
 	struct device_node *overlay;
-- 
2.43.0



