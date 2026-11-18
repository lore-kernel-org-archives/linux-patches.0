Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049366;
	b=MuTYo1vUuQjV7kWq3+pj2qfuhF+qWdGrIkZS6H1qkCKUaMTTaRmTkU7TXo8qFpq7SjHX
	 lKjrp0Y70mlBOEk0XBkpTC2bvhrHoLheeiJWD4NC5a95Fq8sLYI3Q4OZJhI299gOsgCnK
	 a4V2ZMepQGz6d6otUyXiCEmwD8Tgn5EelmGcmnsswBMpIjjWEXvljXTZR7oqGEKUAluRc
	 8gyTuuhGTKQr+5wnOwe+7mhYu4W3Gyu1EJawJr2zE9YUy9kdfdG5Msnju1SyCD+AT8vL+
	 wOYIvo1HkaGpWUgIJ1ZnwViSgVwFo3/A4KZXgUfTE68Gr1qWS87IQiFMgeLEo3WpbgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=samJdQBu3PX6fBIMTeNPmV9+QS4w8aDniHJPzZcV6aE=;
	b=ZoEyuP9Je17Q+VXWRnMI40DPutzgzbK3gov1MBFz2RsQtiKM1Sso2+LnmM9ZQlxdE0/J
	 6vy6O2Z8HP8f/AyyP+F87fCDAkJ6GTTznPcrIC1j2exwA9DmJCBwZfvDwMv3R3LM5GB2I
	 HA9gSU+dhuQ1h4vBzenv6fCZEg6qQ5BlBilo5YOhvVDV3EjYrkKFzoZ7TeUd7XYPPnqPz
	 th1w2DoGPPWUEA6VJHNaAtjik+I2E62/KDwhtWrz8jyEo3+eTPV0Z8YJ5H4egQ12tkzTz
	 A8DGBv8cCA0EXk1mjNqwZqNgUxn+brdH9ZScPCvs25EG/S9Rg899tPrlEcjUwjksJAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NjnHac62;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0F3606A330;
	Thu, 19 Nov 2026 00:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NjnHac62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA6A1F000C5;
	Thu, 19 Nov 2026 00:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049366;
	bh=samJdQBu3PX6fBIMTeNPmV9+QS4w8aDniHJPzZcV6aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjnHac62mTio3em3OUEFvlqnUw8ldt85kPP7/28HtMpqLhqV8XcYRZpAjc59gj3a5
	 KjT+5liXMN4/dFly5mStKJu5nm2G+lR7ehmBF/vGv2lC+QjMHUuLnE1KBUTQRqSMWz
	 pQDlTyWvfOAPi2M2DUqf10XQuflO41Oht1AHmwgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2327/2857] ALSA: hda: Avoid non-operational GPU warning at regular device removal
Date: Wed, 18 Nov 2026 15:56:01 +0100
Message-ID: <20261118150325.320982237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 38d7ca14a795b..3058479c42dc6 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1377,7 +1377,6 @@ static void azx_free(struct azx *chip)
 			 * actually stop the chip) to allow GPU to suspend via
 			 * vga_switcheroo, and print a warning.
 			 */
-			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
 			pm_runtime_disable(&pci->dev);
 			pm_runtime_set_suspended(&pci->dev);
 			pm_runtime_enable(&pci->dev);
@@ -2413,6 +2412,8 @@ static int azx_probe_continue(struct azx *chip)
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



