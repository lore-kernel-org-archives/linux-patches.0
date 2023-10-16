Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4211944F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mMFzEYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEAEC433CB;
	Mon, 16 Oct 2023 08:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445858;
	bh=bJS5lhuyNRMqrttmOdC4fKNoIA0EJt4kb5dI5xSeGwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1mMFzEYjVOUr24Z2ARRtSnVF4I96/5nniKtHYLT22WKPJ1sLnh2fCFcbhyMrcFhK3
	 Khn41cxg8zVZ/8um5NA4rV5eMqCGSNNmNtJQEkwzVb4AKrIf2fk+BqaeVC3ZNayH22
	 bAMgNSVOlF00qsXfYezRCNkCyV2F7DIJAStpW0ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/102] of: overlay: Reorder struct fragment fields kerneldoc
Date: Mon, 16 Oct 2023 10:40:07 +0200
Message-ID: <20231016083953.911963846@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ee7f3659b353c..cea5ad907235e 100644
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
2.40.1



