Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46596264A86;
	Tue, 21 Jul 2026 18:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657043; cv=none; b=CrfhDE338IKCbaA7gzX22itJPIzRZGSjZrJFEzfldAiBzatPVZYl4QcVc6sYul18yn5gVMYrh5kI6tdK4HurFZs6fyRoswM9P0WdPU6YhFWSPWD//IJlEvihK1UKJXMeTa+9rY7EgH2BOo2NJ/SNlw9OoBwMeRNaSmcF5pt4vuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657043; c=relaxed/simple;
	bh=BP6iJ+CDRevDntib+LNpHYrpfhvAAFBn2PAve/q6Yoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRPdKiESBDtxtAAphPgEOL8o3SJ29Mo6u3DVhmC8zcM/8PGZkPx9iVCHWrVl9RKs5VYtKnpoup2W+J3lH2FDWv25Os9a97Bj/eGHdrSNNNVBwUrbwaa7g+UwrCw5Pws3kG1pOlAm21k8B/u0e5zKSxatIvCTaBsFKTJz8ILfOnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTmB6eBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTmB6eBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A524E1F00A3D;
	Tue, 21 Jul 2026 18:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657042;
	bh=vwDNLMJsIfn2kCaW8bo1rDzjk5L3T0xrhrNJM124zrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTmB6eBjXWIcP2mfafAfIlbl+lgDY00NhHVLDWvMxdwqvomANYO+r1vd19lXDWl6d
	 KSQd5g+acri+NV3qpEpeLF1uyS+FodXXF9fHvTxXHBHjeX1fRhFGFmGHDgXucJE5jY
	 ZQxF8mcDFL8sB8niPIbL097yhjsmVNfcJw1Wh6xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0616/1611] clk: renesas: rzg2l: Rename iterator in for_each_mod_clock() to avoid shadowing
Date: Tue, 21 Jul 2026 17:12:12 +0200
Message-ID: <20260721152529.241648226@linuxfoundation.org>
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
index edad47ca33ec56..769aae1a9fd356 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -1228,10 +1228,10 @@ struct mod_clock {
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



