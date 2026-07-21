Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463AB446839;
	Tue, 21 Jul 2026 17:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655782; cv=none; b=JPlV6hihFWXwfErbjJaVtV8RZQknrT5HZP7agrrkmon00Uo9XCKrTV8nr9VbcgBTZonOej++IIYuvqNz0FZCcqCW3cC+nj5VlkzMvZu2U/G/rKDAXmlbOB4g7T16F1cHoTwiYjm4OrrWZZEZ7clUZK0JwL3PIqIoLLhLjcbfsbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655782; c=relaxed/simple;
	bh=6iknlKcuG3DdB6lYykzEKgpo2st8QI/3pvS7gFRmy34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC/an22r3/93nZfOc48GrF8b4QqsHtlk5Gj/IpuQkua0AD3MSe/1Jb0yXfwl5sHOLNdA168o27QcCqlkgGuaV0b7h9uSdU4Kd81A39B/Pf58QMbMn2OPP3DagdH9G20BCmkDMdoRjSqLwpbyalL9YqVjEFWjUAPT0BpvSJQ27DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8ih0Sgr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8ih0Sgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E5D1F000E9;
	Tue, 21 Jul 2026 17:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655781;
	bh=WB5LBMTOtylGVhn1YKfggHxzuOM/gumUcGN6WjAGcL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8ih0SgrYyp0LCGZj7eiZxEDKmtzZAF6KI189nTiXiwOMQusjh2RfCbTa0mXUFWKT
	 jbVX2wJom1Ce7emXjh/gtsNSiVwFr+Ywa48qNpBPU35CMtSMqWtbjRTfMtn/GZ3Y67
	 ghTILMWBQeoU09dRPDtfWPvV5vlwqv6z9C8HMXM0=
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
Subject: [PATCH 6.18 0137/1611] clk: scmi: Fix clock rate rounding
Date: Tue, 21 Jul 2026 17:04:13 +0200
Message-ID: <20260721152517.955145309@linuxfoundation.org>
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
index 6b286ea6f1218c..b6a12f3bc123c9 100644
--- a/drivers/clk/clk-scmi.c
+++ b/drivers/clk/clk-scmi.c
@@ -10,9 +10,9 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/scmi_protocol.h>
-#include <asm/div64.h>
 
 #define NOT_ATOMIC	false
 #define ATOMIC		true
@@ -83,7 +83,7 @@ static int scmi_clk_determine_rate(struct clk_hw *hw,
 
 	ftmp = req->rate - fmin;
 	ftmp += clk->info->range.step_size - 1; /* to round up */
-	do_div(ftmp, clk->info->range.step_size);
+	ftmp = div64_ul(ftmp, clk->info->range.step_size);
 
 	req->rate = ftmp * clk->info->range.step_size + fmin;
 
-- 
2.53.0



