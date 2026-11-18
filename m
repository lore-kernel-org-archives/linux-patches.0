Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046136;
	b=KFEjIpnTuu5Huf4detScFSZXzlZww3Xq+vIEK+lgi6qlxcJvXCX9y0XanZreEiSUSXFi
	 RQBKVGzQz0xUQH5/lXaBBVKgq9zWNtLZPgEs59UqM650sw/8GkQyOw1HxgGGk68iC4oTt
	 +dCQVKbaJR4w2o1VaeUrrtTMM50tNEu3TiQ+283slr02nzHy0+933XLhSl81Lw1j4yeeK
	 hiiQuYOcUpruX6JXzxttW8qTFB8IIOehLziAEiFwrSy59+k/DdTtrLuzWWjCapu4QJ43W
	 oE/WjttprIZKzdll9owszQoZvqhh56azs0QoI++LcGxb7ca2Nd27vqso1A5pxwQizgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tIQdi3gamJPFTXrT6i+evdqGKqOcJ076GIy3EbQBMMY=;
	b=WrnycyO94eWMU0cecXIw7TI5UYpoMgPSzhC/mTAzBwB2c74rdXRaBkYnE4yYM1blBxKi
	 jA+5+78CViscWmcabpyOpen0SXz9TgjYG54USXrcVtoOJEXwXoPfTCUDeqEs8AiYdypfs
	 HF8IX1kF7njsLZlF59cZIMaaag8N5UrP6coT4Ahz5gPx46FETD7DmAkzzhsSDpr7roZek
	 hUFXzP/5HigKp7VHJUJWLgc5KYG/ZzHVFY22057+QmVQJFyK+i0ffeTZ65aduhmEzF56j
	 cs6RVadKNCn7beZADTWUkdaotXrcrx8GEWd14X1PO6tWoYD+epeXMh42BbfENAMZdew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKTBtnlG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BAA606A320;
	Wed, 18 Nov 2026 23:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKTBtnlG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143E51F000C4;
	Wed, 18 Nov 2026 23:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046136;
	bh=tIQdi3gamJPFTXrT6i+evdqGKqOcJ076GIy3EbQBMMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKTBtnlGmtltGWI/f4TXtay8RGwgYQ8eC+IpqzXQeMXPskJKMmaZUbMncD/23GDso
	 FN8B6KUDYOoAyUH96XBYVbTUcooScVXapgUH2xLsFArvqnX+/B4mUimjmh+yFOotID
	 0Xu+4eTYPYvNBRdi6m+DAqu7BryeVMNyAGb/fKy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1174/2857] media: require two-byte Cypress type 04 records
Date: Wed, 18 Nov 2026 15:36:48 +0100
Message-ID: <20261118150243.869432245@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



