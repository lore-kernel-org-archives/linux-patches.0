Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985911A23A0;
	Fri, 19 Dec 2025 23:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185699; cv=none; b=X7IgWrIJCFwSr81mEoB8s98ZoKfg2sVNisLaqu40/RpVLdBDAr+7cI0xsWnwroY3MaLcQ86oPN7hahvjQ65VbCdQXUL2aIwYRcBvXVqmFRQWWLU3lcPgwJ/ObmQBuPIgQmvdj3RyPf5XLGe+dZ1UeeqLk+UrS80w1om83wPiaR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185699; c=relaxed/simple;
	bh=tdOyM03s/jtraJEdSS4JdOUdLDcBDqG0Tljm9PeXS14=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ZuQl1uRG0YnTPgSwPRVEeHUS7KV0DLTJ24QIr8OylCWFW6tMWNMhePkP3ro9y2r2aP30GslD2+69ZZnlmdVZcieAN7Xf7Z5JaoUXxBCM3rkj9e0OR+XzBeAcGbTkxQS4kBIvklF6J0obAqSXqcqaCO+TTegsJDIpxcSWWj8wOso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbcFOd8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbcFOd8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1F8C4CEF1;
	Fri, 19 Dec 2025 23:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766185698;
	bh=tdOyM03s/jtraJEdSS4JdOUdLDcBDqG0Tljm9PeXS14=;
	h=From:Date:Subject:To:Cc:From;
	b=bbcFOd8htkE7S4BiJO+MThR/8vhNDfwopFI6Eu5KudZE7bpSrr7zSbZLTYxMdKvm3
	 V+0NeHNPRkBRYyLiubpjAb66AnDGreh6qZHaTGdRq5AgD3dn6sYZc7UPRMEB4AtYb6
	 DCHv9pEmLJYtMxlXGeKzHQIgc3N0AVTZDfqZd2tBN1pF75WtVxampDUfcaj3N9fTw5
	 dsrK7Z7JlvnANiL9zo1t7knkEqrAbG9Gam+YdNRok2OpAe57ATfRBNb7sL3c4HuTMY
	 KisrViE1oiRLqBS4SfRq6tUjOPrq1/wtsJIPYU8ZMVgJPscPLFJsPqdKcgF7S4ulO/
	 Ui1HJHQ1QaXlQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 19 Dec 2025 16:08:08 -0700
Subject: [PATCH] ASoC: rt1320: Change return type of rt1320_t0_load() to
 void
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-rt1320-sdw-avoid-uninit-ret-v1-1-faa3e250ebc4@kernel.org>
X-B4-Tracking: v=1; b=H4sIANfaRWkC/yXMMQ7CMAwF0KtUnrFUBypRroIYQvMLZkiRnRakq
 ncnwPiWt5LDFE6nZiXDoq5TrpBdQ8M95htYUzWFNnQSpGcrsg8te3pxXCZNPGfNWthQOMoRIyS
 mrj9QHZ6GUd+//Xz52+frA0P5lrRtHzhMBuR/AAAA
