Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55776A8D2;
	Tue, 17 Feb 2026 20:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360877; cv=none; b=HGxbCiI1VkFQZ3A8Cc5ZnsYOWBVe39phUw+3sGoNadpvfd8o0bY1+/F0eh6fkPO5Cl7nbVbNFeujcpgXI5Twpz5kum8Qj8/3fU3CQNfeG7eBDLy/lvg2p730giiIkxEQtn4sZ68dbqE1CSXO8lyl872QZNPTSs5MSemObm9dIdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360877; c=relaxed/simple;
	bh=4zrNGeKI0y4Jk/YZB2Ye9D0NKOKjI5+8dU9DVgFjTaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIH9eFY+0+NUqBETeDET/HEAplz3YFk+QAlVL5umAZHiDEy4fRbxRSvLIqA8XjljvX36vg3UzjZfJr4moRmswPd6Zm4EIVjLPL4FCVvo+iMQihhzwLfP3/oYSiyMqGuzVVnd54Rsm7BCFi0Cc0tbId4uWHKNq85w/ve8PCc2tO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPQE2IYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPQE2IYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8B1C4CEF7;
	Tue, 17 Feb 2026 20:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360877;
	bh=4zrNGeKI0y4Jk/YZB2Ye9D0NKOKjI5+8dU9DVgFjTaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPQE2IYYnG0LghQYEFlGSYxJCWA+AOu+vC9wUxn7BblmcZ9Om9ZO5wUO2iYsBfcoh
	 ChA/4aF7pqiezLZwFES629gnmZSxsnQG85pzGYwUNBknW90BHMIMwIGUfOLjwCUcSX
	 /movaT3f/b581YJMm9BZgQHpo1umtpKzsGAM4Aoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/39] ASoC: cs35l45: Corrects ASP_TX5 DAPM widget channel
Date: Tue, 17 Feb 2026 21:30:32 +0100
Message-ID: <20260217200004.623112369@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7e439c778c6b4..11e28c340a709 100644
--- a/sound/soc/codecs/cs35l45.c
+++ b/sound/soc/codecs/cs35l45.c
@@ -316,7 +316,7 @@ static const struct snd_soc_dapm_widget cs35l45_dapm_widgets[] = {
 	SND_SOC_DAPM_AIF_OUT("ASP_TX2", NULL, 1, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX2_EN_SHIFT, 0),
 	SND_SOC_DAPM_AIF_OUT("ASP_TX3", NULL, 2, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX3_EN_SHIFT, 0),
 	SND_SOC_DAPM_AIF_OUT("ASP_TX4", NULL, 3, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX4_EN_SHIFT, 0),
-	SND_SOC_DAPM_AIF_OUT("ASP_TX5", NULL, 3, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX5_EN_SHIFT, 0),
+	SND_SOC_DAPM_AIF_OUT("ASP_TX5", NULL, 4, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX5_EN_SHIFT, 0),
 
 	SND_SOC_DAPM_MUX("ASP_TX1 Source", SND_SOC_NOPM, 0, 0, &cs35l45_asp_muxes[0]),
 	SND_SOC_DAPM_MUX("ASP_TX2 Source", SND_SOC_NOPM, 0, 0, &cs35l45_asp_muxes[1]),
-- 
2.51.0



