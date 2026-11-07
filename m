Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065213;
	b=aR82tsTzvBUL92DSjq018qs6D5svss2Lnaf9rUfeCe/PVgMUmaFkbcFB482i2rCjb03z
	 QdC0dOg+zAST81JrvMpiUQMfd1UdzqCECIBR7xkIUSZuFveFGpBWbynnWIt2EWgzxuCrj
	 GhnSbL/SDCxHYjJnJHyHdcC7w6uc8qBiqWZsddtg4Tly4lJH/gUa2ZWKwGP3STKwb3bfu
	 S9fdnOp5VFR0EFjKU/lK8Y3p/HEKyuWmFO0og20vQZGCB4KkhgavvEyGuiEQFHwo5UGjw
	 ce8CeI3a3NiXBMjR01ySnMxlYJn0pu432FU8FZ0kG/B7VScjMsMv45DKgX+heL9+XOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V178NgMoakyWdHFKRUSNegemQA5VZtNdZT/EOejdGHo=;
	b=DP99xkZcRtGo79Uo5Lsz351es50K403w8dE8dfIye7eCw1C7ETPy9aFwpYHjulWYJ/zE
	 CE108D6mdBQS/Tb5J5AYDSWx18QQy70uus1v8TW1qxydJDauFTfbUpaNubpotRtktg7SK
	 r8AdYx4Q1zI9EFX4CfgIkyU3vZi6F/DUz2lF+N0zMotWtQDRIPeijuF07H1nWAB2z8wa5
	 O71Ot9d3xjkm0hm+K2oY04aYTt77RNWUbezF0Cut7eZDEWGLJJ4A5MYHIxYDWa1FXvRju
	 7y137EjjHKKLaURKutK2y2xunbpSWvw0QXcspHqCdV91BS0kcSAOLAWvEpWou4BuAVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uq6ggGQq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC03B606A331;
	Sat,  7 Nov 2026 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uq6ggGQq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5161F0089F;
	Sat,  7 Nov 2026 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065212;
	bh=V178NgMoakyWdHFKRUSNegemQA5VZtNdZT/EOejdGHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uq6ggGQq6cN11gHOrDGraBRQaLdylbGu1mSONHVH/fmfTQx6784s+n5Un91Q7spTA
	 Rui7UC9fbRiGzD2Ek/NH2N7ujaWjsUtTa+kjk8u2iJyrGF30RnIp91n378gF6QOnVj
	 oe2wofll+rTvCJQEoSOtbOofdKKp/dK39gHiiiSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1007/1257] sh: maple: Use the matching IRQ cookie when invoking free_irq()
Date: Sat,  7 Nov 2026 08:55:03 -0500
Message-ID: <20261107135007.155730552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 5585f220e495c..7df88e00c20f7 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -863,10 +863,10 @@ static int __init maple_bus_init(void)
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



