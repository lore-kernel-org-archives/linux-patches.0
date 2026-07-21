Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705A4415F17;
	Tue, 21 Jul 2026 18:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660278; cv=none; b=U1QCs15kXr4K+jV/5eqmxA6HDZbD0BeqfsV4/VDN8fZ+GiTzNcE6eNe4cOHCn1btbk2g3jrI+J9bUUVBGhqEY2B6MdgTG7/gKqkrM5sSjgfewh7ZIWAnsEDyArtqDvHXq0d/owkkicwwQEg7rOW9K+0kQNr8SngfhDG2jWN504Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660278; c=relaxed/simple;
	bh=5IQZtou/Q5FULhyf3quVxl0cOke7xhWE6ucclcv1dwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cy0RDI3PczS/4TK6O4GmqVLmNdIaXOqcw5LTvn3GhIdAOineqkH7Wg2HaVE1KccH867t9/EIpEpHUj+2z5peRw2kavbWsicHKUr/47/zcFftfoU+vXov7LVnm53FxlJqMe+mkB0gdqQb46Bi/o93YWPo5Vt4eWW6PmRQ7WF0u+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ernRLQt7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ernRLQt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8791F000E9;
	Tue, 21 Jul 2026 18:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660274;
	bh=faQbz7i7fWTocytcg/lX5poEBQnYerIVJXr1yMKvs6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ernRLQt7gx/JQOXYBuz6zIdOOJBO3EDFic6zFkNDDzmBaWV3AoasEr4Lz0m0hv9Qn
	 KXemG8WC09ezc7AllCvKTqOBPyTZcuDoeR/IsonWXBnzqTPTinS+fWUwcQhr6fcwQR
	 BWXPnxPq9rBvaw5a+zi5Hj1xIm0eIHTSSRDdl/Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0916/2077] clk: spacemit: k3: Fix PCIe clock register offset
Date: Tue, 21 Jul 2026 17:09:49 +0200
Message-ID: <20260721152614.418665098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yixun Lan <dlan@kernel.org>

[ Upstream commit 2f20c859a82a291483a8b3f01cbfbb1642782a14 ]

The offset of PCIe Clock CTRL register for port B and C controller was
wrongly swapped, correct it here.

Fixes: 091d19cc2401 ("clk: spacemit: k3: extract common header")
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260511-06-pci-clk-fix-v2-2-c9a5e563bab3@kernel.org
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/soc/spacemit/k3-syscon.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/soc/spacemit/k3-syscon.h b/include/soc/spacemit/k3-syscon.h
index 0299bea065a05d..a68255dd641f31 100644
--- a/include/soc/spacemit/k3-syscon.h
+++ b/include/soc/spacemit/k3-syscon.h
@@ -168,8 +168,8 @@
 #define APMU_CPU_C2_CLK_CTRL		0x394
 #define APMU_CPU_C3_CLK_CTRL		0x208
 #define APMU_PCIE_CLK_RES_CTRL_A	0x1f0
-#define APMU_PCIE_CLK_RES_CTRL_B	0x1c8
-#define APMU_PCIE_CLK_RES_CTRL_C	0x1d0
+#define APMU_PCIE_CLK_RES_CTRL_B	0x1d0
+#define APMU_PCIE_CLK_RES_CTRL_C	0x1c8
 #define APMU_PCIE_CLK_RES_CTRL_D	0x1e0
 #define APMU_PCIE_CLK_RES_CTRL_E	0x1e8
 #define APMU_EMAC0_CLK_RES_CTRL		0x3e4
-- 
2.53.0



