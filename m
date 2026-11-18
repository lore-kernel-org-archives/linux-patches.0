Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033760;
	b=hJKNIEjiUacGEHfd80iGLTDP2Tk8T0FiTktpvqYc1rgouaizcwvvvnFiV7+Hg+xqlG1I
	 BUO/BLH1Lh9QibZftQ3skAmQW7nrXtFrXbvqA19wluzucZWsx6hBMUelJ7PxBn2M7DmvB
	 Cr6VRMPeRbiCl8Woas6VL+7SFijjEICtv5hjH9AVAriY1qfVziOP/be1IkOVT03smTeV4
	 HOHvzGI29VH3wjO2S1iD910IeJ4bfjb28V07HtywykG1w/bD9hGcrxfxJd6C6WCHDKa4h
	 cE4V9fHeIJ7Cu2H2SAsUsQa6G/4EqUVSPR0AvlV2EU/5j1LnPAa0t2PE1s1cxZk3Ieg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nDFp2BmLILfVfnIh7U9w+7huSRQVx1tMmKbjHnr/i7g=;
	b=AMD2KWRDCJnBJbI9bDItcYnAbfoqmDciN8JlaWcL5aMslkm4JyB1VY44dLdwE9B6ugkO
	 VoDcyr5ICtDAw8kM5tY1Os1AZqhjbCyGzwcvnnlOK5dqy6Ismo7wgYjzk8M+Xpho9mjXC
	 gRJJE79gPgo2qXQkG3RQtSa+DEsjYYIJTSGnBo0F4lXCw1SLwqQyL/ioHeYMI7w+esymL
	 hMSEskIPdNOaWwwQKah6ueC3gvSXVjBau/duxygNTvns4enOfOtE+4VrCKsfY1t56FHrk
	 Hw/Wl+8a5dTN2mDWp4gmU3UKi+MjmP8JfkOXvO5d23tPMK/1aYP6vkPVJsdzJqeBsQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdIX848U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B38606A32C;
	Wed, 18 Nov 2026 20:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdIX848U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D697A1F000C5;
	Wed, 18 Nov 2026 20:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033760;
	bh=nDFp2BmLILfVfnIh7U9w+7huSRQVx1tMmKbjHnr/i7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdIX848UiGuhzkmBvKwaXQ/CMb5ztCA+Qwi7P1ERcoTQvWIx7H5EKfuUFJOMuLJgC
	 7HAKuz2tuIh9d0RZnThvdwBqeNnsq6y6FiXgOH4uxBKbpxBHOpZaoiRuwiNHaWUmc9
	 vW8UMTXaK/kJwaAArPHq9ddvzDUpRqovR2jRcnnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0130/3318] comedi: pcmmio: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:12:32 +0100
Message-ID: <20261118150318.284785388@linuxfoundation.org>
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

[ Upstream commit ea72e2fc9026f375314421ddfa4dbdc49432a899 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, check the dev->attached flag in the interrupt handler to
ensure the device has been fully set up, avoiding a possible null
pointer dereference of dev->read_subdev.

Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/lkml/20260610115912.780131-1-jjy600901@snu.ac.kr/
Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-10-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcmmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/comedi/drivers/pcmmio.c b/drivers/comedi/drivers/pcmmio.c
index c2402239d5513..db9cb3fedb48d 100644
--- a/drivers/comedi/drivers/pcmmio.c
+++ b/drivers/comedi/drivers/pcmmio.c
@@ -362,6 +362,9 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 	unsigned int triggered;
 	unsigned char int_pend;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	/* are there any interrupts pending */
 	int_pend = inb(dev->iobase + PCMMIO_INT_PENDING_REG) & 0x07;
 	if (!int_pend)
-- 
2.53.0



