Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061554;
	b=F6TaUGRPheAuF9MIq9x8ibeIblJuH/eBcSNIdqREH/6wur4gYSIgqbi4LYL7ortuiXGp
	 6Nhgw7rc4HyfE0QNuFuA+q0iHxYqge4TVNZukVwUIy2XCC6AM3aIoySQNksi5Y9RIKDo1
	 D/RTcdP0dFHJ5A87awNMer29YLT6qbijPtv/wc4pRo2sW7y3prH8D7g0VryCnJzyy3Pak
	 Zgsvs5KEOVfuweKkBjMdeptuMdpw3Fkj84/bXJKT9HfCqBHPngAOWU9Jm/Q0X/Nt42mNs
	 zCdRbT36+JLX/gpWFl2ElaoYiTwMU3mbhQPbCpjpUQWif4fPiebDLV4v3qlEa0WGwVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fF+/2E9j16PCeSL3e16jJMaQ0W0xXGWY8JdSZQ6TQE4=;
	b=1EMUZXDqtiqQ+oY2AIUpCyNLoNuFYO6+JkZKm4dVWvikpj6A9A4QtZdIyrer4s4m4uLe
	 SAvtxPSLfDhR2TNLxDJAI0fFm8LAybtTTgdxKX8EJVx9O+RCoikpyrN6npMcXRQr0g0Lx
	 ySotNdAAiXd6dLodq+pyMOToLuaYS1V7iL/PGEMdpEh/L68XNqvO6vnTPY9/1Voyd/fMw
	 VjKSaf5/kxepMPrdLdkT8LMUr/bq1b/WnItYVKmNVkpIKqanricS7RkyPScEu7n578Hh/
	 xi/xqeOK6ZWNLZC6l5Fd9IxvnpL4K63ECPVBA7L3xPN7R/itc4FXF6m2IMQw5qt9PMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVGIAL7g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15608606A33D;
	Thu, 19 Nov 2026 04:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVGIAL7g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668021F000C4;
	Thu, 19 Nov 2026 04:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061553;
	bh=fF+/2E9j16PCeSL3e16jJMaQ0W0xXGWY8JdSZQ6TQE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVGIAL7gA2YTtrOeZpYs8NSCuXUfCZHRVAyEQDyOkQ/NXV2Vzc7ga/IkcDqGNYA7V
	 gU8wLO1L/pE6Q7uZstdYPZAGrQzF/NXcUCQYnwmddI7b56gvd02/J2X238oMOuG41A
	 l5Ffrrdo4rVSVsrTpi5fnCR8+FGqUO+q/KNYKuAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1592/1848] net: alacritech: fix dma_free_coherent() in error path
Date: Wed, 18 Nov 2026 16:00:30 +0100
Message-ID: <20261118150026.158014103@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 05b5019b01fb9443b09ae4ed34af1135a80a84c8 ]

In slic_init_stat_queue(), a series of coherent buffers is allocated
with the length size. The size is then stored in stq->mem_size for
normal deallocation. However, in the error path, stq->mem_size is also
used but is not initialized. This error may leave the freed buffers
mapped, leaking a resource and allowing the device to access freed
memory.

Change the length in error path to size.

Fixes: 60c140df15db ("net: ethernet: slicoss: add slicoss gigabit ethernet driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261006140912.50828-2-fourier.thomas@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/alacritech/slicoss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index 696517eae77f0..7b4af9303026b 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -813,7 +813,7 @@ static int slic_init_stat_queue(struct slic_device *sdev)
 
 free_descs:
 	while (i--) {
-		dma_free_coherent(&sdev->pdev->dev, stq->mem_size,
+		dma_free_coherent(&sdev->pdev->dev, size,
 				  stq->descs[i] - stq->addr_offset[i],
 				  stq->paddr[i] - stq->addr_offset[i]);
 	}
-- 
2.53.0



