Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071C0192B8E;
	Tue, 10 Sep 2024 10:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962776; cv=none; b=BpfkQ+dNTCAdEhTvJkQiPocn9PVdHd6zBuT8OXX9QxIDExIhE5p/mmjWp3I8Wd2r3XYnAjLKPMWwsHjO/6BxusW37T0nBBTOs7QtKV56BA1dHmAQUOkDY8Ko/r2qf9OxVoVA8sJb5qiyqOXobrf2Fb8UnwL3D0F8ZYKhK0sJJCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962776; c=relaxed/simple;
	bh=jiFqoLeuo+ejxXNFplrP9QjFn7tWgVaZvahD2MygNcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcnkXNFEhLq0SXh182/E1Lzq/bnppv0pIl1kZPnBPMIuOOUH8Br5B/rMcWRDrL8iV8rGXiNFFAvg3kEZze2RRzRu171Dg3f/0yQp1++0t4w888RUbHUbC4QcUqkfMpWm0vJIpdIcKj6aH4ia/WZETKcRPyjOaCDpMyx7f9bG1AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2YImq/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2YImq/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8134DC4CEC3;
	Tue, 10 Sep 2024 10:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962775;
	bh=jiFqoLeuo+ejxXNFplrP9QjFn7tWgVaZvahD2MygNcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2YImq/XfILKxBPRnsuUhJzVshU7GeLNuRLuknWfWq2tqnouiXnqQ4Q1xS3ezoq9h
	 1nqGVMIbmWMmxLSOJStBGsRRP/v5yEKFTeHTIYk1jgEu0mgNbY74P3MWaGIyS6j4rl
	 O2D2gG0/zMREEBMSvK/tuciR/nk43qgQox8QVrqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 026/192] clk: qcom: clk-alpha-pll: Fix the pll post div mask
Date: Tue, 10 Sep 2024 11:30:50 +0200
Message-ID: <20240910092559.037096326@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
@@ -40,7 +40,7 @@
 
 #define PLL_USER_CTL(p)		((p)->offset + (p)->regs[PLL_OFF_USER_CTL])
 # define PLL_POST_DIV_SHIFT	8
-# define PLL_POST_DIV_MASK(p)	GENMASK((p)->width, 0)
+# define PLL_POST_DIV_MASK(p)	GENMASK((p)->width - 1, 0)
 # define PLL_ALPHA_EN		BIT(24)
 # define PLL_ALPHA_MODE		BIT(25)
 # define PLL_VCO_SHIFT		20


