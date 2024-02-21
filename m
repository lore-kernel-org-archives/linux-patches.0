Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2891A4D5B7;
	Wed, 21 Feb 2024 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523108; cv=none; b=UUkYBoG2wtzXvpBcNuv8bGolksMxwh6IeLE42lfPLEFegj+Ok5/U4o1VW6WeRI5aKo8IGpFmBjhwl6Ygamibh7+ziNCSZUrhUY7M12KO5mkJRNrVJRzgP1fKP4X4f8kL9enH+Hr3qWKSsrl3FWh5yCiE/dwqrxZfyxaulmwcjZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523108; c=relaxed/simple;
	bh=dEJV8sy7+yarFpT3R8SnM7/FJyfOADL6drXpneSudds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjX+oA/FktrSCcqHUQ+WipfSfBgryBvkT/tGLEFWeohbewRiCEQHZ3o0PlXRjLibETH9J+NQHmFGt6Fci2LyAyh7y4Z91K08yaEpRIH24O2YBgMFBilRxSiiJPxcbvcziAqlhGLfXF5wFStsyeJus8Tv+ptAJ1IKE8nb/z9HPYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8S0CsFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8S0CsFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B151C433F1;
	Wed, 21 Feb 2024 13:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523108;
	bh=dEJV8sy7+yarFpT3R8SnM7/FJyfOADL6drXpneSudds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8S0CsFVdvEKSMRpTvCU13xL8h+e2mmHwurmFkUidVk8+H5LM3/O+OV7xsA/6wfDP
	 jbVhL3Jdx0zNalhk3NxzdSU5rx4JowNHF7ElwT0ug7evUCW3lP+otBB94TdwQZAI1b
	 c7YF5ybnqKJUXhv8GMbl26rSSc2Mmxk6Er5vhSWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furong Xu <0x1207@gmail.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 342/476] net: stmmac: xgmac: fix a typo of register name in DPP safety handling
Date: Wed, 21 Feb 2024 14:06:33 +0100
Message-ID: <20240221130020.650548163@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Furong Xu <0x1207@gmail.com>

commit 1ce2654d87e2fb91fea83b288bd9b2641045e42a upstream.

DDPP is copied from Synopsys Data book:

DDPP: Disable Data path Parity Protection.
    When it is 0x0, Data path Parity Protection is enabled.
    When it is 0x1, Data path Parity Protection is disabled.

The macro name should be XGMAC_DPP_DISABLE.

Fixes: 46eba193d04f ("net: stmmac: xgmac: fix handling of DPP safety error for DMA channels")
Signed-off-by: Furong Xu <0x1207@gmail.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20240203053133.1129236-1-0x1207@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h      |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -283,7 +283,7 @@
 #define XGMAC_TXCEIE			BIT(0)
 #define XGMAC_MTL_ECC_INT_STATUS	0x000010cc
 #define XGMAC_MTL_DPP_CONTROL		0x000010e0
-#define XGMAC_DDPP_DISABLE		BIT(0)
+#define XGMAC_DPP_DISABLE		BIT(0)
 #define XGMAC_MTL_TXQ_OPMODE(x)		(0x00001100 + (0x80 * (x)))
 #define XGMAC_TQS			GENMASK(25, 16)
 #define XGMAC_TQS_SHIFT			16
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -886,7 +886,7 @@ dwxgmac3_safety_feat_config(void __iomem
 	/* 5. Enable Data Path Parity Protection */
 	value = readl(ioaddr + XGMAC_MTL_DPP_CONTROL);
 	/* already enabled by default, explicit enable it again */
-	value &= ~XGMAC_DDPP_DISABLE;
+	value &= ~XGMAC_DPP_DISABLE;
 	writel(value, ioaddr + XGMAC_MTL_DPP_CONTROL);
 
 	return 0;


