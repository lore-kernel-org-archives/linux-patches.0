Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9681112DDBC;
	Tue, 14 May 2024 11:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686682; cv=none; b=mTz0cjWpKSX2AzeEgyzD1KInQLOCMowhVl5r37s/TsNgQ7RMd3XR7CPOwAW73Mj43IaAJv5vWR8Jqtk3HGfxit8+lPp0hST4ELOOXjZWw9y6S98Rv/DjxkOEEsYgTuM8sjbVeZMnZ7xNztAsbi1xGJLfoX3FB6byAcxi/Y86ohg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686682; c=relaxed/simple;
	bh=xzQML1lQr0zJg2bYyB/FHiXbOZrlZHrG4IN8KJlEn0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id7oGqEQ8kpaLJorWyHBT1lCV7Q6cOILPKk2D6XmQclwHVL7nuHhUAjPw7DafT/8HqYoitVEDw04c7ewmZ5mFg0Lb+pGKueS6AQFKSBa6vFEhJsMlXVnqIEEfAN6ML3RJdPfJ7WgFzu1HGkd7czMHO5ff/YALV0JwmeBaM7zRT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlTJqFiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlTJqFiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F46FC2BD10;
	Tue, 14 May 2024 11:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686682;
	bh=xzQML1lQr0zJg2bYyB/FHiXbOZrlZHrG4IN8KJlEn0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlTJqFiDgVh7bxxtOj33+BBz8PGjvjBvlHm34rxVBOEahZ26S0fa1fddHi7cYfH2P
	 fTvpTZCs/SZMDCP8OrPs53QoU16P1jd3vRbWwe4QnSSkBnhWutX5a4DW4Y7vAZ1bEc
	 oWykbpfeyqV/naSGxJe6LTsYAPeQwHKmzQeefkJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sameer Pujar <spujar@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 215/236] ASoC: tegra: Fix DSPK 16-bit playback
Date: Tue, 14 May 2024 12:19:37 +0200
Message-ID: <20240514101028.521536397@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sameer Pujar <spujar@nvidia.com>

commit 2e93a29b48a017c777d4fcbfcc51aba4e6a90d38 upstream.

DSPK configuration is wrong for 16-bit playback and this happens because
the client config is always fixed at 24-bit in hw_params(). Fix this by
updating the client config to 16-bit for the respective playback.

Fixes: 327ef6470266 ("ASoC: tegra: Add Tegra186 based DSPK driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://msgid.link/r/20240405104306.551036-1-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra186_dspk.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/sound/soc/tegra/tegra186_dspk.c
+++ b/sound/soc/tegra/tegra186_dspk.c
@@ -1,8 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
+// SPDX-FileCopyrightText: Copyright (c) 2020-2024 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 //
 // tegra186_dspk.c - Tegra186 DSPK driver
-//
-// Copyright (c) 2020 NVIDIA CORPORATION. All rights reserved.
 
 #include <linux/clk.h>
 #include <linux/device.h>
@@ -241,14 +240,14 @@ static int tegra186_dspk_hw_params(struc
 		return -EINVAL;
 	}
 
-	cif_conf.client_bits = TEGRA_ACIF_BITS_24;
-
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
 		cif_conf.audio_bits = TEGRA_ACIF_BITS_16;
+		cif_conf.client_bits = TEGRA_ACIF_BITS_16;
 		break;
 	case SNDRV_PCM_FORMAT_S32_LE:
 		cif_conf.audio_bits = TEGRA_ACIF_BITS_32;
+		cif_conf.client_bits = TEGRA_ACIF_BITS_24;
 		break;
 	default:
 		dev_err(dev, "unsupported format!\n");


