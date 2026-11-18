Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053839;
	b=kADW1DLY6BcTd79b7pifRyzY0YyWS1MUlvsGJ5Hp3SVIhCTzRmN1PkWsAhFmMlCXBZA3
	 G1yg3SzAXGfy5SHhG3/1pZEPzwpPHS2QuG3M/IJjKX7BnZRiUHLNAZcw2D/1rXIEVlyQ3
	 0WU/ZPzmcx5sB8ZSALsygc7RVhcpwJKLBPaMirGvNioHzzalMKlTnZgM0Q8XX9irDXGFJ
	 1/GKrqqOPtgIGLWJ4y5YBQptFqqpEB+wvbTtX7yZqbuNMUWse5osAeJA14zFPajYIURtX
	 lsQDgDmCWQ1sSCFcCZuuPxkVICtBRZToqlOY243jitoJC4gx6czqVET4fYvZU9vlXTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NSozQIe08v69xYUAOhf27YlchlZP8HKMuhqxZ8Ymz9g=;
	b=Fyqvl9TAA02fAJYjlYBq5ItgZ9c6QF46Wi/OBmoEUecZrP2dZ3nMhI4f7nzOPF7FtRnb
	 wveii4X46TppmznmYSPrIYsWiA6ZN3qt9p4ziXScL4Shbbw+ISXoRbViqtUSHUrBkF4Yv
	 fur0tyfe2i079Leks/NMNophVnZzZgfRjuWBplgHcl1GK/cH2tOILdhIkR4WD8pYCny0c
	 HH/o/kxB8eDJ1eSD1uGpcLEdgGHO1hBIYcyqO2/D5hE7+JMeVAJpUN0MawYn7JyLc54Do
	 oQvMwy+5C9S/9v+WgOvy7VupdXNYL0rvdeZFD7p8U7JLElXscoFJM6VZcNcvbPnysxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7ae+L32;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C9C606A31C;
	Thu, 19 Nov 2026 02:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7ae+L32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27C21F000C4;
	Thu, 19 Nov 2026 02:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053839;
	bh=NSozQIe08v69xYUAOhf27YlchlZP8HKMuhqxZ8Ymz9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7ae+L32DLqGr1Le2kH6sFMOgZJ4FYpdhrtxHai4q7Xj+3pJY/MihmpC+2Nb9CnJi
	 bh6snLL5uFSlY9zSWoSz/trM2Du6paJL2yLWVp24rwbv2fNAZ3fGfHsqyjqwKtrvwJ
	 Xi6wZB7AX3u6TuGDfvDZlljNruVXxRLNZwQixVl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Jacob Chen <jacob-chen@iotwrt.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1060/2214] media: rockchip: rga: fix clock cleanup
Date: Wed, 18 Nov 2026 15:45:36 +0100
Message-ID: <20261118150054.706395420@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 254f3337ce2575bf94f1fb40cc40fdbc70371116 ]

Fix this smatch warning:

drivers/media/platform/rockchip/rga/rga.c:734 rga_enable_clocks() warn: 'rga->sclk' from clk_prepare_enable() not released on lines: 734.

The reason is that aclk should be disabled/unprepared before
sclk, instead of the other way around.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Jacob Chen <jacob-chen@iotwrt.com>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: a875c43dd95e ("media: rockchip: rga: quiesce IRQ before releasing m2m state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index bcbbd1408b368..02c2ea2b42a50 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -717,10 +717,10 @@ static int rga_enable_clocks(struct rockchip_rga *rga)
 
 	return 0;
 
-err_disable_sclk:
-	clk_disable_unprepare(rga->sclk);
 err_disable_aclk:
 	clk_disable_unprepare(rga->aclk);
+err_disable_sclk:
+	clk_disable_unprepare(rga->sclk);
 
 	return ret;
 }
-- 
2.53.0



