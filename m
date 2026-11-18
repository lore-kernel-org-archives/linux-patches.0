Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045750;
	b=colVPSIFtf2keWCxLeCFPJXyJe0y+mBZjgjTmH1wQhLBGPb1dTvpPfvNn7Jtl7tH8lhy
	 b8dHHLckiKsSHIAXhXEnJ2UEnFzxKlq58Y9srlH8z5LNnjFKlIuUh311iol+mJO7/zHdx
	 9lFULtIOKmZDOIDV6lKEfi7E90Vp2U3Wi4qqnDxG3NCMyAK+F0jyg/eZKlumI0ofe6a0k
	 EIyZmQR8ndNRc6cyefm52PH8c05xgU9wAKJNuTnv285QmOvIGBVKsrEZAlrXBF/+n4ms1
	 WQFyRT7OLEInMjLl09Ec9xK/bTS+bhZAbxVPj9mlwEA1PsUy50mQgqUOkmitWkMb3zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7o68eTgEsknFFEh40ryUY2D+ntl5jFI2mA/IDAPx4nA=;
	b=Lw5GrydLAiGCUIBdmCcaE8VqprtyeDM7utN3CAVGpZp2jCsUadsrX4zq8L1v465onTwX
	 cuA9ihcKsU1UrKsj/c3B9exEevLyqFoz5q3Xedq0u7bOMXUMYBsb1WCNOucZpTACY2UXr
	 HdSohGIcnWjl/xghmOk5j++u46A4k+HyrdnCsFg6KPhesEe1RnHlBACmWYiC/jkMNjrBa
	 2s9FdPpLmk8SFKgAwXAPgPD3nKqICOkpX9Ed/iO4okJJisQDUVFqP44a1OvyNwpvbinq/
	 X5DGaxgoDEyGwyu5yu30wnuW6ZIU8iT9wFpYhqNRr69oT9ctu/7NP/U4Qqn/wIIlELA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHgbesPv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8524606A31C;
	Wed, 18 Nov 2026 23:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHgbesPv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469BF1F000C4;
	Wed, 18 Nov 2026 23:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045749;
	bh=7o68eTgEsknFFEh40ryUY2D+ntl5jFI2mA/IDAPx4nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHgbesPvaYMoxzcD1uKIjFFMaiFU9fMmJoyGYdbUvI2r+Cf2R8DSq1hSxPanj8jp8
	 QMKBrCjsgZGSohH2U0DbiRI5YvRR8Lmc03z7WiQgyDqMRCcNM/VyZaBzt+NaJoa2lQ
	 ONUCCPg6XJFHJJd6q/4+Bu54H5qhemOz8IUOTMsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Maksimov <nickstogramm@yandex.ru>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0984/2857] ALSA: hda/via: Apply runtime PM workaround for ASUS X55A
Date: Wed, 18 Nov 2026 15:33:38 +0100
Message-ID: <20261118150237.035694518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2994f85bc1b9a..59d4c1689c764 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1044,6 +1044,7 @@ static const struct hda_fixup via_fixups[] = {
 static const struct snd_pci_quirk vt2002p_fixups[] = {
 	SND_PCI_QUIRK(0x1043, 0x13f7, "Asus B23E", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
+	SND_PCI_QUIRK(0x1043, 0x1c33, "Asus X55A", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo", VIA_FIXUP_POWER_SAVE),
 	{}
-- 
2.53.0



