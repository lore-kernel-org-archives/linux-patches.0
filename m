Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048390;
	b=UaZ56k8P7aV1TxXuWJlj34j3PdATxE7k3srwNQWoRABwmks5YSfBmL7n9ddCMopE3m5N
	 dhOI+TRsip6MLtReaadW4GK0e5q90UsmB1mT8a/ZUmNgU+mJxJlpIC+8nMyGGFf3PoTvw
	 BFKDoMhW+Dapi19uNQDW0zaMzMhfP1JUt/t4gv8snALmjeIb2eaVsR3+Vb2KRpB1oOcVK
	 PMF+xg0JKmEEGWCkLP+OB/Eu2mbynvNWnXj2CfF/EFQAcoPu61ouMg6NuwtomgIr9hTa2
	 rkrd3iDGsUtlk5uEQyAlGnDw5F5T9YcGAIpVpgBj85WBW/oV9aum2u9Mva4Fi7If29w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ljwIkING6P3UQ5leQLz/grkaS4zlfOyDmUA0VAY8wuY=;
	b=cM0x1/0QUZf0TTBiQr6mndPLGEzjZu0IgRWAok3lGQyA85UPgMuLXL6H+fMJ7HM3h+UC
	 w1Y1gRK2LnwEyLS+LDcX1G6bonvt9FMmEOsUOg/Yi6lHgwIRfxI0ZVUtEb4Hgjr327MRc
	 MJB1BDO3XuIdUkwCy4koILYpJaPCKRIFK8/IU6vpejpMelgj8SL5DsCsfjy+XJM4hN4SW
	 J0kwYNW0Oa54h86lf1UiyXU6UHYG3aw0CLiRrTk1K0qQwj3avacDkUjwb0RKGWAwlldG2
	 wUPJnMlliZKR14x8iUdEh3r8iQUydiImjtf1unNPVDFSrVB31FGtpG8IGvOhMQHUa2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oEkfXU/y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F1660A383B;
	Thu, 19 Nov 2026 00:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEkfXU/y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7171F000C6;
	Thu, 19 Nov 2026 00:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048389;
	bh=ljwIkING6P3UQ5leQLz/grkaS4zlfOyDmUA0VAY8wuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEkfXU/yTjsagXqtQdU9me8MpitKiaHIMAabg6f9u0BIrvPxt01qiA3picVGodBHy
	 EDmbedtM758WIdB4UKpZJwvWvOeeiJVs/q8s0rHg2cU3R2pTn3RkViUSm6D7qPlXQS
	 d/3CuPYO6Noa7O6WGUqs/9b1WXrMxnE2W+Ij1V9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1976/2857] clk: versatile: clk-icst: Fix node reference leak in of_syscon_icst_setup()
Date: Wed, 18 Nov 2026 15:50:10 +0100
Message-ID: <20261118150312.535867892@linuxfoundation.org>
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
index d5cb372f0901c..9c1fbfd2c6557 100644
--- a/drivers/clk/versatile/clk-icst.c
+++ b/drivers/clk/versatile/clk-icst.c
@@ -498,16 +498,19 @@ static void __init of_syscon_icst_setup(struct device_node *np)
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
 
@@ -534,6 +537,7 @@ static void __init of_syscon_icst_setup(struct device_node *np)
 		ctype = ICST_INTEGRATOR_CP_CM_MEM;
 	} else {
 		pr_err("unknown ICST clock %pOF\n", np);
+		of_node_put(parent);
 		return;
 	}
 
-- 
2.53.0



