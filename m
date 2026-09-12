Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EA6386562;
	Sat, 12 Sep 2026 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225759; cv=none; b=g2ptMRMKr8k2hQ9f7/fr+0bioAvOdePaLHcEWmg7xeZmuiwXruu1SWh65oDzfsxZlqJ02PKf+drZKyCGV8HDhgHYhJsw+GedO9auLKr3WA+VM1DbwkU9oTSFa7JFpHqeCh1ALjtp5XcF+3FpHpVfbsS25iaieO0r/ufe0fXf6Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225759; c=relaxed/simple;
	bh=sIMQ80m8mdNAn4CqUPO4XgHIZ9Hl94FblVo0uOfPl5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APKraQMQYRqYgfz4+7nBxw7t04uQ1R2Xg8D8u6BTdMs/2B9DHCYsEIaOcS41r3m090xkf9H/lDmc960dpsoHdsovCcB1kQdM8+LnRVceJtDXw84uw8ynssGY+VtgmiHt/IXv723c7LpuvcExkP0v2Ngnm56s7hiHnSBgciC4/3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muOOm8Md; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muOOm8Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371B41F000FF;
	Sat, 12 Sep 2026 15:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225754;
	bh=5uioQMeAzP7pwpg9rmTuv/cZROx6XQqV9Tt5cQ2Vipw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muOOm8MdEt5JG32B8tGpICM17vT4B+jI4F5/+WOSvwvgH61VPbNt/2FnOQx7OtnuU
	 yjGRXtZpWefVWi5Bcs5Fsq6Ap5JzurU4jybR5GvuFFcPqzpWj5MEan045ftl6BkVbU
	 nxfvQYdKHEgIdAGQdJ/2ZBqXx2kNEs+oBvUCldbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Carter Edwards <ethan@ethancedwards.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1261/1424] clk: ti: use kcalloc() instead of kzalloc()
Date: Sat, 12 Sep 2026 09:01:33 +0200
Message-ID: <20260912065635.518814346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



