Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F761E2606;
	Wed, 23 Apr 2025 17:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745430123; cv=none; b=ebaxZ+FX2NNiXiXgEkdQP6TL+rHAWpv4Z5e9fMubylECYE/6Li7GWFKjw+GCyrFW5H+BxSHTxnTZgdpUarUOZQL6OzntWaK75quSjoUw5lNADf7D2nOZlNxTo4gig626jMSraIUIyt+JpwBUgOH02YOoLPKDxhMacUbKlCW1kJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745430123; c=relaxed/simple;
	bh=NTrHTWzZvM5uXlSAI972iPQd+fZJob+j5Vq6RPGax0M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hgmooKWG/c+d0Zo+TJvUicJeeSkbKWn84s0fhsySpOMKm5Z26nRUdlg2Kp/pPBxQ5IlNYgKkyAPRo9AVhk6ql/La1npL08oGIxtkPr1K9O7AXxBntIyDcxjNyLHr9h6W+LDYDQm6bjQObqXTZTRk4+sOB62FgtE9V+WESutRKG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAQTSii+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAQTSii+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8DAC4CEF1;
	Wed, 23 Apr 2025 17:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745430122;
	bh=NTrHTWzZvM5uXlSAI972iPQd+fZJob+j5Vq6RPGax0M=;
	h=From:Date:Subject:To:Cc:From;
	b=VAQTSii+LS2I6aFsl0M+J8l2PVEuUc5qeEWUvPrUrX2kvohWAGg1+7lFyzEFMTAcZ
	 +JNT1vz3255ll1UgD4H601JjnJ5rUGNgfHA14lmkC8AjVY1Al4BG37Sm2fq7p2J2ME
	 e3oC3E1SoOLLzd4niquO1i2OZKqcdRPd/ZBIZKtpZzrPJEtfxidujnhnpJrd5zwhFG
	 8E/NjhwFBqFf1cdPdUx8+DIc0aSCZZwGzY5/nQfa3BoE7kCntWMrjIAbqVmCA9ayUi
	 ZSpWVeWi0GXzyCFCYy5BaBd/e1I8EmlnzmMZwjcRb2AMH35MWhik5R31FdLtCLaAdQ
	 du8/16Gho/jHA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 23 Apr 2025 10:41:41 -0700
Subject: [PATCH v2] drm/panel: himax-hx8279: Always initialize
 goa_{even,odd}_valid in hx8279_check_goa_config()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250423-panel-himax-hx8279-fix-sometimes-uninitialized-v2-1-fc501c6558d9@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFQmCWgC/52NQQ6CMBBFr0K6dkw7gIgr72FYFDrQiVBIiwQl3
 N3KEVy+n5/3NhHIMwVxSzbhaeHAo4uAp0Q0VruOgE1kgRJzmSHCpB31YHnQK9j1ikUJLa8QxoF
 mHijAy7HjmXXPHzKAskjzrK3LVDYiSidP8X4EH1Vky2Ee/fvoL+q3/p1aFCi4qMzUWmGdSnN/k
 o+G8+g7Ue37/gUK8aoD7QAAAA==
X-Change-ID: 20250422-panel-himax-hx8279-fix-sometimes-uninitialized-207354fb930c
To: Neil Armstrong <neil.armstrong@linaro.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jessica Zhang <quic_jesszhan@quicinc.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3423; i=nathan@kernel.org;
 h=from:subject:message-id; bh=NTrHTWzZvM5uXlSAI972iPQd+fZJob+j5Vq6RPGax0M=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmcahkrdd8e7uavnvmBY1LhxmWeO088fcfye/Ei7Ql3V
 +oyy5nYdZSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJ6Hgy/E89ft14erP9+vez
 arQ9vPrEDv4+VZvfz9w9P29ZpuFvNRGG/7Eb/176e/fqrp6fiosO/Null3BmcvrTyD1Z39QlDl7
 KFWUGAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/gpu/drm/panel/panel-himax-hx8279.c:838:6: error: variable 'goa_even_valid' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
    838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/panel/panel-himax-hx8279.c:842:23: note: uninitialized use occurs here
    842 |         if (goa_odd_valid != goa_even_valid)
        |                              ^~~~~~~~~~~~~~
  drivers/gpu/drm/panel/panel-himax-hx8279.c:838:2: note: remove the 'if' if its condition is always true
    838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    839 |                 goa_even_valid = false;
  drivers/gpu/drm/panel/panel-himax-hx8279.c:818:36: note: initialize the variable 'goa_even_valid' to silence this warning
    818 |         bool goa_odd_valid, goa_even_valid;
        |                                           ^
        |                                            = 0

Even though only the even valid variable gets flagged, both valid
variables appear to have the same issue of possibly being used
uninitialized if the if statement initializing them to false is not
taken.

Turn the if statement then variable assignment into a single variable
assignment, which states that the configuration is valid when there are
not all zeros, clearing up the warning since the variable will always be
initialized.

Fixes: 38d42c261389 ("drm: panel: Add driver for Himax HX8279 DDIC panels")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v2:
- Initialize valid variables once using the inverse of the current
  condition (Angelo).
- Link to v1: https://lore.kernel.org/r/20250422-panel-himax-hx8279-fix-sometimes-uninitialized-v1-1-614dba12b30d@kernel.org
---
 drivers/gpu/drm/panel/panel-himax-hx8279.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-himax-hx8279.c b/drivers/gpu/drm/panel/panel-himax-hx8279.c
index b48b350b62da..fb302d1f91b9 100644
--- a/drivers/gpu/drm/panel/panel-himax-hx8279.c
+++ b/drivers/gpu/drm/panel/panel-himax-hx8279.c
@@ -825,8 +825,7 @@ static int hx8279_check_goa_config(struct hx8279 *hx, struct device *dev)
 			num_zero++;
 	}
 
-	if (num_zero == ARRAY_SIZE(desc->goa_odd_timing))
-		goa_odd_valid = false;
+	goa_odd_valid = (num_zero != ARRAY_SIZE(desc->goa_odd_timing));
 
 	/* Up to 3 zeroes is a valid config. Check them all. */
 	num_zero = 1;
@@ -835,8 +834,7 @@ static int hx8279_check_goa_config(struct hx8279 *hx, struct device *dev)
 			num_zero++;
 	}
 
-	if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
-		goa_even_valid = false;
+	goa_even_valid = (num_zero != ARRAY_SIZE(desc->goa_even_timing));
 
 	/* Programming one without the other would make no sense! */
 	if (goa_odd_valid != goa_even_valid)

---
base-commit: dcbd5dcc956e2331414fd7020b4655df08deeb87
change-id: 20250422-panel-himax-hx8279-fix-sometimes-uninitialized-207354fb930c

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

