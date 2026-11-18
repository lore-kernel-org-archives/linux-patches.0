Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057310;
	b=RKcQAOC1b1ERnutETGj6BhiezwXyIZ473dq+89IxADG2pqCtpjg4OuOED8bb9YV0eNp5
	 gL/PBEp4/QtLOouGV06m5URKLJ++RJ03ht1Bx87Q3Z/Cxy5nOZ2QAWwLjcLgP5O96eT4E
	 TJmQl+e9Hw/m2Jcg4BB1xloSwgIQBnZXbMG7do8g6Zlx9WDcLewNTdj0ql2PPGnGqF886
	 nrNogvfNH6/MitY4Jk2GsBfRAsxdfIs7JuAnWE4KNHTEKcrTNXM3pfeGzd6TMmEhhb5zA
	 2qDEayOZuakmTsBew2UMvFXUnMsyU5w8HrG1JVEMRF3jZwtu6gvLblzhhzyl3Xjj6gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zlsaubD6rEpeGMLZF9T2uAgk7AALwp/JzCxQ2+v/2Xg=;
	b=Jpbyya0r6Q4Q9YM8rZkpPy/yI/VGPgfRS/wkTe9oQHOoTR1fTTMirCuX7s/ELHH5z81Q
	 N96tuzQPteM9akQgsX/w9eZ7+RiJuV0LJz1GS9SKxmTP9CsdffsBC9fnMyxYo/RqwlCna
	 BeeJZS1VUf6KE6JoVPuJ4dIzvz1lbRZr4KIM1P6JCZUDgsAktrrEh/xWZy/KVXFZPzvD6
	 6TsOyc9VT6zk57tKdA4DTz5F/nhdkUmcUt2FiXwSTAJRQi8F7sAK5n+IzriPiHW7cCbkq
	 oi8BRKfDK9kY1NT+AQ5ZUKepYxSxEpn3E3/v7YCc1OvcINnH00JOuMTv1Xy8/02VnEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KsULAk5t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EF560A3839;
	Thu, 19 Nov 2026 03:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KsULAk5t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D501F000C4;
	Thu, 19 Nov 2026 03:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057309;
	bh=zlsaubD6rEpeGMLZF9T2uAgk7AALwp/JzCxQ2+v/2Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsULAk5t2xmBByvUIe0Lf7+37ryjMrpvGFVKfNs/1Wn1TqKQ5iDkVM4rjp8CdabUs
	 PirR3lIjlqMf8n6DzTCH/WUxCLnEU+Cer9GNv6acOWwBrVAmrvyhz7TginAvt80KKd
	 WYva2HB0Z33DR9kotTxsv2KhGN8frGJNxQMeb7Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0084/1848] comedi: quatech_daqp_cs: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:35:22 +0100
Message-ID: <20261118145914.662270154@linuxfoundation.org>
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

[ Upstream commit 1bc9538df6be8dac8727179d8bcc0d880648361b ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-12-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/quatech_daqp_cs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index fe4408ebf6b3b..c6d0e614d63bc 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -212,13 +212,15 @@ static irqreturn_t daqp_interrupt(int irq, void *dev_id)
 {
 	struct comedi_device *dev = dev_id;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 	int loop_limit = 10000;
 	int status;
 
 	if (!dev->attached)
 		return IRQ_NONE;
 
+	cmd = &s->async->cmd;
+
 	status = inb(dev->iobase + DAQP_STATUS_REG);
 	if (!(status & DAQP_STATUS_EVENTS))
 		return IRQ_NONE;
-- 
2.53.0



