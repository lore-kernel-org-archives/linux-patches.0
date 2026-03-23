Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6383ACEED;
	Mon, 23 Mar 2026 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275210; cv=none; b=iKGGc0RRigFwO4nnGdnxZf623jCje5Lv0z2VaJDDdK3nu2VLWkeS5Ub9wZnbu6hVhOnqPweKjmCTDhHkQ2+MvENW9BvaljJBvScd7fLV6vg/UzGr4lcY0nLPLSZDQJ1E1oQeDbuVth6d/qPGMpbes9jQFY7Y2f+zzVFJ1sujOR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275210; c=relaxed/simple;
	bh=jPzUQC55ptPeajPOBKF/hfe3TG2nIfWdmrDvTPWuGeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7i+1n8iroqucMEW8bSHMBIlRmQSnFGOkd5yGsiAZBIfJ3JUJlmOyIqcDEHLZF8krGL+J8svDIK4yvawdYH/pZ2uda+rWQQWtJptz7t9LrxhPCW98V0Z4Z30dwVbBDnUlhr/ylMQDSXFFTFA5UwS7epygBOx8hl/K1+ON99I+Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeoKwBZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeoKwBZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48B6C4CEF7;
	Mon, 23 Mar 2026 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275210;
	bh=jPzUQC55ptPeajPOBKF/hfe3TG2nIfWdmrDvTPWuGeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeoKwBZxUzgIHcpNa6OFIVa0kpI7upB4uNCy1QO+Jm4mAxd3Kv3k+n7GfBUaexu1W
	 GL0l4xFqC5FLY98Lr40wVdp1JXAVDzA47PMUsDOBxouzLr/tdlWFuydFOzQ59xt6tE
	 cj6jFhgGPnh4hGJpTSyBzF9TSjB2wW4xEzgVmzrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/567] ALSA: hda: cs35l56: Fix signedness error in cs35l56_hda_posture_put()
Date: Mon, 23 Mar 2026 14:38:54 +0100
Message-ID: <20260323134534.117705194@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 003ce8c9b2ca28fbb4860651e76fb1c9a91f2ea1 ]

In cs35l56_hda_posture_put() assign ucontrol->value.integer.value[0] to
a long instead of an unsigned long. ucontrol->value.integer.value[0] is
a long.

This fixes the sparse warning:

sound/hda/codecs/side-codecs/cs35l56_hda.c:256:20: warning: unsigned value
that used to be signed checked against zero?
sound/hda/codecs/side-codecs/cs35l56_hda.c:252:29: signed value source

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 73cfbfa9caea8 ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Link: https://patch.msgid.link/20260226111728.1700431-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 03b2a6a919b4d..8d86a13b8a960 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -238,7 +238,7 @@ static int cs35l56_hda_posture_put(struct snd_kcontrol *kcontrol,
 				   struct snd_ctl_elem_value *ucontrol)
 {
 	struct cs35l56_hda *cs35l56 = snd_kcontrol_chip(kcontrol);
-	unsigned long pos = ucontrol->value.integer.value[0];
+	long pos = ucontrol->value.integer.value[0];
 	bool changed;
 	int ret;
 
-- 
2.51.0



