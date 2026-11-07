Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064999;
	b=nhpnFFIoLk7Rkal4E4XANDIDuAXYefz/ewWN7VkMleGfzrArTDTCwxyYxVTGGhrN25NS
	 xAUovRmzA5FJxImxFIUoI/OwxpAzTgrBoCz0AuoGq6Alr5bpkQKeu1UKxehhldyYuEA0g
	 EM9AGUJ2IcFA5UZoKK96gq7EGWwzaWfZg4qSx49cWN0CcbwMrjZ//S8QrKbaibN821F8t
	 VmesP0ITccRTJLOJQ3HnMdIct9JyVk4wnZS8fHF1qJWplASypsU6R6Yh+b8Q8qPeOyUcl
	 B0h6s5OI2rZGYnw26prChCSdhX7N+yY0iznz/8e8DMyZi5fTVtGrS2szdAUFmSHWfaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v+zHzRLK8m0TyWNBE2KXLCbXxv7/+EdC/dUdFH+nFNw=;
	b=1Ox5cC7Q/pixJhPyXuRUhNp5FCQVevnzyzPMmowQC3m7yn/unwqFwdEDlZrwzh3LXRW7
	 nj7CI2j7P5Wkf95uS/8Xr1uw35hCyHhob3ftTAXkGiFtgJTNl6vXOn8fqm3ai4TF3KfUr
	 bInNkWqaJFADuQwbkJ+rxRj4+6iJU2UTRdDgsZdlrvoZgjwlJVhcEgEVVAL5yU0w46No8
	 pj6/AK6bg+2dHbDV7KLAF6YYoBZAlZN0i/2mBcTOj7lUzOBtGpg7AY35ZrPD77h70YpR2
	 hDY94HclEnyr3ceF40r50wM5geaIxnnsuuqb56+yI+iad0ygPXBgU6/n/84MsdaRxYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XlanMBYM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7F4606A333;
	Sat,  7 Nov 2026 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XlanMBYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA4D1F0089F;
	Sat,  7 Nov 2026 15:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064998;
	bh=v+zHzRLK8m0TyWNBE2KXLCbXxv7/+EdC/dUdFH+nFNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XlanMBYMxqraitqhrq8fh4oe8XzpU4NoCTOm9eI39ciP00LHRowmBZFyj4Tgg34ib
	 HK7Ya6SiJPNmPtFGUcSM6CKPT2Vl6REBABfrwD2Jg04VCxCAJFtK5kikYvA6OqMqRf
	 LaxTGXrfNvvYtgtCzRx24NggTbryDVMSqe6FDwY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Maksimov <nickstogramm@yandex.ru>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0868/1257] ALSA: hda/via: Apply runtime PM workaround for ASUS X55A
Date: Sat,  7 Nov 2026 08:52:44 -0500
Message-ID: <20261107135003.300504028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
 sound/hda/codecs/via.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/via.c b/sound/hda/codecs/via.c
index 807312cffd358..0641fc14b346c 100644
--- a/sound/hda/codecs/via.c
+++ b/sound/hda/codecs/via.c
@@ -933,6 +933,7 @@ static const struct hda_fixup via_fixups[] = {
 static const struct hda_quirk vt2002p_fixups[] = {
 	SND_PCI_QUIRK(0x1043, 0x13f7, "Asus B23E", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
+	SND_PCI_QUIRK(0x1043, 0x1c33, "Asus X55A", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo", VIA_FIXUP_POWER_SAVE),
 	{}
-- 
2.53.0



