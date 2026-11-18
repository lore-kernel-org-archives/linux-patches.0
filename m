Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025960;
	b=pFSexQ7C+u1BQGs6gQeWbqjTCkUCE6z5wLpE5jOO5EioxcmGeIPvCrVlR2tCxedeqYyQ
	 Op/+2TlmdQx1d/+0LcU+xGeVYFwIEFgSP2fD5mYbCPiT/IppYxu7M3ljSaKsuo3jsE1G4
	 Dy3mB3bgUedWOnxhXNU8+pbGLIfQO11NLzGtWBT8xIBeJYl4HJtN673CiCJI+jixqEf0x
	 6LxHhVdE+wj7wWLMk2DCdkVi2bEoJPhnsd7mKfhNyhHqJb2XzNVPilOo4BNQ3DFXQ9Mhj
	 17SHbwPm8hKFMZ7uWlE7BC5UBauCZWNPm6aF44/Iw5I34lEVhcSs0RgFvvW5X1KLw7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7N5nAPh48RkRbBZNNlWPIlVJokI1bh9D+OuJntonMg8=;
	b=afSiSDPP5W51vjw3sFbbyOF9ByisfyRASiR2g5hxKKKLW/GKaggK+vvVSPuydXopb6aN
	 PWUWq1ypPpVeo7nfEDgS9nJs0yAncb8XwkdAjAFxWb0qmf5qrXk+RYhA4YGTrvNLhA/5Q
	 6My82prwTftMLDiQL04GsRPevKpxm+2SQtKVcBBdocWJDyPA5E/QZnrDDqE+fHGlOr4HB
	 rjl7xakidyOlpn86I5rsxiGiJg8SE8emKC3/+oUypKmXpEUzzSOaZA14XN5wnChxWZn8O
	 08bDBRJTXbSe5IJWKUDz0sQadrX9KecGksTCOKbp2dGf6fxhBH2cfNTfQ1oLxy358wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdhqgVma;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5102606A32A;
	Wed, 18 Nov 2026 18:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdhqgVma
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC3E1F000C4;
	Wed, 18 Nov 2026 18:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025960;
	bh=7N5nAPh48RkRbBZNNlWPIlVJokI1bh9D+OuJntonMg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdhqgVmaDdKujBq6KXyrljGFLUjPtCH8DF9x/2rPkPA5Bv+vqR9y+yxBbU5Dmvvov
	 71eaW3QXhMD3o4+Dob5SCyy8qtjXlUe2IER3woN3cI5kVofRgs1NXIyBUj8yCxIdwO
	 i4arozXMhaLxu9x75Gnu3udiA+Kg4tIXyBiK/qGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1265/2151] ALSA: hda: Avoid non-operational GPU warning at regular device removal
Date: Wed, 18 Nov 2026 15:50:00 +0100
Message-ID: <20261118150208.226052523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
 sound/hda/controllers/intel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index fd61dc8e21a53..45bdacb9a91ba 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -1366,7 +1366,6 @@ static void azx_free(struct azx *chip)
 			 * actually stop the chip) to allow GPU to suspend via
 			 * vga_switcheroo, and print a warning.
 			 */
-			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
 			pm_runtime_disable(&pci->dev);
 			pm_runtime_set_suspended(&pci->dev);
 			pm_runtime_enable(&pci->dev);
@@ -2411,6 +2410,8 @@ static int azx_probe_continue(struct azx *chip)
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



