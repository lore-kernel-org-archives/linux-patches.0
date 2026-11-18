Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034982;
	b=l4IgOlbtMUDFpSOFQ42x5Ir9KTuT3+6LRN3nZH8dxxJBaJsqLk5GCalNaeO0R1SQYKrJ
	 ppMxBmFU/UJFKrqz+JjyQyqt4tYXUPjAXdC2QPrCLYgPuu5ftHQDAo2ufx53NkF9fbS1Z
	 ce40nFj7saq7YrOEIz48a44PByIHtGO/5FXrJH+DPAP23XWqn6hfhPM6GoIyheuvymZUw
	 obLKRzVCzeC9XPvCvsDIo9ajBJNeObWH5csZVBn/ApewZf0y/b10PLa0U/C2CHRtdL5b0
	 Slt2Sxfk+iW0zmzRifwS08a4VQ0zYJjmkA4cnghcOKzUc01rfCdBjvHwk7oAmKqiCEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2TXiYOWGzhYgVR+TOEgUpBNLOJn+eR48tOvVvXJAF2c=;
	b=stVLx0cSwMLqU6/z7morHB3gc7l8HlimMmwfxNc1dWoMrlBwbVZv6LdvZbZssZ/Y9lAa
	 0+BjdijXZKsPYm14tbpEMSFNcSAuS2hrYZKeKa5iFdrVk6JceQH2HIhP4mdKbDMubf6Sw
	 sGvxa95a9+2YRNleLN/t9Xv0CnU4ewmY2EDuLhk9/XNrnKqkamwSu6PKh0EEIt8JiNO4w
	 LnKKYDwM+cWM672G6FzysB7MnZU9Vk4h3lfaRzWTwqHlaiQftisdZpYoGpA/Ls//0WU2U
	 UJ7En7Ya0L6k2yMtVQdS3pgAQIqLWJ1I4mjpe8RCdn5ZambIgGV8Ga9W2drSQZgsEqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fsctGECo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0291606A31C;
	Wed, 18 Nov 2026 20:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fsctGECo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4751F000C4;
	Wed, 18 Nov 2026 20:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034982;
	bh=2TXiYOWGzhYgVR+TOEgUpBNLOJn+eR48tOvVvXJAF2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsctGECoBYePBayfwK6651WPi90wTHa+WXPD230fyfbBNZEGlVfQvBpuvMmbsnnrd
	 QO8SkSi3fPHeGvAMAyBI48as/L2guBkDT1sJWsJ626+uBPOGPORapDOu+Rx4FBqJUC
	 hV2+TlYHP5Mpfl3e11D0kw/6TXV/tGvqn/q84D5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 0563/3318] backlight: lm3630a: Cancel delayed work before destroying workqueue
Date: Wed, 18 Nov 2026 15:19:45 +0100
Message-ID: <20261118150334.270507273@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 2cf184caab8b406fdd9db126ee40d62418237456 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/lm3630a_bl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -592,6 +592,7 @@ static void lm3630a_remove(struct i2c_cl
 
 	if (pchip->irq) {
 		free_irq(pchip->irq, pchip);
+		cancel_delayed_work_sync(&pchip->work);
 		destroy_workqueue(pchip->irqthread);
 	}
 }


