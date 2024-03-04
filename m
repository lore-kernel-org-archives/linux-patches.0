Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5216F1C680;
	Mon,  4 Mar 2024 21:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587912; cv=none; b=jem6ygWUPvqJxVkYckOcqjoOsQrxEf2xioD8n/xHYJMz2oh6YwPkpG8xTxPmlsmWz5A9AEx2eSf2dTYJIRgVJuaFTrw1D3rdGrtOUw+dGFR79u0IdXopN9uwTbW9u3yABJfehXEIABNMPgH2vvO8N8tDOl3ChvhrOJsn87nFmf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587912; c=relaxed/simple;
	bh=cwVWzSvnpztWNlsDFv+6u8+A+NyXtSLJJdAGTJccr0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luJ8ZQDbeCXdAJMc6xUDo6O++xivLCu9dsHOr3MvD23rTZ2uca/R5Iz/efCIY5XvXxLrf1ZXhtVyQDHQVCZu11jrHRZ6G2+F9V4Jte2FrwId+l1vjrSiTMzb95NcxR3yioZFuUfrjyMWcfZkLLq408lZozsl9zTYrzHXC6qhqTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZt/BHTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZt/BHTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A9DC433F1;
	Mon,  4 Mar 2024 21:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587912;
	bh=cwVWzSvnpztWNlsDFv+6u8+A+NyXtSLJJdAGTJccr0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZt/BHTjCAAzARdX8RR0bCi2g531mOiuDnbAIx1aItnV2WBaOy3hyx1OgXQl7oABj
	 GuHn4Ahf0azhnJfVOuOsWnjJCpF1pahyv2PoRZ/7GebxZjyLnLZTnlEfiRXJA1RoDU
	 8XtNzBZbSeO4v1taE5JUX6MynjLcqG85ZVdlxugI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 137/162] dmaengine: dw-edma: HDMA_V0_REMOTEL_STOP_INT_EN typo fix
Date: Mon,  4 Mar 2024 21:23:22 +0000
Message-ID: <20240304211556.107982200@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 930a8a015dcfde4b8906351ff081066dc277748c ]

Fix "HDMA_V0_REMOTEL_STOP_INT_EN" typo error

Fixes: e74c39573d35 ("dmaengine: dw-edma: Add support for native HDMA")
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://lore.kernel.org/r/20240129-b4-feature_hdma_mainline-v7-3-8e8c1acb7a46@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-hdma-v0-regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-edma/dw-hdma-v0-regs.h b/drivers/dma/dw-edma/dw-hdma-v0-regs.h
index a974abdf8aaf5..eab5fd7177e54 100644
--- a/drivers/dma/dw-edma/dw-hdma-v0-regs.h
+++ b/drivers/dma/dw-edma/dw-hdma-v0-regs.h
@@ -15,7 +15,7 @@
 #define HDMA_V0_LOCAL_ABORT_INT_EN		BIT(6)
 #define HDMA_V0_REMOTE_ABORT_INT_EN		BIT(5)
 #define HDMA_V0_LOCAL_STOP_INT_EN		BIT(4)
-#define HDMA_V0_REMOTEL_STOP_INT_EN		BIT(3)
+#define HDMA_V0_REMOTE_STOP_INT_EN		BIT(3)
 #define HDMA_V0_ABORT_INT_MASK			BIT(2)
 #define HDMA_V0_STOP_INT_MASK			BIT(0)
 #define HDMA_V0_LINKLIST_EN			BIT(0)
-- 
2.43.0



