Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9A01DE2C2;
	Wed, 19 Feb 2025 08:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954515; cv=none; b=Sglobynwm34/5GixwYZM4B+h83W5dS0HG5gqwjI9FqK8dx4o/SBBy2bb8v+ZxZdkKbqUMl3249Q32m/tjbcL5tSRAaOgGKlK7++4rtOHqgoGlIh4nv/pkjsaKoxbKPBPG8XvDNma0JK1UWkcrYX6xS9bQ1suBmpnAt9P7VWrZ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954515; c=relaxed/simple;
	bh=IS3Ny5ZgHwOtqdza50LNuuDM5xLdiJHC3wd8IpULPDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvNLN7h4O9ms7JBt7+NJIGndw7YVnN3Z3JFjzd6AG1/aOQQ9mI9Ds9I8FC62nFrJ5lmITdNMRJhismd8MuL5wunkREN0iDDXhpKIjrY5Q+MBOKgmAJO05oNA/jaP5i3PaS1Kqy/0GddWuvmMkJuowQDV8mNFsXuJiA89NSgCv7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odfZx/Co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odfZx/Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAB3C4CED1;
	Wed, 19 Feb 2025 08:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954515;
	bh=IS3Ny5ZgHwOtqdza50LNuuDM5xLdiJHC3wd8IpULPDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odfZx/Co2em16v5ANZ1mRn8bQCxJSx0qDCPTaCVPqLNwbl79F/RiO+cnRGFC04m50
	 fp0BD0omslAAUKcGSLSNIanWQb2dMVKROUkDAJDhCYYNbWBOe/wgdNd2UzGV4Mj84e
	 7ibytN97KYeQ7V2hm3zf1Oqju/v29zmFjBESwC+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 226/274] genirq: Remove leading space from irq_chip::irq_print_chip() callbacks
Date: Wed, 19 Feb 2025 09:28:00 +0100
Message-ID: <20250219082618.420680306@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 29a61a1f40637ae010b828745fb41f60301c3a3d ]

The space separator was factored out from the multiple chip name prints,
but several irq_chip::irq_print_chip() callbacks still print a leading
space.  Remove the superfluous double spaces.

Fixes: 9d9f204bdf7243bf ("genirq/proc: Add missing space separator back")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/893f7e9646d8933cd6786d5a1ef3eb076d263768.1738764803.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/fsl_msi.c          | 2 +-
 drivers/bus/moxtet.c                   | 2 +-
 drivers/irqchip/irq-partition-percpu.c | 2 +-
 drivers/soc/qcom/smp2p.c               | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 1aa0cb097c9c9..7b9a5ea9cad9d 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -75,7 +75,7 @@ static void fsl_msi_print_chip(struct irq_data *irqd, struct seq_file *p)
 	srs = (hwirq >> msi_data->srs_shift) & MSI_SRS_MASK;
 	cascade_virq = msi_data->cascade_array[srs]->virq;
 
-	seq_printf(p, " fsl-msi-%d", cascade_virq);
+	seq_printf(p, "fsl-msi-%d", cascade_virq);
 }
 
 
diff --git a/drivers/bus/moxtet.c b/drivers/bus/moxtet.c
index 6276551d79680..1e57ebfb76229 100644
--- a/drivers/bus/moxtet.c
+++ b/drivers/bus/moxtet.c
@@ -657,7 +657,7 @@ static void moxtet_irq_print_chip(struct irq_data *d, struct seq_file *p)
 
 	id = moxtet->modules[pos->idx];
 
-	seq_printf(p, " moxtet-%s.%i#%i", mox_module_name(id), pos->idx,
+	seq_printf(p, "moxtet-%s.%i#%i", mox_module_name(id), pos->idx,
 		   pos->bit);
 }
 
diff --git a/drivers/irqchip/irq-partition-percpu.c b/drivers/irqchip/irq-partition-percpu.c
index 8e76d2913e6be..4441ffe149ea0 100644
--- a/drivers/irqchip/irq-partition-percpu.c
+++ b/drivers/irqchip/irq-partition-percpu.c
@@ -98,7 +98,7 @@ static void partition_irq_print_chip(struct irq_data *d, struct seq_file *p)
 	struct irq_chip *chip = irq_desc_get_chip(part->chained_desc);
 	struct irq_data *data = irq_desc_get_irq_data(part->chained_desc);
 
-	seq_printf(p, " %5s-%lu", chip->name, data->hwirq);
+	seq_printf(p, "%5s-%lu", chip->name, data->hwirq);
 }
 
 static struct irq_chip partition_irq_chip = {
diff --git a/drivers/soc/qcom/smp2p.c b/drivers/soc/qcom/smp2p.c
index 4783ab1adb8d9..a3e88ced328a9 100644
--- a/drivers/soc/qcom/smp2p.c
+++ b/drivers/soc/qcom/smp2p.c
@@ -365,7 +365,7 @@ static void smp2p_irq_print_chip(struct irq_data *irqd, struct seq_file *p)
 {
 	struct smp2p_entry *entry = irq_data_get_irq_chip_data(irqd);
 
-	seq_printf(p, " %8s", dev_name(entry->smp2p->dev));
+	seq_printf(p, "%8s", dev_name(entry->smp2p->dev));
 }
 
 static struct irq_chip smp2p_irq_chip = {
-- 
2.39.5



