Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42F746DFFF;
	Tue, 21 Jul 2026 18:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657163; cv=none; b=rlqMqonpyFwNr1YDVDN+mvFS5akAchHew5XH+qpj8h3D4c6yhX+bR1wmQ1qmTJidxq+cdWZ+3ulMmGCzRASxoD/tebVXMvFk4Cccqv13D7J86YGXuSwoMhKSu1+CmB8PD7Ik7EqnKKJlD+a+fBOxFW8AGNZC0SkLJZVU59oKyiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657163; c=relaxed/simple;
	bh=bCVqm9QaCu4azZuGaB1UoHS2cIntgdxjuXQV8RGPY/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZu6qmaIUEmZJXbQBmjIqN7ei6aMZu7X6AAfRBnlrayGnIUjFyKVeQW/pcWw/ClE6L25PBj0opDOzp+e5BGeGyDncwZWkqkXFbFGXE59aYjRPFiH42/54L9OJhvkUolw4pLHornAZNJx3GzGEiHgwkBXe5aJs7FQyPKW+gN+VwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVqr7RAv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVqr7RAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0201F000E9;
	Tue, 21 Jul 2026 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657162;
	bh=vm6GU7s8YTqZPN1O63K/ArnLNUKPIv2Wwm6aJYF6ESE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qVqr7RAvQcjhqbxlZis5x6d0PrKZOVF82T3vPRT1fQHJ2XSkrHKNx3W/BSZ8yPlcg
	 Aydcw6rrnnEu2L+rQubEZgkUXKHK2aX5dkfagQCKw/Bl6v/gUCW12A+64jVhZDPx29
	 OJqNxmyP5+sflN0IMdmeRp6PlcVHIF1GV0W/LW2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Varney <pbvarney@protonmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0662/1611] clk: qcom: a53: Corrected frequency multiplier for 1152MHz
Date: Tue, 21 Jul 2026 17:12:58 +0200
Message-ID: <20260721152530.274859837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 724a642311e50b..0549b214fcfc8b 100644
--- a/drivers/clk/qcom/a53-pll.c
+++ b/drivers/clk/qcom/a53-pll.c
@@ -20,7 +20,7 @@
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



