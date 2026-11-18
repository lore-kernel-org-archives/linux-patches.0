Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058986;
	b=prh/EcD2Hz9eUyd9Lf2k9yHtPqs16FpnC06BBjklL0JI/5Ph1csN3m+3tHpshBlyXd/Y
	 Cr624ImUmODyvEcSLaBbDzxovrpuQc0Ec7U1HhZ9RBvR1vZZ470kjMHK/KH8S8u+yt3rC
	 RthW5btiYlz2Bv6NcQRLGSCIEoXWflPe5ESdRoF1sJSo2D5Ul7fA3Hbj+95pTJoY9zi4+
	 yCG77+5vJA7M6ijKGAm2I4Py9GUMtGgtbwjH4uVNbJWKjEztYsm0UXd7wfKrCVSy8WCf9
	 AGYcwDETZCZChXQTnzB4g3Bp3zJTeX3797LN6wNkEWFRt+U+Fg3Q3w1G4vq7AkYc2eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZwZ4dI7BGNh8k1/fvLJ+nEI48BpnvZ5z1+8h5EGc+uY=;
	b=fDT32A7/4uMNgJlEKS67/oxT+vnFGVi8whPsS4kzTeEe14u+XTbFwdYRVuvfdXXxAUmE
	 Azl106wylXZG6T3J2MseIgnwGYmrQn2SMtbY9Wwpo7gc1peRJogCPKflrQtt7TiNJaiAy
	 QiFl9I+BBV2aoeMnpu5he6/w6d1xwqVXgrhq3qi9BZ7btf2lSa2ZR3+Sg0mQw+y0NXISy
	 PcldOt3HsEeEioyTJW5p5uOCH2zorDE2QkIeJEEb6kehna7u0pw0TI/Nc8CbxN16BEqDB
	 X+YQhLsyRuIMpwptIfUgvafdsU4GdN9yaJ4aJ5bNYsxullrYPGX+VEYff6kCAdSW4Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQCrSg9I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B52C606A31C;
	Thu, 19 Nov 2026 03:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQCrSg9I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1561F000C4;
	Thu, 19 Nov 2026 03:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058986;
	bh=ZwZ4dI7BGNh8k1/fvLJ+nEI48BpnvZ5z1+8h5EGc+uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQCrSg9IkpPhH4kZXG8Hc6j8HnTQCaBH1EufD3BULWR3HLB/Z/IUbz+RIr4uoxPyP
	 ybTuOUR8Ww+kTuknLp/JXpFp1XddwypDfatMoTFPC5MAboflR1FOdWRtAuYfmVoaM9
	 UkRXzb7IYpF2j1YM2+P96e/N+cRYqj60FStKQf2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0664/1848] media: require two-byte Cypress type 04 records
Date: Wed, 18 Nov 2026 15:45:02 +0100
Message-ID: <20261118145943.598682647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



