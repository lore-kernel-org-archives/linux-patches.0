Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029898;
	b=473LxgAx7OZZLFaPLD9p/k/Reu+uUtndU2yEOGRRRUir99pA/6fsRFvvVFaKHG39BF1g
	 7JEr4KqFg+kQsxOf010BH7NEUPPZehp7ojjNYpiY5nCdp81GUV6L0VJVjPFq7eqMZLYOd
	 ekbwNkUbYPA7WxRB/4iMOaiVwbJ40fobVVuJ1HmvlhjKCZ+J4MPvRNX5LG8quO8Nhqn/m
	 bLJnI+D8lpO4PH5qH4g0Q82+1dR3h+TCxr/3fLBkmsdFLKaj3/92HRdowCePrRedhUuRz
	 h3YVw2/Flkv+fA8jG86A52MkMImNcPu2UbgxbcV4nI6BWyoC4h4nyCz9coKAPq2wOUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RF89iaW2Eze0H7DFXCRxPkeGSuvbRybdkFP4Gfj/HoU=;
	b=TS28M4XGMZatB1HqeYUYaXRNIDnC9f+3kqjgplH4Um/qPdzrpqzr940mdp/PxA4ffKg/
	 zVTMgWogQYIwNnMXF1f3T00CkhH/lwXok1pKFRbDFxdrs76N7knwjENsErrqg1ykP017q
	 wFyR9bnUlTtKo0meXXoeGX1DWr/KiLqjxOcqkHKbzsoiqVT/VskHWZpYkAL/RN1POqG7Q
	 Jb5lEAukaZEUIf6F1/jGh38HutSOu823VbP2Iq7PsgxvciHQozpGhf61f5zNwZKdRZPLH
	 RW1igWHaYBwVjeb2kYMKU+LJjGRftdE1/XVBp7Xr6vfUsQ1DXumO2qac8ik6+WebugQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuaJWZ6V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59200606A325;
	Wed, 18 Nov 2026 19:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuaJWZ6V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CC91F000C8;
	Wed, 18 Nov 2026 19:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029897;
	bh=RF89iaW2Eze0H7DFXCRxPkeGSuvbRybdkFP4Gfj/HoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuaJWZ6VSiUDH4/AR+xOUvdtKsJym34sn4B+NT6kN3PS+ccawKBhSrRtN5f4VPDmS
	 DYmWlaMiciiXZl7WvDWmt+QkLVhVjiufOI7HWkgD3/kb/50sHd06YEvg/RAYgEK3sn
	 s1PWtPsvB4+wqQcbZhdy8D3X/x97/u5IbtpddZ+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0471/1756] clk: versatile: clk-icst: Fix node reference leak in of_syscon_icst_setup()
Date: Wed, 18 Nov 2026 15:43:18 +0100
Message-ID: <20261118150027.626133182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



