Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93D8172BA8;
	Tue, 10 Sep 2024 10:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964079; cv=none; b=CszCPK54EGhdhGLfsJUriW6bny8IMxscidOr3d/DmoN0zAzq9cxUt8MdKjt95K/5QhQ2H54oeJOHv4JLqMFFSTM5GMEDJRzbbinrjr61wdVQSrPAj/ELgl1uGKcv6Za+e/OwZ5chKey6K64d3mamcAESV5Rvqqvy8W7ELf9ZGg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964079; c=relaxed/simple;
	bh=nTyZiDoLgNTF1Wu2D+UjsHL1/M762X+caBhSCXAvUyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6dcimKCCGhyDPYaZXcDxQ5GO2is8kWsHOpTIunnHpNoJikzbFUehaLJYd2ZhX5fTetpR8GfX7Am9r72kE+fV93PzkkL3Vw0vUrhXAgCdxtuO5aCyoNrOAjwYCRFyWfr9RMT7n1UG+9wSnNM+pQ5reuEkfvspELpj2wOGqVWEeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NeqLzQa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NeqLzQa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEB2C4CEC3;
	Tue, 10 Sep 2024 10:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964079;
	bh=nTyZiDoLgNTF1Wu2D+UjsHL1/M762X+caBhSCXAvUyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NeqLzQa2LAhnf2OcIrNyHE7dBETKLXms111fme/mP8vBKQBOLSObKQRcDpCsfvely
	 u6wbPta/e08Sh5YxzBIP8WPZCXLaYOoWtUJBtPcpX+VMLPwXJAjDgMB4/K2lQ+jpth
	 qeV3yuJkJTNhqquS7WuDEibmaRUFPjE5MSri9jTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 034/269] clk: qcom: clk-alpha-pll: Fix the trion pll postdiv set rate API
Date: Tue, 10 Sep 2024 11:30:21 +0200
Message-ID: <20240910092609.459716845@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

commit 4ad1ed6ef27cab94888bb3c740c14042d5c0dff2 upstream.

Correct the pll postdiv shift used in clk_trion_pll_postdiv_set_rate
API. The shift value is not same for different types of plls and
should be taken from the pll's .post_div_shift member.

Fixes: 548a909597d5 ("clk: qcom: clk-alpha-pll: Add support for Trion PLLs")
Cc: stable@vger.kernel.org
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240731062916.2680823-3-quic_skakitap@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-alpha-pll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1478,8 +1478,8 @@ clk_trion_pll_postdiv_set_rate(struct cl
 	}
 
 	return regmap_update_bits(regmap, PLL_USER_CTL(pll),
-				  PLL_POST_DIV_MASK(pll) << PLL_POST_DIV_SHIFT,
-				  val << PLL_POST_DIV_SHIFT);
+				  PLL_POST_DIV_MASK(pll) << pll->post_div_shift,
+				  val << pll->post_div_shift);
 }
 
 const struct clk_ops clk_alpha_pll_postdiv_trion_ops = {


