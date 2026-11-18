Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045085;
	b=N5KMOpsTkp2gPvmEsR+qbcGp2R012cjo7Y6JMY02orQgeZNLuYwIzS3e73jqvb2z9599
	 LNk0CuOg+RZtYHWlQc0IetQt9eTVpkFhSURYfBgA+k6sSjHdgRtbqsL0Nh/AQ7yJ67VSL
	 g66dWk13cIBsS3Kn5rmFNuKEzF1y+PZ1m6zaleDidY3q5rpVoorAIqdx7UEz5lYRbjceP
	 U7rIa4HGa0BWZZ7UwWXnCm2UnevyDJhWudzM3TUINSIt3E5RrZu6xAObde+1QEKrSOYhu
	 D76ixCadJPs2vqPg6DgkzU0wFaWS4LbRpKdwOCivcd+EWfRJXQNMbvpSvnrxZIA1nkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TeyL/4sjhaso/Fr8ekPw3ucLau6vxZ2oXJ7KgXMKOC8=;
	b=vfghS1iW2/GJhA+rdhwgKGlLSNqNpNMder6+SMjKV0ugGmpZyhd2/FKQxUXpASF63GAB
	 P7rTFqS9jhnCX0uoSJyf1v2HboC6AKZuIw2awvp8wyeB1zhiLFDJqZlEfqNTXJsY3JdzE
	 uDVrPIdoG8h1/e+7ztSZ338aYUa+/QB0e4McANJLOMAqtP/503NxbkwQoGyclHcRkMkTp
	 pQL+z8MAFK7EGmZcsYJM3Ypz8ULd67FdymztnrR8+k17cep7cwckeTRognTiPOPNp35h6
	 A1vLSgRXp9SJ9u8rQJgZodorJqqI3y9H1VoiSyFYslr5jEgctKUNdoHArdIH2RJCGTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z6PTgiMZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37F3606A334;
	Wed, 18 Nov 2026 23:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z6PTgiMZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0410B1F000C5;
	Wed, 18 Nov 2026 23:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045085;
	bh=TeyL/4sjhaso/Fr8ekPw3ucLau6vxZ2oXJ7KgXMKOC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6PTgiMZzv49DMtaKA1EJXZ6JiHhy5Xi+EvLpZ8gwHyEVBUU98ryvUuFEWMzpTXz9
	 eBF3Kg7S+a5LT8pcuv/l9bDqPRFWatVdgO5CO3GL09Kx618nWGSgwJntOEgR+IrHh0
	 piWoiBhC4EYyLvpQfH8NVLGpdGyWmU9e/Qbo/aJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0799/2857] crypto: amlogic - Fix IRQ handler return value and fallthrough logic
Date: Wed, 18 Nov 2026 15:30:33 +0100
Message-ID: <20261118150230.344723590@linuxfoundation.org>
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
index 5db6848b49af6..c4c4b952d389a 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -35,12 +35,13 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
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



