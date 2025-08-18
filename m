Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769272C235F;
	Mon, 18 Aug 2025 12:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521478; cv=none; b=isaXhAZ1yG//74IMUmW97hL940rcEsmJ0RyzT29kMfuEiHsrOMUakglb19ieZdPw32w3M68fpm0Fdfvs9mf90FLnxAon89+l7j0gLYTjBWYOFwN9TRxL5dpsPqbovY8X8o3qFINlTbsZA0jt6ynULM5ohTp5lV9P7D5+RTStc7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521478; c=relaxed/simple;
	bh=R53u2pq49f/YUP18y97vdhCbISvYuysGngbzCmTI0cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eYK1hC3grGo3kPOdZ/6OPyYFyC53kYyoQsbgp0uo/+scBkrQhAIX/YDpLO8N3cyBibu/QA685H3BozhfsB2LTqCAb28uLgc494h/XPj3TWNupc2FHJq8hKq1Gg51wFQWtNUGkjYYLKNWoXap9ZzVXgwKMQp0OGbJ8lCMQohHsEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=De718gMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="De718gMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9136DC4CEEB;
	Mon, 18 Aug 2025 12:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521478;
	bh=R53u2pq49f/YUP18y97vdhCbISvYuysGngbzCmTI0cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=De718gMzQGQV5821TX7Tin7YEUh7KQPR0AaMwLPNvh5SYoBM/XWX4Vwc9FY9dv7rb
	 4o5Rw3xYyxgQ6+Uj6FOCBmcsd20M6wiw4YdQSHgjXRQy0cj46AAkw03A4eoyAy9iuz
	 X1MultX4V21GTIUAPhWnSWnsl9b6PDP81dAWKYX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 032/444] clk: samsung: exynos850: fix a comment
Date: Mon, 18 Aug 2025 14:40:58 +0200
Message-ID: <20250818124450.133122906@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


