Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C9F3FFD;
	Tue, 29 Apr 2025 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949679; cv=none; b=KbZSkWczmy3dwWzUShJlKyunKOv+Qi/h+2tZdpdYaSIQLuygRyOM/9Gr86Q/XgH/mgoer74KgKGCeYbJq7CZV8tjy16FtJV5YWD7Rc82WZyZLI2RZar8Tgi/DFUnRzeISGNOR6DkpTop00r75+LfAcK4sF3Z30+uAcMRsx8JhpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949679; c=relaxed/simple;
	bh=t21Pc0J6yqXd4t0hR9ad/ZipTXxdsy/CYidPwXTGrTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrXgLiTjOJH/hG7kXIcJoHVBWlRpzFhqbmjYc+x/v7FCmikBL7ENljcFwPhsssH+uzgxYoyOKJv2khuGE4P9DdUD/twCJZ9zHWgiJFFATEXBi18sbxh5baJvlFEP2CbKTorUPxHxOXb0Lb8J1cfkRP7hop+Ml+HNeioWVFhxFbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zARDBX3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zARDBX3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6082EC4CEE3;
	Tue, 29 Apr 2025 18:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949678;
	bh=t21Pc0J6yqXd4t0hR9ad/ZipTXxdsy/CYidPwXTGrTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zARDBX3Nh8uD5jTOESLTU8bdSe+O+C1JBpfFPISUFoNS+9GeJt4QFzv1q7i8Arz33
	 LSUyOkNQwVN26SE264knrL+hVRvQmxjClzNbfFXWxU0F+9mDdZJ5P0W1iU7+KMlaKs
	 QyNlzR+vSg0T2lWgK6gALvDIjXP08UvYqH9McaOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/167] clk: renesas: rzg2l: Use u32 for flag and mux_flags
Date: Tue, 29 Apr 2025 18:42:09 +0200
Message-ID: <20250429161052.609822469@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 897a3e34d6e73d2386715d5c44c57992f2c0eada ]

flag and mux_flags are intended to keep bit masks.  Use u32 type for it.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230912045157.177966-15-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 7f22a298d926 ("clk: renesas: r9a07g043: Fix HP clock source for RZ/Five")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.h b/drivers/clk/renesas/rzg2l-cpg.h
index aefa53a900597..f362a1d886338 100644
--- a/drivers/clk/renesas/rzg2l-cpg.h
+++ b/drivers/clk/renesas/rzg2l-cpg.h
@@ -92,8 +92,8 @@ struct cpg_core_clk {
 	unsigned int conf;
 	const struct clk_div_table *dtable;
 	const char * const *parent_names;
-	int flag;
-	int mux_flags;
+	u32 flag;
+	u32 mux_flags;
 	int num_parents;
 };
 
-- 
2.39.5



