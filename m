Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040869;
	b=34zINkEnv+sOWp6Wev/7HP/6yffbryeBRUyh+t/faad/haObWs6MWUWgoVYfFASegoep
	 ojo8z5IM2Z58ehnArRoVwxbdV1+g00tkKwbPU5hg0rUvIuR6J23hkTbp2buCjPkSx7UIi
	 RNonBmXiYcodNi0EFKLkkARB50H460U02398Q+41mMj4ANAaYvYNTYREplcAVa0dHZWrF
	 VNcEH5td6Gen98hyDxAUOUpBBLCzPlX8MTzTSZYfbDaP3uikbr/HdCXTkvSPqOQrNzvhg
	 FWGkHE8eOwq67gNhr0493j+hzntplXBBdpYZPXuX2Ci6JfJcGMIJBQmWcJ5BeZqjghw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4+m4pQNlnyj+XoPwU6I/IOyCZ1mkVidb619LuXdPq/k=;
	b=Sccdtg0gm4sH2XsDwIMDdX28d3xXJY+N6/V1gYIurOjL34EuMb8djkZ7akP1o5DFd+MD
	 AgBzBds4uD2l8el+sFgEVRQXBfluOD3J11KRdUmvv/Z84cadVA+kEyQYHBDzqR0J0wgDE
	 bsPfX/kMHJ9PmCE4N0MDqjzSoimIK//RgKI+HysEgdozb7CERiENvHDeaBzlBClP8c5Ht
	 XEfrlsYSR5bd2jBCWtxwR2hyAgILxd9V+usOBSLEqJeoHdagK0ym2XkimoCHUTxWa1eUu
	 AEiXwVuIp3hqFpHbkep5ONE7d0xWjC5CLlAjr2L8hbTyFjVt4Q0DJY8WF3W/5DubKCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rvAd8LuV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CEA606A31C;
	Wed, 18 Nov 2026 22:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rvAd8LuV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB361F000C4;
	Wed, 18 Nov 2026 22:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040868;
	bh=4+m4pQNlnyj+XoPwU6I/IOyCZ1mkVidb619LuXdPq/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rvAd8LuVd8njRrWgcLI1plPNqGtwqKz4OEcB8P3OtLeWAKt/i7JU7phb1bUYD7ihn
	 8u7EjZh4nnv7/88Lj4+PTE11wwD5UR+/BOHjINmnYnhRBuyKkQ+70q+/SiCzYBZ5vs
	 3sULqQfXUOy1E8E7waDVygRBLbdfDqAjYiGgV7IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2610/3318] dmaengine: ste_dma40: Put the LCPA SRAM node
Date: Wed, 18 Nov 2026 15:53:52 +0100
Message-ID: <20261118150439.440803450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 9a3762b470421658214baeb6cce3eed7344bb435 ]

of_parse_phandle() takes a reference to the LCPA SRAM node, but d40_probe()
does not release it after translating the node into a resource. This leaks
the node reference for the lifetime of the system.

Put the node immediately after of_address_to_resource() so both the success
and error paths release the reference.

Fixes: 5a1a3b9c19dd ("dmaengine: ste_dma40: Get LCPA SRAM from SRAM node")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-14-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 066188e289286..55b4728aaad97 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3579,6 +3579,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	}
 	/* This is no device so read the address directly from the node */
 	ret = of_address_to_resource(np_lcpa, 0, &res_lcpa);
+	of_node_put(np_lcpa);
 	if (ret) {
 		dev_err(dev, "no LCPA SRAM resource\n");
 		goto report_failure;
-- 
2.53.0



