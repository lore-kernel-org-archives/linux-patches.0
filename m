Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058588;
	b=Yo58oYHKF+qwP2BGz5tLySfie6pv4WVQ4liT3A14wt9sUPc+ds0ofcPSxDkjXndA41wH
	 2HQEpjFAa+DWaGO+yXjHY50Y1xgJvW7M7k+f1hWuNQieyc32FJPeY+HGmdAwZU09zAHah
	 2+Mv/ubJRojzKcmlssYecPc78kYnWkEAUeW8xmHzTh78dUYZo72+HeCqGU3Ydjx7tgqT8
	 ZhYVVw4VfG7xlnqPxkS5dwD+2QsJ8gmp9ifLe+iZitoQu/QvQLqiyTpHAavBfgR4kPkWY
	 FGps1nA6gu4cid0ntG/QaY57UvizSPaXq0U5pGYOxIf0utXtj7lUmt2FXXH4Wgwe7ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mTZOFKMnnCYeh5fUsGZlDIjProVF7+y5sYeHKU+WsbA=;
	b=ISEJ/FFDN7OiJ6zXIL4pnAx0avAnWMrn6hiYUnXirBb4kSYNBnHOnTzzuPHO3Qi74DsB
	 9Ogze/kgrBM/0tRPc/xxoODwFTECGKnwcbRkCnS1c+DYCR9NJO6TsTRQiJ8Bb5jgL+T1W
	 rIMfUxcKIwon3k4I3ZsBQ81329voWfmQ+NOEMqWusE5w/mdpT9PlZQeKTpdnzfD7bsfuV
	 0sHqBx99KgPB8b4XkLw1HrTci51jSu75CutsXtFcRAZ3elJRbPLBuBnbHnKfFYNQdSoyD
	 OWwztWsdTGRj/atJyg3cuO1eEDMaV7Sn/lMNrPG06bycL8CVuVNU3PsOqJzQL3Q+8nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UbPyz3ow;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A52F606A31C;
	Thu, 19 Nov 2026 03:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UbPyz3ow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A387B1F000C7;
	Thu, 19 Nov 2026 03:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058588;
	bh=mTZOFKMnnCYeh5fUsGZlDIjProVF7+y5sYeHKU+WsbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbPyz3owd5n/Ulw+xfhuAE0627fyYc+cGmUlNSdHke6lmwG/HqdZNP6xLw3rBj0fj
	 BLley+2y9LJJ4KSONNby0xmtUOBJklfQwaAXe5kY+anZLt2fjPZq2bNS3NcicQxy3o
	 /yPNZFGUHK0eFmITYmz4E9CW/rFiN02PRRxJUZ1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Maksimov <nickstogramm@yandex.ru>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0540/1848] ALSA: hda/via: Apply runtime PM workaround for ASUS X55A
Date: Wed, 18 Nov 2026 15:42:58 +0100
Message-ID: <20261118145937.568902402@linuxfoundation.org>
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
index 29abc96dc146c..99e5b4734aa40 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1046,6 +1046,7 @@ static const struct hda_fixup via_fixups[] = {
 static const struct snd_pci_quirk vt2002p_fixups[] = {
 	SND_PCI_QUIRK(0x1043, 0x13f7, "Asus B23E", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
+	SND_PCI_QUIRK(0x1043, 0x1c33, "Asus X55A", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo", VIA_FIXUP_POWER_SAVE),
 	{}
-- 
2.53.0



