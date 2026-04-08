Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F243537DF;
	Wed,  8 Apr 2026 18:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674708; cv=none; b=TvJ54wogrXwdWasPP1PJwQw18rVu8fRJfuUYfchZSBXnjLYaACF5FROyFSCCqZrp6CItggC+B4hjOk2wl3X7IxWIhlD5mXxrXvLn9Kl+t0hxwS5XkzEot9eersV6Zmf9rE97hPctm2L2pwFMKMG4mkWZXweG0UQEgJrgr8yOS34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674708; c=relaxed/simple;
	bh=89V3d05Bsqjni3PiwPjbRdBNF2I1tCJZuJOuXy8vREU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZ/XUyeBPVLPXyHPfRf+3P/znfv9hO5EH0Qy+wMdpK5zAbH4qUoJJzcRTdeEY4pNy9xqjImcfHNKAzAKIDRPLEQbyywX7sQxNkb7p04ENZL3XDVACsXi7zdJ6mEFV46gTLNMRsirbXXvqpZoXlnDJRCTWKM5/BUKaM3fzrw5eoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWGaI1Jl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWGaI1Jl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4F5C19421;
	Wed,  8 Apr 2026 18:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674708;
	bh=89V3d05Bsqjni3PiwPjbRdBNF2I1tCJZuJOuXy8vREU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWGaI1JlHuUJJ0WmzatRspZbQY+Pen1bvUFuQw9kxVf8YAXOjnYApytoEb/skecf3
	 KfHzP0uFmCH35BT+ArsiiBPBpQs4USk1NMRqz1vD6AAEm+iut6vKPoKZilJyAIvp94
	 9HEvP018H/oa4gK0sRxLJ2eHNodz5OOmrbOC6nUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 175/311] ALSA: hda/realtek: Add quirk for ASUS ROG Strix SCAR 15
Date: Wed,  8 Apr 2026 20:02:55 +0200
Message-ID: <20260408175945.940264805@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit f1af71d568e55536d9297bfa7907ad497108cf30 upstream.

ASUS ROG Strix SCAR 15, like the Strix G15, requires the
ALC285_FIXUP_ASUS_G533Z_PINS quirk to work properly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221247
Cc: <stable@vger.kernel.org>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260330075334.50962-2-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7238,6 +7238,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA/XJ/XQ/XU/XV/XI", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301VV/VQ/VU/VJ/VA/VC/VE/VVC/VQC/VUC/VJC/VEC/VCC", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1584, "ASUS UM3406GA ", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1602, "ASUS ROG Strix SCAR 15", ALC285_FIXUP_ASUS_G533Z_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1652, "ASUS ROG Zephyrus Do 15 SE", ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZI/ZJ/ZQ/ZU/ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),


