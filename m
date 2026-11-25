Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624066;
	b=cKUbxLMSLf0qbj/R8+VfQfcb4NsKNmTWBY1qtpICLILMZ8TkrR6cvU3ikiiUbr+klYq8
	 RpivSnBIHf/q4A1NVmLNI2/JmadtUmzl9DVrWGGH+CrYPyFbqSH0Nc8ULmPkb4wRGSn2K
	 DZstBjarb+0poaWDs9mKqxxPR8DLhMQWIRpWfw8/4iH3QVfdIQyfUA4OECBDfBklqlqKI
	 Y6x8xYC3NksWvQQHIOpaSa/M6MZHcABA96c65nFbKiU8NY0K1tQFeYT55V9GDUD/BL/fv
	 Z1nCEkX4P+L1bGh92Kd+QQNKG+Mj/hOJ5Ei/y+guMnTJ8EeEFBmed3DyoWVffhZWDMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K8wQ83H8nFN/CsuAHdAOhThf6haiqCnXNMZl3cSA9VQ=;
	b=5FvyP3oxLmHNMTvUSntirkX2P4SnuCgTSn02iO2gq/8CVVNQdZYUPlmkE98mY06N0ga9
	 u58zIYVK1vL0ldxHCwURUsjTCRv2qX1sXM5LDwjNvI5BFqSRtfB1i/96fIpsFw074nPGf
	 ka0+ucG4JvODh597gWEIT4a9aBGsuEoKdjhFyQCv5RJtJ3+lhzw4wOAQ832R/2xXNDEoD
	 OFQB5eBpuHAtCaEIZOLYFR/ChE6f+wanMFQL4g2bIRu5UCVi8X8xHS46uBW1DqaKrbeDF
	 Z9ItHVELyAAwWRfAKvC/FCqb8C9RPWeo+2n3fATlvnuKtwGvGD2OsocpEPG0yYedAbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWjEAw+4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D772606A31E;
	Wed, 25 Nov 2026 16:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWjEAw+4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F1A1F000C0;
	Wed, 25 Nov 2026 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624066;
	bh=K8wQ83H8nFN/CsuAHdAOhThf6haiqCnXNMZl3cSA9VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWjEAw+4a+HmcmMHTbc6yXcWIl40+9kYAZPrOXjsitwB6hrtVwfcEqtnG0ZWkU7bQ
	 5NKFB5WkNjemXcqxBfMh7NAbmEIoB5X9pu/F7zH2HU5bx7Phz6eI41/7Luvs2Ccd+e
	 6chRIwXqIMVWeBrdQXs0a3R4iXdFe5NyuBkuCepU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/816] net: ethernet: mtk_wed: skip ring reset in wdma_tx_ring_setup for WED v3
Date: Wed, 25 Nov 2026 15:27:01 +0100
Message-ID: <20261125143850.911430158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit cb50f16f37fc3429085c454ee5978e05732d10ba ]

Currently WED v3 tx wdma ring, ring reset happens in a separate code
block unconditionally.

Moreover, v3 has double the size of wdma_desc and has different init
values. mtk_wed_ring_reset doens't deal with that and would corrupt the
wdma_desc.

Fix this by skipping mtk_wed_ring_reset in mtk_wdma_tx_ring_setup for
WED v3.

Fixes: e2f64db13aa1 ("net: ethernet: mtk_wed: introduce WED support for MT7988")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260711112128.971-1-hujy652@gmail.com?part=1
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20261026-wedfix-v6-1-a52f6b15d2fc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 8d95765a3813f..544bf35990c17 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -1939,7 +1939,7 @@ mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device *dev, int idx, int size,
 	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_CPU_IDX, 0);
 	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_DMA_IDX, 0);
 
-	if (reset)
+	if (!mtk_wed_is_v3_or_greater(dev->hw) && reset)
 		mtk_wed_ring_reset(wdma, MTK_WED_WDMA_RING_SIZE, true);
 
 	if (!idx)  {
-- 
2.53.0



