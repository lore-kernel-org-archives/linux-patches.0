Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016303;
	b=WwFG21F/rmhVieMLblO4aDDA2cboYE8DYeTP4QctaswuSV2sok18P3G0b0HfNqJAOiaU
	 wYiXCKar+rU8XEH0edP0OLpTAK01A9UM9b5z7Wwcnx4kBt3nd6ZW0KxUD2+IcjqSASmpR
	 bRCxicbvTIGl4TK7I1AiruJlFWym0jdpyT2+E3tHztD5D+51+bvjKGXsqq/ZxKwTl9RaX
	 tNAJcrGvg1VEcCOSoDR3FswPtlRD7CyFGNWuvgqRXWTSFOn+B22NusSFPgBHkYA7ohIXD
	 wDsF1Q+jAKfvXDSlfp3NRacduUdJ5Y/Gq/VmDbrYr3rVvZqoxTTBeLT0me0n14UKEiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jqkAmuvuzPHKnDsjMx2pzCohzN0BoE4M5ZILgTx/2Nc=;
	b=Sx93Mcdvx5ahbSG2xp9gbN8yGEU8yiwlQQgUr0f0Y/V9MjdzEgkNBojtXxjLKVPFGnCi
	 KG73hEruIwTOCuKa6mMBNIyxxFaLqpMmNlNpKs8ZEiTmn84O4A4SBAr3twXmSXFRyo9+E
	 yoqJLzkoJ/hn/LdlDhd6GM45ycCEnBfprX2UlYjcxjWljRB/n+YaGyJ11wMAcLu01rBHA
	 VGyfiJ9A08Y8cXvN874e2eMj53JhnwkOLNSHT1bpebRdIkjCuQQsAG6gJKsoCu1ZSATv6
	 2GojIWswuo6DYQgLkq3e5xkNVeQyETj/2lul8xhZETWnqy4CScxpyzTrWcnlRY71eXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fh1ivTDF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A4960A3833;
	Wed, 18 Nov 2026 15:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fh1ivTDF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76981F000C7;
	Wed, 18 Nov 2026 15:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016303;
	bh=jqkAmuvuzPHKnDsjMx2pzCohzN0BoE4M5ZILgTx/2Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fh1ivTDFHX22MTLXmGUjk1t0jm5Xy8Kv6ly+Dg+R+k6uv9to1o8s5zBwvVzHJltvG
	 OAfHwVovJe7JPInyXDtSc1NpYq/vc7nhLs7/USY/vuJqQx/KT0JSjhdgv4IHsYX7+P
	 opvIKuihQdADP/bw6udnkGDFJVWfwtvHZvP+UR5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0482/2651] dmaengine: mv_xor: kill tasklet on channel add error path
Date: Wed, 18 Nov 2026 15:28:42 +0100
Message-ID: <20261118150305.133151479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit bcb4d469b19d53dc21e4a1da12d4438e7489e150 ]

If request_irq() succeeds but a later step (self-test or device
registration) fails, the error path at err_free_irq frees the IRQ
but does not kill the tasklet.  A previously scheduled tasklet can
still run after the channel is freed, accessing freed memory.

Add tasklet_kill() after free_irq() on the error path.

Fixes: ff7b04796d98 ("dmaengine: DMA engine driver for Marvell XOR engine")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260909234601.101883-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 25ed61f1b0899..24f22db5dfa11 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1162,6 +1162,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 
 err_free_irq:
 	free_irq(mv_chan->irq, mv_chan);
+	tasklet_kill(&mv_chan->irq_tasklet);
 err_free_dma:
 	dma_free_wc(&pdev->dev, MV_XOR_POOL_SIZE,
 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
-- 
2.53.0



