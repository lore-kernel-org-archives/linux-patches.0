Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039918;
	b=38mMkY04aAjQJ2vI/66RlGGO5gDFdLBJq+gdICDtx/P36UVnknZMkDbRbbR5COHXkBEv
	 3JkS4Q1iM5yj81f9WgD1HEuQBTB/Wiqe9125bdLNc5oMBJAO/nriz7EHwA1pZiJkTXj9u
	 nMldeGgyHoKTtqAM/fRsKRG/imkj5Z1kLnakJDALd7OsiUDnWXoVay1mrLxOk0cUSyfQj
	 VO4o5s22/gTb7oVOzZkD6n0sdQ6WlJvHkanswgGoagyzUILQRtzfV1EzCCZCCHz9QV4Ot
	 ZWa7ZnC1o/MctW5JMFqVZFHbDqmwFfbROgBwbWxGgDfDboXnMk466akqHEKaUDMTV5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=51CL7L70ABPd4fGlHYcPfxongiQxM2r2ws6q2fCDZtM=;
	b=Kq9gIy2MjbTzoqXllYBTO4wbkI8vuQmO0y+49dCx+SlnHoNJtswhuH+iGC/W3FKPTA84
	 c1VFfbOJwmMCcmFDBCdr7IDChNKVeLS/TnGXvNgh+0YejqyRSqAZcCJo/ft4pj01rjTGl
	 wj6suTD7q3IcgWCuHjVmAlpbPdM/Gs9lkGtsZP6ypyorU28xr0bUjTbhXreqXDqlCdet7
	 dzUYXK4JrDdJn8XxgsDCgeZuK+btqFU5xRL2nEaltCjBetfI4Ig9RGVThUbU87sd4w8dM
	 B2+g6cEpX6g/c0QNjhgkUUXadE0LNyteH7kTEdgdmkxJ2PSBLqusuyFI/WXGF4/00CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0iu/5tqf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E09606A31C;
	Wed, 18 Nov 2026 22:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iu/5tqf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852DA1F000C4;
	Wed, 18 Nov 2026 22:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039918;
	bh=51CL7L70ABPd4fGlHYcPfxongiQxM2r2ws6q2fCDZtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iu/5tqfFrdrdj+06WNkK7bbnuPrR6ccrWkspjvYTCJr/MHQPLaFzeEGlRV6RG7lj
	 U9MPUzb8MvlTlh084SHA9E05GI+AruS0x5bpU2sbIHYDmcG95Ad4y7dCZt/CpRWGid
	 L5z9V1mg4PAOWHM9rSNqhZ/dx3W7PvP5I93vrWzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2270/3318] clk: versatile: clk-icst: Fix node reference leak in of_syscon_icst_setup()
Date: Wed, 18 Nov 2026 15:48:12 +0100
Message-ID: <20261118150429.896092628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



