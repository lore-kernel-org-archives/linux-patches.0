Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826891;
	b=OYl6AuF2BLf6EIW3NNNhP/RSg8TvLb6xi7RvjGSJlVVp46UTELZ9Aeav6vI/wwxl5Xgn
	 lUoq/IOFbYnEDFQoFmFM+R5EAm/17b5mJoBLzTLb+cVi2OgYgNTkI64FVQgZsPydaDsWE
	 I3TlxtX3fI0HC8eg7QlsRnC8iBmKX3//3lGTdO6/iPBBVbuiGGFmSM2oiuyCdaT+7j5tV
	 WNbAxxQrDlxP4G9ipSvZMNF9Xtgh4m2WJyqL9Ep2VAwVLg2ax0TKxwWLco6JV+cKX6YsB
	 6ZJrBH3JyyxlgvAE7ydo6NfNur1gkdr5zFRmGurq2B9xflQ+783OnVQdo9ALRqncIIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQy7mGS2SU9xP5VrYe3UXiuf9Fy084hcEKDQpSEH/UQ=;
	b=jdquoM7NnYeK6XhtGgTd8jEgvs7T0Bz5i8LUyzDwLPa/8GMET2shuurUd33INkelOAw/
	 eB9XzFXJy7H/PJUekkzRc31QtH3g7RymuxAIns1N0D9dKdcdTlkSzM/L3d2SPen7nxaIB
	 y7ECCYE6XiwK8nzk0v5IIoFbzQV/xdO28e7UC2ElW/fHM9OESOqtDtWDV9JvAnvfSZxqe
	 eZ4GB25cL9EjcRqeaDatn64KITuwZt6KboaDtgPkiYug9D8cqegFtP5O/hd4eIHhKCq58
	 9SIhMNaidKppH1/qYuCxb25+iIIL7k96jF9Jkn8jhnNLrkuDkEtnJmhlgadp9dzXv1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYd5grVa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878C1607075A;
	Wed,  4 Nov 2026 21:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYd5grVa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131831F00919;
	Wed,  4 Nov 2026 21:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826891;
	bh=ZQy7mGS2SU9xP5VrYe3UXiuf9Fy084hcEKDQpSEH/UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYd5grVajjhPV0qDL3ifUYE9JoQsDhWnIY6ugGr2Vh67jJHrzTp+JeJQCAdjzeKXl
	 BglV4COsXpxeP/0jPDUnUE7UgVCLVtJ6PaOF9wZNEoQF2HbAG0yEh1mkDI/8poWelh
	 4YNLAjJbTvMPdqoN6s8gquWQ37ExSuPe3IBDFgIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"ck.chang" <ck.chang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Chris Marshall <deepspace69@gmail.com>
Subject: [PATCH 7.3 069/547] wifi: mt76: mt7925: fix reset panic caused by the WM2 rx irq mask
Date: Wed,  4 Nov 2026 16:04:13 -0500
Message-ID: <20261104211040.225778304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: ck.chang <ck.chang@mediatek.com>

commit c182bfe944eb275f7526cc326f81229b0e974a0c upstream.

mt7925_irq_map sets wm2_complete_mask, but mt7925_dma_layout has no
tx done ring, so the MT_RXQ_MCU_WA queue and its NAPI are never set up.
On a chip reset, mt7925e_mac_reset() calls napi_disable() on that NAPI
and crashes:

  BUG: kernel NULL pointer dereference, address: 0000000000000a40
  Workqueue: mt76 mt7925_mac_reset_work [mt7925_common]
  RIP: 0010:mutex_lock+0x1c/0x50
  Call Trace:
   napi_disable+0x1d/0x50
   mt7925e_mac_reset+0x327/0x420 [mt7925e]
   mt7925_mac_reset_work+0x9a/0x1a0 [mt7925_common]

Remove the WM2 mask from mt7925_irq_map and from
MT7925_INT_RX_DONE_ALL.

Fixes: c4edf9e3e0e5 ("wifi: mt76: mt7925: replace shared rx irq masks with per-chip definitions")
Signed-off-by: ck.chang <ck.chang@mediatek.com>
Link: https://patch.msgid.link/20260805092409.1489401-1-eason.lai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Cc: Chris Marshall <deepspace69@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c  |    1 -
 drivers/net/wireless/mediatek/mt76/mt7925/regs.h |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -493,7 +493,6 @@ static const struct mt792x_irq_map mt792
 		.all_complete_mask = MT7925_INT_RX_DONE_ALL,
 		.data_complete_mask = MT7925_INT_RX_DONE_DATA,
 		.wm_complete_mask = MT7925_INT_RX_DONE_WM,
-		.wm2_complete_mask = MT_INT_RX_DONE_WM2,
 	},
 };
 
--- a/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
@@ -48,8 +48,7 @@
 #define MT7925_INT_RX_DONE_DATA		HOST_RX_DONE_INT_ENA2
 #define MT7925_INT_RX_DONE_WM		HOST_RX_DONE_INT_ENA0
 #define MT7925_INT_RX_DONE_ALL		(MT7925_INT_RX_DONE_DATA | \
-					 MT7925_INT_RX_DONE_WM | \
-					 MT_INT_RX_DONE_WM2)
+					 MT7925_INT_RX_DONE_WM)
 
 #define MT7927_INT_RX_DONE_DATA		MT7927_RX_DONE_INT_ENA4
 #define MT7927_INT_RX_DONE_WM		MT7927_RX_DONE_INT_ENA6


