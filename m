Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051999;
	b=XZi0g0zG4uFZzOHw3Z0xHUkXH8qm+F5dyueOfMe705Pqct6mss5/m9zsLy1+7nLkMYUe
	 sUjy/nQPUrNOn2HN0g3pVZuJtAiFGpFpmhNApKZFnFvAi+VSu94pU2leOgK7gJ2/LGJ9v
	 hRCzVxWpwWSbapZn0Mk8XWOQEEcp9QQ0zAuU3fjk3pIHeOba60Eol6ZpnXeJAXsPiHekt
	 5c471/6HBV87oWUnQ0SMbUQ4fIIN30YFseMFaI2zezr3HyA9B7N3ZbwGXXFGZ5D3cCkIu
	 DBmv9qDMZWQ3036d5lsSzQuqwjocxBO6Qgjro+TphSCPU5gX1VJCVb87Qxvykh2D6rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0O+z9pvMiNNTwKXPZGC+Fa8GTv+W10lPvBiv/2gb3l0=;
	b=dFxfiVbJ/rBGoM5oqkfJeAQnqIr1cqQCfr/y7/PMrMCakZ+4eeAztPilce3uAh/jzb3l
	 XTL3HSiLVwfaiRddQhAVEjDd6NUoZmZut+nielplYvvfxv2uMuomwDx/TbLILEQuXgAC3
	 4aLdqauvx4lN9rafGGCQ2p5BkTeaLvQedZTxDwPhMxudNceJrX6U2Z2ehGdUJYUZhl0go
	 qQjTYYODpkpHgP1ohR6yPCUu9/EhmM53lPygtmw+LYEEqVVKwjTOLkFlA/nuWkOmLl7uF
	 8bftEjQRIL7cG44a5ksvOMx6E8/BSU+UV9M2U8vy+G89C9NAmKS3E4nuRTuXpjqL28Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyupZ5Y3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A856A606A320;
	Thu, 19 Nov 2026 01:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyupZ5Y3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C3B1F000C4;
	Thu, 19 Nov 2026 01:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051999;
	bh=0O+z9pvMiNNTwKXPZGC+Fa8GTv+W10lPvBiv/2gb3l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GyupZ5Y3BdQP1M6FIIzMxCZZ5rLV78Cc/HVXKqGh5uzbveoC8fVXSL90rHv70RwvS
	 f06CVwWCYuqiBJrklCiwzKO0ikr3Jcu0K36pTb2feKXbO0qLhAdW3Xao9uS1v9K2ao
	 H43OK9szmVLzKMC/oN4+c2mGLI3BJf8Ozl/28DSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0406/2214] backlight: lm3630a: Cancel delayed work before destroying workqueue
Date: Wed, 18 Nov 2026 15:34:42 +0100
Message-ID: <20261118150026.992916094@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 2cf184caab8b406fdd9db126ee40d62418237456 ]

The interrupt handler queues delayed work to read the interrupt status.
After free_irq() stops the producer, this work can still be waiting on its
timer. destroy_workqueue() cannot drain delayed work that has not yet been
queued by its timer, so the timer can outlive both the workqueue and the
devm-allocated chip containing the work.

Cancel the delayed work synchronously after freeing the IRQ and before
destroying the workqueue. This also waits for any running status read to
finish before the chip's resources are released.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 0c2a665a648e ("backlight: add Backlight driver for lm3630 chip")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20261003030439.599330-1-mhun512@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lm3630a_bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index 0886bbce25e54..118a91321b603 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -589,6 +589,7 @@ static int lm3630a_remove(struct i2c_client *client)
 
 	if (pchip->irq) {
 		free_irq(pchip->irq, pchip);
+		cancel_delayed_work_sync(&pchip->work);
 		destroy_workqueue(pchip->irqthread);
 	}
 	return 0;
-- 
2.53.0



