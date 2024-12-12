Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640102AF0E;
	Thu, 12 Dec 2024 15:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016905; cv=none; b=UnF0UC2gkgTUtYO2z1aYSZPo++y5HSHBT3wRrX0bPNWFojO1CveAAVwrJgFQoxl7pg7F1Il5fAtmV/nsHQnvqJK2JXYetbY31XLp77gVLcyA+mzW/ja6qC7F2TKF6aqa7P/AItZ1JE50dZT+P87Pe9xq6xeunVOsGbWpMypg7iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016905; c=relaxed/simple;
	bh=Oh33jIBw09Ja1Yt1VXUkkYKvs7OXwwYEuYKgeKa9tV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaEjPvkwcjceDW/nnZ5d1wQ1m6LkJCWJ7n99IGucboCIhve+UaXR84QXyla8766skK/ahL5rietz3mJp9gQ1s6bDAL6e6BpW1+fdPGpUEtAl3tUnK7jsVbTubI43pi/anRR0LX/wQDRmKgV7HjodZnw/hM79Cxzr/kSRajkjCPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrW/NqEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrW/NqEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74246C4CECE;
	Thu, 12 Dec 2024 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016904;
	bh=Oh33jIBw09Ja1Yt1VXUkkYKvs7OXwwYEuYKgeKa9tV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrW/NqEE1uhDl+Bhd0hSdzvhj/k1vgn7dwAILePhGG3VfbcsrJV7y83/r4VskA9ah
	 Vn/3izj6uHll5v76tbidnXdJfw3sXpfaeeAXOm5vl8JRD3uhgFSMAyQa/v9OhIf2P+
	 tsFrlxpV2Zuk2O52/4WhgTlzWT48rPvfqkmqgmos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/466] ASoC: sdw_utils: Add support for exclusion DAI quirks
Date: Thu, 12 Dec 2024 15:57:48 +0100
Message-ID: <20241212144318.595807904@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 3d9b44d0972be1298400e449cfbcc436df2e988e ]

The system contains a mechanism for certain DAI links to be included
based on a quirk. Add support for certain DAI links to excluded based on
a quirk, this is useful in situations where the vast majority of SKUs
utilise a feature so it is easier to quirk on those that don't.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241016030344.13535-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc_sdw_utils.h       | 1 +
 sound/soc/sdw_utils/soc_sdw_utils.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/sound/soc_sdw_utils.h b/include/sound/soc_sdw_utils.h
index f68c1f193b3b4..dc7541b7b6158 100644
--- a/include/sound/soc_sdw_utils.h
+++ b/include/sound/soc_sdw_utils.h
@@ -59,6 +59,7 @@ struct asoc_sdw_dai_info {
 	int (*rtd_init)(struct snd_soc_pcm_runtime *rtd, struct snd_soc_dai *dai);
 	bool rtd_init_done; /* Indicate that the rtd_init callback is done */
 	unsigned long quirk;
+	bool quirk_exclude;
 };
 
 struct asoc_sdw_codec_info {
diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index a6070f822eb9e..863b4d5527cbe 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -1112,7 +1112,8 @@ int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,
 				dai_info = &codec_info->dais[adr_end->num];
 				soc_dai = asoc_sdw_find_dailink(soc_dais, adr_end);
 
-				if (dai_info->quirk && !(dai_info->quirk & ctx->mc_quirk))
+				if (dai_info->quirk &&
+				    !(dai_info->quirk_exclude ^ !!(dai_info->quirk & ctx->mc_quirk)))
 					continue;
 
 				dev_dbg(dev,
-- 
2.43.0



