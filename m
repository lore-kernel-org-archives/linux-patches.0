Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590130;
	b=MVGMRxyxaUSwyf3ZzbaL70/cIva8SN9tueKX9PzJFUjun279lVCFq7MMB7ZkyyXzefb8
	 k78pqrR3Irb9+V/k0qma1sSs2m/KXjKoU4z66w06kALRGc0c0Y80qwTmsKshbthNm743U
	 Za1j0+DiqDjD2Rvo4rDE63/wq3pHUVh9/aDuWJxZ3KYhtTLXEtuSbgE/SmLTvCBgVqynY
	 lfb+pEENhVNWYZtgbHSMaiIvVreCVU/jX4Uu37xTLH6z1djGVTUqm8oUslmQEC7flbvsz
	 I5FoZXq1cFaAtgV2YEHSxP2y01/OIbLcM0ok0L8vA2wwWUui2YMTL1k9d2Em/Uniiwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A4gjBdgKtDmV4annW6Pr8+TIngMIjDqGB7JCFd57/6c=;
	b=yxzIj2RnLlMHGj6U4JBTIqnCX0bsfYiRpljtCh0ViPlHsbatdYCL8PruMYJ7Hj4Ldd3n
	 Hu4/Djk2tbq+SI+yaOO77pit5g39ViNiQVa9cWsZ6h5blaTKg8lVUT4XcA8Ke+fzlk1xr
	 X+XT0YYibE9lypJ0+SNJ/EP/8ecKlfzvT70kjjs+7BFu/JxM4ogtQYDs77Ozn5nQ4L7QH
	 Xisj6qNp40WKjZH1zUbGgkshg5Oj+PwCGErm/TYXcndbwfAFZRUz8b0W8TzfJHmwZgfXp
	 vGTSbWi5IDWC6DuYoeDxMHOXSPM3e76cFpGKGauCWMesFJcxnzA4290J82m2a599zYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5Ed95e0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D5C60A383D;
	Fri, 13 Nov 2026 17:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5Ed95e0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C41D1F000C9;
	Fri, 13 Nov 2026 17:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590130;
	bh=A4gjBdgKtDmV4annW6Pr8+TIngMIjDqGB7JCFd57/6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5Ed95e0NDE4sd2RaEaXyKwjWH6w7s0FrFuZ9AxiqYl2C02ND8C9wuv3EOEY5kb/2
	 f78Dxzi9EgTMJEn11Mbnf2iBnZ4bd1TQoEM8dLtLg2KCSRWygYJ++XJyhQnF2EghGS
	 Fecx7jqkzz8l06IHxLzg6ACeREeNhn0kIPUErj2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/686] media: require two-byte Cypress type 04 records
Date: Fri, 13 Nov 2026 10:44:43 -0500
Message-ID: <20261113153825.881285091@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit e22872703386c3885d8c6bd595124587bc4e5081 ]

Both Cypress Intel HEX parsers read two address bytes from type 04
records. Generic record framing permits any record length, so a short
record can make the parser consume the checksum or bytes beyond the
firmware record. A longer record also violates the Intel HEX type 04
layout.

Require the type 04 payload length to be exactly two bytes in both
implementations.

Fixes: 79a63c60a6a2 ("[media] media: move dvb-usb-v2/cypress_firmware.c to media/common")
Fixes: 776338e121b9 ("[PATCH] dvb: Add generalized dvb-usb driver")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/cypress_firmware.c      | 2 ++
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/common/cypress_firmware.c b/drivers/media/common/cypress_firmware.c
index cdc7050ed3ac8..3468eff508b02 100644
--- a/drivers/media/common/cypress_firmware.c
+++ b/drivers/media/common/cypress_firmware.c
@@ -59,6 +59,8 @@ static int cypress_get_hexline(const struct firmware *fw,
 	if (hx->type == 0x04) {
 		/* b[4] and b[5] are the Extended linear address record data
 		 * field */
+		if (hx->len != 2)
+			return -EINVAL;
 		hx->addr |= (b[4] << 24) | (b[5] << 16);
 	}
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
index 0fb3fa6100e4a..675d9d1d4f472 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
@@ -141,6 +141,8 @@ int dvb_usb_get_hexline(const struct firmware *fw, struct hexline *hx,
 
 	if (hx->type == 0x04) {
 		/* b[4] and b[5] are the Extended linear address record data field */
+		if (hx->len != 2)
+			return -EINVAL;
 		hx->addr |= (b[4] << 24) | (b[5] << 16);
 /*		hx->len -= 2;
 		data_offs += 2; */
-- 
2.53.0



