Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053687;
	b=sVhJlh3GD28tvNP7hL/oKMaIeFy295SbW7moVdsyuAYCRkUIirtljNKdC7wpVOkp70JH
	 a4SK2SSgOKn6SEFfbN9Mozx5o5mQYLXob2y3qtzThndnAikSp5VSw645rEXRvo715yJLs
	 q0kImWAB1OJ5/5sSkJE6QDvMVgHmXqvIZf4AqXQB1XLdZziQNMhxUuu6mTjLDuCBerJ2W
	 gc6vVkQkjZFxcmsvY4ug7DDQX5wSBFbKX99/pCFDqsGiDUaKRX6r0Mu1A8U3BqCh7Mw+V
	 jVTsdvVnVCtQ7OSNgyWg4b/YCG0cC/Y/H8s9yOdZCiMFMk7Y8oGiKutNhG+wiR2/vBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VGtanFFtVV81TBBITf1M8Lm+S42T43xfjReejecWwvo=;
	b=Fq07fwD71rdeh9OwNWujjPMmCnAtyC/Lo68L3B2pion5blqVhC/xZd2CJJGSL0biwrGg
	 EUA5R25kJaaDK5mtx3MVBTiW5Zlfahp0wf4fTNnG+gPLcf4wwAe5gCGb6cU+5bDk28Kyh
	 3OcZ1dzasNfIR4dfAAD3VK18PsXlToKcZv5bx3r7fGdZ4PpN4P3gaXGAFgWd5zhfXPw+U
	 Rhi4sSPHjGsqqp1PpxzwJpvFqz2+FZyDXNlSmhyhmeWzTHqjL4VZ2eVdnE4gEU83aHOdU
	 LYjyXRyXmRp/Tbij8d2Qvp3WdEp6Is9XiKI/r7F0lNyUkW3pG5buyhAQlpbMtFdzLvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kMWDEyVR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564EA606A320;
	Thu, 19 Nov 2026 02:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kMWDEyVR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C811F000C4;
	Thu, 19 Nov 2026 02:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053687;
	bh=VGtanFFtVV81TBBITf1M8Lm+S42T43xfjReejecWwvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMWDEyVR43n+O85ipjxbRVrZKJSPwqpHOabXdR6sGWW9QuOwFTSPL/OPEk97z1fZy
	 vXJzvJQWMGsqMc7MHltvE54oK7ImfubC0o/urT9vN67OGpocjrJL1Y6U8YI4PNBuZ3
	 tkfHKY9wXwyK+tmLg3SiCRaF8bLzzSN3up1JjxfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0980/2214] media: microchip-isc: dont sleep in the clk .is_enabled callback
Date: Wed, 18 Nov 2026 15:44:16 +0100
Message-ID: <20261118150051.451313053@linuxfoundation.org>
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
[ sashal: Adapted the change to the older driver layout using the two-argument pm_runtime_get_if_active(dev, true) API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index 8e3b264ce8851..5819875309d53 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -182,15 +182,14 @@ static int isc_clk_is_enabled(struct clk_hw *hw)
 {
 	struct isc_clk *isc_clk = to_isc_clk(hw);
 	u32 status;
-	int ret;
 
-	ret = pm_runtime_resume_and_get(isc_clk->dev);
-	if (ret < 0)
+	/* Runs in atomic context, so must not sleep to resume the ISC. */
+	if (pm_runtime_get_if_active(isc_clk->dev, true) <= 0)
 		return 0;
 
 	regmap_read(isc_clk->regmap, ISC_CLKSR, &status);
 
-	pm_runtime_put_sync(isc_clk->dev);
+	pm_runtime_put(isc_clk->dev);
 
 	return status & ISC_CLK(isc_clk->id) ? 1 : 0;
 }
-- 
2.53.0



