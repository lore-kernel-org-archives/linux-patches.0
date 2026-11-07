Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060731;
	b=P5IcWim//22otiKuGXngj+IK2L1N2C2wERPcPyXtbb1t3t5fFSvOLGxsFG+MmjmLyNnJ
	 /p/2T1otsVfJWL2hnYzSdR9Ul3TC5dHblUTETVFHD+/tE1zONHjNWOwqx/Q8cYxOYmtp5
	 E8LQVCoCH71DaL7A1Q3WkJeFlCKdvCZtvCTp0OESuR3zBAqhqvoUBx6UJTkkm83AJ7RKK
	 t4HxzCoP2C9dH0YbNuGr/YxkjpRp3PzzEB9OZPNPsNHQZ9M5jP/tpc3nWS7hcJ4ikbc8s
	 Nj12T2P+QKNVtEa1Rw5dvP5PNXFgLezJ12tiSvwVTOEMmCK/HheS/ZPcgPYlsE+BoGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fmX8Hj8r6GNSt1psMEdbPNJe3X5W7+8K3fdZARMst1U=;
	b=bOWkFgVaLPWwVrsGD33O+OxNjn1e+dzhFdygqScYchpVynK+lzGYurzbfXrnGQ7qCR3o
	 1DF5xnF2vd9eX10vdFsX+1+VpTaytkc1SFP9zobxO8secU6WamjIwlm2hBFVZyE4oU3WF
	 GYraA4zrlKMA1xPe1hmqiV68kSjgwsha0BYFxvzFQ8RhZBb3Ptgr3e10Ba7Qt6UurPOuX
	 UsLCiKiQ3P9wMqQQfgzml6/QkZYMqeD8hUeu0XMOFWikooiPMna4rq8f21U9P9A69rMiG
	 G0Td6439S+x+1aE0x714mYIGQ7Wi9Fl9OjFcY1K3g3IEoZGtOk2uOHtxnTyixdON3qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeoRiCKh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BD0606A326;
	Sat,  7 Nov 2026 14:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeoRiCKh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BC31F008A1;
	Sat,  7 Nov 2026 14:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060731;
	bh=fmX8Hj8r6GNSt1psMEdbPNJe3X5W7+8K3fdZARMst1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeoRiCKhjf64mKMWU9nukpN5fTzEwb0NX/EFff5QMxBFfLU7SDAT0sPAVOUzaEYv3
	 VCFbkxy581mEbygGm1CK4UwPodIGFY0gV40AFMVG7Z5VtwQv0vfdBMYWbJ3oH+i0Ya
	 +Zvqyrs/OZ27kJiq4/pX9tR/qxCzS11dXk6YUNPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0150/1536] comedi: pcm711: Fix sanity check in interrupt handler
Date: Sat,  7 Nov 2026 08:36:06 -0500
Message-ID: <20261107135001.897715280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0cf3917defe79..33407da84ef45 100644
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



