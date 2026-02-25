Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7013E2550D7;
	Wed, 25 Feb 2026 01:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983441; cv=none; b=C703ALWaNRGh5VErJDTMXQpWRddzv/VxwTtZW4ByMov9Mpy/CFwvbakdgKzmu+r3NVWGmWwLUUNLU67lY1wzDEBZNBaqygRVM8YxDbxCyoFDcehFlVAm4O1eQUnTtJUo63TKMhb7hWoZp7pIyB0momJeYu2gOIKiya5TayXxve8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983441; c=relaxed/simple;
	bh=zwClWheAgyHHs0TN7gIJQa/QUTyYbnjGBBvW04jSX+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtmlSaxyvhRGTb5EGf8+mGO5xezVwKXSc7/DmjDwMIT1/29DGbku5x7zKj0JrwSjp1shMZR9EFErhzu3cGOYdrl8dCcWeySMwXO8vcV2IB9zn0wGwPyj+pKUrkSfeFIrv9VgTfEonN7CCTVBMyF4ix0k1dXGr4S7qoQoQiElUD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJmgzfc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJmgzfc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEF0C19423;
	Wed, 25 Feb 2026 01:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983441;
	bh=zwClWheAgyHHs0TN7gIJQa/QUTyYbnjGBBvW04jSX+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJmgzfc4wjoS4DHc8sEbuuNu94wGPvX3sz6JfqFfozORoRVTBVlECH1dJFTuyxiIX
	 AJ6we+jpQJsCoy7iqEMmeinVii3lG1ljHYPBH5Dmb0iK3LXz3JCskqCwbKbI7MbsfJ
	 aQR5lJjTi/pmkl6N8WaMRafh57d2sZs/u8lcMpyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 558/781] clk: zynqmp: pll: Fix zynqmp_clk_divider_determine_rate kerneldoc
Date: Tue, 24 Feb 2026 17:21:07 -0800
Message-ID: <20260225012413.489156455@linuxfoundation.org>
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



