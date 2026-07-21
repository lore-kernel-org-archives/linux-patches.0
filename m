Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1B046D544;
	Tue, 21 Jul 2026 19:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661543; cv=none; b=rE5hhleAVGSrsGPdo9lkwnFyIotffQAo5Yl/Za707cT27ktZzd8Hy3em0DtcBzRdQun8Ln5NxG+ErqMIRwW+hW7J1dA/s4736pPtg+DLxC7x/8Ms4Asd1bcwOy0cwlj9IvTL7EGRFOCJwx7Juqrjp4/bE0Fd+rM9mU4dKBPjhIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661543; c=relaxed/simple;
	bh=BQnx7NcFf+MbqQxKalMOmmwaSrjpCVSiVSD/e139uew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3mz8zMz3UDhUiceSgXsLtGls1FTFj1glVhnZT6uB6xgu2Yj5PNHr32vxgcV/Jm4jhQaMffHxjULwhqQbxf/y/atMzKIwQQWQV9tFJc8TFMpQ26DCc4DjHP7TFINYUHU9GdKB+I9D/4gf7uVLUP3cghnp0WVPK5yuOBr7xsM/4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgIkiLC8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgIkiLC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191751F000E9;
	Tue, 21 Jul 2026 19:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661542;
	bh=FUs9D+6kDMYseqc1hzVTipWPJ+5qs9hHRzoEjXaNf5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgIkiLC8Yi6IBg1Oy9ZFbBtO+FxyFvjj52E1fYnwDX5HNfybnt2HTgh4oVhDiAGht
	 HMLPgfESGDDbrwdA1FstWlFjhAuKExTW4IDGB3o/SYc5QtFRrUbtRV2/JGVnjh8T6P
	 TWscl29i5wGtkSPC0t0U9vmuO6GoiVjgymBlsWAg=
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
Subject: [PATCH 6.12 0107/1276] clk: scmi: Fix clock rate rounding
Date: Tue, 21 Jul 2026 17:09:10 +0200
Message-ID: <20260721152448.492673894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 7b7ea36333a6bc..c0e9db04f450c8 100644
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
@@ -78,7 +78,7 @@ static long scmi_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 
 	ftmp = rate - fmin;
 	ftmp += clk->info->range.step_size - 1; /* to round up */
-	do_div(ftmp, clk->info->range.step_size);
+	ftmp = div64_ul(ftmp, clk->info->range.step_size);
 
 	return ftmp * clk->info->range.step_size + fmin;
 }
-- 
2.53.0



