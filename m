Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590564;
	b=45EvSAEI0/bXcvAfFWR8xSNpPBe/gzaIds36eckj1Xa7kWPJ9f5LCZ5NuCURlsSC1Gig
	 46fGFZeKdHozXro4g+D4hu03bwrR0el8R5j/bxj4Wh2tLmGawml1U3h7G4vO8tTc3+Rfw
	 8mtxin0RJXFXtfmN6U/+4ree4C5aI/HTYZtB1Deh8aq2Od5ZrO3Ur/djeQuRQuw/o9/LC
	 EO8552Fqt0E1eT9HCXOLD8ZnGe6WknjwVW16HMNObrupScYUOw9GzYeVCb0L63aIUEq4U
	 qNiZLPyEzuEHOFaBwUrBJkRw5jT5fEn3/7zYPH7ud7SCPjMQARF9cqK6O1/58iMU69A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0BZug/66r/o7cR4etHqLo9tQdHjgNFDVuPD6YS/BE5c=;
	b=qb8NPjp/bTHuTm9XcyC6YV3a6/C5V8LRTLvVLYG9xLHgRO+VYj1zTmT1+0macxJXUY16
	 7H76cSzvsW6/5/hs8CWpokX5PG7jWGToAhpxAE4x4uRkFuLCYWUlBoE0OK05PXSF8cm36
	 ZRHzLUY9HztcE+Feg1TIaYtyNvEex/zs5ODkwZOX9o2tBcL4UHT5TtxrJ8atA0kDVzh08
	 LRwWhWkM9UUazqE2cNI147IQb8Rx2oAn2JIWj1Fe237lpmfxMUdlPEtcPotQhHw+456G7
	 MjTwPuzlLHecstcgh3BX3BDkknIoO5Dh6mKWKa+bic1bQt4oBXtEBypz8uUj9NaMzTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EsVJlwpT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733CD606A88F;
	Fri, 13 Nov 2026 17:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EsVJlwpT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8871F000C4;
	Fri, 13 Nov 2026 17:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590564;
	bh=0BZug/66r/o7cR4etHqLo9tQdHjgNFDVuPD6YS/BE5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EsVJlwpThYvl0ufncY/Zz/oB2Pk+Md7Ev2o5lcmLD4wQBh7gNjfTYpVYPwTul9jpS
	 P+NA2i+ZDARapEyz7uzKvi2n/k1RW1hQH1c+1oqZF+r+xnX2778jCS224hc/8V9/Tt
	 UbUg9aNBZN7lBY19TmxulF+szHNv7FZ3ERzwfHps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 498/686] media: microchip-isc: fix SBGGR10 Bayer pattern
Date: Fri, 13 Nov 2026 10:50:31 -0500
Message-ID: <20261113153837.795835876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

[ Upstream commit bb96c78c5f87072913f8825faebe64bf711a503c ]

SBGGR10 was mapped to ISC_BAY_CFG_RGRG instead of ISC_BAY_CFG_BGBG,
causing red/blue channel swap.

Fixes: 1e8f401474d6 ("media: atmel: atmel-isc: reworked driver and formats")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/microchip/microchip-sama5d2-isc.c | 2 +-
 drivers/media/platform/microchip/microchip-sama7g5-isc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-sama5d2-isc.c b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
index 57a5aae3cabfb..5e41eee45dbd7 100644
--- a/drivers/media/platform/microchip/microchip-sama5d2-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
@@ -148,7 +148,7 @@ static struct isc_format sama5d2_formats_list[] = {
 		.fourcc		= V4L2_PIX_FMT_SBGGR10,
 		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
 		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
-		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
+		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGBRG10,
diff --git a/drivers/media/platform/microchip/microchip-sama7g5-isc.c b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
index a841266ffc30f..9e78ea07b013a 100644
--- a/drivers/media/platform/microchip/microchip-sama7g5-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
@@ -157,7 +157,7 @@ static struct isc_format sama7g5_formats_list[] = {
 		.fourcc		= V4L2_PIX_FMT_SBGGR10,
 		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
 		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_TEN,
-		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
+		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
 	},
 	{
 		.fourcc		= V4L2_PIX_FMT_SGBRG10,
-- 
2.53.0



