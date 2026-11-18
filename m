Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058254;
	b=gYIEjzydej4OASXbZ0ooEgUjzPhapejl6C8aMmSzil5GsHji377ZiO45WlhhN3S3gnfa
	 3PDz3gWCAAqA6bHYNXbDiQDCHaGirbHUKz2MsUhcAufokjTycvnIGmmMhFjwNCmpYTRIw
	 P20R6NyFApoYBKwqOuLl+M20sRE4HhIlQURKSNAp8Op0qSX7PNMtzvgZA5qtjawbdPsnj
	 fST/yWaPJ6Yk0U0ai+ejcenHJXCGFu3rzCpnfuFmLFcRe0o/nXkbbi1T+BLN/eqQiVuH5
	 L4nDh3cK4BL7Rs0n30+DQBI/mmRG+NxT/M1POhLOyJkUnKv5WXmkh2lGgUH6GUqtqJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dmsldpWRkd6DocN/MiORoCMQv7r4y2HmOHvM8zRIYYA=;
	b=unCo+VckphEf0EhSIrTRhAipqBS28D07DvNIxSp5GhqHfMHu4n+o5Yvp3BMP/pexdde9
	 UinvgKGz4S0YdyKLvY+2169HbOkdhgAdzV5KalfxYs7JxvOJHukOi00JYIsLwhoXYYGsV
	 a8gUUJ56k0xBUWJAj4yOWrsWIpDRgGQSHCnobtli3QScys2iC6LDQPz0us9+PTxT5Lg52
	 EpQ2HocOfFfuC7FDj4MK2ocThutcTOuVZAh65c7Cx4XkVY053VrQRYTXMTZBHFnpUv1s8
	 kTGBfeEdgOdJfkTMJLEYnytdx7V5HokwvTlyWF9LrEKUv1dyLuUm5Uz9n4GoWS5YbOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JeQp54Xa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193CE606A320;
	Thu, 19 Nov 2026 03:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JeQp54Xa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA461F000C4;
	Thu, 19 Nov 2026 03:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058253;
	bh=dmsldpWRkd6DocN/MiORoCMQv7r4y2HmOHvM8zRIYYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeQp54XadqK8zpCgTBQHrG1aLH6KEImkihRGQZtisjp7k6SeVKK7/uoIJ9dKq+x1Z
	 fVUFPiDRsbq8RDz5MJZn/3mVm7QfSDjSyZzrWCNLYH8cy7r4IjmRySFDIr1E7aEbO2
	 tGzRNtp9lwUnI9pzfVmfnj7o0R+XWvTjmuQfhSpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0420/1848] crypto: amlogic - Fix IRQ handler return value and fallthrough logic
Date: Wed, 18 Nov 2026 15:40:58 +0100
Message-ID: <20261118145931.566014308@linuxfoundation.org>
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
index 036fb7b44d518..96491774ebbb8 100644
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



