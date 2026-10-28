Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210789;
	b=py/78h2B4pGTNGQk85THkJT+MGA/NIdZQQgjtrVoOUkoMFLtMLo4NEg5OU+RobD4AjZR
	 CCncWE7vnmi0AU06tU1psvrTBkA3N+ctbVdeNf8xvSF5CxjgJa99lV9JhfQCu7p4NQE8V
	 83y0VGPtlSzwMJxmv0SIqIwIzmMuJGFdtfI3igFf9G22AUvr8KgVpfIQTahR8wIDBFErp
	 /q0K90MqKFS3qR6Xk5BNrXsbrCyMTr2mQeXCPmcwhOpxxoiX530wg1JY/Cxho1DxOd4GU
	 aj6aPtU0dJLyb3CIpOZ3idgF+/fc0Y43VI47DT5a7PJVkhmI0ZZJn4cfzBCkI7ZjFHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kFiuyLHyuw2c1dL9J5qyA9TMww5SIQKocartAaeybt0=;
	b=ceAAUy1N0Jqyy7hNNDw0VEpsTmBXPn6wBFQ2oJmn3zGYt6wH+CYqDRpnQSihkwN+GMLd
	 v/qW0I4UedBCjCIsPsy59GvOXa37CJB6ugHOGUQGwtOM2O0D8dY4dYDkRE7h4cCVm197H
	 IIg6GThBGOSizBdZCB4PA8y93Y5yiKd2BfIqHysoyBYHLJzhNnFN1TbxuWbE6FJW+NKAI
	 L+G9B4pjMQfx75ySwQ4fQL2vjHIVA41X9QYm/VOdBIBhND0Q/Oip5qm38qvWP67YrInQJ
	 glcFD65VUw3fg5SjBV+Y7SqT1BHx/gPW0T/6zUNPO4s76B+Phx9RJkf0322O6iVuKhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuianNdK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6B5606A31C;
	Wed, 28 Oct 2026 18:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuianNdK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D371F01825;
	Wed, 28 Oct 2026 18:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210788;
	bh=kFiuyLHyuw2c1dL9J5qyA9TMww5SIQKocartAaeybt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuianNdKwZGI0UrspKH9CEHfbPMigHugDfV0iNc7XJuzdPrbAn1IzVyxf9yiPHCyH
	 i3bhLwPM+NWnHBu5hzcYCg5XWDVMPZPoB41gj39F6nKnMgKDKHV0MtaV8FB7CtQoN5
	 Rc3LB8tar+MUYRTL3rE6d8KeZ5/+212Kwe8iHu6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/571] of/irq: add missing of_node_put() for interrupt parent node
Date: Wed, 28 Oct 2026 17:54:56 +0100
Message-ID: <20261028170011.552389173@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit eb2b4ecf7299ee39ee9cecc4d3f2633aeb10cefb ]

After calling of_irq_parse_one(), the node provided in the of_phandle_args
has a refcount increment by one. Add missing of_node_put in of_irq_get()
to decrement the refcount once used.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Link: https://lore.kernel.org/r/20230117144929.423089-1-clement.leger@bootlin.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 738fb9d204169..ecc74f12e3e65 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -407,10 +407,16 @@ int of_irq_get(struct device_node *dev, int index)
 		return rc;
 
 	domain = irq_find_host(oirq.np);
-	if (!domain)
-		return -EPROBE_DEFER;
+	if (!domain) {
+		rc = -EPROBE_DEFER;
+		goto out;
+	}
 
-	return irq_create_of_mapping(&oirq);
+	rc = irq_create_of_mapping(&oirq);
+out:
+	of_node_put(oirq.np);
+
+	return rc;
 }
 EXPORT_SYMBOL_GPL(of_irq_get);
 
-- 
2.53.0



