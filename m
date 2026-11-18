Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019355;
	b=oW16o1wSIyDHICSij0sxMMYtK5JcAXYl8xHnA887gnNRQlkKKnykM8ILezPieEWEolME
	 kvkZeqcNbs+N8R/ppkjqyUAPvJKMAEmKzdunOXqMZi95S3KHJJJx2rhCMfGtrRJHQqGTu
	 23UdsS6iu/uGFeHaYJDISTNsyT1uDunXL30GTjrE4k2/DyxeEo3Wq2lV8gCMiouWXyLQq
	 awrbe/3ftwktWnXnEl8Lnh5QJtCZE1Hw60Z1lfp32okkkMc/e6oVGiebPFou3aFjggW0G
	 +oYX+aGaSA03OVPRWEhXWAjDhCHrW+PM5F1zL/a7IONiX8+g9NWO22qyLCn7CqCZTXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/VkXhFx+uU2Y52uWYfLVcsFblnXiqzWyJ/tfdCPUgiw=;
	b=5nhSW4bx3Rnq+t3WANG6VoyDrR3OQzc/vcjQn7tFGXu3x8OLk/4820ZPwQU5M5zSxNSK
	 85lToY1kUayZB+nWNQfhV7/cxRbeenbgm+ZpffP9Dsr5H0/n/g/m9OU4P7EKnQAa017zc
	 Xc95E2LmV0Ahbsi+efEP3lvRRi/jKhU+OYHPv48qX1njbBdNvy2rfCvEeV6Khp5Qz6O1W
	 jWyQnNgI67w6BS5iAiQnN4e+WNWZBkenspMrrRSgFvZtCRT2XYUji0qgb9zGk8V6+n/of
	 dY9d4IrVJj7C62crB38kpN8xcpudgneR8TrFV2lRqNgW3rno2DRr+hA33bet/0HKDCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lRYl37LO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB3B60A260B;
	Wed, 18 Nov 2026 16:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lRYl37LO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A431F000C4;
	Wed, 18 Nov 2026 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019354;
	bh=/VkXhFx+uU2Y52uWYfLVcsFblnXiqzWyJ/tfdCPUgiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRYl37LOyKnYWM7S58MPrN41TqowG/y9+XbcSBMemOGuEwwvS61bbVxe7H6yOFS9p
	 oZIWITr+lx+dZ9poyTHXmmrSApyWENgX0pa1mZMAca0Ni6PK4X1EimUyjbFuV2EUg4
	 igF3fKcLxjPnQltAgaQnTTc5CavBFfVW8rXtyd8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1529/2651] ALSA: hda: Avoid non-operational GPU warning at regular device removal
Date: Wed, 18 Nov 2026 15:46:09 +0100
Message-ID: <20261118150343.026691481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 24015c73a67f0..068fc522658a6 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -1380,7 +1380,6 @@ static void azx_free(struct azx *chip)
 			 * actually stop the chip) to allow GPU to suspend via
 			 * vga_switcheroo, and print a warning.
 			 */
-			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
 			pm_runtime_disable(&pci->dev);
 			pm_runtime_set_suspended(&pci->dev);
 			pm_runtime_enable(&pci->dev);
@@ -2448,6 +2447,8 @@ static int azx_probe_continue(struct azx *chip)
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



