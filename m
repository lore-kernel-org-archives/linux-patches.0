Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA881519AA;
	Wed,  5 Feb 2025 14:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764398; cv=none; b=D2l1Pw+NE/GLS9uKFZy+WfdKRDXLwLerdDkuV7DffVZ/w3HEQOlBhCi3I2OVLyC3ENFjy33nq4fjbNFmQuXTZeIGWW89MslSkJvpgHb5foHF9reiqWLfcuv+t0d2K8tJOQU4QQwi5eNGp/KWEtyrTXMxaIKTqtfhX8D2uoXTdaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764398; c=relaxed/simple;
	bh=wMmaRZ1bz3cgfQY9emMIl4tkTmOtakjqyFyG76oQBj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lX5CNCC4VLk/BIUeMLegQV8l+bdkD8AGiQoMkRWvFAgSgsM9HyeYA062rvJRAmC3nlORJkm+Uzz2jKaYL2iOF1juWevWjM29XAAC4I6cWs8qgYrjE2eOKDWUdqD7Ve12cpMAPhJfTL1aiX/H0kvrcJlB1fS3pZWHVZ4mjwr4Xv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWdZGEme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWdZGEme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BC1C4CED6;
	Wed,  5 Feb 2025 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764398;
	bh=wMmaRZ1bz3cgfQY9emMIl4tkTmOtakjqyFyG76oQBj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWdZGEmeOlL8NPDrUMtG3081OaGQk6ZoUx32hO9iUHpU8cIj7fbdmSNgTW63WRsjs
	 SAuDgxji21A26IY1bZMTBnf2/97NUfNq68KloUAPQk01Qza4mXSBV0msvobLOALkFJ
	 E9EKTmg87kERsX2hrLgSNkdYB0eDpH7eRufcnh/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Li <pengfei.li_1@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/590] dt-bindings: clock: imx93: Drop IMX93_CLK_END macro definition
Date: Wed,  5 Feb 2025 14:37:55 +0100
Message-ID: <20250205134459.851058967@linuxfoundation.org>
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

From: Pengfei Li <pengfei.li_1@nxp.com>

[ Upstream commit c0813ce2e5b0d1174782aff30d366509377abc7b ]

IMX93_CLK_END should be dropped as it is not part of the ABI.

Signed-off-by: Pengfei Li <pengfei.li_1@nxp.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20241023184651.381265-3-pengfei.li_1@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Stable-dep-of: 32e9dea2645f ("dt-bindings: clock: imx93: Add SPDIF IPG clk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/imx93-clock.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/dt-bindings/clock/imx93-clock.h b/include/dt-bindings/clock/imx93-clock.h
index 787c9e74dc96d..a1d0b326bb6bf 100644
--- a/include/dt-bindings/clock/imx93-clock.h
+++ b/include/dt-bindings/clock/imx93-clock.h
@@ -204,6 +204,5 @@
 #define IMX93_CLK_A55_SEL		199
 #define IMX93_CLK_A55_CORE		200
 #define IMX93_CLK_PDM_IPG		201
-#define IMX93_CLK_END			202
 
 #endif
-- 
2.39.5



