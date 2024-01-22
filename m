Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A0B60BA3;
	Tue, 23 Jan 2024 00:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970734; cv=none; b=A3Lop2VVWz+U1iwlimw2DQ1KmbGQ/+zmILvwi4F27QchRu6xMdVa3nt5xU5+UQc4g4AyAYnP8ykQVeB2Wszk3BJV4aPD6H9m5NyrUkWGtHCsTjT7hKIjGq1r2hyO2s3Pw6pttWeY9rH93AcJKoORz8DiWWUHiYRRtCbtHCay7tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970734; c=relaxed/simple;
	bh=q4eRnfS0p1wYjEpynUfzpp4ewMR1eU74HGbbNIm7Mag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzdZnv8u65AeJOSX7bYtmH3x9WPLI7wj4N3ydWFXhopOcB6eUefplH3bZXxG7VZ82NtG1h4b2wsS/jrD/XkpmM6to7n4cG8iOdqU7tlNBmkkH7M69IpTozM1A474s9lZgp2M/Wco9gcShtnTWLfnpHdK8udpt5JH7JSp+fTYec8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msKfTkOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msKfTkOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEBEC433F1;
	Tue, 23 Jan 2024 00:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970733;
	bh=q4eRnfS0p1wYjEpynUfzpp4ewMR1eU74HGbbNIm7Mag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msKfTkOp0rTapcbY6F8eXJHGcW7LSZUw5+LXLLCecYzjF8H9XC0/zYi81A554d1PC
	 AKFOOchVeHgP8th69hGJcJsXJ9FyLThsXolNNDFbxWjjVXsodhcbbzvp+FXwKQsWB3
	 MXOgPpWMWBiCxkpuMbvfYBTJA1QDnO6wgTdA1UDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/286] ASoC: wm8974: Correct boost mixer inputs
Date: Mon, 22 Jan 2024 15:55:14 -0800
Message-ID: <20240122235732.332766258@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 37e6fd0cebf0b9f71afb38fd95b10408799d1f0b ]

Bit 6 of INPPGA (INPPGAMUTE) does not control the Aux path, it controls
the input PGA path, as can been seen from Figure 8 Input Boost Stage in
the datasheet. Update the naming of things in the driver to match this
and update the routing to also reflect this.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231113155916.1741027-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8974.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index c86231dfcf4f..600e93d61a90 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -186,7 +186,7 @@ SOC_DAPM_SINGLE("PCM Playback Switch", WM8974_MONOMIX, 0, 1, 0),
 
 /* Boost mixer */
 static const struct snd_kcontrol_new wm8974_boost_mixer[] = {
-SOC_DAPM_SINGLE("Aux Switch", WM8974_INPPGA, 6, 1, 1),
+SOC_DAPM_SINGLE("PGA Switch", WM8974_INPPGA, 6, 1, 1),
 };
 
 /* Input PGA */
@@ -246,8 +246,8 @@ static const struct snd_soc_dapm_route wm8974_dapm_routes[] = {
 
 	/* Boost Mixer */
 	{"ADC", NULL, "Boost Mixer"},
-	{"Boost Mixer", "Aux Switch", "Aux Input"},
-	{"Boost Mixer", NULL, "Input PGA"},
+	{"Boost Mixer", NULL, "Aux Input"},
+	{"Boost Mixer", "PGA Switch", "Input PGA"},
 	{"Boost Mixer", NULL, "MICP"},
 
 	/* Input PGA */
-- 
2.43.0



