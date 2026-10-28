Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211021;
	b=ECn0GuKzPqJvaPqI3WHiAYjl6vGvuUj0mKERhVDzC6fDdepkxWj46Y9Wyi1MLBpDwjLN
	 6SRYogRsXZGuCurZjaHoNtiOr9d8FXPNEZow1YxPQmcT1tCAvXp6gWb6tWaBhsGSXmmXu
	 /snEB9Gr716oZM72to7FkDLcBhiSe+qGIoZxfy0+85g/Pk8pW4xrnEGxUXbL7Mhk/FGLH
	 XyJri5QrmbA5hbh1l9R+cLcjluiH2U/bHkrJjfYVU4uaDaWIwqkJtRXxNetgUYJivsF7m
	 xmOpcj5jWU1E8lLjnE3p99fxsE9oNLPRrKEtOYWcZh4vIAqWZYwFcHDW6dI/p8T1/ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gpV7cajhJQHslPG8srlh7VFiGuJ+MWZKJQpi6K2cTQQ=;
	b=WVvOj7ng2kqNbYJFf/OfUS1O812gSpLlZ4zU6T+pCzalYMOSYfkDyDGIXdkYPnz/PCNt
	 HXEoEAIiJmtR6ayg2a/Sk4YmDtxyFckVlelEqTgRwnipbEXnsrkM9ovbSO8ThAbBCu3yY
	 4RfkMqeEbbfFZv0V/k8kvdlPnuhN/N5M8iGrTCnL/WFK6WkY70BB+uY1g/jfRR3tOdQfu
	 dGaO8Gq5BAhH/VlMt/dCvH9dtGXWUQhpyNLfo8B4VhcD45TGLx+N0c5Xjw9Q+ucRoIxH2
	 wglpfpVcprG8lRrtXIFsdFlkERlyafRCR4VjTMuWOKP+7Izf6A+MvR07h1T7QgnNuFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fqmWukzI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE44606A31C;
	Wed, 28 Oct 2026 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fqmWukzI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8811F01829;
	Wed, 28 Oct 2026 18:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211021;
	bh=gpV7cajhJQHslPG8srlh7VFiGuJ+MWZKJQpi6K2cTQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqmWukzIU3MpEZX2dmuugNZQlTlgosdWTzJjC5I1HLT1KFRThQcw7tycw2EMHd50N
	 6urufCb2Wt5yGzlSmOOQ/gBcwdoTjfM5+UDyCY/1D6Me1h2hGv6DoNpoSRqngiF7e6
	 g/tJUZrObO1p/6oZEuHrvgkUPnPDrcNTOCBYN8bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 232/571] mtd: rawnand: cadence: Initialize IRQ state before requesting IRQ
Date: Wed, 28 Oct 2026 17:56:19 +0100
Message-ID: <20261028170013.510194075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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


