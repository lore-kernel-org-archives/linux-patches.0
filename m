Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057443;
	b=FiXfAMM/HFx/9unDBlotW3tist60BxwdHSxVnHuTq+un20X40VmI2LVU8GEP3DHJ01IT
	 Sab5qG8Oy8VKi1ksmUjykvnaFLZ22E3HE4vQ89irgKaoFpm4HTjkvRR0SUPWI/7C6tmpl
	 Wv9eS/M03yw8gell7eUht2FH1me+tLBXMR7FHa+QSLCbypBmZnXG0InMEQKQWEap/GkUq
	 NbpKa744GBUPjF+jH0jmkU8bu0BQJRmwXPlJpPDJ4TrSgU1JPW0GuaWLSryngwcjoX9HX
	 i4pRqwaarWp+KGeuFo4juDWV99tvoNFJ2Wi6A3Oyq/AmEcZ03uRD/Dm6gZEBfyBMdSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kcqK4Tk3CHmoI7avAew7tn8wtvSy3xlLzt6oNKSmyjc=;
	b=WLwMEhbPbzB8fPYhqri8Je+wBQZfd8JxyqLzd/30RYscOI0AH4Q5TUqhcAvrRBqRgvwo
	 4RSiUHr/vPbIoqKTYEvWmasQJgkWu0hkSApa192XnNfxZhXuOLvhEPuIC1cNAS+CVNkid
	 bo0nkqofqqcDL4bfR3lbF5Pq9fpBI1jFbEiEF0gPciKBGvS+0XoT1WJ3OjJTzNoFCwpQD
	 t8UHGaTBI03DMPVmQ2eU3t/qYNWfLBU5m7LUYSkE7YNwwK4XjJ58JxX2Blj+QukuCu4vu
	 J5sISHELuXinvaNcNzD+zE5dVFeN0P/THguRSmPdFdKGehUl9CJSEJMAAwnMCvH3Gug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Te/clXjv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A04A606A333;
	Thu, 19 Nov 2026 03:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Te/clXjv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C3F1F000C4;
	Thu, 19 Nov 2026 03:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057443;
	bh=kcqK4Tk3CHmoI7avAew7tn8wtvSy3xlLzt6oNKSmyjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Te/clXjv+etQ/E71wHc/sntCbLrh3LaBFESMoqdUSkco3JIMxjpyyb5Gl/vhck2WB
	 86G9nR0vxqPrYdFNuwUcL7S79kevAnwt6KOl1qtUe/AUmc41gCAw6TArvSkTStl4E3
	 tmZfXK2sjrfF5m9MipewnUo9eVpEh9x8t5P80Mt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0131/1848] ALSA: hda/realtek: add missing NULL check for codec->bus->pci
Date: Wed, 18 Nov 2026 15:36:09 +0100
Message-ID: <20261118145916.631880392@linuxfoundation.org>
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

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit 3b36ac93739e7b119a30affaee9c2dd41f24efbb ]

In alc269_probe(), codec->bus->pci is dereferenced without a NULL check
for the ALC236 vendor ID case. Add the missing check, consistent with
the existing pattern used elsewhere in the same function.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260730015302.253008-2-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ea10ee4de2f5d..acbe56e95f42d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10398,6 +10398,7 @@ static int patch_alc269(struct hda_codec *codec)
 		spec->init_hook = alc256_init;
 		spec->gen.mixer_nid = 0; /* ALC256 does not have any loopback mixer path */
 		if (codec->core.vendor_id == 0x10ec0236 &&
+		    codec->bus->pci &&
 		    codec->bus->pci->vendor != PCI_VENDOR_ID_AMD)
 			spec->en_3kpull_low = false;
 		break;
-- 
2.53.0



