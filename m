Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A1A156F44;
	Wed,  5 Feb 2025 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765631; cv=none; b=ga1a5wD8AAXQGTckHf2BB0IgWQl/ahqUHDaN/5rcGO5R0f/Jy70rLU5cst6c7PpK5MXUNGPGnCs94H1Mr6kMBmm4mOx3nuKBH3T/tobFz7zTjsAx+Tbraaqk6PJyYFbjXy/SOf+Wr0jsCNzYsEgsnZBBfvFHVbyWzYh8J9r1XZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765631; c=relaxed/simple;
	bh=BMZawqKjQShKetbUQ6K1fjWw+hQa/qbFiJfqkSkM6js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5AZPVLK+jOdbJuB7Myy5KF88pBrngHN9WgoC6x/UG3g7bp7LiWCmAoN79zTJRhVngzRUi1vNIn838IMLTT7ly0GBc1paOe0sjClK8JT4WqF3btm06/ZTGw+c7M/NnWsltqRtwpUMUqMp2UTqO8bF1sagnAWiXWzhBeW+bxeGZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nW2Yl0iB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nW2Yl0iB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B65C4CED1;
	Wed,  5 Feb 2025 14:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765631;
	bh=BMZawqKjQShKetbUQ6K1fjWw+hQa/qbFiJfqkSkM6js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nW2Yl0iB3LB8YrbfsUx+ExWcGALER2GQ6/GTnMTRZ1pmRkJbHEkrj5yb6hndqX66T
	 WE4EO9E0h8BN5GE9va7jg8fXBsp0tqE6Kq9migHJjumuSCwRtRBDrl0+p2vGyMWwOV
	 VgNI63fnHHkbLSJJunhwmsbSg/L9Elte4O3BHJIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/590] ASoC: cs40l50: Use *-y for Makefile
Date: Wed,  5 Feb 2025 14:39:53 +0100
Message-ID: <20250205134504.385743518@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3f0b8d367db5b0c0a0096b1c2ff02ec7c5c893b6 ]

We should use *-y instead of *-objs in Makefile for the module
objects.  *-objs is used rather for host programs.

Fixes: c486def5b3ba ("ASoC: cs40l50: Support I2S streaming to CS40L50")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241203141823.22393-2-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 54cbc3feae327..56c519a5c897b 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -79,7 +79,7 @@ snd-soc-cs35l56-shared-y := cs35l56-shared.o
 snd-soc-cs35l56-i2c-y := cs35l56-i2c.o
 snd-soc-cs35l56-spi-y := cs35l56-spi.o
 snd-soc-cs35l56-sdw-y := cs35l56-sdw.o
-snd-soc-cs40l50-objs := cs40l50-codec.o
+snd-soc-cs40l50-y := cs40l50-codec.o
 snd-soc-cs42l42-y := cs42l42.o
 snd-soc-cs42l42-i2c-y := cs42l42-i2c.o
 snd-soc-cs42l42-sdw-y := cs42l42-sdw.o
-- 
2.39.5



