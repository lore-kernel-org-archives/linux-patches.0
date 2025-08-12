Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BE51D416C;
	Tue, 12 Aug 2025 18:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023170; cv=none; b=PTDEDZ+xKNzJ+n4CTtiMVL1T3rD4+WTcfNNoa5XdFO7Ry4NL3fiROvW1i4wVwX2SN8P/CgvZdzj11o/qVD4pto3Spqcpi57c+EXN7+b6JOfliFu3SlgB+iO8thh5fJi3yncnDzYFXDJAhT06RADYcu7+pSHxpRyz5sDmlf077jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023170; c=relaxed/simple;
	bh=oqufU1mVM27QcU4dwkLhIFedkNSereROMK8aplppqlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncniUEpDolkdiPx8/bbPJ/5lPJDpt3XkA2AwC+RomiN26vA9ioeYYowXjfVQ5ht3nWwtxERzWGfOny3BPqdwjFubjP+V8Kstnmes8uotajE7wnHZ/csina+7MNkh441144MfTSCTAb3zvK8OMI82NLsZoeJaiIyJ6CZmnCpXh6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Si40jJMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Si40jJMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82ACC4CEF0;
	Tue, 12 Aug 2025 18:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023170;
	bh=oqufU1mVM27QcU4dwkLhIFedkNSereROMK8aplppqlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Si40jJMJB1BD0FQFTuahrD3tGgBYBuyMj7mzvIJAHv3W7kNmYL9RRZuefCsKKIl9e
	 iv19LVu0OJTEjbK1ONBePHNtRN78bxax851EOv2xjoWAHOzfmYKhIf+t1r9DPBk8zY
	 ukoYM+5W7dw3UKF7wJK/V0L+JdLApBzTmzkRZsb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 356/369] ALSA: hda/realtek - Fix mute LED for HP Victus 16-s0xxx
Date: Tue, 12 Aug 2025 19:30:53 +0200
Message-ID: <20250812173030.083525726@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edip Hazuri <edip@medip.dev>

commit 956048a3cd9d2575032e2c7ca62803677357ae18 upstream.

The mute led on this laptop is using ALC245 but requires a quirk to work
This patch enables the existing quirk for the device.

Tested on Victus 16-S0063NT Laptop. The LED behaviour works
as intended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20250729181848.24432-2-edip@medip.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10736,6 +10736,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8bbe, "HP Victus 16-r0xxx (MB 8BBE)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bc8, "HP Victus 15-fa1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bcd, "HP Omen 16-xd0xxx", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8bd4, "HP Victus 16-s0xxx (MB 8BD4)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bdd, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bde, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bdf, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),


