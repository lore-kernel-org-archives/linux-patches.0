Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386486FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4780C433EF;
	Mon, 19 Dec 2022 19:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477823;
	bh=/Pldpmzlcy5Qw8pDeCjbAU2AHTtkanDviipFsOndU+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKUFixQw8TDRD5Vky2Tb64G94EtYEpG2av6QWWzDBXxD+/Y5uFvrNn2kBis+tBpW0
	 KdWz4+Z9g/1xIKyNZnGu+ELnD3LFDdxVFOeZSYoAqBHTJHo3eakxFF8YFYnulSg3nh
	 r6WI9uKCiQATw5ccjGC41FwR9vibArkEeyrJ524A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 07/25] irqchip/ls-extirq: Fix endianness detection
Date: Mon, 19 Dec 2022 20:22:46 +0100
Message-Id: <20221219182943.712549304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Anderson <sean.anderson@seco.com>

commit 3ae977d0e4e3a2a2ccc912ca2d20c9430508ecdd upstream.

parent is the interrupt parent, not the parent of node. Use
node->parent. This fixes endianness detection on big-endian platforms.

Fixes: 1b00adce8afd ("irqchip/ls-extirq: Fix invalid wait context by avoiding to use regmap")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221201212807.616191-1-sean.anderson@seco.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-ls-extirq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-ls-extirq.c
+++ b/drivers/irqchip/irq-ls-extirq.c
@@ -203,7 +203,7 @@ ls_extirq_of_init(struct device_node *no
 	if (ret)
 		goto err_parse_map;
 
-	priv->big_endian = of_device_is_big_endian(parent);
+	priv->big_endian = of_device_is_big_endian(node->parent);
 	priv->is_ls1021a_or_ls1043a = of_device_is_compatible(node, "fsl,ls1021a-extirq") ||
 				      of_device_is_compatible(node, "fsl,ls1043a-extirq");
 	raw_spin_lock_init(&priv->lock);


