Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055999;
	b=YlGZZkv0Ki1BpDYqX0HMNPDqqwfS/HWJvqotUhNfZc9NP1dB5uamQM+okxYTVRTbF0hE
	 Yg4halRj+VcjcAmCfmqUIq0lhZVc9vIOdITXfHEgwB/U8+CYYKxIpFZEU9TEmYCfo8/Qa
	 1aSCxJ2aymtDKFswVd9S/Je3BPU+IavtbyQ2880Xc3SwrsFyDFMaWszAO83pcvADT1oNN
	 ZnRrNi1dWfmV3PuP4PlofwxpK1v+Wto4vpbFFvXyeLK8w71YWYYBRnLz4iZE0uqEt7n5V
	 aHoPsvZAjXwK91bMQMrMHVEsp/polKXUGDO30uOOwe7yCQVfH5k9dc2JKsGZzBTwXWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e1SAlandCfOJ9m8wLwI3JrVrRAcu1bPilJwLtli9SEA=;
	b=GHkLfnf6DLVT10FUZPZYnButOv6Addka3WVNDfMPtCrYdzwHh7Zvb+7rqksokMOnagZW
	 HRQ3dtgD+jjcFXIg6EMu8mt/agxccviz0FXeP1irsnhdsenC8NIl0696wpH0Sn1v98gjf
	 F5tGcUScd3VGvRwcs5srUjOsb+yt9m65MrhIVhly16S+X5nqUvLENZvHAtQ+N0LGXLeDL
	 7Y0kWZ1gmZVp+5TitXjG+8p/BDyTYnpHJpqo02yV68g30O/Js6XtECNIfmFfl0xYtyJXP
	 SqdxkjPI6VqfgwbtrjB7LxAKCHOt4aUxPTOwrXWtCkC7LLzNEhy4POiqipvrjT4SvEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w52c/BGN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEBC606A31C;
	Thu, 19 Nov 2026 02:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w52c/BGN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319E21F000C4;
	Thu, 19 Nov 2026 02:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055998;
	bh=e1SAlandCfOJ9m8wLwI3JrVrRAcu1bPilJwLtli9SEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w52c/BGNVfUyu+uabSB5Wz8cDDSjrmCsR/Wkf0yuwL3t8UGaxjpj1BuRIB2eFJrYL
	 zomWVwfK5nfIB417T3rMslWS6DUcz3hs6jAJVX3B1azidRNPg4Q4l6nMiCMWq4jL+v
	 XXfAtoaNX3rYvWZ/bB5p3TC/aIoLPrhyEq6Ai3N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1814/2214] ALSA: hda: Avoid non-operational GPU warning at regular device removal
Date: Wed, 18 Nov 2026 15:58:10 +0100
Message-ID: <20261118150124.043063025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3af4ed9f927c469f23d03a76e3b438ed09715bd3 ]

When a hda-intel driver is removed manually and it has a GPU with
switcheroo, it always gives a warning like "GPU sound probed, but not
operational:..." no matter whether GPU has been actually operational
or not.  This warning was originally put for machines that really
suffer from the non-operational GPU HDMI audio, but it's seen at the
common path a normal device removal also goes over.

For avoiding a confusing warning, move the check and the warning at
the error path of azx_probe_continue() that is the point where the
non-functional GPU gets detected and given up.

Fixes: 2b360ba9a493 ("ALSA: hda: intel: Fix Optimus when GPU has no sound")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007171231.8147-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 691fc4be1f022..1a675dcce235d 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1375,7 +1375,6 @@ static void azx_free(struct azx *chip)
 			 * actually stop the chip) to allow GPU to suspend via
 			 * vga_switcheroo, and print a warning.
 			 */
-			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
 			pm_runtime_disable(&pci->dev);
 			pm_runtime_set_suspended(&pci->dev);
 			pm_runtime_enable(&pci->dev);
@@ -2377,6 +2376,8 @@ static int azx_probe_continue(struct azx *chip)
 out_free:
 	if (err < 0) {
 		pci_set_drvdata(pci, NULL);
+		if (hda->vga_switcheroo_registered)
+			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
 		snd_card_free(chip->card);
 		return err;
 	}
-- 
2.53.0



