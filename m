Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FA21D5141;
	Wed, 25 Feb 2026 01:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983440; cv=none; b=nMd3hdRvf/xb3zb045Q5Ft6wy/dwE9vaIRLaZI4m/DklEXCy51dAt0ojE6AJfOHDfndvNjlugCIBuxtpux7KOrTqwYtucmovsJboS5PhW+T4aCQdtp8TdZuic6E93MSqTOlmZ3zA3UDyQ5h9VXgMh4f6NSFm2LnFDbhFS+hXYdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983440; c=relaxed/simple;
	bh=BiOIsbBnJNRRQb0qYIdy7HRElOBc8d4a73np8okxN7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0IDPRdt8pTM2d6Ql8AXmQ+qxebYP2lWgnx+X5yFjuCrp1UauO7M/SXvudHKGFz9BczkmhfPkX+KhqqYFIOQQfcD8ZJwCKDoHskLgoNt4FfqyMHzHUyhFOXSNI5xJ2SZWpyyhDP1JkZ67EtTJuEtit2me1dxsU9AsXnCRN+B7vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9hMab2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9hMab2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1799DC116D0;
	Wed, 25 Feb 2026 01:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983440;
	bh=BiOIsbBnJNRRQb0qYIdy7HRElOBc8d4a73np8okxN7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9hMab2no8pgiIvm1XXtVKTvV7ojez4aPnXgeeA8zged/3YeOeeMbMEqHOsNIx9u8
	 LTQDXpRlirUgyIkp4gkPzxEmYrEABps1a47lnEklYAz6Yq2O1H1YvOWQgWDSBRd8et
	 ZTLl4npQ8C74du+ZX9xefSwf2Ue4JdHatGZDP6b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 557/781] clk: zynqmp: divider: Fix zynqmp_clk_divider_determine_rate kerneldoc
Date: Tue, 24 Feb 2026 17:21:06 -0800
Message-ID: <20260225012413.464910548@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 1b8773864904c7a25e45f1b12ab505bdb7e06568 ]

After renaming round_rate->determine, kerneldoc does not match anymore,
causing W=1 warnings:

  Warning: drivers/clk/zynqmp/divider.c:122 function parameter 'req' not described in 'zynqmp_clk_divider_determine_rate'
  Warning: drivers/clk/zynqmp/divider.c:122 expecting prototype for zynqmp_clk_divider_round_rate(). Prototype was for zynqmp_clk_divider_determine_rate() instead

Fixes: 0f9cf96a01fd ("clk: zynqmp: divider: convert from round_rate() to determine_rate()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/divider.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/zynqmp/divider.c b/drivers/clk/zynqmp/divider.c
index de6f478d527d8..984e577ea6711 100644
--- a/drivers/clk/zynqmp/divider.c
+++ b/drivers/clk/zynqmp/divider.c
@@ -111,10 +111,9 @@ static unsigned long zynqmp_clk_divider_recalc_rate(struct clk_hw *hw,
 }
 
 /**
- * zynqmp_clk_divider_round_rate() - Round rate of divider clock
+ * zynqmp_clk_divider_determine_rate() - Determine rate of divider clock
  * @hw:			handle between common and hardware-specific interfaces
- * @rate:		rate of clock to be set
- * @prate:		rate of parent clock
+ * @req:		rate of clock to be set
  *
  * Return: 0 on success else error+reason
  */
-- 
2.51.0



