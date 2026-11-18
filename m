Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040034;
	b=FjAX5Fwm51FvW+Bh/MkpjaVrIe918KoAPK+ZKv2hlYM8k8mj0hYUFgup6jmrCLszjt24
	 viL0rOInrtt1rS4GkBo+xOoE8Rv0zuCLWn8tzs50PBzlGruKxy+yukpqv3CoaXmDtpqY1
	 20BLHMkEO6J8bo/rZhANFoJTWW6QOHwIfYF1WtQNhIct9Tm6Iej6GB/y2sruysIwFZOdq
	 jCSEMJLSKjbBVU8vPusQXGDL6u+3qt5fsakdkPH209z7U5NWKmZ9EorDWbhbcD+B7NyZ+
	 P+urazpmH8aZTYBNQviTwD21fm19sHOrnXsWff5JzIp4h0N9wsliCx4XY+IEofDMCKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q+NtTUmdAxPu3ER9e/DoKXTb+WhstizN16O5qrFv/7I=;
	b=hsHmInJqlFR2crAbeTgfXFeBTFTbC4L+Oi/a6M9KGNa5bshGoaA7speypzU0QTUg3Q/7
	 NVuniZyIPL5Gs7oXHvBsrrvUPAnqOlOJz6yNTtuFDKPnbjIJqru9sa/+04owfU9MnBVfi
	 MLIaI6+XYZ04gFJL7hNktbexu9C2uAoBr0bsQC/R6SEUq9ML3PcMzX/g/22X3CScdZs3P
	 NKe2Y7rQ/z9+QrOCCQmLBQZzfV7TtPyuApIkkmcEAEmHD54TAywHnhW2frDUgTdBQoDRW
	 dwmPG5bbWAbioHzANUKb5yChlFDc6eQPtFtjh62rRNdU/UohkQcZDmeltcSVhiPEiuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ui1Ssv3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65C7606A325;
	Wed, 18 Nov 2026 22:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ui1Ssv3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121D41F000C4;
	Wed, 18 Nov 2026 22:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040034;
	bh=q+NtTUmdAxPu3ER9e/DoKXTb+WhstizN16O5qrFv/7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ui1Ssv3vwSKWUH9hZRKbR/A5M/bYgVNCXkrLjSkCnKisVXNyjq9jE1zmFQpudivOt
	 C/ndh77Dw0a/hprPqb6WyTqEAWnM4BVezgrCn7TeCp8B8PWvffM9mOvRDzxZhv8btU
	 6E/KBSnzt23pfwntNjRFmLF0EtW5PzfbyYlcyha4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2311/3318] swim: Perform ISM/IWM mode switching according to specs
Date: Wed, 18 Nov 2026 15:48:53 +0100
Message-ID: <20261118150431.023714367@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 52981bb358d1b5c38040b00f81e2cf973f9148ad ]

The SWIM spec says, "MOTOREN must be low to switch modes" and "after
switching from ISM to IWM, the very first command must be a clear L7".

The ISM spec says, MOTOREN "must not be cleared until after the Action
bit is cleared". Perform those operations in the correct sequence.

When switching to ISM mode, the Mode register has to be selected with a
particular sequence of bit flips. Set q7 low then q6 low then mtrOff.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/75714ecc9a12d59511967dc9e24163dc8f3bbdd8.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 741e6086da851..cdfe8fbb16913 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -149,6 +149,7 @@ struct iwm {
 #define ACTION		0x08
 #define WRITE_MODE	0x10
 #define HEDSEL		0x20
+#define ISM_SELECT	0x40
 #define MOTON		0x80
 
 /*----------------------------------------------------------------------------*/
@@ -223,18 +224,21 @@ extern int swim_read_sector_data(struct swim __iomem *base,
 static DEFINE_MUTEX(swim_mutex);
 static inline void set_swim_mode(struct swim __iomem *base, int enable)
 {
-	struct iwm __iomem *iwm_base;
+	struct iwm __iomem *iwm_base = (struct iwm __iomem *)base;
 	unsigned long flags;
 
 	if (!enable) {
-		swim_write(base, mode0, 0xf8);
+		swim_write(base, mode0, ACTION);
+		swim_write(base, mode0, ENBL1 | ENBL2 | MOTON);
+		swim_write(base, mode0, ISM_SELECT);
+		iwm_read(iwm_base, q7L);
 		return;
 	}
 
-	iwm_base = (struct iwm __iomem *)base;
 	local_irq_save(flags);
 
 	iwm_read(iwm_base, q7L);
+	iwm_read(iwm_base, q6L);
 	iwm_read(iwm_base, mtrOff);
 	iwm_read(iwm_base, q6H);
 
-- 
2.53.0



