Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955511EE02F;
	Tue, 30 Sep 2025 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244489; cv=none; b=HJ7Xep3UQJgp9E+JGXfhCdbFt3pQDkguuKLsvEKzp81yhQ0exiAe+zebtj/WCiVwPqoI0zF2fGyYmojY3ivmYgT7T85xXgh6zkuLlucK6fRdpMIXcOejtROVsZscKapXJKhNS6w5EdoIKOtafNSI6dVuNEsF1dDEfgwC8MjbxJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244489; c=relaxed/simple;
	bh=rHO8lqQHbdnRzw+4Ci9QKzy2JJaHOl18qMnfkjOnjSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVhW587GKRBLxBZ3XLlBfpnePrOpHrWBEkm7Ty0Qh92IX0KRJYsQKThB7Zp+XEULibHfxbsEHThNUqvtt6LCCRt79Ob76syEkirdVC1yEbjVBIDLP1Dh7AHnEdI0CLafsF8c0yL81j9h+JChKKYL3/KQ9DzbDs2rJXbhVjlRLAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnOPgbEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnOPgbEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A6CC4CEF0;
	Tue, 30 Sep 2025 15:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244489;
	bh=rHO8lqQHbdnRzw+4Ci9QKzy2JJaHOl18qMnfkjOnjSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnOPgbEtEgcN4CZCbbspRsxByOUYTnqTZh1kor5SNr0yGyRzJHbH+69Zp3gLLDgBh
	 EFEt+xodsXwWx3Q5/JZikKcRZsQWu/tp1fz3Z52Fxy4OHhgPvEUtHmy84YzJlcNlpO
	 1F8+rTi+fllGuVUzvzZpoQyYs46k4U0n29lxXQDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 007/143] ALSA: usb-audio: Avoid multiple assignments in mixer_quirks
Date: Tue, 30 Sep 2025 16:45:31 +0200
Message-ID: <20250930143831.537909224@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 03ddd3bdb94df3edb1f2408b57cfb00b3d92a208 ]

Handle report from checkpatch.pl:

  CHECK: multiple assignments should be avoided

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-6-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index eb245272f123a..741a70d0816cc 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1739,7 +1739,8 @@ static int snd_microii_spdif_default_put(struct snd_kcontrol *kcontrol,
 	unsigned int pval, pval_old;
 	int err;
 
-	pval = pval_old = kcontrol->private_value;
+	pval = kcontrol->private_value;
+	pval_old = pval;
 	pval &= 0xfffff0f0;
 	pval |= (ucontrol->value.iec958.status[1] & 0x0f) << 8;
 	pval |= (ucontrol->value.iec958.status[0] & 0x0f);
-- 
2.51.0



