Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050837;
	b=XGHiA7QviHlAfoRVWG0dIYK8f0IYcHh/M0CM70sghy4d87McAKM9FqX2+r01IJB39j64
	 UpM/ikv4cE/L4UXl7AZqzB84CEX0frecT9IQcbaMbY6IFSl8tJpQytoRnE/7hXxD+YlWr
	 dh+Artqchs+NEnQPN36pzBjvVzUjRBE3e95NIdloJd5Z5Twjr9yYQChDqItgiN+6z/T96
	 5U0qDH+ZY/+qCapo2OAxkuG/kDsZ1AlIPqFY4nkJ1p/NgBontdMrNhlSfJj9PXqn1Be/s
	 BstSMd9MVEBe0nGtQ9A3yoQCN4PnAev1jba9HGt4A+mKk1y1cYWYC3xDnveGw8zSf4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e+7nISDAAQeUBas4xsc3kc2l9C5e3X6S7zyC3VYQppQ=;
	b=mRPFs/Dx+pwiOuPim73wqc+xVVjHOuXpIlh67pXX9nCqdM//DxGzOpNMkzr2r1neNgV5
	 g19xiUVWHFj7pJO63s6pfugadCs7P7LcUZN8kdUUgXueezQFDReDVrfclMmNsCQSGUXZ5
	 XjbeJad+xnHlNQk6HsP8te1QJjYMYanD50Mhr4VY0svkY5pR2Ouf281YIrOPVqBU8S+tI
	 5xFRDwnK9t5WYZhe+IepydRwYsYH/TVDkR7uUd3/oz2N5H/JDv/AvQkAvZY/9O/Kkngna
	 Pi1Xr03a9oYvpH1mPRlRpLUi7hIZH2TWlUzZdrq+WuP0jG3ncrGEo4vB0kSx0727/BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoS8rMoD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8E4606A320;
	Thu, 19 Nov 2026 01:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoS8rMoD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F7B1F000C4;
	Thu, 19 Nov 2026 01:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050837;
	bh=e+7nISDAAQeUBas4xsc3kc2l9C5e3X6S7zyC3VYQppQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoS8rMoDgjpRIFxuqmjq9wTnZyrDV5x0Arr11FhyL6bp7gJokNpM4gPizS1/Ovt5y
	 EVWsT/7S4/czLkLZvNjshsSu1p3VyxFo6B9fgWZTdqUJ+bFtmn/JAHgyi5ZUv+ATiw
	 vmX+VG79R0Uf0z6tRc+//eLevX6IM1IUlIMGGEck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 6.1 2851/2857] irqchip/gic-v3-its: Restore quirk probing for ACPI-based systems
Date: Wed, 18 Nov 2026 16:04:45 +0100
Message-ID: <20261118150344.237173650@linuxfoundation.org>
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
@@ -5119,6 +5119,8 @@ static int __init its_probe_one(struct i
 	u32 ctlr;
 	int err;
 
+	its_enable_quirks(its);
+
 	if (is_v4(its)) {
 		if (!(its->typer & GITS_TYPER_VMOVP)) {
 			err = its_compute_its_list_map(its);
@@ -5472,7 +5474,6 @@ static int __init its_of_probe(struct de
 		if (!its)
 			return -ENOMEM;
 
-		its_enable_quirks(its);
 		err = its_probe_one(its);
 		if (err)  {
 			its_node_destroy(its);


