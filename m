Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26DB3176E4;
	Wed,  8 Apr 2026 18:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674723; cv=none; b=C8PgKPCodPJ06frwS4NClawZbu6m7l0O6RL8H+F0DkPhUr6KY0XEuaSYH9NmGs+fw5purIxRH6aKPc2Uxt2LzpCPNSs04v7t2huh/E5J1ucTmkPr+ZbmSPyCuGoZFmm//AJgJKPnEB2ILXm+77Ijo4F0q8DQeKf0NKfKEZK6HuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674723; c=relaxed/simple;
	bh=c0MIJWZ9ljO5DVuk6ES4XN2xq+28VXvHvD9ToHf+09Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8uNVr4sgxbM4807nQYPEnoDy6nNSNndU0qA/PQjSe1yM8jcPs2OUXhkq6WxdykaXg5kl8igj7TiP/9ktT5XqBbe7fccrgBUmFNpBKe1aX4gYHaLKkpPNddn3IOj9sc4hjdF2p9WYXpM6R2x/iyV4mJ3okIanaK1dI/TjM9q+Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbFJa3xS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbFJa3xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579E5C19421;
	Wed,  8 Apr 2026 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674723;
	bh=c0MIJWZ9ljO5DVuk6ES4XN2xq+28VXvHvD9ToHf+09Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbFJa3xS+IFM0BncxLpu+eejzzLX92JUmk/Z7tG5zOdQtqRpSOCZb/19q8LQ/raCw
	 HxWgB+zEW2Uw2bvMR0CK9kEWOcjWz7IIAI6mMqwbnj+Z3Y8vtZjG6Z0gJxYS0RXSxF
	 FviHTp5XeD1nsFXUKP7mIsaRYd0ESaVhyQol3o1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourav Nayak <nonameblank007@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 176/311] ALSA: hda/realtek: add quirk for HP Victus 15-fb0xxx
Date: Wed,  8 Apr 2026 20:02:56 +0200
Message-ID: <20260408175945.977322366@linuxfoundation.org>
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

From: Sourav Nayak <nonameblank007@gmail.com>

commit 1fbf85dbf02c96c318e056fb5b8fc614758fee3c upstream.

This adds a mute led quirck for HP Victus 15-fb0xxx (103c:8a3d) model

- As it used 0x8(full bright)/0x7f(little dim) for mute led on and other
  values as 0ff (0x0, 0x4, ...)

- So, use ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT insted for safer approach

Cc: <stable@vger.kernel.org>
Signed-off-by: Sourav Nayak <nonameblank007@gmail.com>
Link: https://patch.msgid.link/20260327142805.17139-1-nonameblank007@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6981,6 +6981,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8a30, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a31, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a34, "HP Pavilion x360 2-in-1 Laptop 14-ek0xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8a3d, "HP Victus 15-fb0xxx (MB 8A3D)", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a4f, "HP Victus 15-fa0xxx (MB 8A4F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a6e, "HP EDNA 360", ALC287_FIXUP_CS35L41_I2C_4),
 	SND_PCI_QUIRK(0x103c, 0x8a74, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


