Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C271CBE8A;
	Mon, 14 Oct 2024 15:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919496; cv=none; b=G3qujAKdY2dKwAg2/+loJzhO9q4hGEKmnq2BQn/uToQZYkmRPcHVp8rO0/PsOjUc58GFg0zKTv9vEauK/PcCu35Sbs2Ce1E44Ig7xCtYbuXSmmQ7oqSJmRTp01BgO+kW4371PrESzX5lVA28SaAEYxCBdkeldG68xnGcFk8MHCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919496; c=relaxed/simple;
	bh=S3t5aQJiQWolK8ZBAzVteTlz6ZJl6IbB6K6AdR9m5ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRjCcEgmUSkvyoLwLNhY+eMRxzRSg4O21VhW/4HukhWy7+FjOxSyPsv/HfLOid204jPv1JUd63tEKHbzHDFkCK1+/Kz/BOVumGN2/hsNgtG3/bxz2eaMHTOuJfQo02djJZrYsDVV9/Hnso/IgYo92QM0ngU+6eVTFDTH9Pcfxqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/iEfszY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/iEfszY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDBAC4CEC7;
	Mon, 14 Oct 2024 15:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919495;
	bh=S3t5aQJiQWolK8ZBAzVteTlz6ZJl6IbB6K6AdR9m5ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/iEfszYZQTH8Rad0rY4WuP1dskEZ2w9mZxlB7nqYl0DKH/066EAMNXRT5lmr81Wn
	 GAefwsMaTAEwkBVhe1XstRaYMTeZcgQBePfKwY6P8tsyVfCw3ZnM8jzA8gCsbSjqhG
	 bUetxV2YjM8l7LfUQNmCAaKA4hTYFWs8c2Zf7+dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Virag <virag.david003@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 622/798] dt-bindings: clock: exynos7885: Fix duplicated binding
Date: Mon, 14 Oct 2024 16:19:36 +0200
Message-ID: <20241014141242.475925254@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Virag <virag.david003@gmail.com>

[ Upstream commit abf3a3ea9acb5c886c8729191a670744ecd42024 ]

The numbering in Exynos7885's FSYS CMU bindings has 4 duplicated by
accident, with the rest of the bindings continuing with 5.

Fix this by moving CLK_MOUT_FSYS_USB30DRD_USER to the end as 11.

Since CLK_MOUT_FSYS_USB30DRD_USER is not used in any device tree as of
now, and there are no other clocks affected (maybe apart from
CLK_MOUT_FSYS_MMC_SDIO_USER which the number was shared with, also not
used in a device tree), this is the least impactful way to solve this
problem.

Fixes: cd268e309c29 ("dt-bindings: clock: Add bindings for Exynos7885 CMU_FSYS")
Cc: stable@vger.kernel.org
Signed-off-by: David Virag <virag.david003@gmail.com>
Link: https://lore.kernel.org/r/20240806121157.479212-2-virag.david003@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/exynos7885.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/dt-bindings/clock/exynos7885.h b/include/dt-bindings/clock/exynos7885.h
index 8256e7430b63d..a363eb63dba7c 100644
--- a/include/dt-bindings/clock/exynos7885.h
+++ b/include/dt-bindings/clock/exynos7885.h
@@ -139,13 +139,13 @@
 #define CLK_MOUT_FSYS_MMC_CARD_USER	2
 #define CLK_MOUT_FSYS_MMC_EMBD_USER	3
 #define CLK_MOUT_FSYS_MMC_SDIO_USER	4
-#define CLK_MOUT_FSYS_USB30DRD_USER	4
 #define CLK_GOUT_MMC_CARD_ACLK		5
 #define CLK_GOUT_MMC_CARD_SDCLKIN	6
 #define CLK_GOUT_MMC_EMBD_ACLK		7
 #define CLK_GOUT_MMC_EMBD_SDCLKIN	8
 #define CLK_GOUT_MMC_SDIO_ACLK		9
 #define CLK_GOUT_MMC_SDIO_SDCLKIN	10
-#define FSYS_NR_CLK			11
+#define CLK_MOUT_FSYS_USB30DRD_USER	11
+#define FSYS_NR_CLK			12
 
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS_7885_H */
-- 
2.43.0



