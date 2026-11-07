Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062445;
	b=AgItJ4BTv9cM+Hstgr2NHSb9Qx1FmTst7gDH562faL1OOeRD553ssmp6wfIUAbvpZysc
	 DnVpRNA5Ft9BC9DPWDGB8mhf39nIrRa/YcXoyKHvW/p049zxXOufwefgcc/U2JqRFbiXe
	 UvSXSiYGKhxMIGdeXkDR0O3rYbuBwK52KpclXYLWRmLBpLXI+bYLJMfDEUhz84ZZgUo9r
	 SFER+GN93Sea18a7ZZB6DkRVMXAv7vDWIJ3lmp5eddewmxszacLmlvWs2Gqc16aeN6Bnm
	 s5yR2vzUDxQvExLsilzbuZQzufNyKW6Gr6bac6FLuBw5sFAwTeBl242gKJbSah1qkfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Q5wZh5E849lcWU8nTq4UXSqb8nYK0ALzK37f39xlv0=;
	b=vUJKnFoXKcNWJttbD2fl+0PjbSBRYnNH3WnX2L2LC+gvgBnLy++tYMvJxyfdaNJ3g37b
	 OZLyxSmrKCRgCFsD2KrIKN5NMG0sSEUDQYT/Hf5yYc6phT0TQd3JA6r/xi7+z5IT2cd3C
	 e0P2CMTdkQKh+WBla+SztWfHKxsOhCWa4bkEJbeYxLB83xjBp6J1qZQ30TXUrQGog+tqp
	 PVcKPmYol6xmH0OUIGiqxbNvt5/GkyjELo759/FlM8nFV+DR4PoLb/ALoIS7mLFOIB/3Z
	 vV6RGVKx5SQie5ZKXnrXHmYzzQ9UMMXEArIKa9WYVKzm/qmtGsX5iS3nJJkY8KypJAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JCfDDXXs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CFE606D816;
	Sat,  7 Nov 2026 14:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JCfDDXXs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49941F0089F;
	Sat,  7 Nov 2026 14:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062444;
	bh=/Q5wZh5E849lcWU8nTq4UXSqb8nYK0ALzK37f39xlv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCfDDXXsV+jt8iyKS8kFN6GDDy7P9lgmAHR70vvc2fKJn8NFH2gq13K3ZKOYV2GU5
	 YwoIUeF8z7H89astUOx/Vz8BK8bn6O7Ad4ml4GaZJenUCFUpWKz4x+KPB8wsIoixem
	 nrdIYWxvVkHT14fMvSUNjo2YzUx6TrPUGy7yCPkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Maksimov <nickstogramm@yandex.ru>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1353/1536] ALSA: hda/via: Apply runtime PM workaround for ASUS X55A
Date: Sat,  7 Nov 2026 08:56:09 -0500
Message-ID: <20261107135035.830008253@linuxfoundation.org>
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
index d0893059b1b9b..456df3a7dc6da 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1038,6 +1038,7 @@ static const struct hda_fixup via_fixups[] = {
 static const struct hda_quirk vt2002p_fixups[] = {
 	SND_PCI_QUIRK(0x1043, 0x13f7, "Asus B23E", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
+	SND_PCI_QUIRK(0x1043, 0x1c33, "Asus X55A", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo", VIA_FIXUP_POWER_SAVE),
 	{}
-- 
2.53.0



