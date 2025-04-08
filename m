Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07479224AEB;
	Tue,  8 Apr 2025 12:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115723; cv=none; b=PwSukN+Wrrfddhr2d6TY6NO9YcQvFA7ceTQ8imqO5MX19q3OiZ9ueXRQXC8cBjNXwtlGWXqQF+rBmTyDKNSOHdciTwuu3Ysp36Wuzdg4AlSNWENLE4cgJnL3ihGVoIJn/7T0DFvUZDC8bF23VJITTWen4ak4QxLBQp1GFlT9vPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115723; c=relaxed/simple;
	bh=ofsXOf4SEkCm/g7hAEtQ1v++73qr8OVeS8dxj5iH3ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdax1tfy5gpkU4HSW/6Koz8/S9WdGygWSt0wdiHp/kA2x03Jkk4fxLIwTAkTwlmaZNCgte7JXV0qhu6c4mkTsEY5A419WpiKj4kV39RxI5u+34aFpNjEYV36r6ty+ksRvegx1yqR42nj8acWU+I2nI1uL3ReVfMmPE1GE6+aVqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2ZHFweQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2ZHFweQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8C7C4CEE5;
	Tue,  8 Apr 2025 12:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115722;
	bh=ofsXOf4SEkCm/g7hAEtQ1v++73qr8OVeS8dxj5iH3ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2ZHFweQIWkicC7LNdiErveHE96gxN3AIHNWOYzQ7vLqaAxvafTtlTm/hQHKtCW6z
	 +fna7Im2I8CMRh89ttYVxp0W1FVwn8i6pkRbarJqnrIHHvzlqxQDWLze9V7+ygjy4P
	 9CFppDfB+KMkNzxLxIh1kgjEUvWkxf/l8LS1Afn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/204] clk: amlogic: gxbb: drop non existing 32k clock parent
Date: Tue,  8 Apr 2025 12:50:03 +0200
Message-ID: <20250408104822.500643091@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 48c47503ea752..35bc13e73c0dd 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -1270,14 +1270,13 @@ static struct clk_regmap gxbb_cts_i958 = {
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
@@ -1287,6 +1286,7 @@ static struct clk_regmap gxbb_32k_clk_sel = {
 		.offset = HHI_32K_CLK_CNTL,
 		.mask = 0x3,
 		.shift = 16,
+		.table = gxbb_32k_clk_parents_val_table,
 		},
 	.hw.init = &(struct clk_init_data){
 		.name = "32k_clk_sel",
-- 
2.39.5



