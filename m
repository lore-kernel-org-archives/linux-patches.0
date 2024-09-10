Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2FA18595E;
	Tue, 10 Sep 2024 10:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962523; cv=none; b=YF/6eOAc0+fgRtbcLfRawqxTvyntQfX5qs8usZYaWOl9zbtQmNYWB2lWVe5pHhKDhfCcdWCZLPVw1tjRO1qSlSwLY7tCtNY3JSlap1OFD66OQMUGJmSWA7TtieP0iFviaYTT4Hg4oPtlaUht6SZq2ftsMOr1i5UnG+UsE7onsRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962523; c=relaxed/simple;
	bh=3pR5qFbMDZp7RMD8CVZfO6mHmCVoboCDIu0tJQtJAKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI7IXh8Am1uUD1Nl5/lTejHa8FUvO1nSifQZNezbyac5sSLyCrL65BTbLRlQKW/9srhrkVSOZ7stJy2zgFY8kKrDLthiZbPhMbgBhWYka9h47XvJNkJwB3NrX2caCCv8/IYgOt7k4dha0St4R0TArIedkTqTdNKRfEaGC+y+F3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMHJ4Dpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMHJ4Dpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D736FC4CEC3;
	Tue, 10 Sep 2024 10:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962523;
	bh=3pR5qFbMDZp7RMD8CVZfO6mHmCVoboCDIu0tJQtJAKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMHJ4Dpw9mc5GOgQeb3NdCiALwd77hNLUeWiuN0lAhq9dXk0nlaMRxhj12UebQlhT
	 iNKtG1iY3RAdChXudKfRQxS6GFVvWp9jqVyPnln7MOIClJ16cTwl2nx5BgvgWXYt94
	 bXFQ+uzc+L0q3zgW68qdHF6Lst1dWk4vG2GnNuzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Allison Randal <allison@lohutok.net>,
	Peter Griffin <peter.griffin@linaro.org>,
	linux-clk@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	Yongqin Liu <yongqin.liu@linaro.org>
Subject: [PATCH 5.4 036/121] clk: hi6220: use CLK_OF_DECLARE_DRIVER
Date: Tue, 10 Sep 2024 11:31:51 +0200
Message-ID: <20240910092547.439507139@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

commit f1edb498bd9f25936ae3540a8dbd86e6019fdb95 upstream.

As now we also need to probe in the reset driver as well.

Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Allison Randal <allison@lohutok.net>
Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-clk@vger.kernel.org
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Link: https://lkml.kernel.org/r/20191001182546.70090-1-john.stultz@linaro.org
[sboyd@kernel.org: Add comment about reset driver]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Cc: Yongqin Liu <yongqin.liu@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/hisilicon/clk-hi6220.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/clk/hisilicon/clk-hi6220.c
+++ b/drivers/clk/hisilicon/clk-hi6220.c
@@ -86,7 +86,8 @@ static void __init hi6220_clk_ao_init(st
 	hisi_clk_register_gate_sep(hi6220_separated_gate_clks_ao,
 				ARRAY_SIZE(hi6220_separated_gate_clks_ao), clk_data_ao);
 }
-CLK_OF_DECLARE(hi6220_clk_ao, "hisilicon,hi6220-aoctrl", hi6220_clk_ao_init);
+/* Allow reset driver to probe as well */
+CLK_OF_DECLARE_DRIVER(hi6220_clk_ao, "hisilicon,hi6220-aoctrl", hi6220_clk_ao_init);
 
 
 /* clocks in sysctrl */


