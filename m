Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058643;
	b=ahiy4Un6vNrBco01BTRwhz6A2fwvEmQdeitJeRp/wZd9BDggky8SxmJe4f7DKOENVlER
	 kgokRROpwVDBDvDJOPCsLBbNC53fDcuKkBWdVRr9ZsWPoNS1rMAccgoqkELzwYsHcmdCU
	 0QvX7smltSpZTIqPgNSuArIoDVwNzpgJlrUt86PvsQZkUM0AQGDkjkOVD6NyVjb6kjGPL
	 bJ+Jb0t6hmPFr7hugQdCVOf53y6AX5vsdQHpz9rE3w/MNQk7iRlRqqkCaLbwcvSV9934m
	 VL8iBOduYZutV7AnyMM/8qize21F9bnFfc160dsulH8hpNVi6IRdkcGw2qkLmSjeVAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EA6GbIzZc7JTcjnp0NHeBxgc/S7a32WdQyJXr7DQyg8=;
	b=ZTtNZFRZv3O9I019C0FJb99AVHkxwjra2kQ8NrDGNvs+20lyrKXgn6DvdFFwwzagMNbE
	 6dEuvG78AZHNFy1uddnRbe49E8QLM5QBdaL4Cc0YW1L/DoLkDV/HNh/QX5FTeIxyv0yO5
	 M0+5uXjcWV67zL5octYsohGJ+KlJSg2RNIi0ioYxbTNJvSElYilPAwNxESQEgShA2fKL2
	 Dop1KPU6tjsWL9g2rujzBkwyC44g93jzsuI9K+fOwb0zJI7e9TVTel/FRTe/VQFfy+M6e
	 TAI+apoA9k1RA+b854yeN8nyeOIwA2IsiPHv3u9PkxRJhECdeqfQW2dEOj4SO49uSKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2a8rvHgW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB16606A31C;
	Thu, 19 Nov 2026 03:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2a8rvHgW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F531F000C4;
	Thu, 19 Nov 2026 03:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058643;
	bh=EA6GbIzZc7JTcjnp0NHeBxgc/S7a32WdQyJXr7DQyg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2a8rvHgWY00KDJa1z6GpToo8TpNE3Ih7XoV29BzqGRvJP5M7ubetgevWYRxLfiNqj
	 2T0zCzq4H4yQq3h8pYFOWaqVHrgFT0lh9Bwj6/Khy9mZNtDidsygToNSEtSR+O/wZ6
	 UuoPevo1KqhviVVdZdVxtGN5bBPeLX2qIvh+LIUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0558/1848] sh: maple: Use the matching IRQ cookie when invoking free_irq()
Date: Wed, 18 Nov 2026 15:43:16 +0100
Message-ID: <20261118145938.250820143@linuxfoundation.org>
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
index 44a931d41a132..ad6f4724f0189 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -871,10 +871,10 @@ static int __init maple_bus_init(void)
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



