Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033754;
	b=k8l6eOW2tDZPY8xJcxnIeFIQzW0wjso+wGA2RDVnob2Ao5NJVzB0drZhi3GA8Bng9PYr
	 AO15Vh1x6Za1nWX0QY3eNTtBSPdoBPbkU0uMJDmWOrj0L8htqADve78hRpl0lR7Kj6JO2
	 29S6aCgEunLaJEjW8sdp30uo2i9cjFE+rBHzG6BTRcGflVUHhdXPrvzlotUTcmHW3D/Re
	 Oof+ODI1/ZSin58L2Qev88vI2nr1LOjTaExjQcyBduYY8KM5xWJjqKTW7G5TtyMmjVYD3
	 CAfQBRM4lRYVEgXT17RkamgVJthTkaFbjuad0Jb9JzkXBCPqxn9ZrPVV2PcjPty1WXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P5GdcMPTNytZkvS3L02yNi8Pu6Ppf1KpemFr802tOl4=;
	b=GcnKbuH1+3ezOK64pJwF8ZqWGXt6UXmfMmwk0OXsQuqmMJe9vmCd5gTfMJkx43mZ5eLD
	 59Ybya1eVYlb8Kp+gACywp/1e0+a7o6TXsBqt2Wt0vLdt6xuIPeECdt68YKcky+CLJIOP
	 MraO4MtGMZfEdqM32AiMusxuzVp1hlFXyqprLAhjb6oHkLjqfrYve1qt+hanotLi1rd0O
	 Tp/Qr/Jqz6mSRfSvFJu5/O8hqjXgNncvkVJ8bgOvcWSrTLPmiFgLhEgEH72Khb1E1RGYv
	 fhwyTG0b4lujLRzAYiZuh6h8zLGCWxHQj62cGpygDMyB3idHYUzRVd0uz0Oast4a+fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WXdgH/cX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C547A606A31C;
	Wed, 18 Nov 2026 20:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WXdgH/cX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2633E1F000C4;
	Wed, 18 Nov 2026 20:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033754;
	bh=P5GdcMPTNytZkvS3L02yNi8Pu6Ppf1KpemFr802tOl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXdgH/cXXLN8S+Z6SYG3auLqjD3AAKIHrt4f4ZgqA0Vlp35pmlRbuHteM0VXjE77Z
	 Aq92oX7cGJTsnGrH3TbTrpB3q4AkTyCvYHvZa+mYAKD/txPVWzLoWl9NAVlhNahVLd
	 zShekULrKSXNB0DRrMEcTAgiGh2z1huoK+008hss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0128/3318] comedi: pcm711: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:12:30 +0100
Message-ID: <20261118150318.211380372@linuxfoundation.org>
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



