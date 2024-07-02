Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2980F14293;
	Tue,  2 Jul 2024 17:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940893; cv=none; b=ouxozQC00u80LuzFlsTFkfJ/hcLr4MgV3P4eSmE0GBTejPFdiUjRcBma6furt2Y1wcGoyL7dzpRhDBORZeJK4WWwGSeTPDZutuF1hLRDNXN/NxnZ++hY9rtQwejaf+qpJkLNp3QtTVabaVuQPKn6tzurjffZfLjGx4b+H3n4VUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940893; c=relaxed/simple;
	bh=h7XWqwa5MBO+bB5imRvjoZzeKY+t71a6zuMwdT0kSHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruAXCbZtt2GMoSzGoY0Jbsw5IXc6+DfOBiOHhGqEuY6qNfP/u0klgEjujQOwgb7K57lRZKav9hHFqKWd8gO/9LFgyGZQUmp8xRfzBnmDlyn8ge7apGGsohJ3t5BgTCNx1Qe0JzTzycsY5f2uTOcOOW5G0QfKE/QTuWdvOCJxvzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2vMyScT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2vMyScT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D173C116B1;
	Tue,  2 Jul 2024 17:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940893;
	bh=h7XWqwa5MBO+bB5imRvjoZzeKY+t71a6zuMwdT0kSHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2vMyScT9sZPKJoC9gd3VpC6RBQAsxjEhDSsZCSpK+KEaDnu9Ewmb+Y711K/5aeyB
	 elZqW533tuNCC20ZcnAPRbgBOsEB54t3wsAeUrdwg1cVbvO4Hin3+X3FYHAXqsaeqF
	 WFQN4EyWBI8k1r4ADtWd2VUhrfdp8gYJsxmeW7GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/163] irqchip/loongson: Select GENERIC_IRQ_EFFECTIVE_AFF_MASK if SMP for IRQ_LOONGARCH_CPU
Date: Tue,  2 Jul 2024 19:03:00 +0200
Message-ID: <20240702170235.562151031@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 42a7d887664b02a747ef5d479f6fd01081564af8 ]

An interrupt's effective affinity can only be different from its configured
affinity if there are multiple CPUs. Make it clear that this option is only
meaningful when SMP is enabled. Otherwise, there exists "WARNING: unmet
direct dependencies detected for GENERIC_IRQ_EFFECTIVE_AFF_MASK" when make
menuconfig if CONFIG_SMP is not set on LoongArch.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240326121130.16622-3-yangtiezhu@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index f7149d0f3d45c..e7b736800dd02 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -557,7 +557,7 @@ config IRQ_LOONGARCH_CPU
 	bool
 	select GENERIC_IRQ_CHIP
 	select IRQ_DOMAIN
-	select GENERIC_IRQ_EFFECTIVE_AFF_MASK
+	select GENERIC_IRQ_EFFECTIVE_AFF_MASK if SMP
 	select LOONGSON_HTVEC
 	select LOONGSON_LIOINTC
 	select LOONGSON_EIOINTC
-- 
2.43.0



