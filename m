Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062210;
	b=z6+SIAnKq4LLwSiMexW8Q/4yQOou2/9chvt0hWQ/Km/dKpiRrvkazDaznVvnjnubsBVZ
	 OXcQWWrRxzr5aoIc03qZxULfpnbY0PEnwBeYDaFYHuiGSiycBHYtFNcmR/lhFooBi8/be
	 iyz1ZRz1X+b5fJKlD1f5jo3K4Ue2od4uS0o4beL7awZCAdjXbqRlrlMmwlE5UXAh9ratH
	 +6nVex0m2nGxOrOi8NxDBvLewRyh1dHzj8ZSGlL1Ek1ru5Ysjl4B13LqUjPxAs4NJ2SEp
	 VPwTHOJa1JLfEW/ATzByyN2Kr3E0/0ReTJRAHOadiqX7zyaGW9TtASokMOOWWprU4SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GKpsdcWgl3N8HY8vmVDXqPR90u3tHJG5Rb0UusK2W3w=;
	b=qUHHyXcpXZRGGPMG46f4GxlDThl5T90yYEC4NfNgKArjBw42as6L04VTSLTsXVWjIuqz
	 9a8vtjoz79xt9IFB9zn33cij6G51GsyEDeqbtlDs53wCLVb3tdzoUhisozQjEtbeEJclq
	 BeicUiqIwWINPYsu4d21GnKztLhXLnQ1fiU+Jbv+igf5T/oH1upRM+m5VmI0AdOTXfClM
	 d81U3wo6PqD4RcYsQnPN6h+thBCJb87FB9f2QwxzxKqnd04RD9iTEiWRpB06xqBxgSarp
	 63zn7uAtx1NzLDSffzoLVQOHABmMF7chH+wcLL3ue474IT+zwRQcEHDJUh5FzCNHnNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEYt9FDd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C651F606A320;
	Thu, 19 Nov 2026 04:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEYt9FDd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2534E1F000C4;
	Thu, 19 Nov 2026 04:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062210;
	bh=GKpsdcWgl3N8HY8vmVDXqPR90u3tHJG5Rb0UusK2W3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEYt9FDd9IdzFCmdtyLc9QZyQ5+Zq1eYsDXy7WMevVlGWwVozbQTwfuvWGfgpCxJj
	 wgT1NSWfRORntK0/addmLttXelv5K0JL/odxfkbFM5qo6Ar5bRchxQ/fJ/qldGIzJu
	 rjILvZ435V/QipjdsGkXsY9e8MmII/oyFWLzeDK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 5.10 1830/1848] irqchip/gic-v3-its: Restore quirk probing for ACPI-based systems
Date: Wed, 18 Nov 2026 16:04:28 +0100
Message-ID: <20261118150036.253866404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit 8b02da04ad978827e5ccd675acf170198f747a7a upstream.

While refactoring the way the ITSs are probed, the handling of quirks
applicable to ACPI-based platforms was lost. As a result, systems such as
HIP07 lose their GICv4 functionnality, and some other may even fail to
boot, unless they are configured to boot with DT.

Move the enabling of quirks into its_probe_one(), making it common to all
firmware implementations.

Fixes: 9585a495ac93 ("irqchip/gic-v3-its: Split allocation from initialisation of its_node")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240213101206.2137483-3-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5110,6 +5110,8 @@ static int __init its_probe_one(struct i
 	u32 ctlr;
 	int err;
 
+	its_enable_quirks(its);
+
 	if (is_v4(its)) {
 		if (!(its->typer & GITS_TYPER_VMOVP)) {
 			err = its_compute_its_list_map(its);
@@ -5449,7 +5451,6 @@ static int __init its_of_probe(struct de
 		if (!its)
 			return -ENOMEM;
 
-		its_enable_quirks(its);
 		err = its_probe_one(its);
 		if (err)  {
 			its_node_destroy(its);


