Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059397;
	b=GHE1zxHLUTMuku/bTV1UzKnXdtX4qTxYL1sFT+SeDsRZ0cKLIE2fm45i8syeLPVUVfCG
	 NeYjeIqNAUZpGuFgicXjINqbt+WQspk71QI2/SfihJ7yNNmj66WY/lDN2dDZtBb7CG25m
	 RDsc6uxzLhLOaVYz7ZmInEaWYBGkCZb6HUw1ugSKobpnMoJu1wHWhfjPsp3G7rE0X3Co+
	 zQJ0dJ/aWTFB6/0y5laU0f3VEi4p5cxLyJID8CsF6zqM7ZnCGAOZk8pMi4DDlneSkLfsl
	 MU4Iku1ZaYd+tfxgkHhzHkMSBPY/l/FJdtG57leMEqRkh7HFJoKUZLiwHQfSZZoa72A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YLT655YHaY3adUge667eaJH2TphHompXyxsMMVHauWQ=;
	b=0R/p2Ox5TPBSoRbQhCEYgpQ0sZP+17a0jz7WR9jjNPvIuChiSGZNp6orJ9XWjmnuOzt1
	 KGeSCVyQcASBJJMqSIeJceiTkfZvy6DDfGt6UVqJbD2LQalMGMvubrLKzVWaRan/NwuFv
	 dzoHvmjTmCkrcwa5VsK/dseH5FkndCFz+WZIZ9D5zIBnJj3A+HPb/s+7spo7oWgKo6371
	 MpBOtQ9jlyvRLgCWppfb5LtjcRENvM0yEn7eUVoEnQLze6FHryfaq+ynrgyhrKuEJ+aIP
	 08pHUl6iPiSRuqe/By8tfQ204nuZd452NbgBNoH/Ql5ONuM25VpGcgMu3Xdt6iiCj6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpfi97ih;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F57606A320;
	Thu, 19 Nov 2026 03:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpfi97ih
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10F31F000C4;
	Thu, 19 Nov 2026 03:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059397;
	bh=YLT655YHaY3adUge667eaJH2TphHompXyxsMMVHauWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpfi97ih7RApIqQmV3h02FaO5NcXX2vbSPCVBQ/TgJDJad40Lsyu7asOuhKfSIHt2
	 KNIDNYzpdtehQt/svtpxhQTK0RIcm7pPb0RRZ5Kqtb+e5SAFmtVpNH6n/mqpvv4YNi
	 8L26DngWNDQDeeXMAd6LwHCLRpRVwdsTjfjUb280=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0826/1848] mtd: rawnand: ndfc: fix gcc uninitialized var
Date: Wed, 18 Nov 2026 15:47:44 +0100
Message-ID: <20261118145951.311389540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit cceca8cb776b03e83985578f84bd730c30d57f70 ]

Now that this can be built with COMPILE_TEST, an unassigned variable was
found. Set to 0 to fix the W=1 error under GCC.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606141301.iyVdFgl7-lkp@intel.com/
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 0d66f9895f28 ("mtd: rawnand: ndfc: use devm_platform_ioremap_resource()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/ndfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index 0fb4ba93c41e0..b9223cdaa8e34 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -188,7 +188,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 	const __be32 *reg;
 	u32 ccr;
 	u32 cs;
-	int err, len;
+	int err, len = 0;
 
 	/* Read the reg property to get the chip select */
 	reg = of_get_property(ofdev->dev.of_node, "reg", &len);
-- 
2.53.0



