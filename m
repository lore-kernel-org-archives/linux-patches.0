Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C0F2F5301;
	Tue, 30 Sep 2025 15:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245229; cv=none; b=LndQM8MPdxnuCkTpIbxvh6X0+LwoBhbVzsBX5GNdU+rhvC3wAOfHiZdRdGTZWoZwYcIgUH97BqXaKbAUj1svQePGgqiUqp5miASBf6iHwqDax9SP+tRAQpN5mBAqRLk9iilQvqXcywjNroF25YWEUCQUOETy07SRjNnNyuxBZNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245229; c=relaxed/simple;
	bh=oWjsiEKn23pWXVN/m0hpQu4RL65TliQ11zW+3N/W3lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pixo+bierdp02kkCuCNFQTwhGL16qsPkWde9zV73hMpXUMPpc/ONXHPShX12dmR7twxNaEWa5MUIAEqSqA0pQuMe99MMgSO9uDdTC11eKM2NkFD5hM8jap3L3KFG/u+nr5QurYi9jozUZoMxvlHzVVXg6Y56N6ZIZqNWjDm4jWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVT6uGpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVT6uGpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46300C4CEF0;
	Tue, 30 Sep 2025 15:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245229;
	bh=oWjsiEKn23pWXVN/m0hpQu4RL65TliQ11zW+3N/W3lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVT6uGpxrlsEB8IdvT4mbVX5NiBszyoJNENNCkOGeyVpgHV5dO6/o1klkrdw2PtK9
	 h7s8W9z58zXNWmGgXhnHE58+JcoPgfDPijrpNnvX5wRo+wmzLCBwK9UNKX+tLoE3Uu
	 NR9QR4OcbzGKakxqjIW9laIG+QopUVf1OaxDx8H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/151] ALSA: usb-audio: Avoid multiple assignments in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:15 +0200
Message-ID: <20250930143831.789965881@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 866d309454aa3..4ab57ef56330d 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1734,7 +1734,8 @@ static int snd_microii_spdif_default_put(struct snd_kcontrol *kcontrol,
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



