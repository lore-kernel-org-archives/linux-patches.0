Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C296196D99;
	Thu,  6 Jun 2024 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683003; cv=none; b=XysRN8H2bFYb034OXId/dQlW5vL98Xs/Kowy6gjoypACBrBwiTcoYh/bZnyASZFi6WfDRaIU+lOhLD3B3jjPmFySfS/oI2/U6rDrNvptX3OivCfDO5jRU4wQ2QQWV+LqNKpYNrdaHqVkcwBsWwpDfwp3GyZq6eVJcw9rVADTXpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683003; c=relaxed/simple;
	bh=cfvZ2qI/d9h+AE7oVrl2COXYp1hsRCz5Ej1JXoM5rMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDMB8U2aq3aTv+aCGKtV07ZbUe5ryymt3PY8j+RQUnX9dcJ6k7hfqf+luxMboyTi6ed/0KW9whbIuIsB49HHWV6Pmc9QvA/8EihdQWlcfPNGdTA2rLzoG7QTh7ji3/zLpLNTxB3LlQ98oltyI5a9/npgESmXuO5PlYhRRN98sFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUEqhSUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUEqhSUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A62C2BD10;
	Thu,  6 Jun 2024 14:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683003;
	bh=cfvZ2qI/d9h+AE7oVrl2COXYp1hsRCz5Ej1JXoM5rMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUEqhSUGdOlkBICC/f5Im6z0IeOnFwM9JxSxc/AZ+grzmJQ+ruHTRMnFbbK+dPaU0
	 kbqdwCtvOyd04P5DhLNtViESWPXXhBFwxl7u+/U98h7Y3xueRVv1INvAm/PkZ3KYcE
	 LQTHv7s7QKHcySPCaK8x74u7lQ5bAQBMVTNT0OSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 208/374] ASoC: tas2781: Fix a warning reported by robot kernel test
Date: Thu,  6 Jun 2024 16:03:07 +0200
Message-ID: <20240606131658.790702461@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 1ae14f3520b1a0ad144610a3f592c81a3e81cd1b ]

Fix a warning reported by robot kernel test that 'fw_entry' in function
'tas2781_load_calibration' is used uninitialized with compiler
sh4-linux-gcc (GCC) 13.2.0, an update of copyright and a correction of the
comments.

Fixes: ef3bcde75d06 ("ASoc: tas2781: Add tas2781 driver")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://lore.kernel.org/r/20240505122346.1326-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-fmwlib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 45760fe195237..a6be81adcb839 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 //
-// tasdevice-fmw.c -- TASDEVICE firmware support
+// tas2781-fmwlib.c -- TASDEVICE firmware support
 //
-// Copyright 2023 Texas Instruments, Inc.
+// Copyright 2023 - 2024 Texas Instruments, Inc.
 //
 // Author: Shenghao Ding <shenghao-ding@ti.com>
 
@@ -1878,7 +1878,7 @@ int tas2781_load_calibration(void *context, char *file_name,
 {
 	struct tasdevice_priv *tas_priv = (struct tasdevice_priv *)context;
 	struct tasdevice *tasdev = &(tas_priv->tasdevice[i]);
-	const struct firmware *fw_entry;
+	const struct firmware *fw_entry = NULL;
 	struct tasdevice_fw *tas_fmw;
 	struct firmware fmw;
 	int offset = 0;
-- 
2.43.0



