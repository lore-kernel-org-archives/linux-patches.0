Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212880;
	b=nriFSR8cQzz6cOaqErvD9pTr8Cu+jG9f93eSbArWWNO7WS/lD6ds5W/9ONhezx62YPrJ
	 bs8pzonvBwLHJI5OAVbb0yJCDuclClSaJ40pSGJDGmDYevaejbta6r0SH7/HGJ9l+9MkG
	 eroJSCkHJjDt8I9CitctMPZyHM79570O0HrSrc14obfu9TtUO7l1cM1yhQTr1m6kdur7Y
	 I6P/h43sY30gbrqs02B96x6q8bveemJtZapQvEdcgYeG+mjJxihLC56o8g4DiOxO4jn30
	 RCGZnqQwqgMbJ2yFj+HwsRXOMEVUJjlLLniSm7s/XzByYm1q3CnGqKkFVhdO/cReTbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BqOooK3pvqHqYbsY/vxAuHpjQ1qxYS4u4Zo7nKYudaY=;
	b=GjCpEEMxFeCHmM+zJsserrOlKXkcr5ZxFYcXbRREbw6z6z8ArfqOT8ydJIB7/BHQA6A8
	 s8DA69yTvK9cAcW5vRcHrS1RO+4IB/KVOQMxK3Gs2OYAFtu4NmzWwjW4pfCjrXE3/8cc5
	 ngMa69TjyCoVjRx+MDTKZk4KQPFr7bSYjOY6UH1kT40xPdSTOk28TMxuE+SP/p1byLExc
	 Ru8UASYa7gLEb+QHJhBi6yE0HWkehfckIQOZVhk7e1goLiHDxE7AFf+CyRJgjK0r//CX2
	 fZ0Sva7An/GreNW+6+448rFKeZgkQ3gjBxk+cQhDFqIUkuuUFTI1sVV7h3b9mYuw0QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jn513JqJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE507606A31D;
	Wed, 28 Oct 2026 18:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jn513JqJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A49C1F01828;
	Wed, 28 Oct 2026 18:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212879;
	bh=BqOooK3pvqHqYbsY/vxAuHpjQ1qxYS4u4Zo7nKYudaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jn513JqJq1O+75zUx7STKMXJif4d6h3/rlSbWX+cmK6ORCtbSUD5N5uwfYTxOHBMW
	 B60Np3D6QtpOVgIHbtINwNOcx1ZNmaVs2BSqqEDsD/mt9NnFryhujjui8ZQ7m+2EUP
	 gMJ1BwaXQ0ph3D7iq7gLFuQgOEIHW2Ab8oBUwzyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 0310/1887] mtd: rawnand: cadence: Initialize IRQ state before requesting IRQ
Date: Wed, 28 Oct 2026 17:40:06 +0100
Message-ID: <20261028170506.283562267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 21f027016b1290d13c30b198ae7a00e6b3d1d5a5 upstream.

The Cadence NAND interrupt handler uses both the IRQ lock and completion
object. Registering the IRQ before initializing them leaves a window in
which a pending interrupt can access uninitialized synchronization state.

Initialize them before registering the handler.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -2847,6 +2847,9 @@ static int cadence_nand_init(struct cdns
 		goto free_buf_desc;
 	}
 
+	spin_lock_init(&cdns_ctrl->irq_lock);
+	init_completion(&cdns_ctrl->complete);
+
 	if (devm_request_irq(cdns_ctrl->dev, cdns_ctrl->irq, cadence_nand_isr,
 			     IRQF_SHARED, "cadence-nand-controller",
 			     cdns_ctrl)) {
@@ -2855,9 +2858,6 @@ static int cadence_nand_init(struct cdns
 		goto free_buf;
 	}
 
-	spin_lock_init(&cdns_ctrl->irq_lock);
-	init_completion(&cdns_ctrl->complete);
-
 	ret = cadence_nand_hw_init(cdns_ctrl);
 	if (ret)
 		goto disable_irq;


