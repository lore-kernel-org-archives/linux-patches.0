Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017856;
	b=Qrkoz0Xm6xLTTJvAs3LLYqITtS7cmyZHATWUsUP6Puom04jZwpNns3x3J/Ti2y1Zajlt
	 /PMI+tQDUZnAw0vW7P2WNimOl2iP9HiGstaoQ/aSrVx9OYAFXcvl+NRPNuIJxcfich67D
	 R6QI5iCZTc0AWwUycDOkhnsjEnNaO/Bayp2aWhE5xADCHGgUPriVwl10ZCohc4L7mz/1y
	 /25TJSYgSz9CspktarRo0S0go/PSg1FOyASBrq3qFKJtVpX/z4s+5DseDBoXK5vq8Xo/V
	 LFCVIJrr60hUlhJKYHHyXGw8b3KllYm7D8UtUd9GID3qxrccJUTcDelw65K/Ess9xfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mXWHb5ETncfJQfxsLo19cZ95DvseVY6toDPeaMdoXj0=;
	b=GrIh2sTBczS62hb6CxmTxwlMOZbcmvUW542iEgyD2F+WF4B/Z7n42RcMfcqym/9bs28/
	 Fl2JflSLUeDYUr3dYxr852BdQE/sUX2Wo+LH9lYY1EM5O4ma43lsZCDuAk1yT1lnpbDqp
	 akQj6Yf5zK9691N7BA8jLjhoZFtyTh38mkf9EIA6REfa20ZJ0ZhVu9bNqkcu7crCpPzp3
	 5fIeXuXf6TuSsN260kY35XwhLqG/j6RO8smh6Wj6+jMGwzt2ofP1Lp5lvTVBzuYaqDX8L
	 W0DOt5EoBXjlAlWml0bev6opuaJtZ2nzVN+PcXJ9TSpBsHbW62G1H5c0+zW24BH7Hvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CUWUCgns;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EFA606A31C;
	Wed, 18 Nov 2026 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CUWUCgns
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B3C1F000C4;
	Wed, 18 Nov 2026 16:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017856;
	bh=mXWHb5ETncfJQfxsLo19cZ95DvseVY6toDPeaMdoXj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUWUCgns5mpc5rfzFuZgpA6bWa3tICakyPFNH9j6dsCXq+kB3SrzbCQ1ag+BCWyHl
	 C+OVSTznMRlPtWXLGqKZNZBxIcBuO5QZNLGSpk7cj37PaVeBoAoO3CUZ0LxGB75lKx
	 Zmp9eDgfe8tXS9BatEJ3XuoZI36JHBeOSIrIhUs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Peng Fan <peng.fan@nxp.com>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1032/2651] clk: validate spread spectrum configuration
Date: Wed, 18 Nov 2026 15:37:52 +0100
Message-ID: <20261118150325.118206976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 109124b8ff43fb911d5b8790bb5e4c5684f72d88 ]

The spread spectrum configuration is passed to the provider's
set_spread_spectrum() callback without any validation, as clk-conf.c
only skips all-zero triplets from "assigned-clock-sscs". An invalid
device tree can hand providers a zero modulation frequency or a spread
ratio above 100%, and each provider would have to add the same checks
to protect e.g. divisions in its rate computations.

The KUnit test data for assigned-clock-sscs uses spread values of 30000
and 40000 permyriad (300% and 400%), which the new check rejects, as
reported by Sashiko, so fix them to 300 and 400 (3% and 4%). Also use
a realistic 6% value for the initial settings of the skip tests, for
consistency.

