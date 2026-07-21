Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAD03E121A;
	Tue, 21 Jul 2026 22:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673804; cv=none; b=PHpbUSGbNriYbPwz/LlLVJkSDCenlIXDLMgzPY8hxIhdkokFKIctqDWweJrnRLdJRFBGki76B2iFTIeJt6NoqE4q0sBkERLREuTO9Okh8jXP8bBl9JeWogKa0uL6FdnIoFt74R3Vq25HjCULwawigEfoeYA5uEDasF+OENlxp58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673804; c=relaxed/simple;
	bh=1hQukLY1qZFmW+JCWX+I1h+JFblVONGzfPinUu73Owc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVYH/Qmyqg3C7XbC+q2kHEPwTl3/PdbxElB3g9+qaM7pZ6kFuOtdXS0kqldDrlinSe3yQYmXzp7CDiPKeD9PCFhtQJYhSMCRYrqxCnJx8rxcye/bOSjS9x36ukizMlGkOa4cuRIjAhTW9douIVTbqMk51LvKZQhrqVJlUAYFU/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSaU3woD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSaU3woD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C02A1F00A3A;
	Tue, 21 Jul 2026 22:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673803;
	bh=JYFB6UTsKDF2yI35PNrLiTCIrppEasXc3DEmQmBfnJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSaU3woDdMB+nY1iMayNKjySJoKGZ9hgh0CyMdZ8ilcCCbZmUZFL4ClZ+zsRMryiO
	 YzAYd9OycdbYGa4pLB5X4q4cNgA18Fh/UjFmBPPh0hrT4S+8GMz4NgWgEQdcl9CdJx
	 ynW9pU6g6uIrEr1RCQ5SdgAokghEyuCIAr2NbwkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Varney <pbvarney@protonmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/699] clk: qcom: a53: Corrected frequency multiplier for 1152MHz
Date: Tue, 21 Jul 2026 17:20:59 +0200
Message-ID: <20260721152402.464679988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Varney <pbvarney@protonmail.com>

[ Upstream commit bb56147ea9fce98ebde1d367335ba006cba61fbd ]

The 1152MHz frequency entry for the a53 currently selects a multiplier of 62, giving 1190MHz. This changes the mulitiplier to 60 giving the intended 1152MHz.

Signed-off-by: Phillip Varney <pbvarney@protonmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 0c6ab1b8f894 ("clk: qcom: Add A53 PLL support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260605005502.313928-1-pbvarney@protonmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/a53-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/a53-pll.c b/drivers/clk/qcom/a53-pll.c
index af6ac17c7daeb6..ffb775e0062ebe 100644
--- a/drivers/clk/qcom/a53-pll.c
+++ b/drivers/clk/qcom/a53-pll.c
@@ -18,7 +18,7 @@
 static const struct pll_freq_tbl a53pll_freq[] = {
 	{  998400000, 52, 0x0, 0x1, 0 },
 	{ 1094400000, 57, 0x0, 0x1, 0 },
-	{ 1152000000, 62, 0x0, 0x1, 0 },
+	{ 1152000000, 60, 0x0, 0x1, 0 },
 	{ 1209600000, 63, 0x0, 0x1, 0 },
 	{ 1248000000, 65, 0x0, 0x1, 0 },
 	{ 1363200000, 71, 0x0, 0x1, 0 },
-- 
2.53.0



