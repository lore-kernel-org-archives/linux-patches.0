Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057307;
	b=eAy4K+3Pt1lrGP8YRF6xaMd5CORO7TJCITME+X2eWmR6Uhh1/jqTE9SnAfZo6g7k+IUh
	 fQhmOmIrkH5DDywhWmfIi5Ggr+R0Pk5nYM+ARCqx+4CWt1z1G6eViyNZflOtfW5BeUIuz
	 PC8YA1o/hntKD20qG5KLOPbE/CmPsCe0jBNoXAzHqbz5k9QxiNY1+Q/bzVpdIO6RUSyBm
	 MC7xq7/av4cB7QAuEM118vM2JY4W8XF9Qn9q29bwagNtf8k3ZpOtUdEHkB2+IuIIQVY3a
	 8Ul9emr1Axju8TmPPGVQvSFJTT/apAFM7eWnbzI9FjDpgbdZxffhsDJtBqkKeVCr6yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LNw3TotxFhERmnNocgBmL65D3NGWhbWnz9IPJqraaTQ=;
	b=zJJXKJzBPavF3KmvtV5qBDgQVA+SRX/fpReJRVfVP5A2w5qek44o3+QJqFYEVhngH/ZA
	 vkur7J7KXKqMZtmzh5kmFnBP2wRYf9kwR5k+cvaMFvRBG3VGr4xwccRmg8iNvc3V9xaRo
	 pdvRAVfy2kfeKV/VvjS84fJYZgZmh01ZpFDfSahZbTUbPZv2kse5buOxoHxN4ZAVQWqGH
	 +hbTxRO2OJm7Q0SWhn8tk8I7BsvADnguAe4wDr0cq9X71cl2dGOA8PSUT2tsKQSySTJZp
	 j9DvI2S1caMXedjo63WO35qSJW8w05KA+9Pw+u6KfcR7Go8/Tu0LT4/JRALOQB38UBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JAUo2I5d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5251606A332;
	Thu, 19 Nov 2026 03:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JAUo2I5d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4073B1F000C5;
	Thu, 19 Nov 2026 03:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057306;
	bh=LNw3TotxFhERmnNocgBmL65D3NGWhbWnz9IPJqraaTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAUo2I5defQrylkPvvFu3nT1H3A/b5D4510Ybjfyyc1NhT3ysZXg8XTlfvUFsiiNL
	 3O0h3y7rM2D8mRL5oED5f2cokvbkYZLo1HgUy6PPS5Xt3IhycrFqdpfe/XLccQ+t3O
	 0nk52LYWcCXJx0M9qiRerq7Y3P9BnqvkOOZVuYIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0083/1848] comedi: pcm818: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:35:21 +0100
Message-ID: <20261118145914.611159260@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 956e8478261a575d1e87490f2e5db1788b8c209d ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-9-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/pcl818.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index f4b4a686c710f..e81260448eed8 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -536,13 +536,14 @@ static irqreturn_t pcl818_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct pcl818_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 
 	if (!dev->attached || !devpriv->ai_cmd_running) {
 		pcl818_ai_clear_eoc(dev);
 		return IRQ_HANDLED;
 	}
 
+	cmd = &s->async->cmd;
 	if (devpriv->ai_cmd_canceled) {
 		/*
 		 * The cleanup from ai_cancel() has been delayed
-- 
2.53.0



