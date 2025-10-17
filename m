Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECEA32E15B;
	Fri, 17 Oct 2025 15:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715489; cv=none; b=T5uNJbSq7hdoFk7rf7dy21F2+K5Lb0LWTOSbtPQVJ42ShLkb4fefOrodNq0ymYZE3iRE+5X49iDkSIyvA1Rd6iqgD2laERwnP/glQfS3Pt15XpW4vvC1IVo1Oo3VQvsgQjZdJtPV3spe1q4vs3nmmtLKQbiRJXhgezcWci54yME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715489; c=relaxed/simple;
	bh=CaHmt0sFuqMZr7i/OJopMnTLBUybfCs9/7ngqqUoiSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYso3A4C9WD81JNJGBcbtWmW+seGWNGWxaKGpurjIh2g/8gv4JJVcpyFKQPF7BeCAZXx2K1UQkhpkBWfurCYDYUGYvHsMA4qLRBbrktOujzX5TCU7B+22CCAtpggOoDUfLJ2mnLfTd9tqFxjRBfo3XG6jLKwF/YisIm+mXk5LIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFcAkpqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFcAkpqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEE5C116B1;
	Fri, 17 Oct 2025 15:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715487;
	bh=CaHmt0sFuqMZr7i/OJopMnTLBUybfCs9/7ngqqUoiSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFcAkpqXRGBOeBq92AR1NE90GSV2+tCplqbKg8GXbYUXpfU+gmSBd7Jfgc4DvqsMb
	 QO2a8F3yvZDhpqOyI5UlILkenQLlLsa+QCKJPDrFTft1X1DLewKxMO3Wpf02SJ53+A
	 9ueL43xMwNI13yQswodETz/pkCwj34MK2qr5d00k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.17 200/371] clk: qcom: tcsrcc-x1e80100: Set the bi_tcxo as parent to eDP refclk
Date: Fri, 17 Oct 2025 16:52:55 +0200
Message-ID: <20251017145209.161304421@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit 57c8e9da3dfe606b918d8f193837ebf2213a9545 upstream.

All the other ref clocks provided by this driver have the bi_tcxo
as parent. The eDP refclk is the only one without a parent, leading
to reporting its rate as 0. So set its parent to bi_tcxo, just like
the rest of the refclks.

Cc: stable@vger.kernel.org # v6.9
Fixes: 06aff116199c ("clk: qcom: Add TCSR clock driver for x1e80100")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250730-clk-qcom-tcsrcc-x1e80100-parent-edp-refclk-v1-1-7a36ef06e045@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/tcsrcc-x1e80100.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/clk/qcom/tcsrcc-x1e80100.c
+++ b/drivers/clk/qcom/tcsrcc-x1e80100.c
@@ -29,6 +29,10 @@ static struct clk_branch tcsr_edp_clkref
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_edp_clkref_en",
+			.parent_data = &(const struct clk_parent_data){
+				.index = DT_BI_TCXO_PAD,
+			},
+			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},


