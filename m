Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037466;
	b=pQKvXSUV83iMe8P/ENdcCcW5jCCEcR6l+218LW3wU2OqeisYT4WJclJrsRni8a+bQgse
	 6uEhN+9Jk762ij7GZF0lSy0unRHIQ/plpgvLV3OUc5d1cWEKQMY6YO+ZtbN2IQDyYscsr
	 8xfK68EyRrkucXv/H+6Bno16HlypdndXqEMXy8hJTvSmiFrEjjJ492AVXOq8GLAu8E/vi
	 m2BveFN5NpcL5VtkK8biKge9tBgiOP3n0LnEbXptsWFDNyRcLS1L4yj0ilQgI4isg3Ybf
	 ZMV9ucYpV8BjMAdhzkGU/s5HqZ3WwFYKE3m9VVGOP6sIL9PhRhD8bkfIfrEyLzrfDRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NpH+VMmTl6GtShOMAl9CF0f1tuUxYEAYuFptRMSF8nk=;
	b=v0tm6W0byL/BO2wDNKEVivC30cwfgwOFBzkYAXVoBXUmIdX1eW1xJ12w6NBHrGK+qBCJ
	 R9uAMf4uuoY4UWg3gj1Qulcav6d9kV0iXOunrkwgQLPNICoq5a+iBZoRGxTgZboBPTonD
	 EMM7+W1H1GzzEYjSVEorL1MJvnkRNrwvIKZ/XhDp6aSy6mwKGOkG/ez7noiDfDGqXU4RL
	 wgWe3IBmC1CN2/5u62SSIp83Bzi9g3m9s+F/fTduvyDSsk0VUlD3YPVWNVyZmWxshBZ9Y
	 jjZ95guoj8qrzcyV2Quv6J0+O1HUGsHTk6/350q/bJCkHZnFhJUghJG1sf9dTUEwq5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oNAB1X6D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F8A606A31C;
	Wed, 18 Nov 2026 21:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oNAB1X6D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD22A1F000C4;
	Wed, 18 Nov 2026 21:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037466;
	bh=NpH+VMmTl6GtShOMAl9CF0f1tuUxYEAYuFptRMSF8nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNAB1X6Dy6tz+T+JczhRyK/CSBSaXhU1djhdzyWcZB+SoWoL3edVDnyr+P6Y0t1zr
	 Sbcgs1W5VXQasEURjcm0YQxzydiKX7bvmB1jbKkXYG23Lrzc+O3cYp05sf/KFX0Taq
	 UHo5XVddRJ3mZZiGDOIbow2B5kbttLjwzBxrikt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1381/3318] media: require two-byte Cypress type 04 records
Date: Wed, 18 Nov 2026 15:33:23 +0100
Message-ID: <20261118150401.965643987@linuxfoundation.org>
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



