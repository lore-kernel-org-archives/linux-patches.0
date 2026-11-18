Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036314;
	b=g9V/ombtAtOz9i087hGl7LpWdsDzI8mlzq1m16PZ5Y18/mE7/cgdlSgzfUu39CT5rqgl
	 yJpqw4lVu9H0FoS/bVhUhtQX1MMg1Zbg+5E8oe/5ZJCbrGnElGuo4h302F5/6fP4JJwE9
	 PRqcukz8VhTLeNxZr8l1K726o1nnoA25OfxwIJG7KFMdSKmh88iSuvseNx217kNZaXWYR
	 TIFhcQvOM8XWqQWmCnulwmuNTxqjfjXUnwtgdkMxQL97jP6YRHrjVV5NmzJZxxLafoqmB
	 Omluw9wVsBSbSwzZOObIbFoch9VHTK0+bdRhPNR8pMPutIiaM5GDnijz/VTOkZsfU0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O8T92WbSVt/BO1GSKvbCF/nXexiDgh9XsoCh35M3yJg=;
	b=YHbmEtrryuOmV6tL08pPMBxc4b2jZlQpQitgJDmEwT0st9dtdfagG1JtJaoKF7Jz4/pt
	 3RuWIk5Tnl0GbPywFc0XhS0cZBBEMz/u4RSecadRuAeVkXcdIjsyFX0la5nSoVCgdARls
	 LbAJk1105Vmir65S4Du9CZDbcPOpEym9yFJKTXzcrMKqmg7L0Sk/+P9we9yrLjrw0k0QW
	 pHCDfhYSTJfHZ2MswZ58QwBtsuOUP+8f1mwhOFWscZzFI0F50Wg6iS4d8swL52aNGRcAZ
	 5fHofB+nWpgoUHo+mhgqiRo8JY5Ih90B8sMvhPONWzKZnlYdSazK7eMbzU15RNCm2ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKnjdoHu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF79606A31C;
	Wed, 18 Nov 2026 21:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKnjdoHu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A701F000C4;
	Wed, 18 Nov 2026 21:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036314;
	bh=O8T92WbSVt/BO1GSKvbCF/nXexiDgh9XsoCh35M3yJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKnjdoHuBNOxHfyVdN61COOPWPJv1Cz0q9/NWg2ifG6VO/AMwWfS997s7GusRe74P
	 d2Jr6H7P9yOHtSFDDUtsNNn9CZJY5GR9Xayhrh9h+VfW9qOoItf+F4gjUi74Pi7k0b
	 xIOvsW2piyRtlHL+Z9Pe8a5A4CEbfcp9OjAll67E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0972/3318] staging: rtl8723bs: fix RX buffer OOB write from device-reported length
Date: Wed, 18 Nov 2026 15:26:34 +0100
Message-ID: <20261118150348.865516073@linuxfoundation.org>
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

From: Tianchu Chen <flynnnchen@tencent.com>

[ Upstream commit c52929073fccbc149267a2fd7458626a7e9abcfc ]

sd_recv_rxfifo() trusts the device-reported RX0_REQ_LEN value
(hal->SdioRxFIFOSize, a u16 read from the card via CMD52) as the
size of the next RX packet and passes it to sdio_read_port(), which
copies that many bytes into the recvbuf skb whose data area is only
MAX_RECVBUF_SZ (10240) bytes. A bogus device on SDIO can report up to
65535 bytes, causing a heap overflow of up to ~55KB past the skb
buffer.

Bail out when the RX0_REQ_LEN exceeds MAX_RECVBUF_SZ. This is expected
to keep behavior unchanged on normal devices.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Link: https://patch.msgid.link/8114c3adc1acaea78523cc0fb4d4b25f7665cee9@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/hal/sdio_ops.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/rtl8723bs/hal/sdio_ops.c b/drivers/staging/rtl8723bs/hal/sdio_ops.c
index 107f427ee4aa5..e825384fd0e1d 100644
--- a/drivers/staging/rtl8723bs/hal/sdio_ops.c
+++ b/drivers/staging/rtl8723bs/hal/sdio_ops.c
@@ -792,6 +792,13 @@ static struct recv_buf *sd_recv_rxfifo(struct adapter *adapter, u32 size)
 	struct recv_priv *recv_priv;
 	struct recv_buf	*recvbuf;
 
+	/* RX0_REQ_LEN is device-reported; the skb buffer is only
+	 * MAX_RECVBUF_SZ bytes, reject bogus lengths instead of
+	 * overflowing past it.
+	 */
+	if (size > MAX_RECVBUF_SZ)
+		return NULL;
+
 	/*  Patch for some SDIO Host 4 bytes issue */
 	/*  ex. RK3188 */
 	readsize = round_up(size, 4);
-- 
2.53.0



