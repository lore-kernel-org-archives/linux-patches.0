Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585875;
	b=XSmwKqxjuoPE1fgZb8FkfCZUzxDA8UmTFwETd5E5gnBf3enL0HXS1AMLPSbaAdMn3JUz
	 w0dR/CeDRb5Q0iJjESb8REdnHlItNRT6CmlWHnplYTmkPUgz4fGwhbICLWux1XP/08pwT
	 xEOCXNAfComxW9l5jm74lxgkJbzsBjtPlhQdXMwmWaBmnr/HbN42mfF0UpvlWezKsYar4
	 +77d5vu8Rv7sL8qK4YRh1O3zhM6NQtfUGXjQBne2siS5HiJXmWrTfWuekbsYH3k9/bCQs
	 /cAFJ9HuvvWWC8MRa/GjJkQrHfELajlTmmaRBiid2gPoAQgPF3mxRc9Eibm/lR/wy/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UrcpM/6nSVqOtarxY+Vl8y6VdrMhiniA0jg6WnpEpqQ=;
	b=0SS6PrRJgK6nI3uHergGQj8hnIthcANBQgWLwdmR0tolwpXFTM0nQ0TlyYghWzm+kM+U
	 /keUkbCFzOllCgzUWECr+vnN5UyDT1ZYWDoZqZo2ayCenRyRgHPGgP10TjpV4ct6CJdT4
	 JNighN6XiIGrTUpyWShYdxnq/OFUyCknK6w/aC0NrENessrIcXD1f0o8ZiS7HdyQM/03N
	 cfs/03Rc3OSRM5rLjh99qNBpfDeNnbTtsWJ8Wz/6cSUbUuP02r7KsfC4aLbdij1HTgQC3
	 BwmP8uHN+xZuvQrvumlNaAtXzcUVrQZbl9F7iycgK4fzfRW9w15G3rJUcDi8KndCfng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uG8LCO3Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AEB606D2EE;
	Fri, 13 Nov 2026 16:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uG8LCO3Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EDE1F000C6;
	Fri, 13 Nov 2026 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585874;
	bh=UrcpM/6nSVqOtarxY+Vl8y6VdrMhiniA0jg6WnpEpqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uG8LCO3Yt+I0I68vJ0w99fm8HVht/k06CgztmJunuiKx+fi1kS7AktKVZAYHE8gcb
	 G08YEwa90UClHRX2oC+Q8OIytoKK7byXfueiMQ1nAN/fkAU/d/V2tN9jCAqfn8STOV
	 KwnClardsqw5MjM6ec0/+vxT7kRQRrZjC6eK98sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 444/507] media: microchip-isc: store the unshifted PFE_CFG0 BPS value
Date: Fri, 13 Nov 2026 10:52:28 -0500
Message-ID: <20261113153811.786682547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 14cbe597504a04c5c49342d0566438e2b438a948 ]

pfe_cfg0_bps held a pre-shifted BPS value (ISC_PFE_CFG0_BPS_EIGHT was
0x4 << 28) ORed straight into the register. The other format selectors
like cfa_baycfg store the bare field value and position it at the write,
so this one was inconsistent.

Store the bare BPS value and apply it with FIELD_PREP() at the PFE_CFG0
write, and fix the pfe_cfg0_bps comment to match. No functional change.

Suggested-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: 6e9eaa3b9387 ("media: microchip-isc: fix WB offset and gain register field masking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/microchip/microchip-isc-base.c |  4 +++-
 drivers/media/platform/microchip/microchip-isc-regs.h | 10 +++++-----
 drivers/media/platform/microchip/microchip-isc.h      |  4 +++-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-base.c b/drivers/media/platform/microchip/microchip-isc-base.c
index 21d108eb93c7b..e5ecf6ffd24a8 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -8,6 +8,7 @@
  * Author: Eugen Hristev <eugen.hristev@microchip.com>
  *
  */
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/math64.h>
@@ -291,7 +292,8 @@ static int isc_configure(struct isc_device *isc)
 	struct isc_subdev_entity *subdev = isc->current_subdev;
 	int ret;
 
-	pfe_cfg0 = isc->config.sd_format->pfe_cfg0_bps;
+	pfe_cfg0 = FIELD_PREP(ISC_PFE_CFG0_BPS_MASK,
+			      isc->config.sd_format->pfe_cfg0_bps);
 	pipeline = isc->config.bits_pipeline;
 
 	dcfg = isc->config.dcfg_imode | isc->dcfg;
diff --git a/drivers/media/platform/microchip/microchip-isc-regs.h b/drivers/media/platform/microchip/microchip-isc-regs.h
index e77e1d9a1db87..185ef0eab7ad3 100644
--- a/drivers/media/platform/microchip/microchip-isc-regs.h
+++ b/drivers/media/platform/microchip/microchip-isc-regs.h
@@ -31,11 +31,11 @@
 #define ISC_PFE_CFG0_MODE_PROGRESSIVE   (0x0 << 4)
 #define ISC_PFE_CFG0_MODE_MASK          GENMASK(6, 4)
 
-#define ISC_PFE_CFG0_BPS_EIGHT  (0x4 << 28)
-#define ISC_PFG_CFG0_BPS_NINE   (0x3 << 28)
-#define ISC_PFG_CFG0_BPS_TEN    (0x2 << 28)
-#define ISC_PFG_CFG0_BPS_ELEVEN (0x1 << 28)
-#define ISC_PFG_CFG0_BPS_TWELVE (0x0 << 28)
+#define ISC_PFE_CFG0_BPS_EIGHT  0x4
+#define ISC_PFG_CFG0_BPS_NINE   0x3
+#define ISC_PFG_CFG0_BPS_TEN    0x2
+#define ISC_PFG_CFG0_BPS_ELEVEN 0x1
+#define ISC_PFG_CFG0_BPS_TWELVE 0x0
 #define ISC_PFE_CFG0_BPS_MASK   GENMASK(30, 28)
 
 #define ISC_PFE_CFG0_COLEN	BIT(12)
diff --git a/drivers/media/platform/microchip/microchip-isc.h b/drivers/media/platform/microchip/microchip-isc.h
index f5e322c2e36bc..d7bcd74efff92 100644
--- a/drivers/media/platform/microchip/microchip-isc.h
+++ b/drivers/media/platform/microchip/microchip-isc.h
@@ -62,7 +62,9 @@ struct isc_subdev_entity {
  * @mbus_code:		V4L2 media bus format code.
  * @cfa_baycfg:		If this format is RAW BAYER, indicate the type of bayer.
 			this is either BGBG, RGRG, etc.
- * @pfe_cfg0_bps:	Number of hardware data lines connected to the ISC
+ * @pfe_cfg0_bps:	ISC_PFE_CFG0 BPS field value (e.g. ISC_PFE_CFG0_BPS_EIGHT),
+			written into PFE_CFG0 with FIELD_PREP(ISC_PFE_CFG0_BPS_MASK)
+			at configure time.
  * @raw:		If the format is raw bayer.
  */
 
-- 
2.53.0



