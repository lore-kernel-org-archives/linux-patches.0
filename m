Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053159;
	b=gkqoNMwHV3DE9Q7nUZBlEfPJwLp0aZx+cO6CAtgxaAMkvJipXTff6dEyol/270KePQYb
	 QBiiE6rFM1UN9n36If8NBiyN6fSpYAIXKeA/SNjJEe4VeGoxVfU83DoiP0CSVfIx4aIbx
	 P/n1RZBC54V1lLe/GCR6/IVK7ZSlbf2yfSgskIhanLYQ8EkOaSQc+6Z+DaIjpChU8KNZ/
	 Kvfo3zx0qqXZFhaqfsd3FeZy86eMpOe1B/sN1q9Gq6SVyM9pAJmMrhPyNkYQbLrLYHR5w
	 1W60CTD/f0XoUrs2dx98AbQpYN0cT0h1kRjwpwBxNpg3FtQ54wHSCYVdMWoYegd17zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1r6XLwKGNwngCeLaLFAzrBf4P16xvqainY6M6Xy4Nag=;
	b=tbGiQZovCtOvl9LtY/3//AQjB9uhDb4lKDFiiF3xJlyk56bxnooyIM4PvVHFKQzPKmzw
	 40xIyfSND0f7ZhVt38399rwKXh7lRYq8OAa1QtBVZZ9ssLAG+xGrQc4TtwZkpGtity/mJ
	 KfpmVv6mXyMtZ5XshXEVwkzDKwxrNlYDwzpgDSWBDtK043Hht17Fh/xP+jitKKFnVwejs
	 +WmOjZsxIEorbHysO36tB9AVdYRjdpgaaS549BRx+FDbdLV/RCTZWvve8xichDR9M/CxG
	 qhPh13t5mOTKELcvljYpHg1Z9Mr2W1P4inbaECWrb9+1kSN+mgbByhkWLSTL9FQyTLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h62U2M6Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56E3606A337;
	Thu, 19 Nov 2026 01:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h62U2M6Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045AF1F000C7;
	Thu, 19 Nov 2026 01:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053159;
	bh=1r6XLwKGNwngCeLaLFAzrBf4P16xvqainY6M6Xy4Nag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h62U2M6ZP1A8ox3xxYm1HefXpxVmi6iBUZpN1xTn4gsv8fA7PQFPqOfTNLK3dlvjT
	 AuT6fu3TNkBCFROMGC3OcrBJZcwoDtQFyzhEqOmEKQPmcJzj2l6fYSw6EaYEe+1zAN
	 E1/S+TTfaj7jomg46NZb3sxRmfOjwcNEpwfnHeas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0819/2214] media: require two-byte Cypress type 04 records
Date: Wed, 18 Nov 2026 15:41:35 +0100
Message-ID: <20261118150044.326789541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



