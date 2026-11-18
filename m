Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043220;
	b=zxHQaL+jBZhuzb1sOiGBa4PyGP9q7OCAItHkkD2YZFccAOYnub2R/kYyy6I9SYgBkNJv
	 Ii6FCSeBCuXK7u6xKDKAHys9oqSGWiaIYWGd4Gz9HdcSpOlPjVpV+69F2srO7H7JzYPzw
	 fMwmJWBzmypoXnxqjRlhnEf/tb9ykoGPL9VlgOOntJ95q4Byo/Tk4wCtUSb8ET19u8/sA
	 DO9veq32LaS09MEf7RQEaR9jFahreYqvz7JWl9rZrQXSTrZu22MSLTdLG64DvldxsMKLC
	 Kp6ZebT6zoc52mRrRIVmD8wKTYxW059UBdp57AaDhSB3VzlMMWwYiBQOFiKyYhKyDcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n3apMuit/ZPLV+8BRW0Ox6x1XB7z0muiTIv0bNw474Q=;
	b=liS0GVGh9QO14W+vKLO+OFH9EcV5QSLptK8CRQgcx3Ita6df4GKOy5GcQVKXx4NtmG8P
	 17kQT4LnBciJfFh9CZ98fW+arR1wsQnNaZGu9i3MiI61zX+6+D+LViT7XqbYcGP9RNIRP
	 HNvFFFDSmxjo6wSmYuCEQedKvZ4jfC31Dr0wnoO6gUN8eKpaF823PNQR9TerHhpCLuX2e
	 WU0icOIyNJoSxyo4HFXK41JMwKtTTuspKWzYw1uh3BRIcAixWfBh0dhdw/CCLd4zfddjI
	 v6PoN1iC6MRAkcLhOTT8jFBGLNymsSqRjoUlh9XuZRNNRO6ezwETkHVD62LTXs7dPFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5UD0lZm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5F6606A325;
	Wed, 18 Nov 2026 23:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5UD0lZm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849BA1F000C4;
	Wed, 18 Nov 2026 23:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043220;
	bh=n3apMuit/ZPLV+8BRW0Ox6x1XB7z0muiTIv0bNw474Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5UD0lZma1yKK35G0kBDKVkWhBXq14ZL7a9lXtZrg5hwdljX7cgCT+sCq73SyYaSl
	 MgwMH1Ocpv/+JZg5wDi6kXqZQ0lTtRyk+vIGktEhr4PlOPx3a37lCS7EYPwDwpi3ac
	 j360qW8S+2QRWTyo9KRPKov89Z5hpq0P7mtiO7NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0106/2857] comedi: pcm818: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:19:00 +0100
Message-ID: <20261118150205.077296903@linuxfoundation.org>
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
 drivers/comedi/drivers/pcl818.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl818.c b/drivers/comedi/drivers/pcl818.c
index c5b60616967e6..4a61760d1be8f 100644
--- a/drivers/comedi/drivers/pcl818.c
+++ b/drivers/comedi/drivers/pcl818.c
@@ -534,13 +534,14 @@ static irqreturn_t pcl818_interrupt(int irq, void *d)
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



