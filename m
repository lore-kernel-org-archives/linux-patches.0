Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E7A227BB5;
	Mon,  2 Jun 2025 14:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873746; cv=none; b=rJAIWN+wLXv2GQ60m6eXJVyGxZXFYLrj9yc/L4NDxm8L1/D/j1ES+tV3N0Nj6oNHZ20np6dEj1PbZaYPUua050iHiCTF6vwT32/Qk8Rf8ocr38j++BuNHgdu/QwfJY54tFhS0AYzl6Koj14Ymao1d/Kl0/T4vwcg/A5978D2+uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873746; c=relaxed/simple;
	bh=ALy5IN4K0qlYM2q+gJqUBsdFFCovslCRcoSrxiDFnyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDnBqco/yywUYyobFMWt0eV+4qaZR8kKnbFp5DbyfDS0OqjidA9X0UPoLgEQS4MvGeLYUN4x8Z1eO9lSvW0w8JJ8hwezE4KqBex7uP0LWtmKKCP1CL6K92yJxDOO+/vvOgStiNw66OjQbESSUwy9kZJnxKb/sRfU1l+0ldNMq+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aU/wHRcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aU/wHRcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF29C4CEEB;
	Mon,  2 Jun 2025 14:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873745;
	bh=ALy5IN4K0qlYM2q+gJqUBsdFFCovslCRcoSrxiDFnyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aU/wHRcLNnuj8u+HJbjO5LXsbyy1Wk1y+4LFByOYQHyjF74A3m12xJ9CnI28hrQLc
	 0fsfm4qENwX+zVHBTmbx7RYM+faFUfRo6T7tn1f5XQ23pKHRFJTFKTYMMHEDOYeVlJ
	 cmXVr+FqPu3eU9mwhADAUUr5P2LojOPu+KUbYxRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Chan <exxxxkc@getgoogleoff.me>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/444] clk: qcom: ipq5018: allow it to be bulid on arm32
Date: Mon,  2 Jun 2025 15:45:00 +0200
Message-ID: <20250602134350.489402868@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Chan <exxxxkc@getgoogleoff.me>

[ Upstream commit 5d02941c83997b58e8fc15390290c7c6975acaff ]

There are some ipq5018 based device's firmware only can able to boot
arm32 but the clock driver dont allow it to be compiled on arm32.
Therefore allow GCC for IPQ5018 to be selected when building ARM32
kernel

Signed-off-by: Karl Chan <exxxxkc@getgoogleoff.me>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241007163414.32458-4-exxxxkc@getgoogleoff.me
[bjorn: Updated commit message, per Dmitry's suggestion]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 1de1661037b1b..95cbea8d380c3 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -148,7 +148,7 @@ config IPQ_GCC_4019
 
 config IPQ_GCC_5018
 	tristate "IPQ5018 Global Clock Controller"
-	depends on ARM64 || COMPILE_TEST
+	depends on ARM || ARM64 || COMPILE_TEST
 	help
 	  Support for global clock controller on ipq5018 devices.
 	  Say Y if you want to use peripheral devices such as UART, SPI,
-- 
2.39.5



