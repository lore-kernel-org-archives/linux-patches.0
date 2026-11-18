Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036026;
	b=mHjP98W3etmQlWDqG8C2UzXINH1Msf3ApAUs9bc3F/6ZU64TWngU7po/Vmw4H1yMHeLz
	 0WcsGsTd7uvMxGfyOvxvx7UuMF423jgFkGHP4CBrohgRvQDhu27o5wNw3WI1DhguQ09Op
	 LAO8ASS0PUDiOZQfCVOc1mBQXm13rCP1GAiZebE6MovjUGJ4SDTL6+aiGmh0v3nHdlPsM
	 rAciM83yIH45f936rTQUwRTgAdGKulErVcj7FYk2JviFuncnVk7Q3+1UDciopq9aQFSeb
	 DHeQSmzISlwifdreHAYB1fRwmIdlKJFSXNsy/BnU8W8nRcO96uuQW3XvyRUqBVBzvig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t/A7o+1+tP/WRADrLS9DK6rsuwSTIf334/Iey8MpBwQ=;
	b=FnerjcufY6L5Mdt5TquF/E4jvUaQl17tRBToH/26ed+mq8rJLlLyi5ynH8Tcp0nG+E3g
	 o9RseOzkFv/j73mDPPSX0nKBmLIRKnjwhL+qZvzCIBPhBfLJK85i6JM2Ld+Fh7/BVohPe
	 zz/SXlPDnQw3suGlZ8Uw1FjJsICjP+bEPbQ6o1YA26ePMeScw021EpdcVRZjZo3+OJM/y
	 tdD5UfvRCUjcOfDl+UyOcmogq3lGHtwbRxoVnpCa/kW4ohFUjwZyw4Hnk80ZrxpGv38w5
	 kn1O0XyJkUP9mhck+3DiDzRUtekuKYIeBV0eU1rtGpSV3sJD7KSTveCdKdQcyog2rlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tJMNF2Nr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11944606A31C;
	Wed, 18 Nov 2026 21:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tJMNF2Nr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A511F000C4;
	Wed, 18 Nov 2026 21:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036025;
	bh=t/A7o+1+tP/WRADrLS9DK6rsuwSTIf334/Iey8MpBwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJMNF2NrgHPMnAHOLgvPdIfmsgRLXJGLET9xOpmU0x2CgTVrFoGR+YXLG0e5JfdeJ
	 ZBBzknPL44/LzkQtL5iWhqcy8xEyJcT4SutBcALrSm+8kuOvol9sVE5NHTcRbDtLfq
	 Iiq5hQ9LDabRiwtbC3URS7mB47+TptsbgoBsHEWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0911/3318] crypto: amlogic - Fix IRQ handler return value and fallthrough logic
Date: Wed, 18 Nov 2026 15:25:33 +0100
Message-ID: <20261118150346.843132179@linuxfoundation.org>
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

From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

[ Upstream commit 4b8ae2732070c5669adee2d5d3bb97b14af53a63 ]

In meson_irq_handler(), when an interrupt matches a flow but the status
register is empty, the driver prints an error but doesn't return. It
falls through the loop and incorrectly prints an `unknown irq` message.

Fix this by returning immediately. For empty status registers, return
IRQ_NONE instead of IRQ_HANDLED to avoid masking spurious interrupts and
allow the kernel to detect interrupt storms. Also use
dev_err_ratelimited() to prevent console lockups during an interrupt
storm.

Additionally, the handler returned IRQ_HANDLED for genuinely unknown
interrupts. Return IRQ_NONE instead for unhandled interrupts.

Cc: stable@vger.kernel.org
Fixes: 48fe583fe5417 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index fde4f7bf7b1bd..a92d209c7a9ed 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -37,12 +37,13 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
 				complete(&mc->chanlist[flow].complete);
 				return IRQ_HANDLED;
 			}
-			dev_err(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", __func__, irq, flow);
+			dev_err_ratelimited(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", __func__, irq, flow);
+			return IRQ_NONE;
 		}
 	}
 
-	dev_err(mc->dev, "%s %d from unknown irq\n", __func__, irq);
-	return IRQ_HANDLED;
+	dev_err_ratelimited(mc->dev, "%s %d from unknown irq\n", __func__, irq);
+	return IRQ_NONE;
 }
 
 static struct meson_alg_template mc_algs[] = {
-- 
2.53.0



