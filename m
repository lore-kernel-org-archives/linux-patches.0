Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023938;
	b=QUhyKArA5k+Ks6GcUJfHVN7QLS1eJYeT38zGtS6rsGWonyE1Vmk3iMN9gV6Vh761TTa0
	 lPhK/SeihHuilNnfEAYOPrsboXVwUq5M9t5NE3h5tJ+Ct0gE0uZrEcNoj2kZtpEA5lVeU
	 v7aMUwuNCY5CzU6FJAFGZlfoqnWaIz53ZqadmwEENQ/liRLond9Kpd3rVDKxsyhI4Kgtk
	 OHqAxaS9jmdIxD3I2ddDWs9zDv0QVM9jGn6iOwRh2MunxmYrZvMrigWX7btAK5zKsVxFw
	 lvsds4ej2cmS7tmuCjgP7jj3upt6PMyz8u45v6BgVyp3n614gLTBBxZgOlZREoz3qFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/eMZ57ldgiXPJhS2Tu4IKfG6oa18Kfd0g2/10wcKHTQ=;
	b=DZrXeaQj6l7wBUO/siW0pbVWGWds+W7i2BuZ/76TG5WNa1sFD3Bvhe0Nvt+XQaxyAhag
	 LoVQWa1/4ZHvUOpcI2a6bq9kQxp2vYgVfIjoGIShCSEg/vxE6SJJqijDUXlOkH9LunXUR
	 N3VEbekbTY1AHsXXWrBn2Qi4QBhDag2TRioyYZAelVpE6/cnLnq2h0beeiolCozwzCsh6
	 u78zicvuanNTdzCkU+1DibKtpuqnx1QlNZefwQUFgFOOdZ+P1Vel4utmnjLqy45wGSE9I
	 1nwH/z3ddeKvqnozwZeSBcIfgtRUsAoymmgB8Kc+a2LML3qWowsuUElnQbpcl2mPl4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3MpL04O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D342606A320;
	Wed, 18 Nov 2026 17:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3MpL04O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EB11F000C4;
	Wed, 18 Nov 2026 17:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023938;
	bh=/eMZ57ldgiXPJhS2Tu4IKfG6oa18Kfd0g2/10wcKHTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3MpL04OglxnqYBMQkU3U4o9IXXhrLlOtBY2+czZUiFovqtKyX5I6enP77WANOcEY
	 jKgX+zTwX3roZxY6NiT1I53EtZHN6PHZezGFFYPT6H+ZbxmH3uA7VLLkh83iSfG6gj
	 x+TolxOYKf21CgBkopZLESK0zjUEO5EXrtAGMVFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0546/2151] clk: versatile: clk-icst: Fix node reference leak in of_syscon_icst_setup()
Date: Wed, 18 Nov 2026 15:38:01 +0100
Message-ID: <20261118150141.859509248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit c90a50d07f0c38c62ce13a60806ab5e3b841f70f ]

of_get_parent() takes a reference on the syscon parent node. The
reference is intentionally kept on the success path, but the error paths
return without dropping it, leaking the node reference. Release the
reference before returning on the error paths.

Fixes: d430819d69a5 ("clk: versatile-icst: add device tree support")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/versatile/clk-icst.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
index 86ca04ad9fab0..8d198ab248402 100644
--- a/drivers/clk/versatile/clk-icst.c
+++ b/drivers/clk/versatile/clk-icst.c
@@ -516,16 +516,19 @@ static void __init of_syscon_icst_setup(struct device_node *np)
 	map = syscon_node_to_regmap(parent);
 	if (IS_ERR(map)) {
 		pr_err("no regmap for syscon ICST clock parent\n");
+		of_node_put(parent);
 		return;
 	}
 
 	if (of_property_read_u32(np, "reg", &icst_desc.vco_offset) &&
 	    of_property_read_u32(np, "vco-offset", &icst_desc.vco_offset)) {
 		pr_err("no VCO register offset for ICST clock\n");
+		of_node_put(parent);
 		return;
 	}
 	if (of_property_read_u32(np, "lock-offset", &icst_desc.lock_offset)) {
 		pr_err("no lock register offset for ICST clock\n");
+		of_node_put(parent);
 		return;
 	}
 
@@ -552,6 +555,7 @@ static void __init of_syscon_icst_setup(struct device_node *np)
 		ctype = ICST_INTEGRATOR_CP_CM_MEM;
 	} else {
 		pr_err("unknown ICST clock %pOF\n", np);
+		of_node_put(parent);
 		return;
 	}
 
-- 
2.53.0



