Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114E341169F;
	Sat, 12 Sep 2026 16:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231649; cv=none; b=dqC1EAtmHd9aBr2NYAoaH7ktVVyS2BfJe9C8xSCWHemd/4UbYq2y8Bi2To334v/cb1HD56U4JP5hF1bSRral7B5/ppXsRruzlY1ZWFE80PEECyUUutpMdgv/tZb00qru9cf+I+SFbIv3u/lAUuMdZRe3+ab7yNI1iTrMCPps0E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231649; c=relaxed/simple;
	bh=QN3KQM9RRgCltIYPOt/3IU2lL4vEHhV2jRI/aLHMhbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1K6fa+cCvhiUE1VRKngtHT0Uhvxq8m42Tz6EYUhY6ojucqEK86GSyDgyqip2L9rMyP3xqu+J576GpG+WgP6GFJQHkR9W3FulQDEiE2Fr32XK4/tzUms+S+WdFL/FU5nofVAEGixMdCqEl1hFzIp6aaZlXTlNewFvhgKhfFFYh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTx0FlDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTx0FlDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88CA1F000FF;
	Sat, 12 Sep 2026 16:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231648;
	bh=ln7oO4TE2JPErJ1B89c1LHCdETulBW7wj/G0OJ97sgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTx0FlDf0OECWkrUivjD2PjPIGWzWLPXR9+mwIg2v/4KD22DWY7igx/LTGUGp89k4
	 DoSIuscnBZinRHEfw48vN+G3BeL0X3qqx6mm6bTH31Yn+fePfIr7uoLJIvIt9KxWy0
	 EuD4O9360E3i1FTXNEG5chfVx+Qa3XtSf+b5X8i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Carter Edwards <ethan@ethancedwards.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1041/1191] clk: ti: use kcalloc() instead of kzalloc()
Date: Sat, 12 Sep 2026 09:02:49 +0200
Message-ID: <20260912065611.559120358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Carter Edwards <ethan@ethancedwards.com>

[ Upstream commit de517118c5d3482411fd88141093fa838bc0af77 ]

Use 2-factor multiplication argument form kcalloc() instead
of kzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
Link: https://lore.kernel.org/r/xfjn4wqrhukvi45dkgkbulamq3242eijn7567vxwaxznh4ebdr@waat7u3l2mhi
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 667f420c09f1 ("clk: ti: mux: resolve parent clocks by DT index, not by name")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/mux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/ti/mux.c b/drivers/clk/ti/mux.c
index 1ebafa386be61..eaacd830523a2 100644
--- a/drivers/clk/ti/mux.c
+++ b/drivers/clk/ti/mux.c
@@ -180,7 +180,7 @@ static void of_mux_clk_setup(struct device_node *node)
 		pr_err("mux-clock %pOFn must have parents\n", node);
 		return;
 	}
-	parent_names = kzalloc((sizeof(char *) * num_parents), GFP_KERNEL);
+	parent_names = kcalloc(num_parents, sizeof(char *), GFP_KERNEL);
 	if (!parent_names)
 		goto cleanup;
 
-- 
2.53.0



