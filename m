Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97A41ABED9;
	Mon, 14 Oct 2024 15:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919579; cv=none; b=X46uwWyRJsWGPL6Vu4QpKpN5X4r24vqH88XEY4vGujK/PYQJIyXew2cZ28y5bTO7j8oJ0+sD6KTBBmiBQwFD0Ijg8QGcV4J7VkIc2756YD9xjlq3dac+C8LBfLda/C1zUl8B9aEwgFY5MlCeF7y62HQ85+0FAC7LdYuPuedfKpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919579; c=relaxed/simple;
	bh=LrPgmohVnmw1SW74W7lWJhNJtX2iY70lmrfCGZGIcEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=be7DTKufeFVeYSWIKIMDrQOgoCebvQOTA5Hsib03EXXnX2td1uwFL1SIrRhtTknxAgpN7B0gJvPsp6bu9QogpZcIU2UpwQyo9mFAapp6pHBheLkc0ArHV6DS7p5lgqzEbIIgU68QILutraAjh2evR24kkCdncNDe4RUSPPC0gcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtUkzHul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtUkzHul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3770C4CEC3;
	Mon, 14 Oct 2024 15:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919578;
	bh=LrPgmohVnmw1SW74W7lWJhNJtX2iY70lmrfCGZGIcEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtUkzHulCAYTmQkgiTywdNYeskWP377QrtTetq1rjF/jv/DCAoBj8r7CbpLSwVvas
	 tk/4AC/J8MbxTgzjUDeGo70lBe3dnUNbm+SQbZXx71LHCvVdP06eRtF6HkNTr1RRqp
	 vVunph2ILcbZPpxv76YJtc7cUZnbmn8Dz1e+S0C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Virag <virag.david003@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 647/798] clk: samsung: exynos7885: Update CLKS_NR_FSYS after bindings fix
Date: Mon, 14 Oct 2024 16:20:01 +0200
Message-ID: <20241014141243.470823315@linuxfoundation.org>
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

[ Upstream commit 217a5f23c290c349ceaa37a6f2c014ad4c2d5759 ]

Update CLKS_NR_FSYS to the proper value after a fix in DT bindings.
This should always be the last clock in a CMU + 1.

Fixes: cd268e309c29 ("dt-bindings: clock: Add bindings for Exynos7885 CMU_FSYS")
Cc: stable@vger.kernel.org
Signed-off-by: David Virag <virag.david003@gmail.com>
Link: https://lore.kernel.org/r/20240806121157.479212-5-virag.david003@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos7885.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos7885.c b/drivers/clk/samsung/clk-exynos7885.c
index 5d58879606eef..0f71fa6e8878b 100644
--- a/drivers/clk/samsung/clk-exynos7885.c
+++ b/drivers/clk/samsung/clk-exynos7885.c
@@ -21,7 +21,7 @@
 #define CLKS_NR_TOP			(CLK_GOUT_FSYS_USB30DRD + 1)
 #define CLKS_NR_CORE			(CLK_GOUT_TREX_P_CORE_PCLK_P_CORE + 1)
 #define CLKS_NR_PERI			(CLK_GOUT_WDT1_PCLK + 1)
-#define CLKS_NR_FSYS			(CLK_GOUT_MMC_SDIO_SDCLKIN + 1)
+#define CLKS_NR_FSYS			(CLK_MOUT_FSYS_USB30DRD_USER + 1)
 
 /* ---- CMU_TOP ------------------------------------------------------------- */
 
-- 
2.43.0



