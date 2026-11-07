Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063917;
	b=xF3S8y+VPnprbyX561Z3qhq2Eap0v6JR0Pu1qL4/B7BHGl9+WtRiMB6bIHAxsCxsO8wU
	 ZoI7RFMK7CctDs/w7yoN1g0x/nW0lksAS3Kb1wmwplcHDUg7k5qQLAm4jchjbx/ZDJbYp
	 +GdMSYcu9bOdCDhFNPxDLHVMPpmQuCmvSZFizzl/Jv4JrjfFRQbKv2OoqKpQGdQ8BS9OB
	 znjxjyIbTfY3OfCBThqiqFzpYdpHI7pCN6Ay4Q2SASllS600TGgzFlPmXvVIXxg05Z9GP
	 yTEVMmShqWDp3cZR+dKgQ0xAQt2hTObEJrjFcSt20ejDtMB3G7smEzLkwgY6/ib6N9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LrR2YKju0xLBx1/h+99D9X0gC9bm3GvzN3qpDAbmeYM=;
	b=C+2zSKAXp9H1xz1mqCNi347nLYe86XRdH5jnk8IByw+IH0peAPcI8MZ7XWVsxjM22jBL
	 MN3OV093G3+4ZFVdwih7wAZAnLniWuoBtJVxUvLB2IwfdHPph80NOlo/v2qR22bxydqSG
	 Dwhby2IMHqRnpFA1D43Z2I/LRlR3L65WAoEGBZaj5sj7qNfZRa06+htKIWP0YTK2Wb8/R
	 8oLINvS/l1ndEOEdqWyCwAIanNftO5ZW264QzfabpwGZmREHGVLaf6xw1L4qyV53a0M2N
	 Tl7suAMB1Ws4hK+azkrB0Ffrf1OqcNY9mkz0x1QUEDs7UOpcEXyEpLdJ09j14TglAXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zici8ggh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34238606E8E9;
	Sat,  7 Nov 2026 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zici8ggh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D981F0089F;
	Sat,  7 Nov 2026 15:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063917;
	bh=LrR2YKju0xLBx1/h+99D9X0gC9bm3GvzN3qpDAbmeYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zici8gghXZrtwZeu+DBnfO3ymtSgNpAFkY4I9SgL0yuo71ZQs7MmRrxs46OqQ5klg
	 IOBHJM65mkAJFFqzHHvOzC27VEk+betjkCSEtvv4wy1iOpNGItOV7UCxW7vAPR9+mO
	 LjGkiOfW7uePRKwNksVA2/oEhwkRu0WBdVfT14+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0113/1257] media: microchip-isc: dont sleep in the clk .is_enabled callback
Date: Sat,  7 Nov 2026 08:40:09 -0500
Message-ID: <20261107134942.470824477@linuxfoundation.org>
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

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 61490ff518c7b3ea3ff1cd16bbc012e9e4f1ab74 ]

isc_clk_is_enabled() calls pm_runtime_resume_and_get() and
pm_runtime_put_sync(), which can sleep and are not safe here, as
.is_enabled must run in atomic context. clk_disable_unused() calls it so
at boot, and CONFIG_DEBUG_ATOMIC_SLEEP reports a "sleeping function
called from invalid context" BUG.

Use the atomic-safe pm_runtime_get_if_active() and pm_runtime_put()
instead. A suspended ISC has its clocks gated, so report the clock
disabled when the device is not already active.

Fixes: 01192aa1c5c2 ("media: atmel-isc: Enable the clocks during probe")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/microchip/microchip-isc-clk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-clk.c b/drivers/media/platform/microchip/microchip-isc-clk.c
index 24358d804e75d..66dc522a61908 100644
--- a/drivers/media/platform/microchip/microchip-isc-clk.c
+++ b/drivers/media/platform/microchip/microchip-isc-clk.c
@@ -98,15 +98,14 @@ static int isc_clk_is_enabled(struct clk_hw *hw)
 {
 	struct isc_clk *isc_clk = to_isc_clk(hw);
 	u32 status;
-	int ret;
 
-	ret = pm_runtime_resume_and_get(isc_clk->dev);
-	if (ret < 0)
+	/* Runs in atomic context, so must not sleep to resume the ISC. */
+	if (pm_runtime_get_if_active(isc_clk->dev) <= 0)
 		return 0;
 
 	regmap_read(isc_clk->regmap, ISC_CLKSR, &status);
 
-	pm_runtime_put_sync(isc_clk->dev);
+	pm_runtime_put(isc_clk->dev);
 
 	return status & ISC_CLK(isc_clk->id) ? 1 : 0;
 }
-- 
2.53.0



