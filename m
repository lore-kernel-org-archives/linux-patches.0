Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062932;
	b=5Ht8pwhZt15VZ3d9HmKKi/lBMX4XUc96lorUOpN95vFfKmQl1IrT911rjyyJXZ2m6OOC
	 1PW1QT4auhDKNEVRJadigPkGFVYrHIPskFNERgrcgEZ0EDi9JeKnJgyOayxbk0q1sCeFY
	 Sk0GheXVTKNc+r+cAntUhkchW0A8Y7LnlH+Y/nLw7flttekvjHn10toejFVY9XzS6TBF/
	 zdXZxPyDoPz3Jdn+kG/rLVRBf4l6Z3cEVgToeXI2f5kcC3J6peZxWjqhXTCw9ZLsR8tlC
	 FfI73E7OiybZBX4Bh31pLCUhOaOra1VyyjuN/FGBwnUq/x452gdhOmXDBPSaoV6tKDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ztkL8DtpeOL2YG0RJ0rgDqMXFW8crkq9Xa7dWBd+K7A=;
	b=lq7u/TClPbi+b7dKvpbV1EpJnc6G7/u84Jt6Z631xEjpT6qL/F/576hNCJR5ClNGwPA+
	 JPhi7aMfWLsch+350JlNcjIgLXlLJq0saG906B1/GRwSY65Ww4T17ILdSwiXl43mLijPi
	 X9y5OVX30wPXxgfC59mVXIqFKvifSADmrh0mndxQbPyImQAn+Y2HkNkzZzybdiQCcE6tl
	 PPvkbaVp/j9BsDmguvYFx6u2enXKSE/Q89diZJiUDbyYBGC3TN/shnQMML8eDMDajL7Cm
	 dnj0aCBs8wTT7MukscywYp7TFuYzipp9W0aRaB9nlrrXM8tjjhPhd+E9XYcA/u2SZpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1TJ4jXy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E098E606A326;
	Sat,  7 Nov 2026 14:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1TJ4jXy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811DF1F0089F;
	Sat,  7 Nov 2026 14:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062931;
	bh=ztkL8DtpeOL2YG0RJ0rgDqMXFW8crkq9Xa7dWBd+K7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1TJ4jXyS1YDvmNUhbwmyKzUHnIThJUbZ6cHzTYKvV1TergNzg7y4w0nO/VubUptE
	 X8urvh8QMYzFhaClOTGZnnOoW4OIjPqsi1akcPLULGfeo7aKZcM5v8oO+9Y8ECt7yn
	 g0ED1/JFv5rRag5ZqIlgko56ZTa46O/Kcidxeavc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 202/869] crypto: amlogic - Fix IRQ handler return value and fallthrough logic
Date: Sat,  7 Nov 2026 08:48:04 -0500
Message-ID: <20261107134858.865171504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6cb33949915fe..7194117518b9d 100644
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



