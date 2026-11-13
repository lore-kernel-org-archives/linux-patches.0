Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590974;
	b=puAo5j8/J3qbHCnVcecuiQCr3WljvlJMKxC3Eyk/TwwQrVvuuHPfqCAh4VycABLXu+tD
	 7dHGxjgAVLemlBDwDq9WctHFjNZVd9LOHtd9Lh2vhysotiV9CC4ajKpF/wTNsp1B3ZlsB
	 hAYzvIweJmMknpW6fumqvbm+f+NzvF4u/EDPmNl04qKs+rvV8uyEoLi8KDeLCplZ6L/f+
	 +MPUWCxRV3Ul675WKeUh/yrRHGxhRyWYeBSNl0JHzFe+FB+erx8vVznAynKDUWj3pMoTQ
	 2+HhAujcSlEurSjVQjWcyNZ8+SIsAbjFhlL3+9e49bOqtuhAaQhMAjNYPyZ9dtF+q1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K9zRW+n1ai7bgxqXDZV0+bHpqOsPa9dUiv+2pwS037w=;
	b=HC2cgF334sT+qZzjdD/ufDXpND1/gIsUOpjcoRVJLYI5TkKLNOUiUZ9zF3KSJOOnU48U
	 XNpv73kMYvAGYbdyx39HjonLCm08lgwUe7HcU0AOtsKfOJ+5lEFEvexh98dA6FwbNVcE2
	 3DksruNHCp6NSQES2/a5Xay6RAbUVTy8rRyTBLRP3sUqiekHpxTYYwYaO1bY430n8pFyf
	 EIdg/AxDRZqmsFeJE0Ql1Pozs6WfjlM2ADXj/+t5DPXB7B4zEgmfmMeuHaGfy85sSy/nt
	 O+WuRtYpt23MD1qOSDdNHCFGppG6F4UXg21m6O2GIegI0vpuQsRv0sUYz7vLhRJXLQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixBLRGjj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079B9606E65E;
	Fri, 13 Nov 2026 17:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixBLRGjj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79F21F000C4;
	Fri, 13 Nov 2026 17:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590973;
	bh=K9zRW+n1ai7bgxqXDZV0+bHpqOsPa9dUiv+2pwS037w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixBLRGjjAIi7vLE5in9T02I3A83hmepGUW/xDoBNmf/tmFSXwouVPDcQ0+QErcC9F
	 2o9ijsH49/+3f3AcFdVfpvnShis3/rGRa+aervq6yNqVqNbeq8Xt459Iac5QcNKH48
	 lWXNwirp9JH5mu1fBy09gqwSYOjJ4tAbmneC1RUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/670] media: require two-byte Cypress type 04 records
Date: Fri, 13 Nov 2026 10:45:08 -0500
Message-ID: <20261113153816.755494448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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



