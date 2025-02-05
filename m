Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B641151988;
	Wed,  5 Feb 2025 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766184; cv=none; b=QzxrPXaAajufuozllHfAsFnTUAfgM2DB0vDoUFRD+txYBRhtjtOqhiDz+pO1zDObVEzODOiHJCWNPD7vraYsDz5PLWydyqU4+HekZ9RTPfm3akQOkQAtwKQOHoQyNKLtZWz3e+nS3qqV6accR20FpYVxcWFWOze/H4fojBlusPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766184; c=relaxed/simple;
	bh=iX2RghKIkoC8XYCfr2/4byAVXBCqfLv4/dohC4Npn84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npQnUInUhJRArwRTPAcwTEKgFHI71OdFV+0dWd+6v11HXY6pTG6DZ8r2SJwKIItAIgFGTXRUQ9sxuZXELnPdqJ+D5IR/tP1UB2HAw3Aw9lInuFz8oOhN/sbRlgNgM38/5oP5LwD3b9yvrkxUJB5Z91EpZ8fk1vw7m4dxkhDqvHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUQGe6Yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUQGe6Yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9BBC4CED1;
	Wed,  5 Feb 2025 14:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766184;
	bh=iX2RghKIkoC8XYCfr2/4byAVXBCqfLv4/dohC4Npn84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUQGe6Yl+gvw4hoiTRLfT45yvY7GoWuskB4G3yr3KIPtG6VDuZ2c7gWfLSLuPEghW
	 LP+JiBLbpCKmftOvEsrk5Cqxm9f7pB232H1CEWbbbZjKuaNW3ZRdgn49yxefF1dkBg
	 JlTRf4nFuo6z047xVLC1+4BidC3g19aNaHX0HhIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 250/623] ASoC: mediatek: mt8365: Use *-y for Makefile
Date: Wed,  5 Feb 2025 14:39:52 +0100
Message-ID: <20250205134505.796257602@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e9d2a2f49244d9737f0ec33f4b7f3580faecd805 ]

We should use *-y instead of *-objs in Makefile for the module
objects.  *-objs is used rather for host programs.

Fixes: 5bbfdad8cf8d ("ASoC: mediatek: Add MT8365 support")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241203141823.22393-3-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8365/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8365/Makefile b/sound/soc/mediatek/mt8365/Makefile
index 52ba45a8498a2..b197025e34bb8 100644
--- a/sound/soc/mediatek/mt8365/Makefile
+++ b/sound/soc/mediatek/mt8365/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 # MTK Platform driver
-snd-soc-mt8365-pcm-objs := \
+snd-soc-mt8365-pcm-y := \
 	mt8365-afe-clk.o \
 	mt8365-afe-pcm.o \
 	mt8365-dai-adda.o \
-- 
2.39.5



