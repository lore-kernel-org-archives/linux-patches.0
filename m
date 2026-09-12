Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726462EC09B;
	Sat, 12 Sep 2026 13:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218651; cv=none; b=E7JgVs1iyPO63CFFQ+01F3EV2MFFDFrNoV9K0mKDmja4zXfEcP1IWdxBme557RjJmVAWdXZ1T4496DPf3RvhWJtcDcFiUwaddd1ZyNwVKnWw/ut4suM3cb1vmcot/V48Kvx84r7i/XsL4fx4NwDtWIcDt8Ru6vrAEvY82EWGrY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218651; c=relaxed/simple;
	bh=U5xkoniKQ1sUrIQ61ibE0LniuIth//v60+zEUzYEKhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFS1S2/8rQi6Q7Z5PHhkRMIHuvnzIwF++8NHp++S5ZCVQLotCz3Lpw/TacYYSTQ0XZrP4qPO8Gjot8ZBbnyzqQD2OIYjVfQApY7REu5jSJyJDMFVjGXbnyo6AXhutrEm5r8f0GOwM+eOMS312S6kDfM1qmaEyeiJhMrVbQlfzkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVEM+TRH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVEM+TRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785671F000FF;
	Sat, 12 Sep 2026 13:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218650;
	bh=1JG/LfZBhHLewMcnDVJ6KOucaVchsuItVD6c3gjUq8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVEM+TRHDsccssr6HIsyLW3jthIn6PTyj1BLl7YmxeROextWKFfwmNA/RTZw+tErE
	 qndZV0LchARRxNUNEOQJQjcR95QNdojBeMEdGnods1a07IHzPGlYHOnUszRyntGmXX
	 22txTQZoMJBl74J3eDdS1upJw8tFQ8qsrwLWnlO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Carter Edwards <ethan@ethancedwards.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1187/1376] clk: ti: use kcalloc() instead of kzalloc()
Date: Sat, 12 Sep 2026 09:00:13 +0200
Message-ID: <20260912065634.006217376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 216d85d6aac6c..f684fc306eccd 100644
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



