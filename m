Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043270;
	b=Dn5nu/tLkg8MsOQPD3ypNB25pVVz3CUum6tWfVdpnDRIvCfPhOnL/cThUejCyZqQAqU4
	 ICuCNtWgPRUhl/+W3KK0lSO7nqttZVkTGOBwHK7dN2o8T+E3L+22lfVFEItS80sxMWseL
	 9WPTKB4h9C4bQFmNPqLIxOAstgZcy0jKS7y+uluVvZs4S3cu8Gk+3CFmjWX2VzMqAGxzw
	 00K8+Q9yyJG/swJ4j4O6qSmKK8sTiJn13nblNlDOj1r1SmetoUdTTHiY1qRcS8r0KAbaN
	 zsYE7ftwCLgxNxO19FyFefdCzwQPQgk65EGO0C9fm2NiKLdqlHMLRi7yatKZLrR8UJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O3MVGGrjVjVutrjSJYfBPhDYrYAivlgcAtmVEL0skCI=;
	b=izA7LVjxgPzINXQUlFlTyDo0kq18nAmywfkumADRIvoSjccGQG2uanqQ6M3K7Hyfi8n9
	 YKUUmMrHmV6oRSVMKM2Sx7KbLfI72apg0dO61Bf45WF2LwlSN4QQy25lMexYpKBvFVXEF
	 T41MEoztb/PasLdCSoDogzag0C48NfLTywSAxgDW80p2Ueo7bGCHYDbe1ZcVi3jfhngjZ
	 SkzcJbIQ6euoaMw5QV0tg9ywiuB92exbdWqqZDMyJkVGzR6cLCJRFEyVCuBEAxfEWQFWL
	 rsOraDuCE72GfsLv9pKg8qZ8BXiKGk1qVlvvwpidfTCqGp0Nb7QATFiEBtLqmA8yvkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ym8vAHvR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9EF606A32F;
	Wed, 18 Nov 2026 23:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ym8vAHvR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233111F000C4;
	Wed, 18 Nov 2026 23:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043270;
	bh=O3MVGGrjVjVutrjSJYfBPhDYrYAivlgcAtmVEL0skCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ym8vAHvRXE9B5+pgbFQ75tVNR+1vB5iSBGOg/x9gjD4ELD7fBcioj1jqiTkAzgpw/
	 nXrhglpryh+vCWIpYEXYu07nhwC+vn+nr8tbr1qLUNapYW4sq/8tYfAThv8ygSnciW
	 V561RVuKEMMVdDYnYWnp1VwEUuKza3WWPD+/4hFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0110/2857] comedi: pcm711: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:19:04 +0100
Message-ID: <20261118150205.217064805@linuxfoundation.org>
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
index 05172c553c8ac..377265dc298b6 100644
--- a/drivers/comedi/drivers/pcl711.c
+++ b/drivers/comedi/drivers/pcl711.c
@@ -181,7 +181,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 	unsigned short data;
 
 	if (!dev->attached) {
@@ -189,6 +189,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
+	cmd = &s->async->cmd;
 	data = pcl711_ai_get_sample(dev, s);
 
 	outb(PCL711_INT_STAT_CLR, dev->iobase + PCL711_INT_STAT_REG);
-- 
2.53.0



