Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003A227FD78;
	Tue, 27 May 2025 16:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364333; cv=none; b=OcGFTBAzZ7Wnz4sIeQ7D92kvh/LeBaTh8SzR73JWuEDckc58igwUP2wlrQJotGu79ifD01vonKrTtzTsHSqx9yGiPaQS+pIx77CowE2QFlLq/92in50hYlTAoyCZEu5DfKAQU3YRYEhx+zMTsFWm1By9fe5hOe6/w+5/g56m9Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364333; c=relaxed/simple;
	bh=nyte0waYwMIABKrPE3G5DBR/sZ1p9OOkXCrkua85oYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuDTPEO8QKeE2SjVKIUX/lf9lDICAty0Ill4gM/yemNnwyRulW0RmaqlxvPJw/ZECUgYkTtxpBqat2KMhbJRUbk4PB4yfMk0V3ahxv9Mtgk1Sz/wEmhIWA4YGUiaG4vwdAzOFOsh9r1UQgBc1YWi016bEs7DZ988aNgT219syt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfK6QYSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfK6QYSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1010AC4CEE9;
	Tue, 27 May 2025 16:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364330;
	bh=nyte0waYwMIABKrPE3G5DBR/sZ1p9OOkXCrkua85oYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfK6QYSIOVRibmrd1BGk7E8anUjhuww3s+e4cEwTpQY1lpav0kwUHXYAXn+0akTtb
	 1c20OMHWoo46Ibh5oR7pkbroedQ+rBBvizlnod+KaWkczFqjM5PloejUaF1TGMXYsx
	 yTcnX7PY/IcKCfzW/+2NbCjUQVgasTHR8vIlsQJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/626] mei: vsc: Use struct vsc_tp_packet as vsc-tp tx_buf and rx_buf type
Date: Tue, 27 May 2025 18:18:35 +0200
Message-ID: <20250527162445.974586347@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f88c0c72ffb014e5eba676ee337c4eb3b1d6a119 ]

vsc_tp.tx_buf and vsc_tp.rx_buf point to a struct vsc_tp_packet, use
the correct type instead of "void *" and use sizeof(*ptr) when allocating
memory for these buffers.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Alexander Usyskin <alexander.usyskin@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20250318141203.94342-3-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-tp.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index eb51fbe8d92fb..ad7c7f1573191 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -71,8 +71,8 @@ struct vsc_tp {
 	u32 seq;
 
 	/* command buffer */
-	void *tx_buf;
-	void *rx_buf;
+	struct vsc_tp_packet *tx_buf;
+	struct vsc_tp_packet *rx_buf;
 
 	atomic_t assert_cnt;
 	wait_queue_head_t xfer_wait;
@@ -164,7 +164,7 @@ static int vsc_tp_xfer_helper(struct vsc_tp *tp, struct vsc_tp_packet *pkt,
 {
 	int ret, offset = 0, cpy_len, src_len, dst_len = sizeof(struct vsc_tp_packet_hdr);
 	int next_xfer_len = VSC_TP_PACKET_SIZE(pkt) + VSC_TP_XFER_TIMEOUT_BYTES;
-	u8 *src, *crc_src, *rx_buf = tp->rx_buf;
+	u8 *src, *crc_src, *rx_buf = (u8 *)tp->rx_buf;
 	int count_down = VSC_TP_MAX_XFER_COUNT;
 	u32 recv_crc = 0, crc = ~0;
 	struct vsc_tp_packet_hdr ack;
@@ -324,7 +324,7 @@ int vsc_tp_rom_xfer(struct vsc_tp *tp, const void *obuf, void *ibuf, size_t len)
 	guard(mutex)(&tp->mutex);
 
 	/* rom xfer is big endian */
-	cpu_to_be32_array(tp->tx_buf, obuf, words);
+	cpu_to_be32_array((u32 *)tp->tx_buf, obuf, words);
 
 	ret = read_poll_timeout(gpiod_get_value_cansleep, ret,
 				!ret, VSC_TP_ROM_XFER_POLL_DELAY_US,
@@ -340,7 +340,7 @@ int vsc_tp_rom_xfer(struct vsc_tp *tp, const void *obuf, void *ibuf, size_t len)
 		return ret;
 
 	if (ibuf)
-		be32_to_cpu_array(ibuf, tp->rx_buf, words);
+		be32_to_cpu_array(ibuf, (u32 *)tp->rx_buf, words);
 
 	return ret;
 }
@@ -496,11 +496,11 @@ static int vsc_tp_probe(struct spi_device *spi)
 	if (!tp)
 		return -ENOMEM;
 
-	tp->tx_buf = devm_kzalloc(dev, VSC_TP_MAX_XFER_SIZE, GFP_KERNEL);
+	tp->tx_buf = devm_kzalloc(dev, sizeof(*tp->tx_buf), GFP_KERNEL);
 	if (!tp->tx_buf)
 		return -ENOMEM;
 
-	tp->rx_buf = devm_kzalloc(dev, VSC_TP_MAX_XFER_SIZE, GFP_KERNEL);
+	tp->rx_buf = devm_kzalloc(dev, sizeof(*tp->rx_buf), GFP_KERNEL);
 	if (!tp->rx_buf)
 		return -ENOMEM;
 
-- 
2.39.5



