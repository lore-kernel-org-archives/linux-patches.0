Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ADA1519AA;
	Wed,  5 Feb 2025 14:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764422; cv=none; b=nWGdX/RsfpigY86HE0uy/cujB8sHFo9tix9VRKSJJtOZuv0I3BK2HyIgj0LVDdfdsDNAy0Jz52LFNTqLydqef9PKotMOmEhlNIacodjTTJGpd6u8V98jnJwgb5PBwsieQ8sTzqWSn7EI9yDIDli9gzqowJKfLNTjK7O+m3notZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764422; c=relaxed/simple;
	bh=L/QnnBlmvgIE1caUgRQv74Fp/OsgrcQOS6pln8rT294=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfsYeOlKaqyFWy9klsVN8anh6fotqQEU2ZD9IoCUeVrNu9XeiM+cvXEuPEMDmuSKuNItZ/of1riOnXysNXibs3yUQJk120jPCwNKlcG18lAeWzfYqjIhCqeRtQNAlqm8ds7lkR9lTEK7ogO6WOVitCg7ArbO+C8LuAzL+rmshsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCxmE+WB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCxmE+WB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44CFC4CED1;
	Wed,  5 Feb 2025 14:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764422;
	bh=L/QnnBlmvgIE1caUgRQv74Fp/OsgrcQOS6pln8rT294=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCxmE+WBokES8Hi7DGWV9omfmSTb62pnRvobcfqmYs1FqMlKgpFV5coqB76zTNn3e
	 PXEHzqZ4eLylDARuBaa96lVTXHmI9dXhLhnXSe+RFwOvCo11xX3mN4pO9Ff0GeJmYp
	 RZPuDORiw5ivj/UJqnZ//BZ1f6LHvXwgqITAjq9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/590] dt-bindings: clock: imx93: Add SPDIF IPG clk
Date: Wed,  5 Feb 2025 14:37:57 +0100
Message-ID: <20250205134459.929716769@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 32e9dea2645fa10dfa08b4e333918affaf1e4de5 ]

Add SPDIF IPG clk. The SPDIF IPG clock and root clock
share same clock gate.

Fixes: 1c4a4f7362fd ("arm64: dts: imx93: Add audio device nodes")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241119015805.3840606-2-shengjiu.wang@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/imx93-clock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/clock/imx93-clock.h b/include/dt-bindings/clock/imx93-clock.h
index 6c685067288b5..c393fad3a3469 100644
--- a/include/dt-bindings/clock/imx93-clock.h
+++ b/include/dt-bindings/clock/imx93-clock.h
@@ -209,5 +209,6 @@
 #define IMX91_CLK_ENET2_REGULAR     204
 #define IMX91_CLK_ENET2_REGULAR_GATE		205
 #define IMX91_CLK_ENET1_QOS_TSN_GATE		206
+#define IMX93_CLK_SPDIF_IPG		207
 
 #endif
-- 
2.39.5



