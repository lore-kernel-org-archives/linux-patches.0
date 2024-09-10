Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42978190056;
	Tue, 10 Sep 2024 10:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964975; cv=none; b=QRr0JHV+DDAdBCnrNh+7xBaMQcCunfiwMIGZC1ugP6/Mc2v3phdysnvXuU3kQRzhzkaZl131uK3gEMX0mPsSvskXoWGqxzXcqr6XNcZDI2lardpGxEkky7bajQs1Afrp2RXPOC8/l/ythK4mosN56qtk6Q/a323GGzW1wHWOn6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964975; c=relaxed/simple;
	bh=bvHJhM4Uo+v6b0R695grgetmIQ8bjbkR4XgxXY9T6Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClDeSZ5tyzxpTRl84aFPAk8xOPuE0JafiBD7ZZrgDn+TiGNZpb0zqtv8kKbgNIWWJHyUbzsWeCbnGp1xDFsgBcegExlVopj01NwcYR6tEjlzCf3cCt3wQ5/UOSM8Fng3n2t48HzJvvht+zNcwRzlvxxoUFEB5wevvfYEi+4ulGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyrTmcl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyrTmcl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD14C4CEC3;
	Tue, 10 Sep 2024 10:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964975;
	bh=bvHJhM4Uo+v6b0R695grgetmIQ8bjbkR4XgxXY9T6Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyrTmcl85QB8+p1s6ksOD5+tnNSLKNdtlWzG6otYIVzb2l71mfetHAvX+O8l33zdO
	 y/nxXg8CzaDnwqC8oVAL6ppQDrM/ZWET6Y32S7VWxl8jaZ8NNR4fbpJY7yOxC3Tkfc
	 U2CS4iSj6yaboEsn+GWZyOwCadgclASP4Z+uRbtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 068/186] clk: qcom: clk-alpha-pll: Fix the trion pll postdiv set rate API
Date: Tue, 10 Sep 2024 11:32:43 +0200
Message-ID: <20240910092557.314570475@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1321,8 +1321,8 @@ clk_trion_pll_postdiv_set_rate(struct cl
 	}
 
 	return regmap_update_bits(regmap, PLL_USER_CTL(pll),
-				  PLL_POST_DIV_MASK(pll) << PLL_POST_DIV_SHIFT,
-				  val << PLL_POST_DIV_SHIFT);
+				  PLL_POST_DIV_MASK(pll) << pll->post_div_shift,
+				  val << pll->post_div_shift);
 }
 
 const struct clk_ops clk_alpha_pll_postdiv_trion_ops = {


