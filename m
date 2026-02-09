Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0ED235CB6B;
	Mon,  9 Feb 2026 14:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647335; cv=none; b=OxsPDWnLwt5ZbpUpCoIDaAIQkJybXfho9NnWk9hVdXCTwqSKFIICHrVyI4osOJWMAgVhEN1N0z5ho5hNy95Li0wu4g6MKEQHhl2+e7ux7rmVSw5PwQxutD0cVo/tfdqZoYTh97Qy/qD4iMdcfBLl1cyERAUGo6tjxuiLz4Dm6K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647335; c=relaxed/simple;
	bh=zueeKhA1oF48SzUbfzUw6gUmIBytL0ud13N/a2gIZAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MP2XQN0zJ6fEtYt6v0LPPT6ygjyFFJSTX/c0dTBFjhjtelv8GM927/ELZpREA49QQ7OPMU0bOUhfNVQ1V64ZYtJdUXhU556yq6OnwTK66ExQkSB5sQOMN7+ABUBjHmfWM4G6D3IiNPsPUM1rhNB2VWX2OljxIthFqOOrl8xPk+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ga6OXMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ga6OXMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FEEC16AAE;
	Mon,  9 Feb 2026 14:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647335;
	bh=zueeKhA1oF48SzUbfzUw6gUmIBytL0ud13N/a2gIZAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ga6OXMj1Kle/d1tBNgAJP+6/HFoIJkdRId8jWOWoABNsH0XTP6mDvb8JYJb5n+/h
	 8JUHhLljeQtemldlXvY5FcDZPnsl1Zlp7av1C/e8xJ4XnsJ/US6GnjlNwMPQ7oKxgH
	 5nQGFlpssx+HsAOHtu1jCVpDjBRrS9R7ucHXU2BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Matou=C5=A1=20L=C3=A1nsk=C3=BD?= <matouslansky@post.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/175] ALSA: hda/realtek: Add quirk for Acer Nitro AN517-55
Date: Mon,  9 Feb 2026 15:22:22 +0100
Message-ID: <20260209142322.936463162@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matouš Lánský <matouslansky@post.cz>

[ Upstream commit 9be25402d8522e16e5ebe84f2b1b6c5de082a388 ]

Add headset mic quirk for Acer Nitro AN517-55. This laptop uses
the same audio configuration as the AN515-58 model.

Signed-off-by: Matouš Lánský <matouslansky@post.cz>
Link: https://patch.msgid.link/20251231171207.76943-1-matouslansky@post.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 9097de7d2e3d7..28a390f8636dc 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6239,6 +6239,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1597, "Acer Nitro 5 AN517-55", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x182c, "Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
-- 
2.51.0



