Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B6C3D9DA5;
	Wed,  8 Apr 2026 18:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673205; cv=none; b=YZ9C0ZbKIsnrfPmmb4IZ+ImTwGN+j9ydq81cG9cGVcW31xlILklfCFY+DKEX4iy+oaebmocP6tqL+8y8nCuyj4jkSNGp8n7MFbgLdc25qcPoz4w/dE/gfryrnCIwvLi3GJcqjvMosEGdOpwjvaJAYm48RyBqWQKpYQx08cEXY1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673205; c=relaxed/simple;
	bh=OMOkAb3vwJFU/RT4LC5svJav25ft+udVqmN2wUZOG7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msZ7pRm6wRZhE4d0sAnA4YFtxaGPFhU1qR5/h2Fs3O1wpjtjxUfsYOgsrAeqnLa6AtlvY1tAwlwyDgTGwtlVW23SaOzlkQPvyfSfs2+Jl84x6+Swvi8csMiKKSCv7ihMjt3VsE5VVUZnxynHgeSlLAdLEDzzlkpjJBzSqgcIjk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GukGxFU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GukGxFU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A561C4AF09;
	Wed,  8 Apr 2026 18:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673204;
	bh=OMOkAb3vwJFU/RT4LC5svJav25ft+udVqmN2wUZOG7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GukGxFU9xQepVzx9+DCaOUuDVvuecPE0xFzD7WB1EaUi3YwutkR7s40Mm1LOZH2iO
	 FS7BxTp8DLLJ1cr+u981lTZZE5FBTJvrRCXWXoRSEGdloz28jm+j2/D8yKcbUgDMd2
	 9NIkNrHMqAB3+DF/3JI8yqhMVGDfHRaMesdQFKII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourav Nayak <nonameblank007@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 140/277] ALSA: hda/realtek: add quirk for HP Victus 15-fb0xxx
Date: Wed,  8 Apr 2026 20:02:05 +0200
Message-ID: <20260408175939.103499480@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
@@ -6832,6 +6832,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8a30, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a31, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a34, "HP Pavilion x360 2-in-1 Laptop 14-ek0xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8a3d, "HP Victus 15-fb0xxx (MB 8A3D)", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a4f, "HP Victus 15-fa0xxx (MB 8A4F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a6e, "HP EDNA 360", ALC287_FIXUP_CS35L41_I2C_4),
 	SND_PCI_QUIRK(0x103c, 0x8a74, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


