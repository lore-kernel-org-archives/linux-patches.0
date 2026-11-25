Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621593;
	b=m+dE1eRf/A476z6bfawO3k26igja/baWJ/GKRQ9cnRd6QgIZD2XO3t3y2eCkhC+5ufxF
	 dZJXy+WeXT1O1Mom7TWqnoLWbz9Mx1rFyCA/yfxtkoQbH6QynkCGhrKY54bnoblM1ceHx
	 6L+D/mlvUDRfPV2OGBnGridWDe/fBEVQEQUTIjXTwy0mVCBWzEJcssGDl9Yegb5j2TvRR
	 qIj1tgwfpH89IvqeOxTSTQjJ6G82eY888MdJvlFBByMH1DpJoFq+SPIJ7dvRCQgRZjmoS
	 0eyH2Rt8W/yobbI8UeSgyhjXzwindHj5841ZGvaR2IBONVHMVlSFbfq7HIp30dXlOqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YnNz+GE+btGm8z7icOWgGPjZQ6xDJOp2Jc3yAlUZkmo=;
	b=ayXm5MdKeAcTEcrNjjBEXAb5NpRDgFsrVbKXT/1G7uD1htzFCnIGf1MzORwc7E2SVnl2
	 6tmIAAsnirE6hseBUQe0eUYaRQWu8fzcHhLvd1eLXMwhtYul+8EtyySGK946Hm8FM+X9W
	 8Yqq2DPUyGgBu1xNBCs5c7xV/Zx7JBEZ13zeOsVWcASt+bFfacJS3EuTI6Okfchqn5hhc
	 dx6LrMZkt3AqTIuVzNQzJV6MbTarFZahLZoOqORrNSiaM3nXwr1sSKjG9mSi+7chgZoyp
	 klm9rCZp7sg3/tBJi0Jiq+KkBKK2ocx50TPG8eZlp3d/+7P4NP7wpqywV66D1wlw1wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jkHzcPuU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC37C606A332;
	Wed, 25 Nov 2026 15:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jkHzcPuU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6CC1F000CA;
	Wed, 25 Nov 2026 15:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621593;
	bh=YnNz+GE+btGm8z7icOWgGPjZQ6xDJOp2Jc3yAlUZkmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkHzcPuU5I3zxGW0jPqR5zxlQJmEbf8niloZ7uhQFML4qmKsXFPcGglnaVRHJ2uug
	 Mgyhz6C3vmsijT6aKQ01e5GGnuAhrSHFC6cPL/u/QqR3/gdgBp/eZxJvt5iPsAzilj
	 uhsJeBxGaSMsHzLrDUD7mfG7zFApPOGS6avvA2Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 275/990] ALSA: hda: cs35l56: Stop cs_dsp before calling cs_dsp_power_down()
Date: Wed, 25 Nov 2026 15:27:22 +0100
Message-ID: <20261125143828.530547365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 8c63987ac7fe605c337edbf9052cf97e2a415558 ]

In cs35l56_hda_unbind() call cs_dsp_stop() before cs_dsp_power_down()
if cs_dsp is in a running state.

cs35l56_hda_runtime_resume() calls cs_dsp_run() if cs_dsp_power_up() has
previously run successfully. If cs35l56_hda_unbind() is then called while
in this runtime-resumed state cs_dsp will be running. The code wasn't
checking for this and was calling cs_dsp_power_down() while still in a
running state, which is illegal. This is currently fairly harmless for
the cs35l56 driver. But it doesn't comply with the API, so potentially
could break with any future changes that expect the correct API use.

Fixes: fb78d73dde2d4 ("ALSA: hda/cs35l56: Call cs_dsp_power_down() before calling cs_dsp_remove()")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20261104122337.1072468-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cs35l56_hda.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/hda/codecs/side-codecs/cs35l56_hda.c b/sound/hda/codecs/side-codecs/cs35l56_hda.c
index baf286bf7ec83..b55391fed61ac 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.c
@@ -738,6 +738,8 @@ static void cs35l56_hda_unbind(struct device *dev, struct device *master, void *
 	cs_dsp_cleanup_debugfs(&cs35l56->cs_dsp);
 	debugfs_remove_recursive(cs35l56->debugfs_root);
 #endif
+	if (cs35l56->cs_dsp.running)
+		cs_dsp_stop(&cs35l56->cs_dsp);
 
 	if (cs35l56->base.fw_patched)
 		cs_dsp_power_down(&cs35l56->cs_dsp);
-- 
2.53.0



