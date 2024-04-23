Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7D4143C49;
	Tue, 23 Apr 2024 21:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908723; cv=none; b=Pg57OyZAtm8nRMWQWCd7RLzdcmjiXNPJyU0/4MrGVuBDSJYpJuwLXgwy1Qotz2Vw1DX5P0WRGIxJcPx2ScBltWkwAtQ7kY44Zo0Fub4QCM+4JF4+Q2tEfP9XCqhUx2FHsf9dNeSBzQNJKoobVfLr1Kq9FpFRd5nGXoIz6Y2+awc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908723; c=relaxed/simple;
	bh=WbUNBDcsk7eg7ufSXdw5WXt4LnSqBsBaXsjeD7yrGW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtuHvZdqwl56P/tkMFvsVi7k0XWUvjcvWZlM013G5AwGrgvsAZ5pskc2/EkkwcvOI8yzDOr8S7d5nusw8LgCwL2xDk9G35epNRXmRH2rD5nmyFfZ814NDaR6RdcSej8BxNoytjU7AUhWBGhgIlAg8hQbx/qqPmXm7qmcExDuiME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2u6O8ouk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2u6O8ouk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1CDC4AF08;
	Tue, 23 Apr 2024 21:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908723;
	bh=WbUNBDcsk7eg7ufSXdw5WXt4LnSqBsBaXsjeD7yrGW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2u6O8oukX3SVwoTaCpwSdWnk2Pdw/FNtp4ewnlMAd7eAnfFoHKzi918ym7l8gWwD1
	 kHBubq4frv8e59FBNW0OY2y5WOYh6l9U2KXlFycCmBWifSDWSXreGdr97aKqaOPmZU
	 Ucwtr6RK0DDylPdZpjM/2sJ5gvog82cQFZR94vSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhe <yuzhe@nfschina.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/141] clk: remove unnecessary (void*) conversions
Date: Tue, 23 Apr 2024 14:39:15 -0700
Message-ID: <20240423213856.015823139@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhe <yuzhe@nfschina.com>

[ Upstream commit 5b1a1c1ab1f981b15bce778db863344f59bd1501 ]

Pointer variables of void * type do not require type cast.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
Link: https://lore.kernel.org/r/20230316075826.22754-1-yuzhe@nfschina.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 9d1e795f754d ("clk: Get runtime PM before walking tree for clk_summary")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 75d8f7f0de9ba..bf4ac2f52d335 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3245,7 +3245,7 @@ static void clk_summary_show_subtree(struct seq_file *s, struct clk_core *c,
 static int clk_summary_show(struct seq_file *s, void *data)
 {
 	struct clk_core *c;
-	struct hlist_head **lists = (struct hlist_head **)s->private;
+	struct hlist_head **lists = s->private;
 
 	seq_puts(s, "                                 enable  prepare  protect                                duty  hardware\n");
 	seq_puts(s, "   clock                          count    count    count        rate   accuracy phase  cycle    enable\n");
@@ -3304,7 +3304,7 @@ static int clk_dump_show(struct seq_file *s, void *data)
 {
 	struct clk_core *c;
 	bool first_node = true;
-	struct hlist_head **lists = (struct hlist_head **)s->private;
+	struct hlist_head **lists = s->private;
 
 	seq_putc(s, '{');
 	clk_prepare_lock();
-- 
2.43.0



