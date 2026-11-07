Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060949;
	b=vyRqzln1vAh+vqMI/FciIAQ9pYHaod6JPiGkqDYLemU8BWSpSGrA+lvwbQqR2Su+2hzJ
	 ZBQdGZU5bjzdVi9fSw4GWqQkfHeVS4Nd2UU17DCm0FSy9azUYszz77uSoHBwS8FlJqt9X
	 Dv/UjiDXwECZLmKDI4+kjd2iVrVs0mM/0gtTc2dI1rVYfGDU4QpIyd1zZI/EBpGFz5hH2
	 K6cQ4kWIENAwBF2ZNJk6k41lS1hXGkVB6f/NeOprTZWKdpx+F60XUkbqcVp7s+xL/luad
	 wC7ILLeIz4+gwgOm5V7W7mPP0SYNRxAAlJJLo7KsGqhuU4RmvhXWOMlUOXe1XHEh4XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oALJej7gvKFRty4C3TU7bw/Vq3BRBS7TBQcUzi6AJR4=;
	b=XisuCXH/YmX/S4GomkK0ziww9IRi0gK10L5pz0FM2Xmo8yUVZ+noNRkuth8qd7LVfDxi
	 YKjxpim5+wtrxULS757vDjAiAF1anYP7OBcFFP6rfOwlXIPr/91NV757Fk2vJqEvuma6c
	 rRkrTLWLGqdXy4NZTRyCZmRKHyK9AzsIJVHv5QTRIpc+WflPiaYixMyQkxZ6VnqrKTqKH
	 t0CLANs4irQtnNcOuLYGV0HVA4W/4d9EfRN0SyYsTlgTCtREUzEj4PYmiJWli716n2j/S
	 5npRCGr0BXJJzDgj8qLd++9G1yg5RUgjuNsbs9AVGIUk9JUaXB90PLiiAHe19oH1FXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIbzthPF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1264606D80B;
	Sat,  7 Nov 2026 14:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIbzthPF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1A51F0089F;
	Sat,  7 Nov 2026 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060948;
	bh=oALJej7gvKFRty4C3TU7bw/Vq3BRBS7TBQcUzi6AJR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIbzthPFLiF/GFUP10G3cjJgRoFswAkOaJkZTXLJmacXxx4XcYt1RRE++3XiV8qJG
	 XviHVp4sAWeBV6tsZZCdc2niidVHayFuKmjh7toj7BQKgzP6lQAGKyswWpeNdR+hD5
	 33LXm7M/gN6H3OJltVnokRJnkLF5nxmxYytgL92g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0291/1536] ALSA: hda/realtek: Fix headset mic on ASUS Vivobook S14 S5406SA
Date: Sat,  7 Nov 2026 08:38:27 -0500
Message-ID: <20261107135005.906275186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit f2d08f3651fb12634347fef2c41687a807a7dcba ]

On the ASUS Vivobook S14 S5406SA (subsystem 0x104310c4, Lunar Lake
platform) with an ALC294 codec, the headset microphone (3.5mm jack)
fails to capture any audio. Adding the ALC2XX_FIXUP_HEADSET_MIC
quirk resolves the issue and restores proper headset mic recording.

Link: https://github.com/thesofproject/linux/issues/5729
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260807125857.678297-3-zhangheng@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ffef6b5f517cd..6b883ade4bec5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11204,6 +11204,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10a4, "ASUS TP3407SA", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x10c4, "ASUS Vivobook S14 S5406SA", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1154, "ASUS TP3607SH", ALC287_FIXUP_TAS2781_I2C),
-- 
2.53.0