Fixes: c86814e70390 ("clk: Introduce clk_hw_set_spread_spectrum")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260901155657.6A5981F00A3A@smtp.kernel.org
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c                      | 14 ++++++++++++++
 drivers/clk/clk_test.c                 | 12 ++++++------
 drivers/clk/kunit_clk_assigned_rates.h |  4 ++--
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8cb2c450ebd34..d045e8d3222b7 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2852,6 +2852,20 @@ int clk_hw_set_spread_spectrum(struct clk_hw *hw, const struct clk_spread_spectr
 	if (!hw)
 		return 0;
 
+	switch (ss_conf->method) {
+	case CLK_SPREAD_NO:
+		break;
+	case CLK_SPREAD_CENTER:
+	case CLK_SPREAD_UP:
+	case CLK_SPREAD_DOWN:
+		if (!ss_conf->modfreq_hz || !ss_conf->spread_bp ||
+		    ss_conf->spread_bp > 10000)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	core = hw->core;
 
 	clk_prepare_lock();
diff --git a/drivers/clk/clk_test.c b/drivers/clk/clk_test.c
index 1c5c8b7c1f3c1..21e62d68f87fa 100644
--- a/drivers/clk/clk_test.c
+++ b/drivers/clk/clk_test.c
@@ -3526,7 +3526,7 @@ static const struct clk_assigned_rates_test_param clk_assigned_sscs_skips_test_p
 		 */
 		.desc = "provider missing assigned-clocks",
 		TEST_PARAM_OVERLAY(kunit_clk_assigned_sscs_without),
-		.sscs = {50000, 60000, 3},
+		.sscs = {50000, 600, 3},
 	},
 	{
 		/*
@@ -3535,7 +3535,7 @@ static const struct clk_assigned_rates_test_param clk_assigned_sscs_skips_test_p
 		 */
 		.desc = "consumer missing assigned-clocks",
 		TEST_PARAM_OVERLAY(kunit_clk_assigned_sscs_without_consumer),
-		.sscs = {50000, 60000, 3},
+		.sscs = {50000, 600, 3},
 		.consumer_test = true,
 	},
 	{
@@ -3545,7 +3545,7 @@ static const struct clk_assigned_rates_test_param clk_assigned_sscs_skips_test_p
 		 */
 		.desc = "provider assigned-clock-sscs of zero",
 		TEST_PARAM_OVERLAY(kunit_clk_assigned_sscs_zero),
-		.sscs = {50000, 60000, 3},
+		.sscs = {50000, 600, 3},
 	},
 	{
 		/*
@@ -3554,7 +3554,7 @@ static const struct clk_assigned_rates_test_param clk_assigned_sscs_skips_test_p
 		 */
 		.desc = "consumer assigned-clock-sscs of zero",
 		TEST_PARAM_OVERLAY(kunit_clk_assigned_sscs_zero_consumer),
-		.sscs = {50000, 60000, 3},
+		.sscs = {50000, 600, 3},
 		.consumer_test = true,
 	},
 	{
@@ -3564,7 +3564,7 @@ static const struct clk_assigned_rates_test_param clk_assigned_sscs_skips_test_p
 		 */
 		.desc = "provider assigned-clocks null phandle",
 		TEST_PARAM_OVERLAY(kunit_clk_assigned_sscs_null),
-		.sscs = {50000, 60000, 3},
+		.sscs = {50000, 600, 3},
 	},
 	{
 		/*
@@ -3573,7 +3573,7 @@ static const struct clk_assigned_rates_test_param clk_assigned_sscs_skips_test_p
 		 */
 		.desc = "consumer assigned-clocks null phandle",
 		TEST_PARAM_OVERLAY(kunit_clk_assigned_sscs_null_consumer),
-		.sscs = {50000, 60000, 3},
+		.sscs = {50000, 600, 3},
 		.consumer_test = true,
 	},
 };
diff --git a/drivers/clk/kunit_clk_assigned_rates.h b/drivers/clk/kunit_clk_assigned_rates.h
index d7ae5ec2d25be..c5d9f004ee815 100644
--- a/drivers/clk/kunit_clk_assigned_rates.h
+++ b/drivers/clk/kunit_clk_assigned_rates.h
@@ -9,10 +9,10 @@
 #define ASSIGNED_RATES_1_RATE		9700000
 
 #define ASSIGNED_SSCS_0_MODFREQ		10000
-#define ASSIGNED_SSCS_0_SPREAD		30000
+#define ASSIGNED_SSCS_0_SPREAD		300
 #define ASSIGNED_SSCS_0_METHOD		CLK_SSC_CENTER_SPREAD
 #define ASSIGNED_SSCS_1_MODFREQ		20000
-#define ASSIGNED_SSCS_1_SPREAD		40000
+#define ASSIGNED_SSCS_1_SPREAD		400
 #define ASSIGNED_SSCS_1_METHOD		CLK_SSC_UP_SPREAD
 
 #endif
-- 
2.53.0



