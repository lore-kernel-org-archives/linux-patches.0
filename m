Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3935729A1;
	Tue, 17 Feb 2026 20:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361567; cv=none; b=ZxW07TKVBQo4xg/eSxCJ2rzNZKNd5vRA+pjiHXHJdlJhYOo9UTtHlvSDdvDR7LCs6KTqA4kKlHFznHXLsJD+zzQWWTAEE6S2Iw21kysE3Q/5Bdx0wYqSzBXoNtIQFLo69XEbyNLKsK1rFOECMiRxNbsNFBXDry/T8+4XSfM8PP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361567; c=relaxed/simple;
	bh=5jWRvtHplZNuWPZFdO//MUrPJJKbj9KCIE2NDd1Az+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUZAHYugXUK+D942VOUc4aiVEfWNxM4Zt7rqCRr4bBfBtKxnnwEO6M0K7+JH12f6J/lSyhxQGWDakkVxUmNeRLfHGcOhvcBigbofQah6Y1Y88qcyh8xrhyFqHIHugRrDbh78C+vxD/OqT9zQSdbof/guXSZbr+0GbVXJAFlOYZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0JVOEKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0JVOEKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAF9C4CEF7;
	Tue, 17 Feb 2026 20:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361567;
	bh=5jWRvtHplZNuWPZFdO//MUrPJJKbj9KCIE2NDd1Az+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0JVOEKItenImDqYkH8GbPx/tFJqXZXefab8/jcSnt08UHc+tTMsfIwuzD7WbfO87
	 MAdsLkBUMHvWHDdylIfW6jNQkYwH9UG3w41GJBhyj3JwnYTCON8KkLfpkbJZNGvvo/
	 Ynd7OrxOOcEVUgn0ytVy5/VcwXWZQtwVlV2XcpxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 10/42] ASoC: cs35l45: Corrects ASP_TX5 DAPM widget channel
Date: Tue, 17 Feb 2026 21:32:01 +0100
Message-ID: <20260217200006.402224607@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>

[ Upstream commit 6dd0fdc908c02318c28ec2c0979661846ee0a9f7 ]

ASP_TX5 was incorrectly mapped to a channel value of 3 corrects,
the channel value of 4.

Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
Link: https://patch.msgid.link/20260115192523.1335742-2-rriveram@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l45.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l45.c b/sound/soc/codecs/cs35l45.c
index fa1d9d9151f96..7f295c6432b20 100644
--- a/sound/soc/codecs/cs35l45.c
+++ b/sound/soc/codecs/cs35l45.c
@@ -455,7 +455,7 @@ static const struct snd_soc_dapm_widget cs35l45_dapm_widgets[] = {
 	SND_SOC_DAPM_AIF_OUT("ASP_TX2", NULL, 1, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX2_EN_SHIFT, 0),
 	SND_SOC_DAPM_AIF_OUT("ASP_TX3", NULL, 2, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX3_EN_SHIFT, 0),
 	SND_SOC_DAPM_AIF_OUT("ASP_TX4", NULL, 3, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX4_EN_SHIFT, 0),
-	SND_SOC_DAPM_AIF_OUT("ASP_TX5", NULL, 3, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX5_EN_SHIFT, 0),
+	SND_SOC_DAPM_AIF_OUT("ASP_TX5", NULL, 4, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX5_EN_SHIFT, 0),
 
 	SND_SOC_DAPM_MUX("ASP_TX1 Source", SND_SOC_NOPM, 0, 0, &cs35l45_asp_muxes[0]),
 	SND_SOC_DAPM_MUX("ASP_TX2 Source", SND_SOC_NOPM, 0, 0, &cs35l45_asp_muxes[1]),
-- 
2.51.0



