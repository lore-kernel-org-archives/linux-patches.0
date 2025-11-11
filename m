Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB84E263F28;
	Tue, 11 Nov 2025 01:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824544; cv=none; b=Jb1MyvdbpmM4wEw7Te5Pmqm8lhszyrzcr+C2+/NPlRIJbDl7bOUJHTw06oj/wuZeDHUbcg2GeGIZ3ObH7NGsDa59CiIcxVZxv32E04jzWTGZHp0jS29+zZBvQouIEP3D1NP77ABUDq7PzwxJYk8vlDz6ARFh+rvK5pvd86TbpQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824544; c=relaxed/simple;
	bh=Ty+nRpOiBBeQn29wGZuUzB+8T2aiRwob0zeFSRNzwl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rd15gNkK+qWdEcNidkgWQnvoaSy4uzoWD0NQYhkxgUAOlC+3BpnN0vf9YngxF91BLbD9DaerFBCWqXX8zRe4jFMFO6o8X1pe9SOaqPnMsQPD/NhL9e535OGWLAJPVzTBixhf5ESI8kBty/Y4YdGzj/GkCJg/OH6kkBSMN+XKUZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRO4TlEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRO4TlEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8CAC116D0;
	Tue, 11 Nov 2025 01:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824544;
	bh=Ty+nRpOiBBeQn29wGZuUzB+8T2aiRwob0zeFSRNzwl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRO4TlEF/n6QiH8sj1EYpi2uB1FJb2een2vVc/h0zLtAPfHqhZAr0ZPLW2JPuPGSz
	 6U8sqpMbNwtlrHJyvkrH0sN/Lv9YYOg9hzcIl78cJHSMTxSz6eljT3CZCbG6SWDHpQ
	 heXhuc2lZZdeoZBD4ErANcFPB2MPPe21hKGB9s2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 466/565] clk: sunxi-ng: sun6i-rtc: Add A523 specifics
Date: Tue, 11 Nov 2025 09:45:22 +0900
Message-ID: <20251111004537.385017383@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 87e23d16ed0f3..50a85f33b8fbb 100644
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
 MODULE_DEVICE_TABLE(of, sun6i_rtc_ccu_match);
-- 
2.51.0



