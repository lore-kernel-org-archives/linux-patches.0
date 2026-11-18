Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016643;
	b=qraFcBorVLG72MxulCkVWOV59EaRi5gARupuZSfg/Bs8QUBldHTQHwHO3VpI0B0sz3Xn
	 Os4iIeu6K0p7GVGsMCJlM4WTzwWGH3e3nBsLJ/d/D/pkj0ATS1yVNvN9tbbe4JupSi2oL
	 bgeJPRzOBtqBEtVRqG4tRP+/kc9XdmLpNsgXC/+zwKjyHajKiJKLxIIPs3gzU4+rnydn9
	 2S1rmV+fDg1rZGZfEoNDyyDdc+bT+TuE8xD4vNGuJAyLEgNuvPGUbNhemcdi0gwklVsRX
	 AM4GwZ5X4cERonMkvGhuUEintFE5qyNTvzIJSxaVGdnmpEW6zK3tR1DodiTw3I9BY/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lWyhzAUzGA8EBJ3NdyK5AC2dISKMm8pAsd0SGQM4yQs=;
	b=yIZzNLGVpFlwwN60WeLUWavrWD5yko86DuX3iiEL252tuqtEM98vLOv2NAb0cccglLyT
	 JZGPHW3eeNgFMWPo0OLhEKY1855QJ5UpiVEpY5zm6B06bW6sIE4t5BZ0Zkeg2d8/vGVtS
	 xlshUhfFfJrKhqBQrZMIdEJ9BBst9UW5RzrMtNocZ/HNQu9fpna/0J3P74jSaP4QStyl/
	 g6Tw5YJ7ehLkInVLznb3PylhIkCN7bNHp+wpdg+3RKVeV2EZqOJVhXW5+SIfAfXLALyve
	 8p4BN7Er4L1WwegDOU/69SZh6ibe0YgMeBhPPwW+huxmWUX47Tc6QdNI+rh3FLrsVhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aT8ICaAA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB03606A31C;
	Wed, 18 Nov 2026 15:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aT8ICaAA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797E81F000C4;
	Wed, 18 Nov 2026 15:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016643;
	bh=lWyhzAUzGA8EBJ3NdyK5AC2dISKMm8pAsd0SGQM4yQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aT8ICaAA15d1+mmpkeI7cgXjZiXfNbwzwtZUhG2HzFv6LB6VnFkGK+JHUTb0PNsWl
	 vCMtCNAPgYukNHdb9860K6Z1rfv5BWTo28PStcElbdXHQxUqJaS0T12JsEUcWa3adi
	 leLqcImtgVnB/sNBbwHuqrpRemRqnzWUN4ICFWy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0599/2651] clk: versatile: clk-icst: Fix node reference leak in of_syscon_icst_setup()
Date: Wed, 18 Nov 2026 15:30:39 +0100
Message-ID: <20261118150309.289069910@linuxfoundation.org>
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
index 6bd3db54dd229..8c84377f3ec1b 100644
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



