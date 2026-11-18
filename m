Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031270;
	b=JFl7MAmxcFG/hcvYL6dYnWhpNwbFDezoMLbPdbcx8pytfsnqRgycjzrvCUKjjKbG1Y0F
	 GJqUoe0tsbTXJ02N0+a2iPrFLkgTG0yACHT0IfM3n92xsT2WJ+4AOwPzVN79Ys+WqzU4X
	 6npvOQlnQEvmpxu9TNpjwjJ8jBmsQXeRgkVcAUZWxbz8gbgkZLRFmwdKkZG+EXotTYS4t
	 cf53fYXv139Xx1S6wsRTCJqSv/B/mfYcyaOGxzIAOUw8LT+Z5yRaHrlnsGNVWEBGoFibl
	 KT4ATXCT0aI9DlDanRse1sQPrdQzX3QS4n0jrrJ+5XW6O8lF87vSqiqxsJ5RXnUpYRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iCSblbchV1tTO1o7Q6WvMyASGaBEwJXjdMBp54bXcGg=;
	b=wChQxu7EWI/foUYq+fKVUi9LPJodn3gvAQh1DxC4Qns5USk30/CXB344+cCMYr1ouC1d
	 vz524q+VgWUNwebi5kA7QnjTne8nuqUx5XrP8iBIVlNPw56uCiINku36E494sI9HnrWmu
	 yLducsPbi2KdejIktDKSnk9ya0F8xSMo9qhF/hnCNktUbX0PdyV9EI6D1Uzt7F4amWb1C
	 y0Yi+B+LFvjJxy2c06M7575KdsuYxTcM7hDtIzg8BH70t2RDDYbjsKvovVPBk8e3uQSBQ
	 fmR1OWUZi3OKU/w6ORDi7d7v3pn6iV75NOzUxNUUZU8DI+K84e7dIxkpq7wl4QsvrPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vu+uRTKV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF79606A320;
	Wed, 18 Nov 2026 19:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vu+uRTKV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D451F000C4;
	Wed, 18 Nov 2026 19:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031270;
	bh=iCSblbchV1tTO1o7Q6WvMyASGaBEwJXjdMBp54bXcGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vu+uRTKV3bCxj/aRf/2mpGPBmUa3Mp8lImZu+h8MtbEMowlD4kgf/i6DlAknu5nfV
	 DTK6eS75zklNvZdFZChoSvfW/XhYJW0I9+T5IgiK7DzywPHDw0oYW/DKFKfjniGskp
	 UN1elVwC+Fcn+Id55vE1HrFF59XS3l2/Hj1JJz5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0998/1756] ALSA: hda: Avoid non-operational GPU warning at regular device removal
Date: Wed, 18 Nov 2026 15:52:05 +0100
Message-ID: <20261118150049.905959485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 48fe74ad34124..667eac42a0869 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1371,7 +1371,6 @@ static void azx_free(struct azx *chip)
 			 * actually stop the chip) to allow GPU to suspend via
 			 * vga_switcheroo, and print a warning.
 			 */
-			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
 			pm_runtime_disable(&pci->dev);
 			pm_runtime_set_suspended(&pci->dev);
 			pm_runtime_enable(&pci->dev);
@@ -2412,6 +2411,8 @@ static int azx_probe_continue(struct azx *chip)
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



