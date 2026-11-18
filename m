Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036755;
	b=jXyrONS6Ag3p6RoyI7HKxn7dsWHHIJYRMrtT0Te0GU6AviAGhnVYZ6pbjJpWMMWYQtHe
	 H7w6zO/5w5OJWfye2lTVg8IAN5B56fLQr3HiGongrPFe6LMxY/0u/GkI2K2feiJg7dqYx
	 r3FYAil8T87X2lQ151FfwK7hRbctbF4bD81gXWAeVdoXM47bv4yS+f4BsFRArzGGDT7/P
	 84MBr/igwqOw7J0NAViUE0aSqCVWTZWpks3Rl3P+YNcWLlYPVeX2Vt+dX0UqCTuVIlqg1
	 LzmJGSmmsfsvfeuWnoYIzhsmg/gWLmE8WRuCwekLO1ZlsDf2tIQFhQ/Hdj8Bkx7aEIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jz7Vy7eSwfd6p9vh2RSMFKKCERwsp4tEhfVqPtoTIZI=;
	b=tIITw2JUHnQXEzVsUjkTtzE5cM/NX4ZH9IgjA4hUEmSP8flRKwOnMSwMj5nXE3km5WMy
	 wZnSHjJR8QcXsEPMKPRWKj2/k7+9kw8MV7vkV/EEWBKI0zGNwWYnz+7IzBHN0DfSkODGI
	 JG3lvT3FYyIP9yqlKuBmiRI3Ozub1CpgcRzZtoqHUZpAI7pmZ2s/2oT8GZQ2A3C/txV3O
	 y8tr5dg2rSvU6mi3lLo9qcovaJKPt91hZVUquIVCmKrNBLud9TGABEe/lrXCxxHPANwf+
	 YlOsoJjmwudcmbpLwsZNcJDZi/OgD93c+msAXidVMNpfdqStRMdQKFcsoDa2zaTJDdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5atwJgC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CED6606A31C;
	Wed, 18 Nov 2026 21:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5atwJgC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F23A1F000C4;
	Wed, 18 Nov 2026 21:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036754;
	bh=Jz7Vy7eSwfd6p9vh2RSMFKKCERwsp4tEhfVqPtoTIZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5atwJgCIgID80eHjKNs6pg4gma1ccXR9Rs+f4WVjfMZkq9z2Ml7+yMAWlIYG4zat
	 ml7w5H4B22TWyLdyXhJQ1T6jvOCWdbOucGZ8EC8w9Pwkl4I689zAiu2dzmGZsoT335
	 wmK/HHZ8xqMX1A1FtV2Z2Rycrft544BcLJpqtd3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Maksimov <nickstogramm@yandex.ru>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1155/3318] ALSA: hda/via: Apply runtime PM workaround for ASUS X55A
Date: Wed, 18 Nov 2026 15:29:37 +0100
Message-ID: <20261118150354.750951393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit f6e8d5ebde5ceb7d3c0eef6e9e4d82862b503ade ]

ASUS X55A requires the same workaround like other machines with
VT1802, otherwise it loses the codec power on a few nodes and the
sound stays silent.

Link: https://bugzilla.altlinux.org/45606
Cc: <stable@vger.kernel.org>
Tested-by: Nikita Maksimov <nickstogramm@yandex.ru>
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://patch.msgid.link/20261017101257.215166-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_via.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index bbd521859a3af..e761abaacc261 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1044,6 +1044,7 @@ static const struct hda_fixup via_fixups[] = {
 static const struct hda_quirk vt2002p_fixups[] = {
 	SND_PCI_QUIRK(0x1043, 0x13f7, "Asus B23E", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
+	SND_PCI_QUIRK(0x1043, 0x1c33, "Asus X55A", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo", VIA_FIXUP_POWER_SAVE),
 	{}
-- 
2.53.0



