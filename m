Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA763BBA12;
	Thu, 15 Jan 2026 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496411; cv=none; b=nvmeg6OBblWU1h7PKrBdYEqkalOkOsJgKNA5leoh3cz8QKm6kDhlzjWJdLHfqCfNslHpC4vz+8VapX705l5Jp67dEj8GJzFrDpDaQCxomvbsF0N66LhI8TGKS9RbofYaWKUugkPMGJrMk++ggbHvfoMX24oYRABqOWwwvYWBcww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496411; c=relaxed/simple;
	bh=CSNvPtDm7ml+01uzTubN8v8k27syaUaE3NE1nbpxb6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPcOR6m5Kr2KnqtUWcFk5QSbrif+80ISrf5YgDZpD9Dcz3b1DtKjSsCXNybSVsRSXQvsp4B7N+k/Sqev6A7d4v67CzwFFI+PXzHu0WSRqoD/n4A/wxSDUOaRsN6hQBnms1L22jsunkNeSK4MrTmIMxe4OLXFqYH48YzL1CMkE5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTn9i5nT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTn9i5nT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF77C116D0;
	Thu, 15 Jan 2026 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496411;
	bh=CSNvPtDm7ml+01uzTubN8v8k27syaUaE3NE1nbpxb6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTn9i5nTWV/fVRhyj9mvKZV8vD/03Vxjq4iJ7Sb80Zv2nA1b+FWMt7fLsgpmvxDYh
	 0oNH97OW1hKCxQ7HeRRkk6XTs8TwsTwL4cJ8eEt2+YMwrSGcA5duWvIKPF4uIcUtXu
	 IMoALqPz66kK5pXgKmqp5KJ+8kxGuSJjA9IkykMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	davplsm <davpal@yahoo.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/181] ALSA: hda/realtek: enable woofer speakers on Medion NM14LNL
Date: Thu, 15 Jan 2026 17:48:35 +0100
Message-ID: <20260115164208.740530772@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit e64826e5e367ad45539ab245b92f009ee165025c ]

The ALC233 codec on these Medion NM14LNL (SPRCHRGD 14 S2) systems
requires a quirk to enable all speakers.

Tested-by: davplsm <davpal@yahoo.com>
Link: https://github.com/thesofproject/linux/issues/5611
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20251212174658.752641-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index eea8399e32588..eb6197d19078c 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7211,6 +7211,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1e39, 0xca14, "MEDION NM14LNL", ALC233_FIXUP_MEDION_MTL_SPK),
 	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.51.0



