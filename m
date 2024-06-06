Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6111C8FA0;
	Thu,  6 Jun 2024 14:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683718; cv=none; b=VsKoT/XbsYMkiwARpcxZa00RrTi8HoyV7A5fECUoQI+Ds6rXRzSHD40R+ymNlMrMlrCw8xV+KDJm2Oo+SzUWk9h4JZScQSItrU3UyTPWJcEhOIrsbj7njfRAakL+Dq4N6zOUVz2qd4BWe6q8bNv8RS1xvp+dhrStxgwhiPPYYXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683718; c=relaxed/simple;
	bh=vf0fp0y+PF6ys44toNb1BsjFPtpGQ19XGNKhbkvp87w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1bYiVgFVJRhxnPhv+q8Xy70rnc+881aXtg3buE8jkU7hjMtWfduMzGFgvuNHCaCl5OCfLUFdIT4zJUvitFDWktEjQMexDVAARIKS44TP4/wGXEXyiTcNUtYLbg6gYGjabVmcmE79fxZKH8ZSUEDmwFPvmcIQt/Rd//gmCi870Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShSEYXlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShSEYXlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA44C32781;
	Thu,  6 Jun 2024 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683717;
	bh=vf0fp0y+PF6ys44toNb1BsjFPtpGQ19XGNKhbkvp87w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShSEYXlqWg4Db2P6rdSXevLOtY71YgzNA4CT1QGkLaw0h05Coxwtdp7zK0v0V0HFH
	 6hGtsqVbkgt+zzuarL+60XjnZBLd5M2QlE/fZ/AhVNz9uVjB43VIR/y523wNtRPeP1
	 x8eSwMmK/l8i1di6cNCXC4f4KCH4Z0movV8c8KJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 615/744] ASoC: tas2781: Fix a warning reported by robot kernel test
Date: Thu,  6 Jun 2024 16:04:47 +0200
Message-ID: <20240606131752.228323254@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 61b05629a9a9c..a7ae4005d83f4 100644
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
 
@@ -1908,7 +1908,7 @@ int tas2781_load_calibration(void *context, char *file_name,
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



