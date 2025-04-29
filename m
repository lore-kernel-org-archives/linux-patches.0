Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E289416A94A;
	Tue, 29 Apr 2025 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950223; cv=none; b=D20nhfT1Aw9Sm81aJqZ09XfDnm5KVp3uYxPAif7T/c89IVwSzwRXw5qI+WghMce0tYO4Qs+ebPJJbMw8F/vZK412giDf09KnWIk08zTp96RlryQitCQhlyfdy4ATYc0KvZc+UFB9wmH/HD+gZAhcb4TENOpfKwOhF1IA9HulFas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950223; c=relaxed/simple;
	bh=5XSi7i3y5jLAokaqs+6eUyW8bgLlNfxFzENjU/3OSqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE4cCqs1IWbzMzztYkStlNWGr3VaXWxA4QzA2Jndid+myRdqppPPrcE0DRQgTkYUYdwJWW/+UGN0UTgMoUGmgQqct9xXQTNeE6yLPJb2ao4ntEcFMEb00V8oE+1CPDezmSuj9LG7fEpKEahb4MjShy5x3L+pc9HxTekAVkK0z0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJwZucZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJwZucZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65F2C4CEE3;
	Tue, 29 Apr 2025 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950222;
	bh=5XSi7i3y5jLAokaqs+6eUyW8bgLlNfxFzENjU/3OSqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJwZucZoiTo+8ZAds8dzwCj9QpSqxumO8hNA5oenGeLm1aWMAMPArJ3HWWtpqNJ1W
	 HslrpPv/wgvJp6H3blOWT8CXmt3I7X6yT4t0kb8FwFTh39elwca2Ox8Eb7qLOteVKr
	 1ERebCqCKLAdyytHTFdBTMeC6GcWid9IgFbiFZcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/204] clk: renesas: rzg2l: Use u32 for flag and mux_flags
Date: Tue, 29 Apr 2025 18:41:54 +0200
Message-ID: <20250429161100.488874588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 91e9c2569f801..097fd8f616806 100644
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