X-Change-ID: 20251219-rt1320-sdw-avoid-uninit-ret-a18efe1ad594
To: Mark Brown <broonie@kernel.org>, Shuming Fan <shumingf@realtek.com>, 
 Oder Chiou <oder_chiou@realtek.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-sound@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3632; i=nathan@kernel.org;
 h=from:subject:message-id; bh=tdOyM03s/jtraJEdSS4JdOUdLDcBDqG0Tljm9PeXS14=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJmut+5vvKRSVJ9806JMepr4O5bwiYc/Kh9zT19lkXd+V
 u+U5YG6HaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAizHYM/+xfNi+JLGK5ePxP
 y6Okp8mKc4sf8rBfayrQPmthV3JztwLD/5rJXyvvKsxQb7/3a2biotIvgvL/ezbl5zIXub3avGD
 Xe0YA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y / W=e):

  sound/soc/codecs/rt1320-sdw.c:1387:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
   1387 |         if (!fw_ready) {
        |             ^~~~~~~~~
  sound/soc/codecs/rt1320-sdw.c:1421:9: note: uninitialized use occurs here
   1421 |         return ret;
        |                ^~~
  sound/soc/codecs/rt1320-sdw.c:1387:2: note: remove the 'if' if its condition is always false
   1387 |         if (!fw_ready) {
        |         ^~~~~~~~~~~~~~~~
   1388 |                 dev_warn(dev, "%s, DSP FW is NOT ready\n", __func__);
        |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1389 |                 goto _exit_;
        |                 ~~~~~~~~~~~~
   1390 |         }
        |         ~
  sound/soc/codecs/rt1320-sdw.c:1366:9: note: initialize the variable 'ret' to silence this warning
   1366 |         int ret;
        |                ^
        |                 = 0

The return value of rt1320_t0_load() is never actually used, so it can
just be eliminated altogether by returning void, clearing up the
warning.

Fixes: da1682d5e8b5 ("ASoC: rt1320: support calibration and temperature/r0 loading")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512191711.wY6XU796-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/soc/codecs/rt1320-sdw.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/rt1320-sdw.c b/sound/soc/codecs/rt1320-sdw.c
index 9447e742c672..85560455c3e3 100644
--- a/sound/soc/codecs/rt1320-sdw.c
+++ b/sound/soc/codecs/rt1320-sdw.c
@@ -1357,13 +1357,12 @@ static void rt1320_vab_preset(struct rt1320_sdw_priv *rt1320)
 	}
 }
 
-static int rt1320_t0_load(struct rt1320_sdw_priv *rt1320, unsigned int l_t0, unsigned int r_t0)
+static void rt1320_t0_load(struct rt1320_sdw_priv *rt1320, unsigned int l_t0, unsigned int r_t0)
 {
 	struct device *dev = &rt1320->sdw_slave->dev;
 	unsigned int factor = (1 << 22), fw_ready;
 	int l_t0_data[38], r_t0_data[38];
 	unsigned int fw_status_addr;
-	int ret;
 
 	switch (rt1320->dev_id) {
 	case RT1320_DEV_ID:
@@ -1374,7 +1373,7 @@ static int rt1320_t0_load(struct rt1320_sdw_priv *rt1320, unsigned int l_t0, uns
 		break;
 	default:
 		dev_err(dev, "%s: Unknown device ID %d\n", __func__, rt1320->dev_id);
-		return -EINVAL;
+		return;
 	}
 
 	regmap_write(rt1320->regmap,
@@ -1399,8 +1398,7 @@ static int rt1320_t0_load(struct rt1320_sdw_priv *rt1320, unsigned int l_t0, uns
 
 	rt1320_fw_param_protocol(rt1320, RT1320_SET_PARAM, 3, &l_t0_data[0], sizeof(l_t0_data));
 	rt1320_fw_param_protocol(rt1320, RT1320_SET_PARAM, 4, &r_t0_data[0], sizeof(r_t0_data));
-	ret = rt1320_check_fw_ready(rt1320);
-	if (ret < 0)
+	if (rt1320_check_fw_ready(rt1320) < 0)
 		dev_err(dev, "%s: Failed to set FW param 3,4!\n", __func__);
 
 	rt1320->temp_l_calib = l_t0;
@@ -1417,8 +1415,6 @@ static int rt1320_t0_load(struct rt1320_sdw_priv *rt1320, unsigned int l_t0, uns
 			SDW_SDCA_CTL(FUNC_NUM_AMP, RT1320_SDCA_ENT_PDE23,
 				RT1320_SDCA_CTL_REQ_POWER_STATE, 0), 0x03);
 	rt1320_pde_transition_delay(rt1320, FUNC_NUM_AMP, RT1320_SDCA_ENT_PDE23, 0x03);
-
-	return ret;
 }
 
 static int rt1320_rae_load(struct rt1320_sdw_priv *rt1320)

---
base-commit: a54fd483d0d5f5f620c48a29c98b013e59009a09
change-id: 20251219-rt1320-sdw-avoid-uninit-ret-a18efe1ad594

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

