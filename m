Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063991;
	b=wCxCbuQr4oE6OhAz8tXK/DxKBMoc0f1zujL/X7w7uZu8jpZ/BbiiRmTCJs0mSwqlxm7G
	 isACJzLqtPTPqW/V2u7nJS4miyua3v+z5zgHQG+7ux73Nf1CHiPjCrxu6+K25S6K8+Pq6
	 iuAtJmejvRPUnAQ2xgV+8RDojtSth/RPdKRNX8d+DN4PZS8ww2vyuriyU3Tg5ZanF89YZ
	 I8GX37rd4xd7WHRbq7ldgFEAhqi/mM15BSS8k9ERx0UCMaZ27oMZFnWT4OGl2j9Pvpw0A
	 FQCsm3HWtcUBhyEsGu07qZo6zhVppEdKNvwTemyISdpTZcIRi48R2RAch/EKZqB2PXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4C/jRg6sJFTO7ihTvY3dVzvxNfVBhGp6pGy88gl7KMs=;
	b=hWLlw3cb3SxB8XPGBJbsncWGCQZM73h2JUmRg/EMvNJP8LAn8nkt117WUINjfhYjVZIG
	 81oHkaj2pSZumiGflKhjySTM49mX1ymEPhw5TWLQelWQokVMDgusWSlop9FNZi6OesAVo
	 zVGYJJ5xRAGRCV8DH04T7MYXVXJt1gwaqGdnQsJB+jn0Ie9f7DNgD6w6iQc+Nm9s7ZwDQ
	 /15Bxak/pJ8Sjcp8AQLzi19eWx0iqYL8EKu3E0iP1hNubpEgcTjfwyP35bRRqthLCdFZM
	 ITvE6CrLHJXdn9brZEvB1zAeZuR3Rv5quctd5ihEWNz52R14f908YZyWELSCSuq6DCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gH/9lmdM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3668660A2616;
	Sat,  7 Nov 2026 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gH/9lmdM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68581F008A7;
	Sat,  7 Nov 2026 15:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063991;
	bh=4C/jRg6sJFTO7ihTvY3dVzvxNfVBhGp6pGy88gl7KMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gH/9lmdM+tLggk4KbDjAYeFdKyJavXUDWhwhHcDdFrYhKvH4aw5gKS3yLMPW3I3DB
	 FFpMnCPIzfL1W0u/VzfpIINgEFHwE6SJOcFaAAaFu8dPiyazhoIX88xLsdR+qMNYkI
	 qxuMw+vorfHi/O6CtlAyJL3QvC2+lmXQ8/f7oBdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0125/1257] media: require two-byte Cypress type 04 records
Date: Sat,  7 Nov 2026 08:40:21 -0500
Message-ID: <20261107134942.779011762@linuxfoundation.org>
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
index 66274fdf52438..d0f66ed01c4b1 100644
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



