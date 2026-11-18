Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052411;
	b=Q9ZqmEOwKyOgZuJgpkFXbbMWdR/sEg9/iLG1H8CANdgqCMHSKbPtXsqshn5Pnyyl6TfT
	 a4YKtaa6Ivh1AbA1F6GIYQUvoL8JOBnq2j0Ek3mcQ2VQaYS57UpGN/26+uY5NFoqtVXKF
	 ql55upAedNUsc1wU+ZjlRmM0M3qsVnyBhlCdxLKoIf24lbJpF54KCAvJeoyakFfARGUZd
	 nLiIv42q7GTnkiytTtq79f2bvyuHvbcWQz89u5iPFiRpZZwKhG6CHwpJM486utPEe/N+n
	 mBrjhynJ2VDd7GRe8ZZP3r22IANJXoS6Degid4d/t3zmqb8mqB/3/WrKGqgxYvbm1BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yu7YySPQPz6bcY7HBX+QAZK6anQT220mYFi26r+AGSw=;
	b=N1xe0v2VoNfdP1PMr11Abnsc6cU7OFAFeR1zTKJhGFZpDQ93pNvVlSLQtJWkVjmZXM37
	 6PKN8e8tQqDhYwKpzst7uyu2UDwTYpTJ1mbAlDUttvELBOZPpQQcuIwgbQGvj3t4fPEJ4
	 4lUklvjAO/E+SyMxUf8XYn4KlAuG/ytN6FoSNotuBFoPMkSKN2/0NHcsbAuGHDVZDkHp4
	 8b/6HR0ZBqq5OkzOsYDelbvcYc3vjKpD7157scSh8TKzXvQykfEF6FgyGtVOyzNTYaxkc
	 OiE37yCX6U8lxOTuOy/Y/ts//MIZCUtIV9rmPKrCX3pBrBoX+Jvh+Z4/N6RbzzqgTgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeEGCAwB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D530606A32C;
	Thu, 19 Nov 2026 01:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeEGCAwB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E011F000D0;
	Thu, 19 Nov 2026 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052411;
	bh=yu7YySPQPz6bcY7HBX+QAZK6anQT220mYFi26r+AGSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YeEGCAwB25eZ04GEpWIdH6ePcANGa2ZDAAe322nZ6sx3kachqZ8eoFBGVMSjjMAnY
	 xXWWsaZxyONAwUNwFz1TjWzihG80p1pH7FS4sBrfgKBJlUSPwANBTa9kIclzNWKeST
	 vdk26DrsvNTElj2bl3jV5NMFLwd4qcUtDx/zRz+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0553/2214] staging: rtl8723bs: fix RX buffer OOB write from device-reported length
Date: Wed, 18 Nov 2026 15:37:09 +0100
Message-ID: <20261118150033.145112100@linuxfoundation.org>
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
index a545832a468e7..c2a52fa303bf9 100644
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



