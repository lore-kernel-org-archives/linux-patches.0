Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061405;
	b=zrw6bRbdyVBl9v9zxkyoSQ6xm4XjKqvW0Abm9atVSNOQ2QyYMkcEGhPaFrkbi8Jr8y1y
	 BwooR/Wie1rNtdWIitCuhvVX5YQBgnGLS5aKnoXSr53509c+qMYqrkkn6HfIO8iUcw6IG
	 SlasY64tDatMBQfh8Ux38Bxvh1pyVB/oCIXweRCIuAbGolrvGxqgHZBo+BFc0zotfDTTr
	 Zp3eAasq4qoTH3DnuArohhTknaLJnBRW3dIe46beBKedlIgicfbBF+Z50aU0HNfyZeDZn
	 IMwuGbxrhXqZJgfs30ifK5bww8OUjHDq6GWZCrCBWL8zbL4MU4xtoRrnLHCz7+V80lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UkSpQ5Nb4xuZ7c/ix3xrmRjC8J/amG5TapIHBR99S0I=;
	b=uHJr8bnTi658ogtJmEpUvGjIoVY6HpqxHhvwWmGpXRcvsr+c687Hb3qVNZx8bp0LyX88
	 POWE2Wm9FAbSsGfNcLFLFRzfTyAJE1NI8FzVisdqhWj/feanfUdQ7xhFxjcQOoNGXYfqb
	 TeDeuToc9Um9G/UKaSkYoikWw99dcLECp6OPlJgFU8hDDaWKC9La+SEdgRlbch0TVyiK8
	 obR9gIWLGqBxjO/sE6EDVGwrUwyNTebQ9wYhWEJNWjpK2zSLDI/89N3LoPbKPuBkHFdrO
	 1EcIsIybyzUexRHudWkn4S0suHRxwuV6wIQJk2BwaRZOWbg9BGcw/rxVt+yw0XzY7mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptOn9mW3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E8A606A320;
	Thu, 19 Nov 2026 04:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptOn9mW3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C828C1F000C5;
	Thu, 19 Nov 2026 04:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061405;
	bh=UkSpQ5Nb4xuZ7c/ix3xrmRjC8J/amG5TapIHBR99S0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptOn9mW366Rjm16CmNMXQrFHpHhrvjdOx4jVxdoNMtWtp3JPHp4pGFyJJIyNnC6zE
	 +VXbXy5vrM6/8FicmAEFZtN5EmV2MGmIfO87s5XQxSUNx/1Kjc17jYpsuImi+JMc3o
	 kUUBLhAHlprAIk/m+DwtgaM/RcZbD3yF/UTZGziA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1540/1848] ALSA: hda: Avoid non-operational GPU warning at regular device removal
Date: Wed, 18 Nov 2026 15:59:38 +0100
Message-ID: <20261118150023.971110201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a16c09fcaedec..f5417611f2551 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1409,7 +1409,6 @@ static void azx_free(struct azx *chip)
 			 * actually stop the chip) to allow GPU to suspend via
 			 * vga_switcheroo, and print a warning.
 			 */
-			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
 			pm_runtime_disable(&pci->dev);
 			pm_runtime_set_suspended(&pci->dev);
 			pm_runtime_enable(&pci->dev);
@@ -2445,6 +2444,8 @@ static int azx_probe_continue(struct azx *chip)
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



