Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E91145B0F;
	Tue, 23 Apr 2024 21:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908620; cv=none; b=Gu74O6AmDYPsSe0Lnz5qRkN1HuHwzj+UcXyNtoV2QTEf3NomiPKongAW4gZRMESPjRjgD5CPuZQozQGpJEOFf6+AIa9m7XaDsiaNJLQqXRenLHPV7HxrTOTN2VZpsCNI5AELb7+ih8J15gk+Twa2t7ZS2WWGmwuWF6AAeGMV+dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908620; c=relaxed/simple;
	bh=VXG57ggfJGcr37FRhfkNSYNuFuF2gwQjSX+xwhR3GUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaAjnj+5AvhjWcuNF90KoggY6vpMJScvIJsNRX4CIa6hcJMi+D8KoCt1T1nxGE2p0EwWMMf6iW+aI15jQV4vUrmlgPZOFJKvAlK5+7LD8b6YgP4rkQCa50IT7RbrYFRLC6lhFg8dHcHZvU4YPVS2a53CrhHGS+11cjbZ/aqY3Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9eE2FzG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9eE2FzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902F5C116B1;
	Tue, 23 Apr 2024 21:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908620;
	bh=VXG57ggfJGcr37FRhfkNSYNuFuF2gwQjSX+xwhR3GUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9eE2FzGKz28rYATz2mrKCAKfLtg38igzHNwMlyfJIyMcWXNMYH3CJHnQaLPe78w1
	 7sMxZHEtR6dsKzKMm3fS91ct669uBFvdAAh/txkb6sqq4fX+f01zWcbz02qIzCSUan
	 yW8M4oJ204/YtFLB9raMvtgKNTSU0fsKQHQVVl60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chinmoy Ghosh <chinmoyghosh2001@gmail.com>,
	Mintu Patel <mintupatel89@gmail.com>,
	Vimal Kumar <vimal.kumar32@gmail.com>,
	Vishal Badole <badolevishal1116@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/158] clk: Show active consumers of clocks in debugfs
Date: Tue, 23 Apr 2024 14:38:51 -0700
Message-ID: <20240423213858.798053346@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Badole <badolevishal1116@gmail.com>

[ Upstream commit dcce5cc7826e9c6b3a2443e5e6b7f8d02a103c35 ]

This feature lists the clock consumer's name and respective connection
id. Using this feature user can easily check that which user has
acquired and enabled a particular clock.

Usage:
>> cat /sys/kernel/debug/clk/clk_summary
                      enable  prepare  protect
                                                                          duty  hardware                            Connection
   clock               count    count    count    rate   accuracy phase  cycle    enable   consumer                         Id
------------------------------------------------------------------------------------------------------------------------------
 clk_mcasp0_fixed         0        0        0    24576000          0      0  50000     Y   deviceless                     of_clk_get_from_provider
                                                                                           deviceless                     no_connection_id
    clk_mcasp0            0        0        0    24576000          0      0  50000     N      simple-audio-card,cpu           no_connection_id
                                                                                              deviceless                      no_connection_id

Co-developed-by: Chinmoy Ghosh <chinmoyghosh2001@gmail.com>
Signed-off-by: Chinmoy Ghosh <chinmoyghosh2001@gmail.com>
Co-developed-by: Mintu Patel <mintupatel89@gmail.com>
Signed-off-by: Mintu Patel <mintupatel89@gmail.com>
Co-developed-by: Vimal Kumar <vimal.kumar32@gmail.com>
Signed-off-by: Vimal Kumar <vimal.kumar32@gmail.com>
Signed-off-by: Vishal Badole <badolevishal1116@gmail.com>
Link: https://lore.kernel.org/r/1669569799-8526-1-git-send-email-badolevishal1116@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 9d1e795f754d ("clk: Get runtime PM before walking tree for clk_summary")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 7c87a8084df76..011e7632541fa 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3279,28 +3279,41 @@ static void clk_summary_show_one(struct seq_file *s, struct clk_core *c,
 				 int level)
 {
 	int phase;
+	struct clk *clk_user;
+	int multi_node = 0;
 
-	seq_printf(s, "%*s%-*s %7d %8d %8d %11lu %10lu ",
+	seq_printf(s, "%*s%-*s %-7d %-8d %-8d %-11lu %-10lu ",
 		   level * 3 + 1, "",
-		   30 - level * 3, c->name,
+		   35 - level * 3, c->name,
 		   c->enable_count, c->prepare_count, c->protect_count,
 		   clk_core_get_rate_recalc(c),
 		   clk_core_get_accuracy_recalc(c));
 
 	phase = clk_core_get_phase(c);
 	if (phase >= 0)
-		seq_printf(s, "%5d", phase);
+		seq_printf(s, "%-5d", phase);
 	else
 		seq_puts(s, "-----");
 
-	seq_printf(s, " %6d", clk_core_get_scaled_duty_cycle(c, 100000));
+	seq_printf(s, " %-6d", clk_core_get_scaled_duty_cycle(c, 100000));
 
 	if (c->ops->is_enabled)
-		seq_printf(s, " %9c\n", clk_core_is_enabled(c) ? 'Y' : 'N');
+		seq_printf(s, " %5c ", clk_core_is_enabled(c) ? 'Y' : 'N');
 	else if (!c->ops->enable)
-		seq_printf(s, " %9c\n", 'Y');
+		seq_printf(s, " %5c ", 'Y');
 	else
-		seq_printf(s, " %9c\n", '?');
+		seq_printf(s, " %5c ", '?');
+
+	hlist_for_each_entry(clk_user, &c->clks, clks_node) {
+		seq_printf(s, "%*s%-*s  %-25s\n",
+			   level * 3 + 2 + 105 * multi_node, "",
+			   30,
+			   clk_user->dev_id ? clk_user->dev_id : "deviceless",
+			   clk_user->con_id ? clk_user->con_id : "no_connection_id");
+
+		multi_node = 1;
+	}
+
 }
 
 static void clk_summary_show_subtree(struct seq_file *s, struct clk_core *c,
@@ -3321,9 +3334,10 @@ static int clk_summary_show(struct seq_file *s, void *data)
 	struct clk_core *c;
 	struct hlist_head **lists = s->private;
 
-	seq_puts(s, "                                 enable  prepare  protect                                duty  hardware\n");
-	seq_puts(s, "   clock                          count    count    count        rate   accuracy phase  cycle    enable\n");
-	seq_puts(s, "-------------------------------------------------------------------------------------------------------\n");
+	seq_puts(s, "                                 enable  prepare  protect                                duty  hardware                            connection\n");
+	seq_puts(s, "   clock                          count    count    count        rate   accuracy phase  cycle    enable   consumer                         id\n");
+	seq_puts(s, "---------------------------------------------------------------------------------------------------------------------------------------------\n");
+
 
 	clk_prepare_lock();
 
-- 
2.43.0



