Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B5E2D6E58;
	Wed, 25 Feb 2026 06:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002667; cv=none; b=UnwB0NoxQJiPHmpEBE8llLUFHa9ecQWdhZ33RdX3AhKrfwWyUx5OmGKFRVcgMoSGop6DcR1qEM0yYWRsu0WJYeUIdp7/xr5j7hv22NMm+55x1/qWr97oLN/WaBj57hMnOF9bT/6gwKLBPNprkHuS253g2UHJ8bVmCMzipXnIcmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002667; c=relaxed/simple;
	bh=NhZ47EmxQFNzlb9dGpGNhrVsZIhR1cIGaVa20IeODS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kx/DlZIT5Mtb4XKJJlDtF6cC5OS0GHlsTXpR6lrQuUar3hb0mN7FuQLOVXHFb8mF86HLgA6s22vq2xGOakEhT8lPmpFOhy88Iazk+qcT67x2X0mj9FHqDsG2BTz1zrNcnujTRhp341iRKbcmGiaOlOsnVIdPzTzAMT++mD7HRig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEcy6AkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEcy6AkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA1BC116D0;
	Wed, 25 Feb 2026 06:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002667;
	bh=NhZ47EmxQFNzlb9dGpGNhrVsZIhR1cIGaVa20IeODS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEcy6AkYTk2EjLZeiGfi4og7+IX/AoJ1KcofaUyoUw1TE9eD4T8PID2GLgD+crWbr
	 87rB2gORFL59+oUBJfnb4vOJx6XTRYasTFifNYczRqQ/0M0F0Xq7IQL7l/XZOC5wLv
	 d92CqmObiQ6bt4CdVQhsy3aS5MwJRTEB5lPoPIOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 448/641] clk: zynqmp: divider: Fix zynqmp_clk_divider_determine_rate kerneldoc
Date: Tue, 24 Feb 2026 17:22:54 -0800
Message-ID: <20260225012359.376236365@linuxfoundation.org>
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



