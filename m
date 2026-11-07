Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062796;
	b=MUh/Muk826HU9xaebEzylp1G5791SK9FpJ5C+qjWkIvCC03H7cIRrEXMG82AASKDfHYt
	 9LV7GTNEp77M579+o/wFG4YTxQaCE7mAz4nnphQmbY5p1+VrrRWudTXJ9A7RH3WtcTXG9
	 loPXU5MXK1cxSaMgK0VrqPiQJqqCOoLJsw9OBs2BiI0A1Ce13vUXiqvhrQVhRZmbFi35x
	 Y05SvJ0Si4ymXkfVAYI75L79wEw1cJmBZiyTcjeUHSj44kaFiCo9qfiWkf30uI0yullkM
	 9tHtc9AJtTXx6LgEjW04UriEaARFZSbUTHllwpTeHnAke3K27UV8Pg2loIfiPbzVzNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PhlIYYQS/uyQjvSEgYQyUvMtbaHCabPdwU3QLieh1RM=;
	b=JEZBtlwg/wkBPB3clEnfH7+DZHxcagRS63/haEF9BDAvGXDIGEFpfXAovnUDgNmlbLnZ
	 7mhqUB90MXaTcbx/+JK53TOzfyEV7HNbSnwP+Y5UgSo+tMAjl/DOO2iRo8RbpJFdM3FW6
	 rDKM7dLM4p0C0Fad/MMbR0dbR/EunEESk4C/Mw61XqYLYFBqszR2IgTyNA5nhcgJj0eKU
	 KklHm9z9EVct4TPg3dXSWmyM4Oy7zPv22Cqg8EQXc+FVvH5nnzkD1PIdDm6+zKKs14y6K
	 w3MtfLRNOxr4zsshKK9tRnrgAPi3Hc6dF2MOtdLlwgvmrEfF7pJteMl10tQikCGWtWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vhg+W1sa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F64F606D81E;
	Sat,  7 Nov 2026 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vhg+W1sa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29921F008A3;
	Sat,  7 Nov 2026 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062796;
	bh=PhlIYYQS/uyQjvSEgYQyUvMtbaHCabPdwU3QLieh1RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vhg+W1saJtciHgcuYh9Z+plncBtp1IzVCTcMGAKDu1aoBYN07DsIJBbwSWFciv6TF
	 iMeBV17YI+sIY/j6kbO/AkCK+vjEF/rOwVEyytkbm5AF5PsSRIACnWogdpMDDMHkaS
	 OsimM8FD0t+DAxASI/VSA4lnAleig2499J7/6wDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/869] media: microchip-isc: dont sleep in the clk .is_enabled callback
Date: Sat,  7 Nov 2026 08:46:22 -0500
Message-ID: <20261107134856.042405503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



