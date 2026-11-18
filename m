Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038071;
	b=tzsK5ITcN3ZtRwbFHEUwPU5TGm+kWHZ6e8Wowz2SQx7dv9+8+JSVRwvgxPetKkFjkI8+
	 Dduu+yv9P8C8EE7KjGw2AphgNJ0iys9SJr8eH6ILExs2CcURHDMV8B7zZcKRvxkeuX/n0
	 eUZBaC5G/CYFiOPEGsCVHGYE62ICt7B5l8+cBCX3/Vk303FOAce6CLO3cC4WbDtoE5jFM
	 CqpcfnIBsBRzVfOZg2BcN6K72HZvQyfW2QW+AZhpvRzmQ+G4XtD6WDEZMDCTA98s5vlfm
	 pfZlwDT/34NaGNJnoeNCdfVDl9V0pTVWZcvPhh9GYpx3W1kFtqAWQ2q+xw8MP7C8/aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yVIu9NbKM5luphMV+Hbvhn+Uy6cRJZROI6wyRDpeuDk=;
	b=u7zkSh5rqJL4tRocWabc97gwDLordQbd+8BCLZglLA40wwu/B91TQAUdPnAsKrBSiEMQ
	 gybWgl4QezHfJBKM3dAgbcmsCMt1kOFPcrTQoCbH3EmRD66CuR1XjfFzL7bRUBPGGb9S6
	 o7YWTu5Elkbqy3WubL6IyJprIHilLKm+YEc169mSAeWyYviHXz6wZBYdndx5S6sYDOW1w
	 U4nGsTME/2012OzvlswAvYA6hig0Uun7YVroyg8E/hFzgo2jiO25Ecpm4l5Ntoytj/oNa
	 8u/AHsDvLlRdH46okN5sUQUYi3u6Xar7Bmlj45mrOJYd+HKSjh/MzggarBt0pVtxcmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6gTsaEP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DA5606A31C;
	Wed, 18 Nov 2026 21:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6gTsaEP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F851F000C4;
	Wed, 18 Nov 2026 21:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038071;
	bh=yVIu9NbKM5luphMV+Hbvhn+Uy6cRJZROI6wyRDpeuDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6gTsaEPvbr0a4Lra2vu80EhSBOHdU7x6/HuZEVOQE15NdCdY5poRfRmUQGa58rwX
	 4TsDwvnbiY3FR/Emnqu8So2UxAPL5qgDqgWj44mj6PqI4IWqECnDjojuGHvN5SYf6p
	 EqZFcCm4s3TMrmwPOQtCBxSS63/hlZbi9oJBln7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1617/3318] media: microchip-isc: fix SBGGR10 Bayer pattern
Date: Wed, 18 Nov 2026 15:37:19 +0100
Message-ID: <20261118150409.703560695@linuxfoundation.org>
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
index 9b74c92ca6eb8..a5d9d37b4c40f 100644
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
index 15ec519f61870..ee4f66526bd60 100644
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



