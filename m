Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8E71E98EF;
	Sun,  7 Jun 2026 10:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829013; cv=none; b=OYRYqQhAif2sd6aLceGpN38WIz6aW4d2faZxkUUpKj5dgbyiWxvk0xB9BOGAb1qjV058TgPGX1Iu2pQ71S/j0ZU6HDphB8IVm2S6LJrmCaD/D9NR5U2LAzPEig1YoM9ddQcj3VRtcMZTEyS85gkXQxy0tOcnuO4uBoKhNdKnleg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829013; c=relaxed/simple;
	bh=rHBHXvbdpNwle0FR0r6nzhpSpedy/3fbIt46SgdKfQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nU5uV3FAMBrebUchKSZp3H8rEepzhONdgtZbBgSTlVhTS1c/1OxMtBMwdni3/zM8dnpzY6YkLAZ/nEXyWQgrfntuqc1+ExusywxCnq4H7Hw5qxhj9rJoRGZpSNos4VeELqQnVhHgl9hACjgUkXNKM5Dld/PB07j2jil3xzTUAlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IoausAE+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IoausAE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B47D1F00898;
	Sun,  7 Jun 2026 10:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829012;
	bh=tT4jEl+VOXVZcfdILQbwXlLz9VHIP58ZM9WVtErNXAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IoausAE+FzsacKw8ZW42Z9ZsSpObGb0FVw7GaFNcXdfW/nx2sQv2gl+wgLuxOt8Bm
	 9jiKBtCM2S5Q9EWzP+z6dGzHOAvqMWVntuKxCI02avWVK5QlmO6ZHaPPvSr8T8hUPc
	 wrCtc6cog6PbgyPLWnMRY8bjMN8GFLOMpA1uo20A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 234/332] ALSA: hda/realtek: Fix speaker output on ASUS ROG Strix G615LP
Date: Sun,  7 Jun 2026 12:00:03 +0200
Message-ID: <20260607095736.647787117@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit 20587302f8d700f26ee2c8a60ffb0a69ae0edf16 upstream.

Add quirk for ALC294 codec on ASUS ROG Strix G615LP
(SSID 1043:1214) using ALC287_FIXUP_TXNW2781_I2C_ASUS to
fix speaker output.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221173
Cc: <stable@vger.kernel.org>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260526013611.1954949-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7260,6 +7260,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x11c0, "ASUS X556UR", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	HDA_CODEC_QUIRK(0x1043, 0x1204, "ASUS Strix G16 G615JMR", ALC287_FIXUP_TXNW2781_I2C_ASUS),
 	SND_PCI_QUIRK(0x1043, 0x1204, "ASUS Strix G615JHR_JMR_JPR", ALC287_FIXUP_TAS2781_I2C),
+	HDA_CODEC_QUIRK(0x1043, 0x1214, "ASUS ROG Strix G615LP", ALC287_FIXUP_TXNW2781_I2C_ASUS),
 	SND_PCI_QUIRK(0x1043, 0x1214, "ASUS Strix G615LH_LM_LP", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x125e, "ASUS Q524UQK", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1271, "ASUS X430UN", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),


