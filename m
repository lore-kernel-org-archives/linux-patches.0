Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773921DFD1;
	Tue,  8 Oct 2024 13:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392579; cv=none; b=C5CwzIatpJuOyXLnw6IR1sAE5Bu9QRd2QJfuPDGwm8tJrlIeXYd2100qR/ybiL2JNOQlvRDLoXPTIh593kqIKg52MrVEzgaonaL4QxUWA+oIGVWuTK2iQ1iKMIeloW3iBoNwXf/PZmI3HCYgsqjv+G6nEqyfkWzjihHfcGsXISQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392579; c=relaxed/simple;
	bh=OdXGhK5ElceWSAFOZb04xbqAHTwNNvsJKb6dDVns1zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TysZMklFFMacr+yQIQOqo9G+qikk4sYEwl7x1xyswafLJO9SZvJCWL/Afea4br61pywkj6I1x9hjiC2lqU7KxMGsPiT7ZTonLfzssy4IxBtt7yci0W/QcT2jnpReUVq3AK6+hEz+M/d1c6vjjK9KyUYRTlmJvPbDG219LjHpgWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nroQNocu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nroQNocu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD96C4CEC7;
	Tue,  8 Oct 2024 13:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392579;
	bh=OdXGhK5ElceWSAFOZb04xbqAHTwNNvsJKb6dDVns1zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nroQNocu0WjTYT8VzgX+H+UAReaPXKALMQYOQx/HxzIVaa4YYHkGKpp79HxnpvSKI
	 gQ4LX1W/XVrRy9Q+euK0zERqkSGkKhM+KzaoOM4jlQu8mR1OU8wx2B+jKIGiQz4mJ4
	 wRRRFn6fCrg97+8dLR5dcBD2MWnp4vOuSmT47MAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Virag <virag.david003@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.11 458/558] clk: samsung: exynos7885: Update CLKS_NR_FSYS after bindings fix
Date: Tue,  8 Oct 2024 14:08:08 +0200
Message-ID: <20241008115720.280275152@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 


