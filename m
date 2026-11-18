Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045359;
	b=ogKdvPKPbT3+mWPhylhuWEh32CjbcwfjKjkYt4XWWNyUcT1FdTFRQWqUnBXEXrYR7alc
	 GCF04axxQUZL20jyq5GgnmaIbsp09OTTFBKep9dzoZnECU32uMOCzb5UueHcDkTwPkOFY
	 0MjETWwJdv2tcND5KOmgmChs6SsZGzXJPZc25llPVtvnByVeLtN4e5czODWT5QBjYmAkv
	 KdX3hDX2tg0y3y5RSQX+pb4MOP9O9/+1QCIfKMLZZf3EjOb+44c9V465uGBneo0CVt7Iz
	 T7WMziR/a3WTQQ5bsVPo3ZEdc9sFm4MHaBQTK7mu0Yip6MOi2l3csXgXrRIBinfhS2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sDzFMh1R0glAa21A8k3EPCfow2eHWnU3r9/8QZ1S82E=;
	b=DgwBVsgszck/44lQ8RU4GsW6PBbbwu6Mff6EM1ZAHzm12PXambl1FvbSzgyXhLlJk8uA
	 KeoY3ImuzP/lSVQoyYpoP1qB0VtQvBldLG59+GMPo95sd83GYyd2zqucSOnUCrsWe23nl
	 4tklt7fzqlrgYR+De4Ds02njE+6a7aLZOJxsqaIXMPVCmS/joWlqrNwzUQ7LtwA7yPtk+
	 1FPwHKuMNpduAEKqWv2d1bVpGiIXDiRZaMDAxAaFsiK4opDGrAN88pkTbdlWCGMbdZ7UK
	 U7lJ+tl+n3cEl/aD+lgnnoXQB9odLV3hxGMH3GNEb3/4C92p7XnrhpVkwoMcNSit8CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMYLiCiD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C39606A320;
	Wed, 18 Nov 2026 23:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMYLiCiD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2381F000C4;
	Wed, 18 Nov 2026 23:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045358;
	bh=sDzFMh1R0glAa21A8k3EPCfow2eHWnU3r9/8QZ1S82E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMYLiCiD7VIrKR+fRRH8T/7H+SWw+KIxrV6hdN+5iBdySFtN08xYAdA7BKBCMMuh4
	 1cEsGeFRzeMPpQHJ0WM/a5LGFOSK7Z2e1gffN67OavLpzHqV8EqKwutilJA5uNXTpw
	 Y6m72fQQB6C4560x+01JJy7PE9rScU4WLc3uSU88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0845/2857] staging: rtl8723bs: fix RX buffer OOB write from device-reported length
Date: Wed, 18 Nov 2026 15:31:19 +0100
Message-ID: <20261118150232.000691453@linuxfoundation.org>
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



