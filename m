Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0356B14B071;
	Tue, 23 Apr 2024 21:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908786; cv=none; b=T4C3wC3P1o21XmhXWMM9LotquoVYoYDAHPqe1mjYhFix+exx1l5EUfiJJv9j66zmM/bOcTjHFBr3qnwyFp+TOpekTkj3ImsobmaSIM//BOOerY7HO2GchwflqZ6hrzTInmj6XbCDC2MiyA9otInhwGFOJRC6GfROMRbaJl1O2Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908786; c=relaxed/simple;
	bh=8EAmWsoML/jSigPGT8387Fzz2Mqk5bESQYEQ0OKIAbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEK4vm8xgp2pqXIBVf1ItBK7M6/B6XufQZt4j4Ic8ef7UgFakazJmlFT3O27gXXuVjXBfxY4450BcA/BIXwGDOHYgBPE2VJucwS7sisBmLrHyMNpSG/IWlth6MHXYipgsbd8YITYMqiYwuDdsFwFedamgenpYFDoA8bdgzzokJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLXckV8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLXckV8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC8FC3277B;
	Tue, 23 Apr 2024 21:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908785;
	bh=8EAmWsoML/jSigPGT8387Fzz2Mqk5bESQYEQ0OKIAbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLXckV8dSO1+ND2xOdL6+BZno8bUWCp1l1iXrKK4VAeBvxKUrfl9cT34AvrXWZfeW
	 Nfn31fOXTtwZbrs/HCy+ckiPInmMsO8WCdoFPGzqyvvxiGCdhg2HdVDpy8yk2dHVYe
	 im5pibj1pg2mMdnpPu2EZ1dj7meql0YU+losjPGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/71] clk: remove extra empty line
Date: Tue, 23 Apr 2024 14:39:49 -0700
Message-ID: <20240423213845.394208792@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 79806d338829b2bf903480428d8ce5aab8e2d24b ]

Remove extra empty line.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220630151205.3935560-1-claudiu.beznea@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: e581cf5d2162 ("clk: Get runtime PM before walking tree during disable_unused")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 0d93537d46c34..52877fb06e181 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3653,7 +3653,6 @@ static int __clk_core_init(struct clk_core *core)
 
 	clk_core_reparent_orphans_nolock();
 
-
 	kref_init(&core->ref);
 out:
 	clk_pm_runtime_put(core);
-- 
2.43.0



