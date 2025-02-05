Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEA7151988;
	Wed,  5 Feb 2025 14:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766207; cv=none; b=Y1O/LDCOgVmvdFd/U+G9rvOZmbQTWJALLCtRPXADt6MEl0b2nWyJMHEQAxRWI5NPzLSD7MD3CDgGg8wjMK27+ozHIQAAIeu82I6N3nAEwO/aGKNlZohowLVxiVnlt8mPrrnUs6gbj0NyH9wJk4lNEYCjnyt0K6vjVpxKNz2cy2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766207; c=relaxed/simple;
	bh=bbpzJ9JgP5TZLkgcOpePTIkLs3c+90pODV/1I2Cz+qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlJx9wj5szweQwxTL7ExFj/a5lNywnDWmcWbAgttNOHyDlUS4ov7hQBn341R5BtaAzT41R/fK9S5mI/UsRql61UrLIOllf7tjuc0z6v7a1C2f9wGCHs7YA9VTXEjs7z7+CLYkHOdbk91ES/wa7J3ngNEtnUSPzPMFgCwmU1975E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Doc6lohx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Doc6lohx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFCAC4CED6;
	Wed,  5 Feb 2025 14:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766207;
	bh=bbpzJ9JgP5TZLkgcOpePTIkLs3c+90pODV/1I2Cz+qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Doc6lohxVKiXvZgeeePbmeE5/T7yiIqTTNwUlXwbsVpOnvKMtBxvu71amB45HOIJr
	 8s071tW+6qE3+YzoIyvs16sXhmlYKxA/r4fjNPfYUe+Er6lUV+yiy/bycGzTbkg2nY
	 X7Qod+OENSlChnwUQwPny4Ob55XnPbGsMC34lGno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 252/623] ASoC: cs42l84: Use *-y for Makefile
Date: Wed,  5 Feb 2025 14:39:54 +0100
Message-ID: <20250205134505.873344384@linuxfoundation.org>
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

[ Upstream commit 7916a8d8782d4e53fe0133c8dace20a925e0204e ]

We should use *-y instead of *-objs in Makefile for the module
objects.  *-objs is used rather for host programs.

Fixes: 250304a0fb34 ("ASoC: cs42l84: Add new codec driver")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241203141823.22393-5-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 57d3aab27d2fe..5a83ee9639661 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -92,7 +92,7 @@ snd-soc-cs42l52-y := cs42l52.o
 snd-soc-cs42l56-y := cs42l56.o
 snd-soc-cs42l73-y := cs42l73.o
 snd-soc-cs42l83-i2c-y := cs42l83-i2c.o
-snd-soc-cs42l84-objs := cs42l84.o
+snd-soc-cs42l84-y := cs42l84.o
 snd-soc-cs4234-y := cs4234.o
 snd-soc-cs4265-y := cs4265.o
 snd-soc-cs4270-y := cs4270.o
-- 
2.39.5



