Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082CC423A7C;
	Tue, 31 Mar 2026 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976396; cv=none; b=SUByLZklpz/CKKBHLtlPSr9XUK4TDmg0xTjNFi865VzXv+Tlp9BP42ou51g/S1hlvGQTY3SEiyqF3qqDHDRjXT1pC5dXjPRCH9X2eY8THbiEIt6DehIJCe3JFeqeNjBJuAG9zMM0DyuCwvtSolq/s+blAGcdeQQytWC3ee8PnMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976396; c=relaxed/simple;
	bh=/D+jh8pz2u8nJsqBPmwEWVItmzgGq2/RULtULMevKXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoG5L17hB00146P/4mxKLwR3i6lQTL+D4iXW2o0MzSXYfgW4so+/VYBaDeEYyTKfNgeyksEuAmiYknMKzPb7FBOBZPXmcp7eaHVgts3zIDTpGtLpEha0lQmW+s3M3rLQyakHms+aYORvJ5gaZk1TFkuh3U1Kkt8osF4+HnRgk8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMxQ0Bd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMxQ0Bd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93979C19423;
	Tue, 31 Mar 2026 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976395;
	bh=/D+jh8pz2u8nJsqBPmwEWVItmzgGq2/RULtULMevKXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMxQ0Bd6qRLG+YbGT7IIQg7BP71AihwdFNzVqsPvN6y0MBfBkG6UZ2G2CSH+kixJJ
	 w6aWyq3yd4WO64o3nPyXDxhdEz533lly9qhxzPmi55PdXixxIJNrPD1hyp1PnckDS1
	 Eq9Q4dwa0VKFrB0EUOCyxalsKNlj/oGPW4J34Oy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/309] ALSA: hda/realtek: Add quirk for Gigabyte Technology to fix headphone
Date: Tue, 31 Mar 2026 18:19:22 +0200
Message-ID: <20260331161755.659954030@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 56fbbe096a89ff4b52af78a21a4afd9d94bdcc80 ]

The BIOS of this machine has set 0x19 to mic, which needs to be set
to headphone pin in order to work properly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220814
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/b55f6ebe-7449-49f7-ae85-00d2ba1e7af0@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc662.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc662.c b/sound/hda/codecs/realtek/alc662.c
index 5073165d1f3cf..3a943adf90876 100644
--- a/sound/hda/codecs/realtek/alc662.c
+++ b/sound/hda/codecs/realtek/alc662.c
@@ -313,6 +313,7 @@ enum {
 	ALC897_FIXUP_HEADSET_MIC_PIN2,
 	ALC897_FIXUP_UNIS_H3C_X500S,
 	ALC897_FIXUP_HEADSET_MIC_PIN3,
+	ALC897_FIXUP_H610M_HP_PIN,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -766,6 +767,13 @@ static const struct hda_fixup alc662_fixups[] = {
 			{ }
 		},
 	},
+	[ALC897_FIXUP_H610M_HP_PIN] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x0321403f }, /* HP out */
+			{ }
+		},
+	},
 };
 
 static const struct hda_quirk alc662_fixup_tbl[] = {
@@ -815,6 +823,7 @@ static const struct hda_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x8469, "ASUS mobo", ALC662_FIXUP_NO_JACK_DETECT),
 	SND_PCI_QUIRK(0x105b, 0x0cd6, "Foxconn", ALC662_FIXUP_ASUS_MODE2),
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
+	SND_PCI_QUIRK(0x1458, 0xa194, "H610M H V2 DDR4", ALC897_FIXUP_H610M_HP_PIN),
 	SND_PCI_QUIRK(0x14cd, 0x5003, "USI", ALC662_FIXUP_USI_HEADSET_MODE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC662_FIXUP_LENOVO_MULTI_CODECS),
 	SND_PCI_QUIRK(0x17aa, 0x1057, "Lenovo P360", ALC897_FIXUP_HEADSET_MIC_PIN),
-- 
2.51.0



