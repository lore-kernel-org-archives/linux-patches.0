Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033744;
	b=gyYofYaSXnfsPfCD7UE0byWrPmNSnA1aAVSl1/EUJ4ngBtHKEYbRUde3jvo//oKbImj5
	 fcQG9VvAMgmR7weHKia6ZjOhJwvh0LIwnkE5roMPndpSDaSHMCY2FKyMeKi/FTY/x6dmv
	 xlHhATmGe7hDXNy2b1Un4grZBcf8G9/i6E/Ke87AykGDce9m2JBOS0jEl4ZOerMdBmiet
	 alkFq1DNO1TfZe94EHVL83e/DeEMcADZ1NRaUhf3d5KZZ2jewPThjj7iV2SXwZe6MQV+m
	 NGchYOv2D2sl+Os5ANb8va6jPIg8JmBtj25B+Q7jZH2/2b36i0lO2DNfYz5STMZ3tXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tSbcqKI+Ymn1wp2Uam+ZlkT3PdyTFoBaBhk8gvNsYdI=;
	b=WhX/YMQLpi7fPFlWbZd7BQpSZmZ9rSctslFGwK0h8pbbt1AxSol3uDMiM/iBaezTWlcr
	 jsFEL0NMEWZFBUM2CScrCGIWV7lQcGmwDHkv2oNUewodVvGd5pmz826XBNrJKPAwe3e5s
	 0YVXmbIs+HVEtN9HbuCNd8TWhOVKXoqIjgEKhKdKZJxwAMHPHM3IwQerxRTEhx1i8UV47
	 YKKSCdoWgqpoUhHr8h7qvOwyqSgLgCzCuJcEsEvvPEfQAlv/tawLS/9rjS2kJaxyYDP4Y
	 EgatMg0EGmSuWXZRHP7frkm8rhiG56mU/AvL/dOg2BJZcLgKyxJf+uBqyYcb7TRIapg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxbSayVA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4301C606A31C;
	Wed, 18 Nov 2026 20:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxbSayVA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DFD1F000C4;
	Wed, 18 Nov 2026 20:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033743;
	bh=tSbcqKI+Ymn1wp2Uam+ZlkT3PdyTFoBaBhk8gvNsYdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxbSayVAJlFz6l+27m/ImDzT4yQ43MUATdgwIkAY8DzMKzD8iN4oUhOG2jhmWL1cD
	 oDThvkqODdoToJ8N0RROihULp9xjovxitvVb2uqT9cay6Zy21lZFynLJ4oCj4ZD64S
	 lZ7gBYbJHd+YDrtbYtBRoN2Zp9JD69GmEGV4b21M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0124/3318] comedi: pcm818: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:12:26 +0100
Message-ID: <20261118150318.070335361@linuxfoundation.org>
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



