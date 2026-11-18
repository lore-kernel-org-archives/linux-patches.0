Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052314;
	b=jH0vejLL3PRvoBhMNgbnCYV3vU+tW7pU5pmVjzs1iHrLfFHyuXo0JEEEB4dl3yqvL+sB
	 qXtCpwYxUOimVQhvocU/BUuWyXPoi+N1mUcjFbiEL4rpaIOYWaKD8ROXGb2iCJCKRDbvx
	 etP58p8i+QcrYvhmBi6B7chgP3LappcOn3djkI87SCv2uUrD+Cpy316+15B2zTit/cCpa
	 NnMO62vByctAHD5tsti1n3HucAulJ/Oo1G7XlHU8YDRpB9zdvLaEirkjgex6vNCXUPJqe
	 2ztcPEIIrMfdh1L0LVX8I+lo8Z313Fqj4KPsSd6AfYyJU/QFTtvY2OGMBEZmzhKcSaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=++B5zhy9z/k9Y5hDbZwH4bGZUJ8VEIWDXF/usm5R028=;
	b=ZNQYKB5AvueCuyYq01tKq7jnWJZYwIyWxcy+IEpP6rOFPzbUjxLqbrwNCdoF95ZAmT/q
	 UXVA4SO2qz7cr8+cj8+05m41zia0fkyLH2qo1XHCHL6RfWfh9CZeDPHzpkfQNRLkyWbW0
	 f1Urm4AlR/gW0xiH8B33SjViB22uHUs7mYGuW0kTogrLsgTfYnu/XgpTRIaXEMiCCov5I
	 gpxaYoq5p0sGJF5n+DzzyUXPr/fFxQ2R9ULaNYc/VhKS/84i+rlSZwHZ1hGLZXFSzCh+Y
	 s3cHyeymG4pIYJtD6aqyVJU6/vQcXvrSfl9NUoctRlyo2xtI41iCIjX1drp5mRlslpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1BYs6vNZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B1E606A31C;
	Thu, 19 Nov 2026 01:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1BYs6vNZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A367E1F000C5;
	Thu, 19 Nov 2026 01:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052314;
	bh=++B5zhy9z/k9Y5hDbZwH4bGZUJ8VEIWDXF/usm5R028=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1BYs6vNZX0jHY9IHC+3N8hzuuIEXdU5LKhdhAj+yITB604ozc45l9yg29zCGPef7b
	 QfleZjXxPTrBvjpFU3uFnZuVheOcqV/KXegY4zXT5NPsklC2z5pLlmXf5H1VN6KyuM
	 s9xx7UGHxf/i3ts1YnXXFJm0CV/FLMxzvt5XI8r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0517/2214] crypto: amlogic - Fix IRQ handler return value and fallthrough logic
Date: Wed, 18 Nov 2026 15:36:33 +0100
Message-ID: <20261118150031.777592868@linuxfoundation.org>
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



