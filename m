Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CC51774B;
	Thu, 18 Jan 2024 10:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575538; cv=none; b=YeAGrcqIK8Rjj3+F995TALzMqS9xtJijZEjjaKmVP2NBl5gaCpIMp3DjmEqaInoCZ5MUbSQteA3FRhckQQOk8bU0Ia9ktVZTTswUGjKILg3J5H+vbLuutAjsKGOHS4fZPBlG5/gHFvLwHCHb7++lOYXUcP/RJjkOXuEgkDX3/w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575538; c=relaxed/simple;
	bh=46TcRNEHL9K7ESWwRXqQfRY29xaklJbOZyqon8pjblg=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=XIQhjEKu5j7fM7K2Mi7P1dzvgQ2gY/yudTFygLGiJSgw8opTXGJLSmHEKY9Ity0gOwN2flx9eRfWbJIQMCURfmJfSAeQ8imMle918Y050/gcBAvltWT6932Ve5FXxvlRI4gxlgsnrkQ5xdp355NL0+8PHOYRoz+pp/1dG+H6Pkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JY6V21DM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JY6V21DM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B1BC433F1;
	Thu, 18 Jan 2024 10:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575538;
	bh=46TcRNEHL9K7ESWwRXqQfRY29xaklJbOZyqon8pjblg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JY6V21DMfV35N80HixPdEzPWzaV8qvfOr5pYO4OOwOodu/WSQGZ303yXFjZ2ER5bV
	 uOgm2mHYOtonKQL8AjlIoA9H+j7v8NBbBvlT6gNuxk8rENCmPmg0RDTAhtPJD7PKfv
	 tdNILBVaMV/7gp+HK2TYehwvBVtXZLM5To4HL8NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/100] ASoC: wm8974: Correct boost mixer inputs
Date: Thu, 18 Jan 2024 11:48:26 +0100
Message-ID: <20240118104311.708998396@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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
index 010a394c705c..1becbf2c6ffa 100644
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



