Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051129;
	b=ASp5EJN+Hb9Or7ZVoyrZlC+in9n4G7JDRBF1hf9mn9HpgTviTkYLQnJChLOfqvHMvPkr
	 NMiJB4yfikqJaI5YKDUYwtlmrukMXf20ECBc5FaK+l3Sl5uT0ALtX53kmzBkU+R9A9SEP
	 EsOguSk6d/TxFkXEH+405zs/utAHXcIazXFBA9IJwIVPcuEoWg4RLnuE56hj5TdPKzg0I
	 zADweYBhPRV5YSKXqLhdZmxTGbIwIM6vcn03+q+Q4r6Ssw1JTUYM9STV38wM6Uy6jvRtv
	 Nwvv531crQ4/Zdij1noiscGLBAzhlxkA6mZgrCLKKvoQUGsCYulDsMRdxqg98ILhGtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vrjH+QA5k2ywE7H1fwYZfYjFaKOciAKMGeKQXpZ+CDY=;
	b=xl/Mj5YftlZeu5InUmnLcVZvdpWqyR4zbvWkn/ILgRCCC+G3sXjC/UQRXTlzfp/wB2Er
	 4JGcn0A1CZrDkz5m/pJUAjN31N6JMmoLYV8scXS7cgGTuMaHHA571OXdiD47X45jJynem
	 tfTPe1ZjGf6UCU+RROJ5W1HOO32Nwlsu7jw2Vfm6zxPUx4rdy6qNsDKSmtd380LQgwtis
	 Knpibd4r5Tc1jG4imio59/sqrjEi0bgI7terWazgfgRURYLqcB5AmNE6cB044KIfIH1PG
	 Y5nUpgATz/ztHxFjs05EPNB9J40hgNuRhmBzNjw4D1TRjPBema2UuuN48O1LA2JSgxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A9+hNAV+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C22606A331;
	Thu, 19 Nov 2026 01:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A9+hNAV+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1455E1F000C4;
	Thu, 19 Nov 2026 01:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051129;
	bh=vrjH+QA5k2ywE7H1fwYZfYjFaKOciAKMGeKQXpZ+CDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9+hNAV+zQVVb1siUWSoVBYdkQYNLa9BWMf1FP9B4yeSBCCOW5MtloMv3wCy0iLcQ
	 TZ2lpfNkv/IlwXupclogMf8YvtooLK9x+fUBKn5peQiouJCRIED6PtiNqTGUvm2Ahf
	 6n62djuSeo5YqbKOIvJTY9FSjsESq3UGcyH3PY30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0100/2214] comedi: pcm711: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:29:36 +0100
Message-ID: <20261118150013.939927228@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit f876cbfe3e066bc9e3f3210907bd534be82946c8 ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/lkml/20260610115912.780131-1-jjy600901@snu.ac.kr/
Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-7-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcl711.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl711.c b/drivers/comedi/drivers/pcl711.c
index bd6f42fe9e3ca..a473f0442de06 100644
--- a/drivers/comedi/drivers/pcl711.c
+++ b/drivers/comedi/drivers/pcl711.c
@@ -183,7 +183,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 	unsigned short data;
 
 	if (!dev->attached) {
@@ -191,6 +191,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
+	cmd = &s->async->cmd;
 	data = pcl711_ai_get_sample(dev, s);
 
 	outb(PCL711_INT_STAT_CLR, dev->iobase + PCL711_INT_STAT_REG);
-- 
2.53.0



