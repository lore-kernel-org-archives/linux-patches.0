Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3897016D4C7;
	Mon,  1 Jul 2024 16:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719851067; cv=none; b=CLub7RIg8fhWBAZjGQlWFnaFzRAt5ZSzf9FwYPsewyPWNG2HpmwG6j12NNNR7Muc+AKTFxvlHYAROa9DEHIs/U5325PcEs/ClFYLCxJnSaN1cG+aFMJ8twtLkzT2BZdHuNoAYz7y55cvXyfnuJrLib2xSFzJZ/wxHNuWHRoBFDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719851067; c=relaxed/simple;
	bh=oBVFJlu3MmnNdnNe9Q9BhkVgV1GOgRax+RD1hh59NIs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=qahsrmhxkjfKlngcQXSsWboxaXcosh1xImTZwXkyOu6i86kaHr82csV3YbFQHmgjRODf3Mm8fwILpF8OkqUcPquIwxp1pSjfYzc+ZFM99AFJdSsxGl/Q4qIrcG1p9/6+FBVYxlvPwLdsTG4ddjA2UB7I7RFpJRHsT5QDmHZtzfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNfaOgTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNfaOgTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F67C116B1;
	Mon,  1 Jul 2024 16:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719851065;
	bh=oBVFJlu3MmnNdnNe9Q9BhkVgV1GOgRax+RD1hh59NIs=;
	h=From:Date:Subject:To:Cc:From;
	b=MNfaOgTI38XHbTvoSalMKLauxUd+9J/w1Q99eE96NJCsllyoTZgXBI6Sy4yc5ZAWz
	 9lhd7stnTg5qOwtBlWhzRf1bZEBM2Z1+KvGrt35Pga41dHChLFpsASxl2s7rcG5WEd
	 IjTwmuvK9w6t2J3u5OVbPThQV2tY13Pro0/kDpUpeRyNlgPqSg4MZKVN3fUJHcLynI
	 uM2rFprmO8AIyyoheuuoCfSd2mPaz4x/Fu1dYLf3ndPBr+SxBUowtowO8S2yRpptyQ
	 /RZPof4m2qkjmhkp5DlG79wllZAAWMyyC+6SIlZNoY6TuR0RRpLC07brLaOhD0aXAo
	 ZQkCdYNG01+ZQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 01 Jul 2024 09:24:16 -0700
Subject: [PATCH] ASoC: fsl: lpc3xxx-i2s: Avoid using ret uninitialized in
 lpc32xx_i2s_probe()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240701-lpc32xx-asoc-fix-uninitialized-ret-v1-1-985d86189739@kernel.org>
X-B4-Tracking: v=1; b=H4sIAC/YgmYC/x2NzQqDMBAGX0X23IVN/ANfpfQQkm39QKIkVoLiu
 zf0ODDMXJQ1QTNNzUVJD2SssYJ5NORnFz/KCJXJiu1kFMPL5ltbCru8en6j8DciYodbcGrgpDt
 3o0gYQt8P3lANbUmr+J88X/f9AyTAwd50AAAA
To: "J.M.B. Downing" <jonathan.downing@nautel.com>, 
 Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>, 
 Mark Brown <broonie@kernel.org>
Cc: Vladimir Zapolskiy <vz@mleia.com>, Liam Girdwood <lgirdwood@gmail.com>, 
 alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org, 
 linux-sound@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2122; i=nathan@kernel.org;
 h=from:subject:message-id; bh=oBVFJlu3MmnNdnNe9Q9BhkVgV1GOgRax+RD1hh59NIs=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGlNNyxOBzy1UVET3irgUXTDdu7+cq5F79i0f9i/ydsUF
 LG55862jlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRp0cZGXr631qo3FnZemTN
 5k6jhZ1rBSbECur+dFZelzgnU3eH3T9GhjX3eNamS0ZNeMxY1K8eef8+q6tI9MMgwRiFpSrX8rh
 d2QE=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

clang points out that ret may be used uninitialized in
lpc32xx_i2s_probe() in an error pointer path (which becomes fatal with
CONFIG_WERROR):

  sound/soc/fsl/lpc3xxx-i2s.c:326:47: error: variable 'ret' is uninitialized when used here [-Werror,-Wuninitialized]
    326 |                                      "failed to init register map: %d\n", ret);
        |                                                                           ^~~
  sound/soc/fsl/lpc3xxx-i2s.c:310:9: note: initialize the variable 'ret' to silence this warning
    310 |         int ret;
        |                ^
        |                 = 0
  1 error generated.

One solution would be a small refactoring of the second parameter in
dev_err_probe(), PTR_ERR(i2s_info_p->regs), to be the value of ret in
the if statement. However, a nicer solution for debugging purposes,
which is the point of this statement, would be to use the '%pe'
specifier to symbolically print the error pointer value. Do so, which
eliminates the uninitialized use of ret, clearing up the warning.

Fixes: 0959de657a10 ("ASoC: fsl: Add i2s and pcm drivers for LPC32xx CPUs")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/soc/fsl/lpc3xxx-i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/lpc3xxx-i2s.c b/sound/soc/fsl/lpc3xxx-i2s.c
index 0e5b4d5202ff..af995ca081a3 100644
--- a/sound/soc/fsl/lpc3xxx-i2s.c
+++ b/sound/soc/fsl/lpc3xxx-i2s.c
@@ -323,7 +323,7 @@ static int lpc32xx_i2s_probe(struct platform_device *pdev)
 	i2s_info_p->regs = devm_regmap_init_mmio(dev, iomem, &lpc32xx_i2s_regconfig);
 	if (IS_ERR(i2s_info_p->regs))
 		return dev_err_probe(dev, PTR_ERR(i2s_info_p->regs),
-				     "failed to init register map: %d\n", ret);
+				     "failed to init register map: %pe\n", i2s_info_p->regs);
 
 	i2s_info_p->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(i2s_info_p->clk))

---
base-commit: 878f4c36f9235e8a15fe0c2ecde066d92c50c8ff
change-id: 20240701-lpc32xx-asoc-fix-uninitialized-ret-4700d6d556c1

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

