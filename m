Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7496C1F76DF;
	Tue, 17 Dec 2024 17:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456826; cv=none; b=NJNoQ2jCRuOCuj5pb5954cw2woU54CgSN2IjE2JFV82pGfKP8vHWwixbmXkr/huYLOW3U7JiKnCxknnm19vhfphOTdYq1KaUA2jT4awHy74PuYn+d5XPzEwkboht8E9t39/cKvohAxEmB6U0glbWgVX91jBTaMeKZDQJwe8mzZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456826; c=relaxed/simple;
	bh=tCtLnYBs1Uxewu1ky2znIcdzi4MQn+sJ448eKI+SKh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dqJJBdOe4PcIQXAHyl5DDPSqb3SoE2Mu4XXQskegzUSV7DmUoy9oBRGov7e7tjaLL0E+q+S+fTw/tJ2B8EyEqY1uWGZUujzqOiP8JhRWwdF5jl67bdk8TSG15sUTZ/e2qXZ1hXKrOOdLWyp4L2/VbsmZpar+ACLRqAxa+RZ+Ga8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMovYu0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMovYu0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6BFC4CED3;
	Tue, 17 Dec 2024 17:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456826;
	bh=tCtLnYBs1Uxewu1ky2znIcdzi4MQn+sJ448eKI+SKh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMovYu0pp3ysvGORp54gxYKO8oDq+BWJSaO8/gsV2oPNqBAkOzJQdZj6bx6J6Owo1
	 uA+zlIJqBKu/WQT3P0dSN16On33smDAaG/Y9YEhaBOSHHxPUVR73hJGkYdkmQpFr/v
	 zfOesQm4M0GjCNXVNzOOLOeRbADfc/6gnDReW29g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/172] ASoC: Intel: sof_sdw: Add space for a terminator into DAIs array
Date: Tue, 17 Dec 2024 18:08:21 +0100
Message-ID: <20241217170552.346897612@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 255cc582e6e16191a20d54bcdbca6c91d3e90c5e ]

The code uses the initialised member of the asoc_sdw_dailink struct to
determine if a member of the array is in use. However in the case the
array is completely full this will lead to an access 1 past the end of
the array, expand the array by one entry to include a space for a
terminator.

Fixes: 27fd36aefa00 ("ASoC: Intel: sof-sdw: Add new code for parsing the snd_soc_acpi structs")
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20241212105742.1508574-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index a58842a8c8a6..db57292c00ca 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -1003,8 +1003,12 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 		return ret;
 	}
 
-	/* One per DAI link, worst case is a DAI link for every endpoint */
-	sof_dais = kcalloc(num_ends, sizeof(*sof_dais), GFP_KERNEL);
+	/*
+	 * One per DAI link, worst case is a DAI link for every endpoint, also
+	 * add one additional to act as a terminator such that code can iterate
+	 * until it hits an uninitialised DAI.
+	 */
+	sof_dais = kcalloc(num_ends + 1, sizeof(*sof_dais), GFP_KERNEL);
 	if (!sof_dais)
 		return -ENOMEM;
 
-- 
2.39.5



