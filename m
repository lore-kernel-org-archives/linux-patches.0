Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A47281369;
	Thu, 13 Feb 2025 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457648; cv=none; b=peG0TXCirhtXSH42xQwS0mtFqyzZcWVs0XuOdUswm343r4X1iOWeHX26Fq0GpZBiduBbkVL6L7OTYx38NoQD4y/88Mw7uzpTJ2QGfBpB7lz8VpkTkfbWDiW9UOhDp2OJAhut/oCbYkiwGUZxryTTMLKiX+j9CDzOyzA+o3OhAkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457648; c=relaxed/simple;
	bh=zFPfamPXhYPnxvNxryukQM4UemmFejTm+iv/ogVPRvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaRjy5W57fGcPArv1xc2wXWzU94OYR3xO+1mSQaZw2vf1+fhD6Ctw1/W2U6DVM3SQHb5slS1HlKyAlooh+p8TpjiXe8geVKvWmuzxyCwvb956qalFA+AkaaKqPghVuj8KorEPqe40n/rmVP/aGyhKgM780knVpdqAQ2wn87hTak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAeQSG+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAeQSG+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFBBC4CED1;
	Thu, 13 Feb 2025 14:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457648;
	bh=zFPfamPXhYPnxvNxryukQM4UemmFejTm+iv/ogVPRvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAeQSG+SZDOtgZF0mufnAbKeBZJhHElf4JLAXi1iCy/Zkoxbwkd0aKBkDYwYlNR1V
	 OSwTWR58itjoDt0KR5ktXxn5+JryhTk9qOnbHw+mu3aeZBroS/YJOm41UpaeR0lZNU
	 khRRszQgMon5oq82WY8kDccvv4uIt3ZlP3IY6Mv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cody Eksal <masterr3c0rd@epochal.quest>,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 6.12 173/422] clk: sunxi-ng: a100: enable MMC clock reparenting
Date: Thu, 13 Feb 2025 15:25:22 +0100
Message-ID: <20250213142443.220656957@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cody Eksal <masterr3c0rd@epochal.quest>

commit 16414720045de30945b8d14b7907e0cbf81a4b49 upstream.

While testing the MMC nodes proposed in [1], it was noted that mmc0/1
would fail to initialize, with "mmc: fatal err update clk timeout" in
the kernel logs. A closer look at the clock definitions showed that the MMC
MPs had the "CLK_SET_RATE_NO_REPARENT" flag set. No reason was given for
adding this flag in the first place, and its original purpose is unknown,
but it doesn't seem to make sense and results in severe limitations to MMC
speeds. Thus, remove this flag from the 3 MMC MPs.

[1] https://msgid.link/20241024170540.2721307-10-masterr3c0rd@epochal.quest

Fixes: fb038ce4db55 ("clk: sunxi-ng: add support for the Allwinner A100 CCU")
Cc: stable@vger.kernel.org
Signed-off-by: Cody Eksal <masterr3c0rd@epochal.quest>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Link: https://patch.msgid.link/20241109003739.3440904-1-masterr3c0rd@epochal.quest
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-a100.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/clk/sunxi-ng/ccu-sun50i-a100.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-a100.c
@@ -436,7 +436,7 @@ static SUNXI_CCU_MP_WITH_MUX_GATE_POSTDI
 					  24, 2,	/* mux */
 					  BIT(31),	/* gate */
 					  2,		/* post-div */
-					  CLK_SET_RATE_NO_REPARENT);
+					  0);
 
 static SUNXI_CCU_MP_WITH_MUX_GATE_POSTDIV(mmc1_clk, "mmc1", mmc_parents, 0x834,
 					  0, 4,		/* M */
@@ -444,7 +444,7 @@ static SUNXI_CCU_MP_WITH_MUX_GATE_POSTDI
 					  24, 2,	/* mux */
 					  BIT(31),	/* gate */
 					  2,		/* post-div */
-					  CLK_SET_RATE_NO_REPARENT);
+					  0);
 
 static SUNXI_CCU_MP_WITH_MUX_GATE_POSTDIV(mmc2_clk, "mmc2", mmc_parents, 0x838,
 					  0, 4,		/* M */
@@ -452,7 +452,7 @@ static SUNXI_CCU_MP_WITH_MUX_GATE_POSTDI
 					  24, 2,	/* mux */
 					  BIT(31),	/* gate */
 					  2,		/* post-div */
-					  CLK_SET_RATE_NO_REPARENT);
+					  0);
 
 static SUNXI_CCU_GATE(bus_mmc0_clk, "bus-mmc0", "ahb3", 0x84c, BIT(0), 0);
 static SUNXI_CCU_GATE(bus_mmc1_clk, "bus-mmc1", "ahb3", 0x84c, BIT(1), 0);


