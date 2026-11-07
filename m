Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064138;
	b=PSu6ykXIB3tTROgApLMHGVyRywkCFg3oEWc7+BYUMNSVqtpZc4dXwKdO675GordUwd2X
	 3kCaIFCdHKEZOV4fIVoI34f04JJH3Mm5WKw0NUwIJKN1xIiw8TJzYkZ8e7Jc4YrnGl66F
	 +KJ4OXLYq/KA14t8kV0CzcVBprftDbwonB0jqas0XylfkvXellc/AgWLyRfJyVkKBDtTC
	 XiEEFOCSusMl0tVgDt+w16uZPLMPE3jsAl0b3woHAtf88r00wD5+1ep5YsnCyZkg9hLuk
	 cfCLowKdUnw6aTZ7nYDe4Ska16DLOcjzamhoJ7OeGWpxCkSowV8zfxs58dXDLwz/K8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yiZXnouj5fr9ND5GPG8nNGFQORab85V23l5CdOjkvDU=;
	b=UbhmoN48yzGH58mzWabVwejLxuK4QyjjP0N5U0vbaE/M2DwDTqhf2lkg8aCEdNFRQPf7
	 bxfb4mSkY+TKr3XXA/1X5k5qgzw7/DlBx2oZZY061mT0z5TpipbVgVeYar968gzkmvKXT
	 8OsFOec7GK2A6S4TWx30PoOn+pn99erFmjdC6AGYifs1e1GqTJdxMKcDjNGVU5Il2QQFh
	 3+D+XHzeE/NhTcl3yXwRvFACO+3DdABOnV89i1SzZW7meRG1T9poDxe4wYm2NIJz7Wydq
	 QUoKaDuDYVMqk0T1zmqlPWbL85E7fVrF+Sa0RQHDjjbC7yfiHXOkyQUgRUQehRAHNcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geCSRKcY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28ED2606A33F;
	Sat,  7 Nov 2026 15:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geCSRKcY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB191F0089F;
	Sat,  7 Nov 2026 15:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064138;
	bh=yiZXnouj5fr9ND5GPG8nNGFQORab85V23l5CdOjkvDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=geCSRKcYSP/Rc+g0HQPROd1aKXxaw65Km7/DT2yg8F5q1z8/AEPu4XNZw1cMptijl
	 p7Yp8fCDwBbTRxW20xsKuxjRYpVtH7DMJs0sxDxt1or+GSTo1bBKcyKzb1RmHl5bGQ
	 JWlxY1aD3ZB9tbP+0N9HRHY4dfnivp+c3eqIvwPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0252/1257] crypto: amlogic - Fix IRQ handler return value and fallthrough logic
Date: Sat,  7 Nov 2026 08:42:28 -0500
Message-ID: <20261107134946.466700547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 169c6eeb51e51..09d3ccd92b80d 100644
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



