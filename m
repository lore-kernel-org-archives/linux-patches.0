Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304D446444;
	Tue, 10 Sep 2024 09:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961013; cv=none; b=YvBM+GQgMEXHk/bhmSNgtuOvrF+wHbNElYyhSaPCmIP/mufzXGI5T7CI7OZ2lu88QNPVbpCHS4SCRDSuQqiGEik8KGeVuS74Kh272zAk0C0GU/jQ0DCjzBdKrounWJA/KKTYOzhJKM6k2AmycO7y1XLoisOkrxoU+ZBrSwvl2+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961013; c=relaxed/simple;
	bh=ZJxPS8uXUNyUGM+7JHWp98vh7kSfExq+Jn2D7Wpbcew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbLd/2KWfymtqcRR4t4tTlPfft4lQQMqciC1QsILI6tayJpZPFabq/QHhphRkZMfFVrK52aOTRH1U88rDcyAw9tDHoCk88Bg3V6fWbP16kPPDdZ3ofP50xa9Qu0sw2g5zf84ZkLzTL7Siv0pqywiLwNzGyAbbG3Q34UI1ZiOQdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzThSGea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzThSGea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B0EC4CEC3;
	Tue, 10 Sep 2024 09:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961013;
	bh=ZJxPS8uXUNyUGM+7JHWp98vh7kSfExq+Jn2D7Wpbcew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzThSGea+GBngiJ5QOKzCEjYna274X3fF0wjv1x5vOV0q8Q0Dr0EVDek38x2OIVOv
	 64Ep2PC8Bo0NHJCqUOftABIs3lWakIxe9/z9DigVygpxJU2YGZny3kSiV96GO0YE+u
	 ebENzzcS7eMy0ZQ7a78LfLNOwaLy0kLFxl0VdIuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 4.19 23/96] clk: qcom: clk-alpha-pll: Fix the pll post div mask
Date: Tue, 10 Sep 2024 11:31:25 +0200
Message-ID: <20240910092542.464818810@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

commit 2c4553e6c485a96b5d86989eb9654bf20e51e6dd upstream.

The PLL_POST_DIV_MASK should be 0 to (width - 1) bits. Fix it.

Fixes: 1c3541145cbf ("clk: qcom: support for 2 bit PLL post divider")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Link: https://lore.kernel.org/r/20240731062916.2680823-2-quic_skakitap@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-alpha-pll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -37,7 +37,7 @@
 
 #define PLL_USER_CTL(p)		((p)->offset + (p)->regs[PLL_OFF_USER_CTL])
 # define PLL_POST_DIV_SHIFT	8
-# define PLL_POST_DIV_MASK(p)	GENMASK((p)->width, 0)
+# define PLL_POST_DIV_MASK(p)	GENMASK((p)->width - 1, 0)
 # define PLL_ALPHA_EN		BIT(24)
 # define PLL_ALPHA_MODE		BIT(25)
 # define PLL_VCO_SHIFT		20


