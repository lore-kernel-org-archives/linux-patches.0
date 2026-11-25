Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624555;
	b=jSJAKeo+aH608+g5NGa0MX60PqTJVsHOhsH/o3XXdnqkorpKaQgdTX7ckhIGx/+rF0qw
	 Yq+yYzBKU2/3zlRsoQTlwdMV7NAjLjPEx0IJAJ/wkjHTIDA3Nb/UMiJxDt2fEO0U4sVR4
	 Ed91C+gF5Zeg1xHJyD7wNS0A8X0YlHGavy5GdjoWAhSvETW8+vftRuwtO685O+JB1W4qA
	 5IBuszn56lI5aXn2L07LgVGLeAIvrHAc4vEhagiSFkLnWE6sRsN/pvobhG3t4Jp2990Qr
	 ZwJzVBqUClipa31RGYnROMQyDAx95JjtoB0zaEAnQ+jng60aMsj5WMxuZZjZmTpoyHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4uTOxRdjsQWWu3DxLiWA5+wSIVWaCISCWTJpG9v6oxE=;
	b=V9q4nhSBsBpku3oG9uyFEvoHxN9AdkbslRNEdzXL/Qq7hWm4XHDLB+zovV4G0gR39gP9
	 HkwDQfG6NFTj6mnd5J3Eo3GXFdlvYEVcM5OuKF/1IIb82P/HCD/gFNEi7kRAZykyWbO/t
	 OXxXbutWvRkgyHsqFnT6azyweX9as6L8H6w4hfeyAq5r4jbKJF5pee6S372O4fHkFhYGc
	 sm74UuZsgq9023F/gAWsG6wxT65/nu3sJA6vrlEY6AM6p+FoUklI3vRYTd4VxTCCPKNpW
	 6cQ0gKOGEApOtxQfXW7s8408dESdstLuSY3++/n8CHg0yqYrnAe0lTwSpXrTWrbAZpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dJNW6/cO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FC6606A33B;
	Wed, 25 Nov 2026 16:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJNW6/cO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6A51F000CA;
	Wed, 25 Nov 2026 16:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624554;
	bh=4uTOxRdjsQWWu3DxLiWA5+wSIVWaCISCWTJpG9v6oxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJNW6/cOpL6vRHwEPSVYoOqGT2f/yVtNsYc9oxP0zuVDzCIPt47A1o67TVJxdIt7n
	 22mC5IvdyjgzN8zN411gWK7p2Lo1bgiEdgUBPMEqdOrQ1b1jnMd2ucVmqeY6XNxqS3
	 fbRRTePhnSTJHX0EQgghWs209CoSW78iULP+XPyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 224/816] ALSA: hda: cs35l56: Stop cs_dsp before calling cs_dsp_power_down()
Date: Wed, 25 Nov 2026 15:29:32 +0100
Message-ID: <20261125143854.391551260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 sound/pci/hda/cs35l56_hda.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 8663de44d97f7..938d49c0b992a 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -742,6 +742,8 @@ static void cs35l56_hda_unbind(struct device *dev, struct device *master, void *
 	cs_dsp_cleanup_debugfs(&cs35l56->cs_dsp);
 	debugfs_remove_recursive(cs35l56->debugfs_root);
 #endif
+	if (cs35l56->cs_dsp.running)
+		cs_dsp_stop(&cs35l56->cs_dsp);
 
 	if (cs35l56->base.fw_patched)
 		cs_dsp_power_down(&cs35l56->cs_dsp);
-- 
2.53.0



