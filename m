Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055823;
	b=W0slzhfVhFa9DWPtTaF7s+t4Eb8imRd8+QUNXIty5t3yoibEJLlgCwrVffY+jRj55Tid
	 L1Keh7Laf6wX3xzmU4ubRbENMktycx4OowEu/F/J/hKjayS7A/lvfRR1xy5CnZNHbo+Si
	 WEZrSRXPenSTPJGsKpjBMGiCl1Bk4Adr7iZw8f3pEC2wPzHKzB5YHfcSCPxEffC/T07j7
	 Y3boIcqsetYbZHCmQSHbnUCMI3UWUrliSYYmR/Bg4ALGmk49lx79Ln1RsDhmotrMW+FGv
	 MgBi58IOom0DcskcZDmTQEneekYOcda/auyzPDPnlv7ORW89n7DLwbodGOpVH+wYjRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QNbEPy4RTRKD39KUdO5te9tTfyFjfD+Y4MFTx2DKGHQ=;
	b=q8WKgV/zP9G/xdggyLoGky/dUAfwCbrfR01U0d107XUev17d4Ake556MIdsZcULzVNMe
	 lRaqldzL1XrcUBOnBl25vRhAGYgEDBkzE12X7QbhgwRB1Z4rPepWVzYLx4RKrlbPnStfU
	 6nMhwmhm2YCoRu4woAQw8S+tPz9u0zdVNlR/luo412bNGDcQiL28kzs6pR1a6Ovx6k6no
	 0dUs0w4DkAZ1QlLHIvYz+Id54lAzDAVRFpcvXg7c85nZQU4QTEI1i3IHK5VqkUMBFQlhv
	 4JPJZd5C45EN3p3iyK4jZCQZGYTsuO3NDgFKKu9ei06F3aeRpt9DQEeWCtQxFmQ2tmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I/ATdzxs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8F9606A332;
	Thu, 19 Nov 2026 02:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I/ATdzxs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1865B1F000C4;
	Thu, 19 Nov 2026 02:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055823;
	bh=QNbEPy4RTRKD39KUdO5te9tTfyFjfD+Y4MFTx2DKGHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/ATdzxsIgfvcsv3z6UE4WAKAqZ1jNpB3yOd9bDI8GP4PL0pVkYYrgM2UiubTsh2J
	 kuVLyQ4Fgc0EDI5+JsDTkUGIsdDolDsEIGOBLvFdAHa/NVEdp1NtPh6OqkxkCFo84+
	 4Pw0OscKxseelnmuCJp9SnvnrKuyUDHsc260hrTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1767/2214] dmaengine: ste_dma40: Validate DMA specifier length
Date: Wed, 18 Nov 2026 15:57:23 +0100
Message-ID: <20261118150122.214394108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 9f1064ebe17cf3ab65ac6eb166398e02678aea33 ]

The DMA40 binding requires three cells, but d40_xlate() reads args[0],
args[1], and args[2] without checking args_count. A malformed provider node
can specify fewer cells, leaving some of these values uninitialized when
the OF DMA core invokes the translation callback.

Reject specifiers that do not contain exactly three cells before reading
the argument array.

Fixes: fa332de5c6b3 ("dmaengine: ste_dma40: Supply full Device Tree parsing support")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-17-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index e5094250b235d..9ac2d44285222 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2384,6 +2384,9 @@ static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
 	dma_cap_mask_t cap;
 	u32 flags;
 
+	if (dma_spec->args_count != 3)
+		return NULL;
+
 	memset(&cfg, 0, sizeof(struct stedma40_chan_cfg));
 
 	dma_cap_zero(cap);
-- 
2.53.0



