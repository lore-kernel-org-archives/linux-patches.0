Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045708;
	b=1bTJBeMoDd4YQ2Sps8n2oZ3r5gXduI48lSmBbO6r9AuV+028yJAeIVXFBO9pKF/bpaaq
	 eMTvJQjcmJFhOUjspG9HuHbBUAc/n7qD0bimP2uOQAyNC9JZefYf9sOSNv4A+ijXLV1R2
	 FRMiCFzmYsW0bOpTUxNGlxKnF+xVekU/pgmgv393mKIVhRYv/CTIcQo2unQLqqoY6CKhV
	 izV6guw3UrTOquEVkyKSGL5DZGaL3yTh+oOp4Y1SX0UdWboNv44MIV8NzG8dib8b3z0Wu
	 MUjJmB7mZP7G0V/MRfZyncG9wBPlbjrImEtVMMJybgh7eHZT0pAgjiPbvLY5E5QtCaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ufcleh5pCYVH4Mz2CQR/cMFxGsQz6aIFCoOJv2u/m6s=;
	b=EwHiVDFfQvRZa8S/sNIHPThASlA/yl2v5wJzLPDgmAqOE4ElB/SsojyYv/hjYXaPjdey
	 K8Anc2c9IBJ3fAGCrNDIod6JcfV0a2UdfUiyNHNXDBfrH1SXqTCBa8EVMZsDOmm9CsDAC
	 9qnVR3dF0aXKF6o62JR8W0qX6Hqf8ejVNd6LPanu5KYp6ldnMFj9m1nHQRW43x5NVLUEo
	 T8Ufadq+nLN98rMEykC18w9hmpDm2p5mkKBgofwxoXRj8YBQhcUcrVFhiVr0P5s3fV8ah
	 gFIqCrZTyF6PY5KISp3o6NSbE9mNEtC02eQCfxr2Y1N1oweB1+Mr2AP4CanRb+UK1TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZsDKzjcw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FB9606A32C;
	Wed, 18 Nov 2026 23:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZsDKzjcw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9D91F000C4;
	Wed, 18 Nov 2026 23:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045708;
	bh=Ufcleh5pCYVH4Mz2CQR/cMFxGsQz6aIFCoOJv2u/m6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZsDKzjcwKsF4F0+JwcWt8QmBYo8ixg+1vXX8zHjmpSCMFVUF6nowdxNHkohRvuk4U
	 sDHbyMF9/Aukjv+OWsDIftvoVJwyzN9tKTXKMa642MhxMR6MtTjk0z9lowM3i4ee5c
	 2yfT3Q2V1LXiWkIoVFLW+uGpfafEQMeaErE46FyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1019/2857] sh: maple: Use the matching IRQ cookie when invoking free_irq()
Date: Wed, 18 Nov 2026 15:34:13 +0100
Message-ID: <20261118150238.289408762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit e3ef44e77b40e3cecfb34757ff3c15ecceea0309 ]

The Maple DMA and VBLANK handlers are registered with
&maple_unsupported_device as their dev_id. Passing NULL to free_irq()
cannot find either action, so the handlers remain registered and the
IRQ core warns.

Use the same cookie when freeing both handlers on the error paths.

Fixes: b3c69e248176 ("maple: more robust device detection.")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Tested-by: Florian Fuchs <fuchsfl@gmail.com>
Reviewed-By: Florian Fuchs <fuchsfl@gmail.com>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/sh/maple/maple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index e24e220e56eea..398043a4e8705 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -870,10 +870,10 @@ static int __init maple_bus_init(void)
 	kmem_cache_destroy(maple_queue_cache);
 
 cleanup_bothirqs:
-	free_irq(HW_EVENT_VSYNC, 0);
+	free_irq(HW_EVENT_VSYNC, &maple_unsupported_device);
 
 cleanup_irq:
-	free_irq(HW_EVENT_MAPLE_DMA, 0);
+	free_irq(HW_EVENT_MAPLE_DMA, &maple_unsupported_device);
 
 cleanup_dma:
 	free_pages((unsigned long) maple_sendbuf, MAPLE_DMA_PAGES);
-- 
2.53.0



