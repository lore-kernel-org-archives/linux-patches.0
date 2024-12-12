Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5476222D66;
	Thu, 12 Dec 2024 16:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022327; cv=none; b=XwMjbhEc4k/PYKClnoDi8a53nUicHESDAtHMspj8qOHd3eo8SEQ2FykFngfHpDu5bTNS7w1js4VDzngY931ilhkj5HkQKa1LuXgH4viQ3sBDzNalVv5SuNeSdbKBTXpiYed3Pyb9O4GLxqKTy4Eso29L0VfnHCBSsmkVtUfhPSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022327; c=relaxed/simple;
	bh=jv0u0Q93DCo+cjyKn9BRlDfWNwDwpB3BSQZMHELIdRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKsPK8+6eR6BGwV/gvcTGowQIpIgWPTEjUnmRFGQYsmk0HyVRSCPiV+PNC95zwFtH9jSX27CenbuFP9gLsqwrMClCtYH1KiF1r4bzHhYazN+79/m1waxoWuu76l/U8v1dTYGfmWB3o4Gb761dtf4DXag6+ntNvryK0AF7KPSE4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0h+o+Trg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0h+o+Trg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3DBC4CED0;
	Thu, 12 Dec 2024 16:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022327;
	bh=jv0u0Q93DCo+cjyKn9BRlDfWNwDwpB3BSQZMHELIdRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0h+o+TrgiV5043gptlZr7IMn7u7eHPElMOngaXliCa/FVVDhP1fNrlLI9RG8eIG0H
	 xKhQmIJf30kuszDoqnu5D/+xPPkKUgu5Rp55fkQttppmI1N5uOoz/XGOFGO682hUDW
	 Lc3pshugGFy9TTahP0u15yZQDoeg/lFlSSAwxSNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 210/565] pinctrl: zynqmp: drop excess struct member description
Date: Thu, 12 Dec 2024 15:56:45 +0100
Message-ID: <20241212144319.798041100@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 2a85fc7044987d751f27d7f1e4423eebbcecc2c6 ]

The 'node' member has never been part of this structure so drop its
description.

Fixes: 8b242ca700f8 ("pinctrl: Add Xilinx ZynqMP pinctrl driver support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/20241010080432.7781-1-brgl@bgdev.pl
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-zynqmp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-zynqmp.c b/drivers/pinctrl/pinctrl-zynqmp.c
index e14012209992f..9bd3e663ab08e 100644
--- a/drivers/pinctrl/pinctrl-zynqmp.c
+++ b/drivers/pinctrl/pinctrl-zynqmp.c
@@ -45,7 +45,6 @@
  * @name:	Name of the pin mux function
  * @groups:	List of pin groups for this function
  * @ngroups:	Number of entries in @groups
- * @node:	Firmware node matching with the function
  *
  * This structure holds information about pin control function
  * and function group names supporting that function.
-- 
2.43.0



