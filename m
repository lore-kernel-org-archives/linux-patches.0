Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85B5302755;
	Tue, 30 Sep 2025 14:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244385; cv=none; b=kjwRGSaRvv8j9WCMvTgE8KAC+HfwAqkGQCsObcoha97mfoPv3o5ZUIYWmkwLN5KwLFKK+4daACfdAKLgwDJHOHL+OyETs4Mp1V4UsgijAc0Q4vM7u3T4lcdtb8PQ+JaB6Dmzh6+KW9+5NTLeLrkorvykbMph23LWMPnf1V+RZa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244385; c=relaxed/simple;
	bh=mAuKMu5mh3HF8g6Eg/rxNO7m/+GMEm/DpEK4mwTQwkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHIt4eheN1UDzgGE+wHWYRvrlXuXfDJ3YMIO9jLqInuCmfISX6nuzQLk8nhGiiSRXXJOIEv2/37Wovf/xoen9J6ekr1L3XEBGsr6+mtBSQQAs5jOxMKQJTFgqPMk+Z3nmQOOmxvBJ4nb/JeA/ObfVZoCVb0eBKw3jWvQDgG4WMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6SbN0wo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6SbN0wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FB2C4CEF0;
	Tue, 30 Sep 2025 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244385;
	bh=mAuKMu5mh3HF8g6Eg/rxNO7m/+GMEm/DpEK4mwTQwkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6SbN0woXLPf/JkeoqN5TnPtymNLEOjYApnK/RKdtwUVtpkJKY2Bqn1bPVTXOZt1i
	 04u97PchjI83ndd13MdhFWSa956UGO5zGOXnMSrNiMnbOUK5RDzs/hJ/X7taqIunxl
	 AFDMNVNaa1Qf8ORcCIatTeDNDxRanr+pmn09F9Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/122] ALSA: usb-audio: Avoid multiple assignments in mixer_quirks
Date: Tue, 30 Sep 2025 16:46:57 +0200
Message-ID: <20250930143826.518265386@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8a84e89890772..715b0922243c1 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1593,7 +1593,8 @@ static int snd_microii_spdif_default_put(struct snd_kcontrol *kcontrol,
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



