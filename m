Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D5B13D51C;
	Tue, 14 May 2024 11:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685942; cv=none; b=JbrI0TA0fIbhzxFDbbuG5bpD5yjjrb2KOCJRUCM3m1pyb1bzRp+i4iu5Tv+WdWBFk6hcDjPCgRyJ/Dxfaq0xfI0agesRXHSSkbD52uqZpmTVnOJ3ha/sGjgVYGY8ONKj/xQ9oUoZWq/TmdmUnGUNdfOZIjFZhEOhErHzbkSxeRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685942; c=relaxed/simple;
	bh=JUgEuSzEbwqMxQHE1bQznPO1AMU+77niJd3wdLYyUoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCoKYAR+LA2UppzH9uNuTU+9nk3FyP4MNUA8ssWVYviF5y2NFp9M3ZSiJBN23eFkPj+brrAgjI5rTfEuZj+UUBSyTKFtF7mfQNH6fbWCgCBNDR3yib9gQSNWvWGEoxnHvCV18gI333iTBSwX1WZDqrnXNSK1DrkAAzfMg0p+jyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCepl8Yh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCepl8Yh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0264DC2BD10;
	Tue, 14 May 2024 11:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685942;
	bh=JUgEuSzEbwqMxQHE1bQznPO1AMU+77niJd3wdLYyUoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCepl8Yh0HXBz7zaHAejXi9bQ3QnBbbDCcqeRtUo/LKyfENlsmAcbZDMAmwjE88/S
	 oe/yYfKJJNqdxUKq/4NugGh6JMy+sqlm2lDGvNhfmzsDZMg+T2hFn/6LFui81xnAco
	 s3z4SWdNLNqEWfTmi1aRR93kAuQsYiSGGoQFFfas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Roversi <diegor@tiscali.it>,
	Maxime Ripard <mripard@kernel.org>,
	Frank Oltmanns <frank@oltmanns.dev>,
	Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH 6.6 264/301] clk: sunxi-ng: a64: Set minimum and maximum rate for PLL-MIPI
Date: Tue, 14 May 2024 12:18:55 +0200
Message-ID: <20240514101042.224185908@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Frank Oltmanns <frank@oltmanns.dev>

commit 69f16d9b789821183d342719d2ebd4a5ac7178bc upstream.

When the Allwinner A64's TCON0 searches the ideal rate for the connected
panel, it may happen that it requests a rate from its parent PLL-MIPI
which PLL-MIPI does not support.

This happens for example on the Olimex TERES-I laptop where TCON0
requests PLL-MIPI to change to a rate of several GHz which causes the
panel to stay blank. It also happens on the pinephone where a rate of
less than 500 MHz is requested which causes instabilities on some
phones.

Set the minimum and maximum rate of Allwinner A64's PLL-MIPI according
to the Allwinner User Manual.

Fixes: ca1170b69968 ("clk: sunxi-ng: a64: force select PLL_MIPI in TCON0 mux")
Reported-by: Diego Roversi <diegor@tiscali.it>
Closes: https://groups.google.com/g/linux-sunxi/c/Rh-Uqqa66bw
Tested-by: Diego Roversi <diegor@tiscali.it>
Cc: stable@vger.kernel.org
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Frank Oltmanns <frank@oltmanns.dev>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20240310-pinephone-pll-fixes-v4-2-46fc80c83637@oltmanns.dev
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-a64.c b/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
index 8951ffc14ff5..6a4b2b9ef30a 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
@@ -182,6 +182,8 @@ static struct ccu_nkm pll_mipi_clk = {
 					      &ccu_nkm_ops,
 					      CLK_SET_RATE_UNGATE | CLK_SET_RATE_PARENT),
 		.features	= CCU_FEATURE_CLOSEST_RATE,
+		.min_rate	= 500000000,
+		.max_rate	= 1400000000,
 	},
 };
 
-- 
2.45.0



