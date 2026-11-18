Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020410;
	b=kE3PFDhNWTgD/8NopfwEQVEwA5Dy4Vt7SeoOXPyAGz8UDkyw5E/MWCxWDXTKX/YEvuSO
	 Dx1kL48g5+zpWW+Ctiy7L0flCFoO2XAZCZkyI18wMoJKAHCTKJsLxANN/PmNb+x4cQ6d0
	 JVHHDs7rkig4n0W4VfEUK3ov6vag2CDNCX9scx9pTcLjllb/9WcBoBEmnwlrr2MC7O8kv
	 8AHUpIr4R0Y5FyHsocp0a3is81FEjM0pgMDEdpUlmt0Cy4xCkZXmeoL9/Fkl9QJfu3ZPI
	 xCGUsjBZ0ZHUEtP2o6yQzhQAfpfggkO+0EFCKr4bQnbYyKWLOLGAVMGaLlhvqg0fIBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4lLdJgjwaDMygP7pJyM0dw6MJjG2j3kx9L+KQzqZcLA=;
	b=OJV2+WE5Nf8cmVQDuJ7XRbIDfD1Bx/9PJFScXG26qpBK58865H8M67kFUmabtyseV8ie
	 FsPxmEEJTlVc0da7K2JDn/TpaoKx68rY0d/mqc+kL3ZMhf6FwPrG0IBmJdQxXOQHmkvjO
	 0UnIxG+V7/b5MGFP1PPObEF/T/PNtKc1GzO8Aq960vKHprvSbW2W3rCZ1WbOiEhLl6B8m
	 gFrZjJsHa9iyyoSUcuTUCEe5SxOHDkzMbwuWAc5/nkjdqDDAIFEv5DHPaUSmqcGCIlp3n
	 om+AskDSSypOdJShGB10LTqJoYwiOIHBjLdoPsTyrGe/pGqcHSnvx1jea1fsWKFLqrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LRUN/snJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0BD606A32A;
	Wed, 18 Nov 2026 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRUN/snJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E8D1F000C4;
	Wed, 18 Nov 2026 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020410;
	bh=4lLdJgjwaDMygP7pJyM0dw6MJjG2j3kx9L+KQzqZcLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRUN/snJxpbcoFE6RaRJB8UhBhppn8bYDrxX3eAIfoTvQIiWKFs0ZUv/RyTAMbFtu
	 k2goHt8dms99zxl0k1PXZKmg/yHXEdgsCx/neGioU24R5Ks2ZMA/igJFWEKBIO47Zr
	 ZlM8WsKiAeGycZfq6pXq343+rqXcgXpXWwzUjSPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1942/2651] irqchip/mst-intc: Validate the DT interrupt range
Date: Wed, 18 Nov 2026 15:53:02 +0100
Message-ID: <20261118150356.529698519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 16f25d326e5d3b9fd51bc5e3916ecbffbca63e7b ]

The driver takes an inclusive interrupt range from the device tree
without checking its endpoints. A reversed range wraps the unsigned
count calculation, and a range larger than MST_INTC_MAX_IRQS exceeds the
controller capacity used by the driver.

Reject these ranges before calculating nr_irqs or creating the domain.
Check the difference after ordering the endpoints so the validation
itself cannot wrap.

The issue was found by our static-analysis tool.

Fixes: ad4c938c92af ("irqchip/irq-mst: Add MStar interrupt controller support")
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: gpt 5
Reviewed-by: Radu Rendec <radu@rendec.net>
Link: https://patch.msgid.link/20260920034236.16229-1-hppiscas@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mst-intc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-mst-intc.c b/drivers/irqchip/irq-mst-intc.c
index b5335f6fd6d6e..1070de5de8cce 100644
--- a/drivers/irqchip/irq-mst-intc.c
+++ b/drivers/irqchip/irq-mst-intc.c
@@ -263,6 +263,9 @@ static int __init mst_intc_of_init(struct device_node *dn,
 	    of_property_read_u32_index(dn, "mstar,irqs-map-range", 1, &irq_end))
 		return -EINVAL;
 
+	if (irq_end < irq_start || irq_end - irq_start >= MST_INTC_MAX_IRQS)
+		return -EINVAL;
+
 	cd = kzalloc_obj(*cd);
 	if (!cd)
 		return -ENOMEM;
-- 
2.53.0



