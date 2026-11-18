Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048482;
	b=aAcAMpEVzkriFMwdMS6f1J8YAIYsL9bO5eU0bWWuZd+ZzLcNENn3nZaKDdZoQOEiZxXc
	 KD+fdAiT4X13RHDPYURQlc0RPFYodNmrsDK6uaW7C2YJQOYtjLxHMDGGBQ6CSe9D/L59O
	 i6xU1cCO2ld9t4Nw6moHxiiD+OypmXFGJwarVloUNXqn6emW+Cuh3iYheMeb4i5weCTpE
	 GGPqy4VzzJ2SsaEDIpSWMuBdtfRz7PNysqqktB+M2m1meqNWnCwgbGxCX05X9VnaKk5DY
	 Y3RQE8noJuq/nJ5IZ6USl7nMf9TQIxZrBew7it+DcgkDMi2+PMzD2oi2VF6ZVJfTuqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VEFbX4hBaUtsQMRWit6l/ksmRQ6yGRBXKj4D9SpzZ5g=;
	b=dfPxs2skhLcu90cUuJes4uKutURyWFCCslT6a1NRwl5pK0S6Cdkt1DBn+eYE16XFD2wf
	 dB1oPmhuf4JYPYgT61Z8ilXMX5KrJfUabdKEvIHn7/iY+gxzauIWhRwRLTqH/rzWt1kyG
	 Loqdyi9F8NrIjNmvQyTENrTo3e9URbIm9yMkbLjjcCpRUnNYl4ImYuiexvMR2ywqx6w1j
	 xo2Y4InIlXxoy7rprJuaXNMO6jZ3cq7FmasN7So6Wi864GCzdxQxOYiKxmxTs58xAwH7N
	 tIEsyivL4a4xBRCZfs72iaf+C7E7PNjRXVKVv5r7fxk4mfYIliXgk9MNFur1VWT9xBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fo7uBRxz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD2B606A325;
	Thu, 19 Nov 2026 00:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fo7uBRxz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506381F000C4;
	Thu, 19 Nov 2026 00:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048481;
	bh=VEFbX4hBaUtsQMRWit6l/ksmRQ6yGRBXKj4D9SpzZ5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fo7uBRxziDZG7gpXMEYP5QpznePw5FnGa8Hhf8pbf+3VwDb0SjVFpo3qmKZCrgEYc
	 FqSH828bVe4r+zCu3Oe0tNf9PrS36Kwyq25piXuPK7Zgm+4z2RGRnkL38AzHo32K/l
	 Nfwcrp/qYTiGzWgrEU4yZktltnWqX/ym/a1AfY5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2010/2857] swim: Assert strobe with stable outputs
Date: Wed, 18 Nov 2026 15:50:44 +0100
Message-ID: <20261118150313.772239149@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit adcc410bfb41715fef198a0975db4ed594a49bb7 ]

Inside Macintosh says, "Be sure that you don't change CA0-CA2 or SEL
while LSTRB is high". Unfortunately, those bits do change. The CA0-CA2
outputs become inputs when (LSTRB << 4) | LSTRB gets written to the
phase register. Then LSTRB is driven low (with CA0-CA2 bits set).

This is a problem because the drive interprets a STEP command as an
EJECT command when these pins float high. This occurs intermittently,
perhaps because interrupts are disabled and the race condition happens
to end well. However, when I add code to step the heads with interrupts
enabled, the disk always ejects.

Keep the four phase pin directions set to output and hold their levels
constant during LSTRB signalling. Introduce the PHASE_PIN_DIRECTION
macro to separate the pin configuration from the logic level changes.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/6da86b9bfd1335fac3ebc8c435fb613d5de4a70c.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 62 ++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 42b4b68286909..c82447a4656b2 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -87,37 +87,37 @@ struct iwm {
 #define iwm_write(base, reg, v) 	out_8(&(base)->reg, (v))
 #define iwm_read(base, reg)		in_8(&(base)->reg)
 
-/* bits in phase register */
+/* Bits in phase register */
 
-#define SEEK_POSITIVE	0x070
-#define SEEK_NEGATIVE	0x074
-#define STEP		0x071
-#define MOTOR_ON	0x072
-#define MOTOR_OFF	0x076
-#define INDEX		0x073
-#define EJECT		0x077
-#define SETMFM		0x171
-#define SETGCR		0x175
-
-#define RELAX		0x033
-#define LSTRB		0x008
-
-#define CA_MASK		0x077
+#define RELAX		0x03
+#define LSTRB		0x08
+#define CA_MASK		0x07
+#define PHASE_PIN_DIR	0xF0
 
 /* Select values for swim_select and swim_readbit */
 
-#define READ_DATA_0	0x074
-#define ONEMEG_DRIVE	0x075
-#define SINGLE_SIDED	0x076
-#define DRIVE_PRESENT	0x077
-#define DISK_IN		0x170
-#define WRITE_PROT	0x171
-#define TRACK_ZERO	0x172
-#define TACHO		0x173
-#define READ_DATA_1	0x174
-#define GCR_MODE	0x175
-#define SEEK_COMPLETE	0x176
-#define TWOMEG_MEDIA	0x177
+#define SEEK_POSITIVE	0x000
+#define SEEK_NEGATIVE	0x004
+#define STEP		0x001
+#define MOTOR_ON	0x002
+#define MOTOR_OFF	0x006
+#define INDEX		0x003
+#define EJECT		0x007
+#define SETMFM		0x101
+#define SETGCR		0x105
+
+#define READ_DATA_0	0x004
+#define ONEMEG_DRIVE	0x005
+#define SINGLE_SIDED	0x006
+#define DRIVE_PRESENT	0x007
+#define DISK_IN		0x100
+#define WRITE_PROT	0x101
+#define TRACK_ZERO	0x102
+#define TACHO		0x103
+#define READ_DATA_1	0x104
+#define GCR_MODE	0x105
+#define SEEK_COMPLETE	0x106
+#define TWOMEG_MEDIA	0x107
 
 /* Bits in handshake register */
 
@@ -269,11 +269,11 @@ static inline int get_swim_mode(struct swim __iomem *base)
 
 static inline void swim_select(struct swim __iomem *base, int sel)
 {
-	swim_write(base, phase, RELAX);
+	swim_write(base, phase, RELAX | PHASE_PIN_DIR);
 
 	via1_set_head(sel & 0x100);
 
-	swim_write(base, phase, sel & CA_MASK);
+	swim_write(base, phase, (sel & CA_MASK) | PHASE_PIN_DIR);
 }
 
 static inline void swim_action(struct swim __iomem *base, int action)
@@ -284,9 +284,9 @@ static inline void swim_action(struct swim __iomem *base, int action)
 
 	swim_select(base, action);
 	udelay(1);
-	swim_write(base, phase, (LSTRB<<4) | LSTRB);
+	swim_write(base, phase, LSTRB | action | PHASE_PIN_DIR);
 	udelay(1);
-	swim_write(base, phase, (LSTRB<<4) | ((~LSTRB) & 0x0F));
+	swim_write(base, phase, action | PHASE_PIN_DIR);
 	udelay(1);
 
 	local_irq_restore(flags);
-- 
2.53.0



