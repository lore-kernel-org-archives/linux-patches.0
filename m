Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E084B261B70;
	Tue, 17 Feb 2026 20:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361433; cv=none; b=OXfcmDdNr9iyHYj379iiyv1BYx9JRFljuLAqUbH1rqHqRwuL7FWbPclp9Vw2O7gdxEy/Jc7m67eg6abuJwGNnw2BIsbhDBCMt9y2aco3/wEjYHrGuujHM2t0Y8RjMoqSyGwCFGUnlJHDKafc2Jlr5LAI3t8tP6nqGJztevnhn9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361433; c=relaxed/simple;
	bh=qk9iS7bXJwrHlbqx8v8DaO4KKB6tCz237BXGP7uiqgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6hE7RV1W4exIi48v3Am8xKVfby+VB1eX+Qc8tPsiuk5VJJzwupIJJmpkxVbgEQM2xeNcpVyupQn2eba/jviNz00YILv4rv2zBMBiQ+h3bETVqeMC0av1mn3hgG/ZOYqqdUWDsu7BWocA/prN4PD6JJHh6NOZ151XivFgzLgtwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3iq5+92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3iq5+92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4BDC4CEF7;
	Tue, 17 Feb 2026 20:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361432;
	bh=qk9iS7bXJwrHlbqx8v8DaO4KKB6tCz237BXGP7uiqgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3iq5+92rjz8pkxUKAkddVCHdMXEW4YM6SFWhp+oiECdyhvDBm+85Dh6YStt7Ul3p
	 ThRQEA8ZDe4Aqy5+YY8GWOHg91Xxiy4hb4HuA5FycGGZDVxbmbGCbs+oziU193Jd2j
	 hQHruNz36EuyhLonbImq1BulhTIwBk8DmNOJd06I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Baptista <brenomb07@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 15/43] ALSA: hda/realtek: Enable headset mic for Acer Nitro 5
Date: Tue, 17 Feb 2026 21:31:55 +0100
Message-ID: <20260217200007.053968837@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

From: Breno Baptista <brenomb07@gmail.com>

[ Upstream commit 51db05283f7c9c95a3e6853a3044cd04226551bf ]

Add quirk to support microphone input through headphone jack on Acer Nitro 5 AN515-57 (ALC295).

Signed-off-by: Breno Baptista <brenomb07@gmail.com>
Link: https://patch.msgid.link/20260205024341.26694-1-brenomb07@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 55ef52fefaef4..a16cb45ac59e3 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6271,6 +6271,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1025, 0x1539, "Acer Nitro 5 AN515-57", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1597, "Acer Nitro 5 AN517-55", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
-- 
2.51.0



