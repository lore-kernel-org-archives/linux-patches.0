Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097231EB9EB;
	Mon, 21 Oct 2024 10:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506810; cv=none; b=qClvJ8fMR67bCA+H7L1qgAG8mNDSS5TE/a7Ggo+0T0GWrCOMFHUbovxjm8i+ftuqr5UZBryqWGljazd+A18SHjBIhnz57FtEWqTEXZQHSN2iDx0P6QzFc73a29fmTyXN2fMoNChMuEiFtAXgAZ9R/cSPBNbxEgRSyW0vdZ38+yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506810; c=relaxed/simple;
	bh=XIPhKd+LOtnIILzMpmiPaZ4AiFi6J6IYLpg6MBGVBdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Erl1u6LvjsLZDQzyCHDfELpZsMb7+rQ9BKMlJ7Q/SlOKRWvK4MpeCDE2cWFHdFS39KDpm0TBRp4S1NnLyBHyCTXDUP97K4qbjDfTLrqjZkptppck3T1ubwW9efArdosjZRW4mgjB5ol0A8V5oW99y8+hd6P2jQ2L4Si5Eozde00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8t1G6My; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8t1G6My"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561A9C4CEE7;
	Mon, 21 Oct 2024 10:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506809;
	bh=XIPhKd+LOtnIILzMpmiPaZ4AiFi6J6IYLpg6MBGVBdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8t1G6Myvm3gRgW6QPOrQ188S/vtO2LpK0UDSGt5Q0pGHMwVpbUTTUoIpHHAJv6JM
	 pljKTYPgfqDwA0T73zslHMKrAzjSFCXEbAB9CjEAXq2OjAKPz4fhD9D9r/YORyZWGd
	 Kp71c1RMGx0yxVU1rU2ez2dvlus7R4LZ8TbIL/mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Anup Patel <anup@brainfault.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 6.11 128/135] irqchip/sifive-plic: Return error code on failure
Date: Mon, 21 Oct 2024 12:24:44 +0200
Message-ID: <20241021102304.349777022@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlie Jenkins <charlie@rivosinc.com>

commit 6eabf656048d904d961584de2e1d45bc0854f9fb upstream.

Set error to -ENOMEM if kcalloc() fails or if irq_domain_add_linear()
fails inside of plic_probe() instead of returning 0.

Fixes: 4d936f10ff80 ("irqchip/sifive-plic: Probe plic driver early for Allwinner D1 platform")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240903-correct_error_codes_sifive_plic-v1-1-d929b79663a2@rivosinc.com
Closes: https://lore.kernel.org/r/202409031122.yBh8HrxA-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-sifive-plic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -578,8 +578,10 @@ static int plic_probe(struct fwnode_hand
 
 		handler->enable_save = kcalloc(DIV_ROUND_UP(nr_irqs, 32),
 					       sizeof(*handler->enable_save), GFP_KERNEL);
-		if (!handler->enable_save)
+		if (!handler->enable_save) {
+			error = -ENOMEM;
 			goto fail_cleanup_contexts;
+		}
 done:
 		for (hwirq = 1; hwirq <= nr_irqs; hwirq++) {
 			plic_toggle(handler, hwirq, 0);
@@ -591,8 +593,10 @@ done:
 
 	priv->irqdomain = irq_domain_add_linear(to_of_node(fwnode), nr_irqs + 1,
 						&plic_irqdomain_ops, priv);
-	if (WARN_ON(!priv->irqdomain))
+	if (WARN_ON(!priv->irqdomain)) {
+		error = -ENOMEM;
 		goto fail_cleanup_contexts;
+	}
 
 	/*
 	 * We can have multiple PLIC instances so setup global state


