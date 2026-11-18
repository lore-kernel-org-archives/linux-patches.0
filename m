Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016929;
	b=FCRGigLKq4PPz7MKOr/7IDXGCNg/ucpBG1dKadF2gugssc0egfqyU/UP4dwFOtHlMQPs
	 xUh1EpQZlRQTwY0DX992K7rHyjvR7DpCLkk3Ot+1W3TgV1SSmn2atnKfMjtQc5rdXzpUx
	 pu6H76B0DRByDE+8MthO+I5Cnf1Cc5Ryq/2DlbVBWEr2OyWVGOz6Za7dI/xPg2limmBAZ
	 sCZRRoWfW/esb4CvhmKjNI0KfPb6lJ0cNqQamUUIUB4lKfVg/V89jyxU8Ah7ig7mmS3HT
	 /dV0uLxyDfomFDf1Mmz6NaOn8cfkBXnPtOl1+u+l94Lp7oFxQj6bjRbq2UFkJIWi2cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QFVejcbKCx2M2BnsOPmLdgUfY0lv1bCB4NHkIeFUGYI=;
	b=JWm7c4oWRztZCI9efnFanrv9bsx6i36zU3xx0gLwQCbgn3etJrNnbQE2H3HVpsYpheRx
	 Ir02Nhn8Nddx+E768dIu95jl4/2kPApQHlKxjr5uD6YIKkHyB0z76V7MgJQ9OG+RPryGq
	 NqT2IZ8KEY6kYEU6kHuDAo8ejyn8WX9Ev/GpGur/2s6y+BCbTOtIvmxDoVJSsbUDf9SI1
	 uRiYH36JuFwPsdQHjV6crkW+AI0VI6mLQHXz4T2lXgT9Uq4KODkcCB8dyaNALchpjXpwo
	 n049ny/dIFzdmt7D3SIuAaPPEjhW2/YxtZDEJK7ODGtt+Mlrd3x3X3wWGFLrIWEIQFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XLkMxCXi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D413606A31C;
	Wed, 18 Nov 2026 15:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XLkMxCXi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD771F000C5;
	Wed, 18 Nov 2026 15:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016929;
	bh=QFVejcbKCx2M2BnsOPmLdgUfY0lv1bCB4NHkIeFUGYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLkMxCXiCdl656FuUeTIbrJJWMEagu+ZtTNJiWdEdQt5+pRxU3QEVOWBnf8PWPI6m
	 iBMSMMgS7PUAxIlzdcrrr/Siy/jNzTTWblVZTU9ARTfkLVgOGhKpvsee1D1/SdldYC
	 PpruQ3Ni0PtQf3ipwqEPvgopZKEd3vMtetMiRl6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0704/2651] swim: Perform ISM/IWM mode switching according to specs
Date: Wed, 18 Nov 2026 15:32:24 +0100
Message-ID: <20261118150313.174232770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 3f92677ad127a..190b2e1b5b0e1 100644
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



