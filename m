Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F916471264;
	Tue, 21 Jul 2026 18:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660225; cv=none; b=Kos+OFqqX0Svf+O8iJVCQm6Gag5ow0ymUPnCr3VjsLgr+B5cIHtT074Ka+kgFqIorvS0OtAxJy4Tr+igvlH1ATr1IwDFzZ2eT62Q9zyzbnJ2FqzDLxlYoxZnAgToVKRLsF/gsBRDLXUWuqso1xUlSftBXPvGxxopz8e+yuZTS2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660225; c=relaxed/simple;
	bh=+Jj368t33TgLcUc8gI8ELQSNDhrffMveOvKz7ewYAl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7109JKp+m+1GpLIcc8ELq6NZkwvjfa9SWoJ6tLNFe9moZcWkUV262YulHw6g8anteO+A1fGBKJJArrwzT7SDByGgj8uAmQaY9NhjteIADljJNSvmKP108ACtH10pTL98OFpDbtRHtWA5MJEfggjOysz3HnVZvsgJv80E4LXJWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pm3wyYhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pm3wyYhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8675B1F000E9;
	Tue, 21 Jul 2026 18:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660224;
	bh=pNUHgm1EU8lNDUuaxRjQKdVNavtYGUmKDdHymv/VtN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pm3wyYhY82Rva5xRtMqj5f6QtJm4PIBBuhMHfUhhJ1Ex+PEIwNEMO4MrxniFS1+yC
	 4h7HWqjOGanSPqew9bPGErgMKnJzjYe2xJ2jjxAQi9lMOX5dv6mfqXy4/PbKEyXMgz
	 r/MwH7Uqf9ZkaXVwX0a4HM00+DlM/mGChyisiw6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0899/2077] clk: renesas: rzg2l: Rename iterator in for_each_mod_clock() to avoid shadowing
Date: Tue, 21 Jul 2026 17:09:32 +0200
Message-ID: <20260721152614.023228393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 1f10c4509649e7c5f6d5d3acccf3ef6fbb5cdd46 ]

Rename the internal loop iterator variable in the for_each_mod_clock()
macro from 'i' to '__i'.

The current naming conflicts with local loop variables named 'i' inside
code blocks that utilize the macro, triggering compiler warnings due to
variable shadowing:

  drivers/clk/renesas/rzg2l-cpg.c:1494:36: warning: declaration of `i` shadows a previous local [-Wshadow]
   1494 |                  for (unsigned int i = 0; i < clk->num_shared_mstop_clks; i++)

Using a unique identifier for the macro-internal iterator resolves the
shadowing warnings globally across all macro expansions.

Fixes: 3fd4a8bb4b63 ("clk: renesas: rzg2l: Add macro to loop through module clocks")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260520092947.70596-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index abfd8634d2bef2..c7bb5b97e7c45b 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -1340,10 +1340,10 @@ struct mod_clock {
 #define to_mod_clock(_hw) container_of(_hw, struct mod_clock, hw)
 
 #define for_each_mod_clock(mod_clock, hw, priv) \
-	for (unsigned int i = 0; (priv) && i < (priv)->num_mod_clks; i++) \
-		if ((priv)->clks[(priv)->num_core_clks + i] == ERR_PTR(-ENOENT)) \
+	for (unsigned int __i = 0; (priv) && __i < (priv)->num_mod_clks; __i++) \
+		if ((priv)->clks[(priv)->num_core_clks + __i] == ERR_PTR(-ENOENT)) \
 			continue; \
-		else if (((hw) = __clk_get_hw((priv)->clks[(priv)->num_core_clks + i])) && \
+		else if (((hw) = __clk_get_hw((priv)->clks[(priv)->num_core_clks + __i])) && \
 			 ((mod_clock) = to_mod_clock(hw)))
 
 /* Need to be called with a lock held to avoid concurrent access to mstop->usecnt. */
-- 
2.53.0



