Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD6A4C81;
	Tue, 23 Jan 2024 00:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969598; cv=none; b=PA5SKrfd9cYv7CMwJXImpqIOyRClM3L4lQZgqR95Ry8tEgPuVfEanoSD4Z37n0xiX+X/0Ww+GIXgDpJDKGR1svWs5ldX3ZG97myHLtm5FJ/pQZIZ7VSiSdDqDI5h5Dn1t7PWrTP0M4FtJTRzPqkhb/d4gRNS6jQZ3adTqFHtCTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969598; c=relaxed/simple;
	bh=bJdoElVps5ymh12YNXNenhQqFnUXgh0WuWKtSQrDnXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwNes+/P7YlrzSBEmkNnQYBLWoekzHU9M5v2r/S1NJvVOVJihjWIJb442rH6SYb4gzfMbHfZMAPYs6kVvIrP7XRWTq6ExiUNJc/QRQc2WSneRFWhJZsW6a1kuuErbh/z2XeWBiGkvjzH3rHx3pkz8hIwRY6uA7gHbILj3m63lnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j29SXRxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j29SXRxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F000C433F1;
	Tue, 23 Jan 2024 00:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969598;
	bh=bJdoElVps5ymh12YNXNenhQqFnUXgh0WuWKtSQrDnXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j29SXRxfp8fh8j/QwkvJkY4iiAqKZh7pcHNQhnOJP76DWmv+7YAOKoDGT+ofQCVW0
	 /opSHgongWcOWZzmq2IrSjzHjN5bxA1dfy5Ut4tZ8v1TLCwx/6MwYViyx7lv9Rr2yd
	 L05Q4NdQGgvhAU/WHQvKiqVOTZOR06lBOnZCvIsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 341/641] clk: rs9: Fix DIF OEn bit placement on 9FGV0241
Date: Mon, 22 Jan 2024 15:54:05 -0800
Message-ID: <20240122235828.586150394@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 29d861b5d29b6c80a887e93ad982cbbf4af2a06b ]

On 9FGV0241, the DIF OE0 is BIT(1) and DIF OE1 is BIT(2), on the other
chips like 9FGV0441 and 9FGV0841 DIF OE0 is BIT(0) and so on. Increment
the index in BIT() macro instead of the result of BIT() macro to shift
the bit correctly on 9FGV0241.

Fixes: 603df193ec51 ("clk: rs9: Support device specific dif bit calculation")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Link: https://lore.kernel.org/r/20231105200642.62792-1-marek.vasut+renesas@mailbox.org
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-renesas-pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-renesas-pcie.c b/drivers/clk/clk-renesas-pcie.c
index 380245f635d6..6606aba253c5 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -163,7 +163,7 @@ static u8 rs9_calc_dif(const struct rs9_driver_data *rs9, int idx)
 	enum rs9_model model = rs9->chip_info->model;
 
 	if (model == RENESAS_9FGV0241)
-		return BIT(idx) + 1;
+		return BIT(idx + 1);
 	else if (model == RENESAS_9FGV0441)
 		return BIT(idx);
 
-- 
2.43.0



