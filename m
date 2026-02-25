Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8443B2D94AF;
	Wed, 25 Feb 2026 06:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002668; cv=none; b=gGGRtQuyZZ9u80H+Wpu6qoRMPxydsDabK5ENRcipWX5Y5zuChyrnMWE+eT4ffz0BZByUWjlMvr7aZinXEi0IzaWLeMn4uZyxj0bex6R0uc+Noaa3x98+mnRKjsTapw7yjD0AQlvOzvmbeyV5fF4icUKXohXrZ1et61XaS8YNGs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002668; c=relaxed/simple;
	bh=30oi680SREIfV+iATQ6j34+LB54Wn0hDXAdqIsh7bv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvC9L+mzqDTno8ed9JYI9wrqJ2chV/VIjf7Ew5ZrSkAOxxbwvSVkiMfplMRj+sdaIDGVoWBZeRh5xc96MWXPR+y3W2d2Mps/6qJND74nxqFmY3IwqsDbiRdPb9Olqh+X5J52dMiZVnP8i9Cr2orW5BQo9Cr+G+94zqlFg6255a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pehturtn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pehturtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FC3C116D0;
	Wed, 25 Feb 2026 06:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002668;
	bh=30oi680SREIfV+iATQ6j34+LB54Wn0hDXAdqIsh7bv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PehturtnKhunM3ed3xsSL4a0yhmT0gi6QSETdZ4jC2vcGh/CDcmn00VBtngzK5+yR
	 RNzaD1YEAGR+c+xGoueZt6D5ppq4GVoZ5pMz+/fZsW2XV5P0hSsNbA63Hax61cxyw7
	 dMBNrfkpQQbvtR5sEltgxnLQCYtOkM3cGCJ+lBc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 449/641] clk: zynqmp: pll: Fix zynqmp_clk_divider_determine_rate kerneldoc
Date: Tue, 24 Feb 2026 17:22:55 -0800
Message-ID: <20260225012359.400718545@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 750e0e0a1652530618d2c07697618e705bc5061b ]

After renaming round_rate->determine, kerneldoc does not match anymore,
causing W=1 warnings:

  pll.c:102 function parameter 'req' not described in 'zynqmp_pll_determine_rate'
  pll.c:102 expecting prototype for zynqmp_pll_round_rate(). Prototype was for zynqmp_pll_determine_rate() instead

Fixes: 193650c7a873 ("clk: zynqmp: pll: convert from round_rate() to determine_rate()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/pll.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/zynqmp/pll.c b/drivers/clk/zynqmp/pll.c
index 630a3936c97c3..6bc2c3934f564 100644
--- a/drivers/clk/zynqmp/pll.c
+++ b/drivers/clk/zynqmp/pll.c
@@ -91,10 +91,9 @@ static inline void zynqmp_pll_set_mode(struct clk_hw *hw, bool on)
 }
 
 /**
- * zynqmp_pll_round_rate() - Round a clock frequency
+ * zynqmp_pll_determine_rate() - Round a clock frequency
  * @hw:		Handle between common and hardware-specific interfaces
- * @rate:	Desired clock frequency
- * @prate:	Clock frequency of parent clock
+ * @req:	Desired clock frequency
  *
  * Return: Frequency closest to @rate the hardware can generate
  */
-- 
2.51.0



