Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5E32676C9;
	Tue,  8 Apr 2025 11:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111358; cv=none; b=jrg8412qpEo0pGK4/0CtaOv0Qcn55RQET6ToSR9XjDS5bZe9hdnUlvN4ZgpmHM8XnSsWjWO2+l7L37ttzWPExyyi3eOI0V0telB2Wgvx0v1VomNGGDmQ4xdhHzm7hUWnMn4lQE7/rQWDaWMl/SlrczEtrhDlNFMZFK89aV5azF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111358; c=relaxed/simple;
	bh=A9/dyeXlHRbukas4ntsf+Ob89LguIHona2qs9j8sssU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzUwFvhAanGUsNwuOmK0O4DeStn/pQq7wlCzKCjVcLNq0DBb+9DG4eTrPvaE56gkqUMJmpvJwTh7nAa7s7pYPWB5UGUQ7VFJSlcjgwd2eHphyFdRDKE221KmBgWxxkItLwwol8sdMPxLfLVkFIxqD0bWdyTttP6pxdr5P+ozB+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDJ8vYOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDJ8vYOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEF6C4CEE5;
	Tue,  8 Apr 2025 11:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111358;
	bh=A9/dyeXlHRbukas4ntsf+Ob89LguIHona2qs9j8sssU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nDJ8vYOQpFHz58kjkJqW5pg9KQX0I/XC/a160yZVsRqb+BOEoSDb+t37YHLut5B45
	 2R+YkJn6m5XLwDgFXjSmsLUEsNIIHE4ruUnKN4CNYNgMSg/KTbvKarFQSqRHALMpYr
	 YrFeeqCwCjA8iFQHrLws7BIL18YE3gLk31t/PT7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 403/731] clk: amlogic: gxbb: drop non existing 32k clock parent
Date: Tue,  8 Apr 2025 12:45:00 +0200
Message-ID: <20250408104923.648276113@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 7915d7d5407c026fa9343befb4d3343f7a345f97 ]

The 32k clock reference a parent 'cts_slow_oscin' with a fixme note saying
that this clock should be provided by AO controller.

The HW probably has this clock but it does not exist at the moment in
any controller implementation. Furthermore, referencing clock by the global
name should be avoided whenever possible.

There is no reason to keep this hack around, at least for now.

Fixes: 14c735c8e308 ("clk: meson-gxbb: Add EE 32K Clock for CEC")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241220-amlogic-clk-gxbb-32k-fixes-v1-2-baca56ecf2db@baylibre.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/gxbb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/meson/gxbb.c b/drivers/clk/meson/gxbb.c
index df9250de51dc8..3abb44a2532b9 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -1266,14 +1266,13 @@ static struct clk_regmap gxbb_cts_i958 = {
 	},
 };
 
+/*
+ * This table skips a clock named 'cts_slow_oscin' in the documentation
+ * This clock does not exist yet in this controller or the AO one
+ */
+static u32 gxbb_32k_clk_parents_val_table[] = { 0, 2, 3 };
 static const struct clk_parent_data gxbb_32k_clk_parent_data[] = {
 	{ .fw_name = "xtal", },
-	/*
-	 * FIXME: This clock is provided by the ao clock controller but the
-	 * clock is not yet part of the binding of this controller, so string
-	 * name must be use to set this parent.
-	 */
-	{ .name = "cts_slow_oscin", .index = -1 },
 	{ .hw = &gxbb_fclk_div3.hw },
 	{ .hw = &gxbb_fclk_div5.hw },
 };
@@ -1283,6 +1282,7 @@ static struct clk_regmap gxbb_32k_clk_sel = {
 		.offset = HHI_32K_CLK_CNTL,
 		.mask = 0x3,
 		.shift = 16,
+		.table = gxbb_32k_clk_parents_val_table,
 		},
 	.hw.init = &(struct clk_init_data){
 		.name = "32k_clk_sel",
-- 
2.39.5



