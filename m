Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043158;
	b=wz9AK4RNDzta0E5TYWf27JrMZRHIw4uICt75UcWm6Qc7eNOi6WXdcx04q4HwcXlXgVd7
	 +fnHx+OZnDgrUS5tuU1zUSZd8ZEk16r+lElcHk9PlfJfryi5f1goP1wotE8cH004L0auW
	 05VUVHV+c+qxCX4wDJFM9vj9M5EXstMkFiTdpdpEP0NAjxq6U4Aq2E6isjA7wSQQpNPw+
	 PaA9IKvFvXuwR/OIIOzOBYW562aBTsPcGE9GWgCFHuX9x6xFzRvP9zaoWo45tdWDvhjHM
	 inJLaBFqoVe/9W6JaJkLIJtFRET32PqQMdAn2etomDFcBqwb0/lpshDjk33EDslNzgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hi3xWWOIkRFhKEHCwzHIL+neTARh0OZlTDL0Ne97xto=;
	b=CCbMNi1mV3eeCTlPnVe6EHzbvrfAOluOnizcClhHj8i7khFG9RVOnHuxczRt/04vO2w0
	 oLQgENW/0duqqXPAhmN/4m6kJmR7jSCdpjpiBLAtCAgNKajQyphzqXCXs446EWVkhrbrh
	 IlCU+6eLoYKe3m2i9/oc8i+wUGJhR9Cy+JZYMBZjBx2uvfaqHiCD5rJMntuGen6gwQm4V
	 vEzAJ3/MKJyQSUR9eJzdG8iLVJ384VJEoMXP3HjIEVaZOo5v+te84OP7c3L0UF2Z9QjhE
	 x8RRJacgLZRkygwRFLEuwz4q98fZj4mNiDgmvjlBwnza5E5klbHFv2rFKpOWZPjG3Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8xHfY6z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7350606A31C;
	Wed, 18 Nov 2026 23:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8xHfY6z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BED91F000C4;
	Wed, 18 Nov 2026 23:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043158;
	bh=hi3xWWOIkRFhKEHCwzHIL+neTARh0OZlTDL0Ne97xto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8xHfY6zXJRg4tLKUkVVWtYl1KV/b16Lk/8vkrL1If2WzvdYQwWgH034ykSTi4FNp
	 ASRfEd0d0Kc8aE3lRSCiHGSlS7hqEX96wD16bdOpRiZnGSde54un3w2hFdMmeQExS6
	 k8i/d3Y/mYEoVxi2Tm0fm5U3O7k3/uE9IALLxp7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0104/2857] comedi: ni_atmio16d: Add sanity check to interrupt handler
Date: Wed, 18 Nov 2026 15:18:58 +0100
Message-ID: <20261118150205.005503517@linuxfoundation.org>
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

[ Upstream commit 13f4796223489a5349b466ce54bb868f46c9fefd ]

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
Link: https://patch.msgid.link/20260618102949.26607-6-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/ni_atmio16d.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/comedi/drivers/ni_atmio16d.c b/drivers/comedi/drivers/ni_atmio16d.c
index e01ab5311d235..b4c25a8b8d40e 100644
--- a/drivers/comedi/drivers/ni_atmio16d.c
+++ b/drivers/comedi/drivers/ni_atmio16d.c
@@ -223,6 +223,9 @@ static irqreturn_t atmio16d_interrupt(int irq, void *d)
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned short val;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	val = inw(dev->iobase + AD_FIFO_REG);
 	comedi_buf_write_samples(s, &val, 1);
 	comedi_handle_events(dev, s);
-- 
2.53.0



