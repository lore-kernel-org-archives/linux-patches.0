Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D41C14A4D2;
	Tue, 20 Feb 2024 21:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464696; cv=none; b=YsTpiegzTpfkJh+JBkFb4A1MuhZsNJo6v916OhsfcxBozzLGQ4xi0e9xSJYdyyH6yeR97GixrdIRP/ZtzRHxDGFE6lNjiKJJEg5ZqvxldaG72dojzDx6OZWsZ8hBIMrY3zVW1QQpYfrpjkm0rbuoWSnmR8XLhTxeEOhP8YS/220=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464696; c=relaxed/simple;
	bh=vyrSEROG5t7LG/g4GhNfeY8yODIJtpbu8j3pu4056PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rb8oBJxA6nDEE8zpBOWNcEK496/T9fXN1ZYthy5Ut+F1qfm9sLO+B6xt6wF+CDhJn/EZZcrBZ0MLeemfJjiPQawhnjY1DfgDzNkkvPj2f7tfVnXGgjQOyPctimWwD/ozRnE1tIMCUzSxGElqyNeoLGeIP1ZD4Jei3IiGTa7OH/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wb4rS3rT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wb4rS3rT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E46C433C7;
	Tue, 20 Feb 2024 21:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464696;
	bh=vyrSEROG5t7LG/g4GhNfeY8yODIJtpbu8j3pu4056PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wb4rS3rTwANlJ4DmrqfR7hiFkoePsLwui1QtLfLkrRtc+dC0gtBtDg3+KcaAwYYti
	 Qmtif/QfMcorfGvzTTsn4BOcD6am24hmvrzRRlltvNxaunDY0i7cUDFKpWY/64/ZGe
	 jFJV7fWxuCzf5yyBELNHlG84inGnlA2JtyKFD1hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 108/309] irqchip/loongson-eiointc: Use correct struct type in eiointc_domain_alloc()
Date: Tue, 20 Feb 2024 21:54:27 +0100
Message-ID: <20240220205636.569228826@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



