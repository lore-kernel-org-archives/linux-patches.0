Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F95842A7B4;
	Tue, 21 Jul 2026 20:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665680; cv=none; b=A1snxsbZNiWI6xksgdX/1YHZd8Wbp9qHBuHN+AwrFl3LQ3k8jC0EhLuxkZ+DuGlM87OPzDUv/rDlFHzONnd2jPZpEmSbXY3YhnCQJ0Fwmv0gk2/CDnVVjbN/mf5Qv1xAiTwJn9E+BjGwhPcfDH3epVUmZJsyJFbOe1YEbQ3Vc5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665680; c=relaxed/simple;
	bh=UElIcja0Wp1NJVx0dVRkd3CY2Vp0LEJ/8XuOqp9634Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jh+mz2jwCSpngCtzuxCDnaCWrmuzQUOZfvZ3e6P0dcPG8/YMVk5S5S9NvBfSsnMz+z6M7lfs1I88ZDG7fhK64vYNgAhfy9xEgZ4AER0nGBmBnfvFOJkTAQC6gsPyWffyFEbcMk9kTqQuLbT24GWjUEOHVVuL8XEa1+cWa41ApYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQ2Bx9WB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQ2Bx9WB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786AA1F000E9;
	Tue, 21 Jul 2026 20:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665678;
	bh=DB4KE19jOAAiKk+TUCqUg8Ynky+oVdYO3UoqPeKREWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQ2Bx9WBTzNPhyhw6BTeqd8eRgp1DLzOuVDmK5kuvy3O4GDo7CVYZHVqfRvpZVFRl
	 LLE38QCvEXNQQ8zGqe00heWgAMw8pXxJxtops2NtBbgGXCLZVicgWBIDW5skA2OrYl
	 9qN6amvakqlbZZz+qXanT37Qqc17u4CwBVjGpQzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	linux-clk@vger.kernel.org,
	Cristian Marussi <cristian.marussi@arm.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0394/1266] clk: scmi: Fix clock rate rounding
Date: Tue, 21 Jul 2026 17:13:51 +0200
Message-ID: <20260721152450.645112096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit d0c81a38d06d446d341532700b3a4a43d3b00eb1 ]

While the do_div() helper used for rounding expects its divisor argument
to be a 32bits quantity, the currently provided divisor parameter is a
64bit value that, as a consequence, is silently truncated and a possible
source of bugs.

Fix by using the proper div64_ul helper.

Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: linux-clk@vger.kernel.org
Fixes: 7a8655e19bdb ("clk: scmi: Fix the rounding of clock rate")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260508153300.2224715-2-cristian.marussi@arm.com
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-scmi.c b/drivers/clk/clk-scmi.c
index fdec715c9ba9b3..096b0691661961 100644
--- a/drivers/clk/clk-scmi.c
+++ b/drivers/clk/clk-scmi.c
@@ -9,9 +9,9 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/scmi_protocol.h>
-#include <asm/div64.h>
 
 static const struct scmi_clk_proto_ops *scmi_proto_clk_ops;
 
@@ -61,7 +61,7 @@ static long scmi_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 
 	ftmp = rate - fmin;
 	ftmp += clk->info->range.step_size - 1; /* to round up */
-	do_div(ftmp, clk->info->range.step_size);
+	ftmp = div64_ul(ftmp, clk->info->range.step_size);
 
 	return ftmp * clk->info->range.step_size + fmin;
 }
-- 
2.53.0



