Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3F92E11A6;
	Tue, 31 Mar 2026 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976677; cv=none; b=Z9pf+0bJCWZOgnqzb3N8JfTb0qeUMCQZgOuM5mZXp4SoaR960NETFaSA/AXjCthA36A2BuO8tH15iG/UUk0ZKN233jg5/zr1o/8TPOtabTk979uBK7kXnSclLglHFC6LW9hH0zFLQakEvFlEqtey499GvI5CVYJr+mL7LoXv/hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976677; c=relaxed/simple;
	bh=WnRptf6Bbl8/IdXOearYZJ0R0QtUVa0pe/n2uTXw+IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwDTKBMK1H0VQPnW3/NMS0LBlr8Cuf2meSkKxBkvUY4Vbo3aO8gefNE5wEzSeUq37o3uwq5UTYQzVDrutKV40L79GoC0R3AT8Eea3/kXM98MLXtii0vH+uMr/NIVcIQk996ObpDCuw8cvdbb6661zk56kCFRAlJuI12ZzeBlCdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTJNxgAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTJNxgAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8B2C19423;
	Tue, 31 Mar 2026 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976677;
	bh=WnRptf6Bbl8/IdXOearYZJ0R0QtUVa0pe/n2uTXw+IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTJNxgAEgwFgv06SnLsv7D90Ow0V4zaDeZ+6Ep8AIe9nN4mxvrFF1evv8C06IjQXL
	 Ojfn9K2V/X49vMtNLa37Zxok4aFkefykF9id6J+eieAVg3TfSj72nWoy7/2zv+/bZn
	 Ldm2VM1et7Va0NOpkg42s4EjEr+YPG0tRu7FYINA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 185/309] ALSA: hda/realtek: add quirk for ASUS Strix G16 G615JMR
Date: Tue, 31 Mar 2026 18:21:28 +0200
Message-ID: <20260331161800.270794505@linuxfoundation.org>
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

commit 0bdf27abaf8940592207be939142451436afe39f upstream.

The machine is equipped with ALC294 and requires the
ALC287_FIXUP_TXNW2781_I2C_ASUS quirk for the amplifier to work properly.
Since the machine's PCI SSID is also 1043:1204, HDA_CODEC_QUIRK is
used to retain the previous quirk.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221173
Cc: <stable@vger.kernel.org>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260316022843.2809968-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7033,6 +7033,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x115d, "Asus 1015E", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x1194, "ASUS UM3406KA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x11c0, "ASUS X556UR", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
+	HDA_CODEC_QUIRK(0x1043, 0x1204, "ASUS Strix G16 G615JMR", ALC287_FIXUP_TXNW2781_I2C_ASUS),
 	SND_PCI_QUIRK(0x1043, 0x1204, "ASUS Strix G615JHR_JMR_JPR", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x1214, "ASUS Strix G615LH_LM_LP", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x125e, "ASUS Q524UQK", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),


