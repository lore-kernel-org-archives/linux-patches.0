Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208713;
	b=lUQ2ec7dYTj3Tgqa20nmXOJzCahce5Me2GEpBuz0zJWyOEzGUoUH/ElfEfuFSsa6n2d7
	 J3yri2WiRIoDxEAQ0KGOaZBbGmkZWl1OVmlWLNx+RWr8dpUYHygmWfnATZYwwi8ByUds1
	 pJtZQBO9Q7IBOzgLpf5F6EZ9YD/6w4XypR39VoJDqOrBzjX3Tz+LU3H3Ju14L9Fb+yDdz
	 HDcZyv70Ytg4wQZlOvg2LlQiCKRRwLng8Mm2Iz1bETxe9NU783ZxaUuNNHAt4uuuv33u0
	 1owkqy6LcKZXT1KFd1woptUb8/30AkH/CVXq1+e7/CnTRFSJBLidi4iEVkaYVY6bCQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5dsdODqPowsXahQQPBEDJfsE8Ae7WsxX8AMeVzz/oFo=;
	b=E1tFFy0P8pGdM2d2EJPjwUYS1HMGFfZe6wVrij2MhxkixVpq3ZMU9UKeVXXGxMvdIclA
	 DTIQdptcf0dt4K4s/pmPWFkjXFW7qeZhmigC83gtxbpu9WjI/b047+eG03+TSbJV9EbcW
	 K1ueVQ6M8Htu1rOXmmivp4OYBLB+y1TJ+45uQLw6emtsB1qzHu+EnS+9+yGJ7Rd8C8vIP
	 D+R7Oj8oeFNKwySyProVsdYOQyuCTY8NmyOJAWpDRlPWYcbMzfWMnsSWtEZa0IDtcjZz0
	 cFphTfzL/WUBJb4EAEz10pveZXszGWU29l09g0rahvL7y/DT2P8Xdo61DS3WZxwM0iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OFBA/RrZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ABA606A31A;
	Wed, 28 Oct 2026 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OFBA/RrZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC7D1F01825;
	Wed, 28 Oct 2026 17:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208713;
	bh=5dsdODqPowsXahQQPBEDJfsE8Ae7WsxX8AMeVzz/oFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFBA/RrZQOro3z5srBehUX/ixGXBxkf/HkNVwwQvgRMnGHgVkVAlPiaDUEJen5CxP
	 ytZaFINn9XBs6qfq9peb2QIYeUofIdO4sOZCd3A0e0VTRjAa8Lcwu0dowrU/JRaqsB
	 BKkyQ/65jFJbRt94znLycw719KtjprHqh5PpLkjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 216/516] mtd: rawnand: cadence: Initialize IRQ state before requesting IRQ
Date: Wed, 28 Oct 2026 17:56:08 +0100
Message-ID: <20261028170008.618428953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
@@ -2850,6 +2850,9 @@ static int cadence_nand_init(struct cdns
 		goto free_buf_desc;
 	}
 
+	spin_lock_init(&cdns_ctrl->irq_lock);
+	init_completion(&cdns_ctrl->complete);
+
 	if (devm_request_irq(cdns_ctrl->dev, cdns_ctrl->irq, cadence_nand_isr,
 			     IRQF_SHARED, "cadence-nand-controller",
 			     cdns_ctrl)) {
@@ -2858,9 +2861,6 @@ static int cadence_nand_init(struct cdns
 		goto free_buf;
 	}
 
-	spin_lock_init(&cdns_ctrl->irq_lock);
-	init_completion(&cdns_ctrl->complete);
-
 	ret = cadence_nand_hw_init(cdns_ctrl);
 	if (ret)
 		goto disable_irq;


