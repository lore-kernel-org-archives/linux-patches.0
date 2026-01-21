Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3338634252D;
	Wed, 21 Jan 2026 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020231; cv=none; b=ru2P/E2JmMaC3jIkB4QfjjhfE/0i16excgPOZVyW844Ou7WemL/o3AaUJV6UPz/MzIGfhToPlVltNeo7+r8O83Q74puHQghwHxF5052t+1JdCM8EQkqJH5tHl4ZVPiGHjLizrck7dYzqod+Y1pUh7baz19mJkP+L6a16OpkKb7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020231; c=relaxed/simple;
	bh=dJUGRJsi4DrH4MOPSRZ+DRuoXi1oGGX7ZDBSHorI+Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtYlb+mSXAyG7S66ad+LIu+xCIdd5fkAG9Bu43DGBxlvI3Fd+dntjI5nEwnBaKp893tKHHX3buzqw4GjBglNIfNH5OeG12RJevpDvDglfUaqPK+dTJBm0mDUZz6maTBdzINKCtTgjrpHTwhepAg/HJKHpIKVXahQXoTc8XqZdeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAOZuvan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAOZuvan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8CDC4CEF1;
	Wed, 21 Jan 2026 18:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020231;
	bh=dJUGRJsi4DrH4MOPSRZ+DRuoXi1oGGX7ZDBSHorI+Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAOZuvanRq5QhinP8PYWVeYXu+QlDDV6j8XFq9ZcL32EH4e+XwWBuA9fB+1oke2fJ
	 E0GKgd9z96ZuhNbrTESI24Z+a8U9Kcq0fkTea8Co3JSZ4RuoOZkz9Lbvl/z7LCqaVV
	 xbqadVo/8skWSSRjFNK5ZSUgmmQpue1VuSz5WVPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 096/198] ALSA: hda/realtek: Add quirk for HP Pavilion x360 to enable mute LED
Date: Wed, 21 Jan 2026 19:15:24 +0100
Message-ID: <20260121181422.010619427@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit ab2be3af8c4ea57f779474cd2a2fe8dd4ad537a6 upstream.

This quirk enables mute LED on HP Pavilion x360 2-in-1 Laptop 14-ek0xxx,
which use ALC245 codec.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220220
Cc: <stable@vger.kernel.org>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260115015844.3129890-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6529,6 +6529,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8a2e, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a30, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a31, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8a34, "HP Pavilion x360 2-in-1 Laptop 14-ek0xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a4f, "HP Victus 15-fa0xxx (MB 8A4F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a6e, "HP EDNA 360", ALC287_FIXUP_CS35L41_I2C_4),
 	SND_PCI_QUIRK(0x103c, 0x8a74, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


