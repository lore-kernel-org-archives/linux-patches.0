Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618521;
	b=Ie5q8FLUcBGqK/aSJYqS1ByxbFOP8ZUS7uC9+/xHuRbkSdEug9PKlUjWju1vVh+TI45A
	 rxExleVhlUsRy4NgLsFlOo+GWTIAQ+HSddPtXnEYoEB3a4Ov/WyYhI0y3DknsfgaBoRhc
	 DQC0zTort7YT8yar2sq17KFXECEAPALLepiDnu7kH075Wvhqcl6ZyEO+rBMNn+Rz/3+BZ
	 Ovfk79WRDXtXYc6g1apgQm3/lWcqOI47HLOCfIqyyulsphH9MV2+slbfDvz0FTX8Z7gJk
	 4wpo3PedsrxX2TE4UvVZQb5Or0coVqhxVE8zA8H6j+5k1Pe+DVUakMUyRrdO7A7oyoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zje1KL+AmsekR3yGBrqfuV3y93hiJfu/515Tlq6hhXU=;
	b=Stli60/kO4Ro3j0xkftMRLSra/4gnocJeMFww/cJ7GGmfXJPGDH0fHxghu9DG3sXAbN7
	 Y8Oc2OFTQFWbXeBzLNh2A5tbFKhH5VHfWUd2XLlTmuS+8jZgmFW3QZb6TD1ehIVRMeWsw
	 8FS28zLKsEjzfhvvCJKD3DCYX04zrbSxfp5O2Fgg8N9TcDm2sflPkg1ADu4bjITQnU0fZ
	 3iW5Bg1ianFAaBSDhW3WUqcesaZNmCGZv9X7q9NZkOONXKlPkfTZG4xxGDIaQTj6F3CVa
	 uOn34Ugp3kRah1rohwFfMzTOS4aZARDaqVjXLnCzJ4NXVT1Cw/K0n0H/6rZcQWP/0hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbwJ9NI3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2168606A33C;
	Wed, 25 Nov 2026 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbwJ9NI3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFA71F000D8;
	Wed, 25 Nov 2026 14:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618520;
	bh=zje1KL+AmsekR3yGBrqfuV3y93hiJfu/515Tlq6hhXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbwJ9NI3mzuvvuDjUyr3/O3XI3fKTcJi7MgyKKdfy0qp4Q3v+yWwk6C9oOMlKUCIH
	 Km5EtiGyFsZfmIQlGd3os619VzgRvFjj2K6oW1QL7hQTdaFKj/WbUAMxPOnc7vkfUO
	 kewlja7UZbqznQCNU6A+WEbXmyCLWnd/rrnlz0hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0304/1005] ALSA: hda: cs35l56: Stop cs_dsp before calling cs_dsp_power_down()
Date: Wed, 25 Nov 2026 15:27:22 +0100
Message-ID: <20261125143828.857389980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 148d760987fdd..5982eebae1525 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.c
@@ -809,6 +809,8 @@ static void cs35l56_hda_unbind(struct device *dev, struct device *master, void *
 	cs_dsp_cleanup_debugfs(&cs35l56->cs_dsp);
 	debugfs_remove_recursive(cs35l56->debugfs_root);
 #endif
+	if (cs35l56->cs_dsp.running)
+		cs_dsp_stop(&cs35l56->cs_dsp);
 
 	if (cs35l56->cs_dsp.booted)
 		cs_dsp_power_down(&cs35l56->cs_dsp);
-- 
2.53.0



