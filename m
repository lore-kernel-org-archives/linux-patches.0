Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ABE34F47C;
	Fri, 21 Nov 2025 13:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732981; cv=none; b=LFPo/MymLLOKH8Iv1irq3YDiDcaZ6y3I+DsMpjiuWVbP2W9zCoW3EOffFZMhyxSVaIBDBif8P6yRYkEvLJpMOaK6SPZ+PFAJl7TxPWnLpUvCADx/IRAEjpvcVN+CJT/HXqDWOkCap6hSBSvnB5V5QOt1L2KpNeq5momY5pvpVCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732981; c=relaxed/simple;
	bh=/EwVtc2KBVsQwGz46pDJQKHqrhHuSCkaAxwCLYzJ3ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8+wbFywk3ilCFMpJxatd9tNgPB2ncn8HFPw4/YiipW91iTpgz7+8Mj/UeonmhHOGd4PNG6PH6wJLK0+Qei55XDGMX263qNaBLt9MDDbkt8mHQleX69/GO7ptC9ninnyRNXY++znuH510IeSSZrrJEd1SSuMnkd8BZ3mvZx6Rq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8lHxtYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8lHxtYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B321AC4CEF1;
	Fri, 21 Nov 2025 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732981;
	bh=/EwVtc2KBVsQwGz46pDJQKHqrhHuSCkaAxwCLYzJ3ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8lHxtYuVCOZV3fGtvxTWCek21BENa5pUbankARpdWUA4Di3SobTEhZSoXKuT/Nit
	 1XTSl5L8AiG3GXcRcOapX7xt8BzeewW3AePeJ9aIOsvxCNtJTHVHQbulldI8xUVe3K
	 O2Sd4FLnTy6bfNKRTSYNFBSMPr5bQRpGvUxGEGMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 308/529] clk: sunxi-ng: sun6i-rtc: Add A523 specifics
Date: Fri, 21 Nov 2025 14:10:07 +0100
Message-ID: <20251121130241.983947319@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 7aa8781f379c32c31bd78f1408a31765b2297c43 ]

The A523's RTC block is backward compatible with the R329's, but it also
has a calibration function for its internal oscillator, which would
allow it to provide a clock rate closer to the desired 32.768 KHz. This
is useful on the Radxa Cubie A5E, which does not have an external 32.768
KHz crystal.

Add new compatible-specific data for it.

Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20250909170947.2221611-1-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun6i-rtc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/clk/sunxi-ng/ccu-sun6i-rtc.c b/drivers/clk/sunxi-ng/ccu-sun6i-rtc.c
index fdc8ccc586c99..ec1717ddaf275 100644
--- a/drivers/clk/sunxi-ng/ccu-sun6i-rtc.c
+++ b/drivers/clk/sunxi-ng/ccu-sun6i-rtc.c
@@ -325,6 +325,13 @@ static const struct sun6i_rtc_match_data sun50i_r329_rtc_ccu_data = {
 	.osc32k_fanout_nparents	= ARRAY_SIZE(sun50i_r329_osc32k_fanout_parents),
 };
 
+static const struct sun6i_rtc_match_data sun55i_a523_rtc_ccu_data = {
+	.have_ext_osc32k	= true,
+	.have_iosc_calibration	= true,
+	.osc32k_fanout_parents	= sun50i_r329_osc32k_fanout_parents,
+	.osc32k_fanout_nparents	= ARRAY_SIZE(sun50i_r329_osc32k_fanout_parents),
+};
+
 static const struct of_device_id sun6i_rtc_ccu_match[] = {
 	{
 		.compatible	= "allwinner,sun50i-h616-rtc",
@@ -334,6 +341,10 @@ static const struct of_device_id sun6i_rtc_ccu_match[] = {
 		.compatible	= "allwinner,sun50i-r329-rtc",
 		.data		= &sun50i_r329_rtc_ccu_data,
 	},
+	{
+		.compatible	= "allwinner,sun55i-a523-rtc",
+		.data		= &sun55i_a523_rtc_ccu_data,
+	},
 	{},
 };
 
-- 
2.51.0



