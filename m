Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAE227B358;
	Mon, 18 Aug 2025 13:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524720; cv=none; b=qNlUIqsVt9dWVWlPIRskuGf7EVpKv2SOOGJfrUDM7EbhWeYNov0f7Nv0WmBpdvuIQQyagoJWZVQm4U3dvhOhcPo3+zB3QSQDGCc9OxDKvMIGK4QEt27vMMbam30ZXmgGPL1aWc5ph1XkX7H1m/U4/x/PCoFQaJWN+/iJueYxD5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524720; c=relaxed/simple;
	bh=tCJfr12E8YbT4lzX2X+oHH986zAMYbwX0cyJIKEpobo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KfytFLEi+5+G+ca5GsDit+bgF8TkD3Kc+lYBUAO/h089EyMasnTZrDMUB8RVvwAXmion0b6HMSC8+CirMH3Va9biyftGHJLiHEJOZHvphpvj5h3RezQjd+mago34bVe33rWDkx0kT0S0EE/WJZlEAxz4TrzLVgChTcTu75HjZh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khdq+iB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khdq+iB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CD4C113D0;
	Mon, 18 Aug 2025 13:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524720;
	bh=tCJfr12E8YbT4lzX2X+oHH986zAMYbwX0cyJIKEpobo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khdq+iB2QVJQmHqNw2D6pXZrzllpMi9gJ4t6IEoLEFAr1XqZIaAxNdSkp0uL39LP0
	 O0FesRpsnbG+SFFb0VD5z59rjl4/V2RaiVQTppxgoGiIZAjCdHNPELV9H6K39ir81T
	 pcW2K3m0w6wvkvy27ADkyUTOrKOHrotQWctwmiq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.16 042/570] clk: samsung: exynos850: fix a comment
Date: Mon, 18 Aug 2025 14:40:29 +0200
Message-ID: <20250818124507.433988237@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


