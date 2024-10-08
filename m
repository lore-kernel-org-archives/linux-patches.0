Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B5A1DEFEA;
	Tue,  8 Oct 2024 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393903; cv=none; b=tf0pX5WsuUmzBQMCHO2dKcjss1y3p6O0NyiRsbW+L6s3uqP0tGUwe4pKy7sh2OSBdESZkb05wQMnKTAdNZ4I3PaBPvOB4pluvVIkuhtfcYcI9d4JLOOoFz33AUbiMHWGNiMwO3gUga3tWXXHTTioBkbZpX/M4+s8DI7YhRyLt7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393903; c=relaxed/simple;
	bh=f6Kmpj3MYcHW+9bAPD2bEqR3nioa36J5+t12kHqPcV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHNWJ08krBonfTUFvC3wT2ZnU7NpWYn8oaD09pe6zt8WENevabjVpb3RJLihapr0zwkJdFFLgnX1bRfzwGmxZKif0BfeTgYooaKZvwhS/29qg6V+WsOlu7qvnAjxr7DThvbL1wRZl9gUUWd3e25Y8vlE8qCKXc/+G8NLPMfo6BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvAm4xbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvAm4xbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237A2C4CECC;
	Tue,  8 Oct 2024 13:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393903;
	bh=f6Kmpj3MYcHW+9bAPD2bEqR3nioa36J5+t12kHqPcV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvAm4xbSPvxSIBVBQrOpdOY/kC+rjUNe9RfNBypkOGO0l6x6o7WkoXENYsHPZhdAH
	 /4XqiGRM5LuLz3M7qXxDjtlEQuOdDUeQD2anC9xH0KMhh93bJxEUsLUB21zBlNdS0D
	 d2H/xwpn6hgnb3oNA1hpusRKxnwDvoGqm4wP8oA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Virag <virag.david003@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.6 287/386] clk: samsung: exynos7885: Update CLKS_NR_FSYS after bindings fix
Date: Tue,  8 Oct 2024 14:08:52 +0200
Message-ID: <20241008115640.680586017@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Virag <virag.david003@gmail.com>

commit 217a5f23c290c349ceaa37a6f2c014ad4c2d5759 upstream.

Update CLKS_NR_FSYS to the proper value after a fix in DT bindings.
This should always be the last clock in a CMU + 1.

Fixes: cd268e309c29 ("dt-bindings: clock: Add bindings for Exynos7885 CMU_FSYS")
Cc: stable@vger.kernel.org
Signed-off-by: David Virag <virag.david003@gmail.com>
Link: https://lore.kernel.org/r/20240806121157.479212-5-virag.david003@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-exynos7885.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/samsung/clk-exynos7885.c
+++ b/drivers/clk/samsung/clk-exynos7885.c
@@ -20,7 +20,7 @@
 #define CLKS_NR_TOP			(CLK_GOUT_FSYS_USB30DRD + 1)
 #define CLKS_NR_CORE			(CLK_GOUT_TREX_P_CORE_PCLK_P_CORE + 1)
 #define CLKS_NR_PERI			(CLK_GOUT_WDT1_PCLK + 1)
-#define CLKS_NR_FSYS			(CLK_GOUT_MMC_SDIO_SDCLKIN + 1)
+#define CLKS_NR_FSYS			(CLK_MOUT_FSYS_USB30DRD_USER + 1)
 
 /* ---- CMU_TOP ------------------------------------------------------------- */
 


