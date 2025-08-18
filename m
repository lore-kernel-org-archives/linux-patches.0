Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4056F321F58;
	Mon, 18 Aug 2025 13:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523006; cv=none; b=E5d7fEO3PPryvH61xIJT7/QzM1M6vJYRdEXimfkE7gNrf/jQBc4W6kz+w8XBHFViXRrXCezwwblf2H8OSdVZQJEqX9mFDFq8b4v20Kvq7rt0j/qoqSIxJG1F60Ms7Q9lAlys3dP5DnmOtdR/0qWiApJykXjJ7bTLzffwu5107FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523006; c=relaxed/simple;
	bh=8P2yIMKdP8XionFQOJuE5YKVK+EsYKFNj2zmmA+QX44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TjxQ5vvDeajI8NDctc8joC1FK1FodjTFuMksvGxe49q6YRupItGcGtED11oeCOlDvaSp1kITUaLR0nPqQ9fMP0sXZM9tASDpK6gZJbSapnE6T6OdmmzqU1/BSjsCzlvEwHD89/qv6YnQWHp3+4p2gYbKqzGAgIk0/wXUCnRbykw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCUEuEDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCUEuEDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B697C4CEEB;
	Mon, 18 Aug 2025 13:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523006;
	bh=8P2yIMKdP8XionFQOJuE5YKVK+EsYKFNj2zmmA+QX44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCUEuEDRyE6eQmufBu2d+mxmkKfpGK1k/wDOY2xVDFOFTQs4DdBeUiIVArjGd+AnH
	 oVoyl6QZpOm7Yhk0Y8949oVbCxJRUha8FN+PVTB6kHwkKg0QzpblbNvYvK8yerXBMg
	 2uXzHFuikvTiHqRMtk6V8aRCFepFpHU7YQV5wyNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.15 040/515] clk: samsung: exynos850: fix a comment
Date: Mon, 18 Aug 2025 14:40:26 +0200
Message-ID: <20250818124459.979271625@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 320e7efce30e2613c2c7877acc46a8e71192cdcd upstream.

The code below the updated comment is for CMU_CPUCL1, not CMU_CPUCL0.

Fixes: dedf87341ad6 ("clk: samsung: exynos850: Add CMU_CPUCL0 and CMU_CPUCL1")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250603-samsung-clk-fixes-v1-3-49daf1ff4592@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-exynos850.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/samsung/clk-exynos850.c
+++ b/drivers/clk/samsung/clk-exynos850.c
@@ -1360,7 +1360,7 @@ static const unsigned long cpucl1_clk_re
 	CLK_CON_GAT_GATE_CLK_CPUCL1_CPU,
 };
 
-/* List of parent clocks for Muxes in CMU_CPUCL0 */
+/* List of parent clocks for Muxes in CMU_CPUCL1 */
 PNAME(mout_pll_cpucl1_p)		 = { "oscclk", "fout_cpucl1_pll" };
 PNAME(mout_cpucl1_switch_user_p)	 = { "oscclk", "dout_cpucl1_switch" };
 PNAME(mout_cpucl1_dbg_user_p)		 = { "oscclk", "dout_cpucl1_dbg" };


