Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057318;
	b=qCGJppWvZdCb70LiBDMyeet6hlVR5CuCwfn/eGiM46/U4c668w8cdAEnqIEKNXAKSRV6
	 rFTFahQpSS8zCCgRy0ayIgBV06dkYax53wGPlZawPQoG+6tdkBYlz3EbATlj195LFpB81
	 z+WLisw5NjTU40Tw9s6Me5u/lTAK5K14LZgBkpaRsSwkwC3i5iV80EX9CBCZsHVrSx6cS
	 1MUBEfP1UrFZKgtpvxB6d2UDouOKy05mRAkcvizbKVUm7at9foHmw26KPsXU2oI8pJMl2
	 aXe7uhunQ+vPRVH2kUK+UL1etS86WLJAOFHMeXmfqeuzRVUCdVcbJLh0tBPegB4tmqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2j457wNjUy9t9cJE8j45XMkpLE8QAiVO3B5PN22n9Wc=;
	b=ZszeW0zd8kIVmUGZ/oIqsxB6I5rtCbYKIEexCETR5uFkmTeNC9Po7S6t4uqXwBLFVmeO
	 5SWPHZkvI9e5NtJYwgkD/76YfJbENcFnsPTN7Dh/yRmo8FeeXzag+ElTDYCjMs59X7JpG
	 G2VvbMdvJknWgHl2dNhyLnYsAasOCsSuiaCspQ+9jtpHxV/F4EMNLFPuXZtzE8Z6Wp+yf
	 WTd3drPZjnCn3EBlzebAwN5V/Tm45532d8Gm4kvJk4k7WWUTiY1xu9WFbw5BvykwUo76+
	 WKnI1CuBMDnttWfod8UgMcSGlM1ws8TD7qA41+VqJTYwRMv9odC4GTiCv0T6CdTJvhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kM5AoP4F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0922260A5BE2;
	Thu, 19 Nov 2026 03:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kM5AoP4F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6121C1F000C4;
	Thu, 19 Nov 2026 03:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057317;
	bh=2j457wNjUy9t9cJE8j45XMkpLE8QAiVO3B5PN22n9Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kM5AoP4F87YHg3R9K/m/uH41HGyhSZSB4IyCCHt0599Y5G/XwyKEvOi9u48Ro3Xux
	 KSOi5HnS2PAEAds0AJ11GRm/gLYiLBpaM2sMJKEyWUujAkF5vdmSQv28vxrEV8iqA7
	 2i4ykeQ3qYizUq4YWkNEeHM0dG81NCXsWthtxBpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0087/1848] comedi: pcm711: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:35:25 +0100
Message-ID: <20261118145914.770597744@linuxfoundation.org>
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
 drivers/staging/comedi/drivers/pcl711.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index bd6f42fe9e3ca..a473f0442de06 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
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



