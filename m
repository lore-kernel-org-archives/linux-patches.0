Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F104A6BB5B;
	Tue, 12 Aug 2025 18:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024721; cv=none; b=Bbu5/tBZZIj3ATMoOWhkvZfZH7/Lt+ObRiwPjVgL0bZN+33fT0ry48MOkd9Uy7TPNPvKlrz15WCUe8E+Mz2fw86Fii8CLer+i/B26nJCKUstPG+8vF7YmY/IjN71911X1AfF5IqJofV4JaQlNzqDuPYKSroijnDU4Kg6jFoTZSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024721; c=relaxed/simple;
	bh=TUkwCaZrnIVvJ3JS95RjbFDw36BTx3pTzp92CdJTH9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOpzZE/744Ptm8Z79TpiH/H7OsPgEzitSmbHhfTgMPvj9R0EpiHQ1NogQ678ynKHxqHXaz8rvqHQLu15rJexDpUUN24MT68pzCrI6mLdEIVwzg35kiVNN+oUuAKZQH4hp/GCiEBlyGz+8LF0p9R9r0mCdSuuk6gNc8P5wbSUHK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKC7Pc0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKC7Pc0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6CAC4CEF0;
	Tue, 12 Aug 2025 18:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024720;
	bh=TUkwCaZrnIVvJ3JS95RjbFDw36BTx3pTzp92CdJTH9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKC7Pc0k7Lb5guGLzFzML3x0ES1hTCv+PwlJwtEjHyCjMaI61iIPgmzEz6DlwOTXc
	 oazwoeT1gi5LTb87/+mOFwCcXP+i+z0fLSoA6Sjc4WPSvgFBXSJJYF1JGulJPZNx4Y
	 S1u00nLsrxP8vIjtHdPwmkkXlPKA/B8Saj8JtLW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhilesh Patil <akhilesh@ee.iitb.ac.in>,
	Haylen Chu <heylenay@4d2.org>,
	Alex Elder <elder@riscstar.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 424/627] clk: spacemit: ccu_pll: fix error return value in recalc_rate callback
Date: Tue, 12 Aug 2025 19:31:59 +0200
Message-ID: <20250812173435.400864780@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhilesh Patil <akhilesh@ee.iitb.ac.in>

[ Upstream commit c60b95389d0206a3a3c087c09113315e7084be3f ]

Return 0 instead of -EINVAL if function ccu_pll_recalc_rate() fails to
get correct rate entry. Follow .recalc_rate callback documentation
as mentioned in include/linux/clk-provider.h for error return value.

Signed-off-by: Akhilesh Patil <akhilesh@ee.iitb.ac.in>
Fixes: 1b72c59db0add ("clk: spacemit: Add clock support for SpacemiT K1 SoC")
Reviewed-by: Haylen Chu <heylenay@4d2.org>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://lore.kernel.org/r/aIBzVClNQOBrjIFG@bhairav-test.ee.iitb.ac.in
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/spacemit/ccu_pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/spacemit/ccu_pll.c b/drivers/clk/spacemit/ccu_pll.c
index 4427dcfbbb97..45f540073a65 100644
--- a/drivers/clk/spacemit/ccu_pll.c
+++ b/drivers/clk/spacemit/ccu_pll.c
@@ -122,7 +122,7 @@ static unsigned long ccu_pll_recalc_rate(struct clk_hw *hw,
 
 	WARN_ON_ONCE(!entry);
 
-	return entry ? entry->rate : -EINVAL;
+	return entry ? entry->rate : 0;
 }
 
 static long ccu_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



