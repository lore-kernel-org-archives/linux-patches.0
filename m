Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E2864CEB;
	Tue, 23 Jan 2024 00:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971578; cv=none; b=heSh3qmL5+Q3mr5a+yOBu1oWZX8VDUaVjgU3dcnjadgN5tS7bjvediSjYxjIcIDkwUpVqeDiD1qbaJ7as2YxlEq3Wkr9bVnzHuAWhEvNfymq01KMsrntacZCu+aZD8QPpPVv+Kc9kaduTg76idYUYFe59SXTrNam4Yissttwpzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971578; c=relaxed/simple;
	bh=5H9ltRwB0R4ivQrsSRok9pl7q6I9V3V9JlLQgmknM7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SY9uSun9uZis63l3BKLcAWiBo8XYMr9f92j/Up1lHz04kN6ju29AuUFGUdnuFrC7V+qmVgHEeLe5jLnU3z11QJgR9JMTl0yK9h89AU+v/gyvPGRm8O1VGxPY19H0+xhmsqPqDr5YYc77j/Hbz3eMN1yF0EjZ8CAdAD5ew72Niho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0yF8OwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0yF8OwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42160C433C7;
	Tue, 23 Jan 2024 00:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971578;
	bh=5H9ltRwB0R4ivQrsSRok9pl7q6I9V3V9JlLQgmknM7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0yF8OwEPB5M6dxzhNpiM2im8mqS7fLm0wzOklKrwAIg4Iby6B2fRWk8ttINOruLa
	 6SHjsPFEZUo12fiCbi9gh1QRYJtOnne2IBMd95YP2Tui/Ze0lW+z3PDHWZY3SAa+Hi
	 PoQpw/CuyRJ3num5ktir2Y+m5hJnBfdPheYy9XB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
	Michal Simek <michal.simek@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/286] clk: zynqmp: Add a check for NULL pointer
Date: Mon, 22 Jan 2024 15:58:06 -0800
Message-ID: <20240122235739.085753757@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

[ Upstream commit 6ab9810cfe6c8f3d8b8750c827d7870abd3751b9 ]

Add a NULL pointer check as clk_hw_get_parent can return NULL.

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Link: https://lore.kernel.org/r/20220518055314.2486-1-shubhrajyoti.datta@xilinx.com
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 1fe15be1fb61 ("drivers: clk: zynqmp: update divider round rate logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/divider.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/zynqmp/divider.c b/drivers/clk/zynqmp/divider.c
index 57bf381f630d..acdd5e48e147 100644
--- a/drivers/clk/zynqmp/divider.c
+++ b/drivers/clk/zynqmp/divider.c
@@ -119,10 +119,13 @@ static void zynqmp_get_divider2_val(struct clk_hw *hw,
 	long error = LONG_MAX;
 	unsigned long div1_prate;
 	struct clk_hw *div1_parent_hw;
+	struct zynqmp_clk_divider *pdivider;
 	struct clk_hw *div2_parent_hw = clk_hw_get_parent(hw);
-	struct zynqmp_clk_divider *pdivider =
-				to_zynqmp_clk_divider(div2_parent_hw);
 
+	if (!div2_parent_hw)
+		return;
+
+	pdivider = to_zynqmp_clk_divider(div2_parent_hw);
 	if (!pdivider)
 		return;
 
-- 
2.43.0



