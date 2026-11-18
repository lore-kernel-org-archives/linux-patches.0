Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058335;
	b=jmJW4f9Nq0oERLYoq+W7xLZVODtgykB4WGVIOeq6jXOC1W3i5vqGZJRy0aN4x0cAXOQe
	 VPN+ugw7tV7qZEN+iIaWD1lg2owFtedEbT2ev/cLTo5/nrV6zKlZEHoFxDwumnRosBTIc
	 qnOZ/CXuxhxpb0PAKyz8zB49tClPwomdgBTZZMUQMDEf1xDCIEpy0QpyfyqmJv10EcBmn
	 2ouxOgv+JfoGzblAH4hFJC8RDGxRJXyNMHNW6UV0l2KBiY7KSZ0xl5vBRCse39s5sSkSV
	 EUsA8zCTRORkzj4CcPSx2i+t4NaGqM7WS7HEI/ewnQ8BADZkN47kyQ+YqdxZ4aPWvkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rGkShC2XLumGpCWxmiErBQu1UEx3AXmeYZLBGUrmtgk=;
	b=t/pLsSRuzrtfETyOSth+MoiJtS4mEjqMNWjh4LZhBorWASWQSNZujpgo8JZDfytT+VFK
	 YVlj6AgU5hlfYUmoPpyQkMzTN3tBGGfeDPeUpYAfXPITopL1i3NBg4h9SxVPR66I4HhaB
	 Ire++q8JfmbJIcH1QZZyfBvj5io3UN6QYUonFa1l5mLwPuTQsVD3KGsQbT7QClvGujyhd
	 GLIvUHfEei9tA4i7rLLHZIYaLMHH0VNFbdCB9xdVkGlSYEebPTjHTaS/c6qFj0G3wis8+
	 uLxWVl/aduZE4qeYtdo/P+TQFUxQzw/Rzonj60r84/MlyI20TWj2c65kNkzrapSkw+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nOhrOFJN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DB0606A31C;
	Thu, 19 Nov 2026 03:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nOhrOFJN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8269B1F000C4;
	Thu, 19 Nov 2026 03:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058335;
	bh=rGkShC2XLumGpCWxmiErBQu1UEx3AXmeYZLBGUrmtgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOhrOFJNtWuxwODRMZ1UVuYU/g3hxn85VZBDafDNdB//liplddft4VdY7qBqhnsSK
	 jx41hwAIx1rzDpUpiJZB9wUl6YRpV23XTYdb/K6VM6VO6VBhoRhi3auktglzpgVFsS
	 77/fAKmSyk/pvOfQ7s2JxceDfA2/QTSZDcRODWYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0450/1848] staging: rtl8723bs: fix RX buffer OOB write from device-reported length
Date: Wed, 18 Nov 2026 15:41:28 +0100
Message-ID: <20261118145933.307852005@linuxfoundation.org>
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
index 31cbcdeac14a1..e700150525683 100644
--- a/drivers/staging/rtl8723bs/hal/sdio_ops.c
+++ b/drivers/staging/rtl8723bs/hal/sdio_ops.c
@@ -857,6 +857,13 @@ static struct recv_buf *sd_recv_rxfifo(struct adapter *adapter, u32 size)
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



