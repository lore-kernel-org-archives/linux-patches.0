Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB5D6A354;
	Tue, 23 Jan 2024 02:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975367; cv=none; b=knR8y6Vv7nHAeh6VxUzZbGlDqger2WTBiCrj1lJVR1y3EGj6QP2OJ1f/SlVAzohlDHYINvsNvXC5/8FTM5KMXcx/NcrgxoAvsuM8XlquqrNRBlssu/cSA1i7N96tsaQAzCkm1M6WR/0M7t91vtw+BlAJjRkmrboJBz82pGMwjp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975367; c=relaxed/simple;
	bh=64GswMfigJA4jIDg1f2RqdDlY8iF3+Fxyb8QRlkF0FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GU5P4SteCb0N81GnEpZXn1SDDcTmhn94hSep3jj0CGWpQwhWmyFzPiFwqhxGp7xo1anZbK5aNg5se5VQEGB0302NNFOeK2rKqYoUwkl00w6LCYOv2+nLkxL6/WqmSk5pmLq2Hfz4xBZcGrHNab2lxfLQo3PY2KJniR6Ju35f0K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TE1ov0m7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TE1ov0m7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18863C433C7;
	Tue, 23 Jan 2024 02:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975367;
	bh=64GswMfigJA4jIDg1f2RqdDlY8iF3+Fxyb8QRlkF0FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TE1ov0m7Y97UXYqxflBeEUFibovBqn48bX/z1bUtATeRl4PjV3kgyUDxSAPI/JjC8
	 Tv3XvYQlMJOMyftQaQ03uox/lfq2yraZ4pQaJko8oXCttAj+Jq0pkBATtLvHZVzmRk
	 GhMReJWjSJpkw6u4MifqYJQZRyiV7mst/uomKLrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/583] clk: rs9: Fix DIF OEn bit placement on 9FGV0241
Date: Mon, 22 Jan 2024 15:55:55 -0800
Message-ID: <20240122235821.326082046@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 7d7b2cb75318..3b6ad2307a41 100644
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



