Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BB8612D7;
	Tue, 20 Feb 2024 21:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463612; cv=none; b=WzD5z1ZSJY/Q6xAqBhZUTUBgQa+GS+mXPDgBaQ/g1PmThrZDG1SvxY1Uh49U7ln2MPr3uqLf29tblLh9EnDAcILexCW74R0J/TMIZSiRtjT0DzwCiIYI1pre32s5+CyN0s9mE3bhRYqmBhVnwfdJUzqdrxUheSNyxpVMzNjMWP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463612; c=relaxed/simple;
	bh=eZhG553ftj3euz2U2UHbTbt0damlFM67rOehkieRh+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7fy7EetyYNM9P+HPZxaJSGxwb+dUeujEXeprP7qI1m1CBMgruBxNPop2MqEmXE8SXf7bo207nvSJLVy5vPA2iclqGAVHoc+9f3OB3LBluqxRGufFAYTqT9Zq987Vam94ebB7FQ8pMqHyQVUNIfnXt9vS+4hewf4SpVQZDcVRNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/GbrBI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/GbrBI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302B1C433C7;
	Tue, 20 Feb 2024 21:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463611;
	bh=eZhG553ftj3euz2U2UHbTbt0damlFM67rOehkieRh+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/GbrBI2DdKGFcO+w5WD9k8cQdXSVciuidprfGCppVJnW3RpWeD2KzG/qNJfx+y2n
	 0JEOYLjAetntondtqwZzeyXva5HxBkk7ecSj+G/+SUaIjSwY4wA1jx9ZNoSszGe6tx
	 Jdi1a71nXGRNujA2L5SUC3kdYQHsxIYr4ZvMvXXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/331] irqchip/loongson-eiointc: Use correct struct type in eiointc_domain_alloc()
Date: Tue, 20 Feb 2024 21:53:34 +0100
Message-ID: <20240220205640.661941698@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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
index 1623cd779175..b3736bdd4b9f 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -241,7 +241,7 @@ static int eiointc_domain_alloc(struct irq_domain *domain, unsigned int virq,
 	int ret;
 	unsigned int i, type;
 	unsigned long hwirq = 0;
-	struct eiointc *priv = domain->host_data;
+	struct eiointc_priv *priv = domain->host_data;
 
 	ret = irq_domain_translate_onecell(domain, arg, &hwirq, &type);
 	if (ret)
-- 
2.43.0



