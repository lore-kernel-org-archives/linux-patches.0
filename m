Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320EF14A4E2;
	Tue, 20 Feb 2024 21:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462866; cv=none; b=FbhcFxwXrgU1P9KzJ0sGofAbviFUbTI04oHXdzosMEhdWYDl8B/54jAaxZEn+8qGklYFh3eSAsluz5cdt7cegZj86OpyjfoL+KnYaWTJvprErC/7wsUzG+2g6cCx8VGlSCbxNpJYJd4WYdAKruCmtO83C9XpzaJPU5IW+uSi6Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462866; c=relaxed/simple;
	bh=IYsC+DYl58NEgATaJMUhil5oSU++9iFCtthqEcqTz+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+iWbBc1fB5KgNQDwcBMtDpqq23yOVgUQWjdVaOv9jRd3/bzT5JVMn2gI4auWt93MG4GjmmFae1bhyXoAR9cFoDvZ8Bhww3dQLP50p+n49XmiLqNKBrNtNJpdGdGe+5+J/4Z7SiK3flcSwwjgHk0uiEIpH1PvvIZi/2sZ6Kh8N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEOVQ7V+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEOVQ7V+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4C8C433C7;
	Tue, 20 Feb 2024 21:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462866;
	bh=IYsC+DYl58NEgATaJMUhil5oSU++9iFCtthqEcqTz+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEOVQ7V+V/Mfom6Ip106Lkon3BCua6N15QDW42wDLJSLUdQ1vjl9MuS2yS9FO2U2M
	 nBU+iagEkRtMTG8VGcWRVJnxeZ/GV8tb9nl6BFeLb+SsHVokDY0Vu+EjsgdppIKBMA
	 bv/8XhXPfhZQ7xVC7qPTvSy9DKlhcxOghhs3VNHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/197] irqchip/loongson-eiointc: Use correct struct type in eiointc_domain_alloc()
Date: Tue, 20 Feb 2024 21:50:20 +0100
Message-ID: <20240220204842.909609936@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit f1c2765c6afcd1f71f76ed8c9bf94acedab4cecb ]

eiointc_domain_alloc() uses struct eiointc, which is not defined, for a
pointer. Older compilers treat that as a forward declaration and due to
assignment of a void pointer there is no warning emitted. As the variable
is then handed in as a void pointer argument to irq_domain_set_info() the
code is functional.

Use struct eiointc_priv instead.

[ tglx: Rewrote changelog ]

Fixes: dd281e1a1a93 ("irqchip: Add Loongson Extended I/O interrupt controller support")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://lore.kernel.org/r/20240130082722.2912576-2-maobibo@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-eiointc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
index 3d99b8bdd8ef..de115ee6e9ec 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -242,7 +242,7 @@ static int eiointc_domain_alloc(struct irq_domain *domain, unsigned int virq,
 	int ret;
 	unsigned int i, type;
 	unsigned long hwirq = 0;
-	struct eiointc *priv = domain->host_data;
+	struct eiointc_priv *priv = domain->host_data;
 
 	ret = irq_domain_translate_onecell(domain, arg, &hwirq, &type);
 	if (ret)
-- 
2.43.0



