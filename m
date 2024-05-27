Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775AE168C4;
	Mon, 27 May 2024 19:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837648; cv=none; b=ahZhoIe27GuXxFwS+LwyEWc/oq3N9egLtiovOyRsCfET3dsia/yDzS66WIVH+KQh5ZcQsM7rywZ5fV/nlK5Vt2uiA6RNfYYz86bHuMgs15f4VhSZuaYON85UYBJXnyCGeioVngJG+pPRSbfGPMr7pBJT9B/ciqiGLXKH1SQrFV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837648; c=relaxed/simple;
	bh=yl6MdbfESLGKTJOUMqFuZ3UFyEKvoXMEB1hHN4SnzX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKoaz1489dYl/GcR27+dGH18ZUWkjNGcdlUt6gajihW9d36HLFS0H2SNzStIWzfynAl3ouUv6RVWwdxPbNX2hG4F9g8ZKu1v9d+Snq6kFLYZ46J6HHV8WV2hQiYoUB3Wnm010Pu4Hic3f96F9J+VP+dqBd1eQlCSeyXI8QpPmG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdA3x5F0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdA3x5F0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AC6C2BBFC;
	Mon, 27 May 2024 19:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837648;
	bh=yl6MdbfESLGKTJOUMqFuZ3UFyEKvoXMEB1hHN4SnzX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdA3x5F0JwEg5Fzyqv26edovkKFFXAr24sjJ0js0S5Ud/3A9r7K7CGG+Sjwc487Zb
	 mO3NkK4rBwAklAgJMHMVkeJvMhmsIHSWeehuqhHM0RUQxdSQy9F2AA2Chge+9DvJ5h
	 16XnYZpxQCfGeTHA4PGRrdYVharf+eFX8FDOF7Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 040/493] dmaengine: xilinx: xdma: Clarify kdoc in XDMA driver
Date: Mon, 27 May 2024 20:50:42 +0200
Message-ID: <20240527185630.085319039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 7a71c6dc21d5ae83ab27c39a67845d6d23ac271f ]

Clarify the kernel doc of xdma_fill_descs(), especially how big chunks
will be handled.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Louis Chauvet <louis.chauvet@bootlin.com>
Link: https://lore.kernel.org/stable/20240327-digigram-xdma-fixes-v1-3-45f4a52c0283%40bootlin.com
Link: https://lore.kernel.org/r/20240327-digigram-xdma-fixes-v1-3-45f4a52c0283@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xdma.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/xilinx/xdma.c b/drivers/dma/xilinx/xdma.c
index 5a3a3293b21b5..313b217388fe9 100644
--- a/drivers/dma/xilinx/xdma.c
+++ b/drivers/dma/xilinx/xdma.c
@@ -554,12 +554,14 @@ static void xdma_synchronize(struct dma_chan *chan)
 }
 
 /**
- * xdma_fill_descs - Fill hardware descriptors with contiguous memory block addresses
- * @sw_desc: tx descriptor state container
- * @src_addr: Value for a ->src_addr field of a first descriptor
- * @dst_addr: Value for a ->dst_addr field of a first descriptor
- * @size: Total size of a contiguous memory block
- * @filled_descs_num: Number of filled hardware descriptors for corresponding sw_desc
+ * xdma_fill_descs() - Fill hardware descriptors for one contiguous memory chunk.
+ *		       More than one descriptor will be used if the size is bigger
+ *		       than XDMA_DESC_BLEN_MAX.
+ * @sw_desc: Descriptor container
+ * @src_addr: First value for the ->src_addr field
+ * @dst_addr: First value for the ->dst_addr field
+ * @size: Size of the contiguous memory block
+ * @filled_descs_num: Index of the first descriptor to take care of in @sw_desc
  */
 static inline u32 xdma_fill_descs(struct xdma_desc *sw_desc, u64 src_addr,
 				  u64 dst_addr, u32 size, u32 filled_descs_num)
-- 
2.43.0



