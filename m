Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882AA39BEB8;
	Tue, 16 Dec 2025 12:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888691; cv=none; b=ld7zfv0P2nbsLEkdxuUeyf8WIw//wkHfhB+AJnRdgoQN43e11zypwZnkU0fWDGjOMmh2soiQ+jhT0mxupY9jJ0g0JVXuNWdkozACW7e7iF/KnO8aQQmjJH/91JjKiuu0Bu1qATHpf6gA4S3EzGO08xPSNVJMes8UPVDl6yRxvBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888691; c=relaxed/simple;
	bh=YFXm6zA9GQkIzeo4lT8qUt7rqZqOTEd/YF/iQXJTZlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQBXfraHdrtmCLseop7dKUpAgDyj+JDCBw0hPHddn6E6gmq4UezE5jVNPPBZb2K0ms+9wP91jbGCnuVZhJFUG3tI0VFvIJdr051Ih5CjS+AaR8DBpkxTHfItdrsg97QfIt5eAgFIHKoPXtuAUzCjT9Pbt1e2tcsxwO+eha5zzec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wx1Dp9tB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wx1Dp9tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3544C4CEF1;
	Tue, 16 Dec 2025 12:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888691;
	bh=YFXm6zA9GQkIzeo4lT8qUt7rqZqOTEd/YF/iQXJTZlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wx1Dp9tBFPxSxjmNj/BdtLnd8ljEoLWHiD90r2h4eD4K2zLiQqQ8tGqjEh+i0uhqC
	 In9hmUfdgvE5T5v1TnI4sJaacbskrOz2mO07pfdjbTOnVj05hnCE5wpeo8aZm15Fdy
	 uVObaInFTLVdBDQIOQTumw1FEon3gQjVwrzfStMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 610/614] ALSA: hda/realtek: Add match for ASUS Xbox Ally projects
Date: Tue, 16 Dec 2025 12:16:17 +0100
Message-ID: <20251216111423.498050557@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Antheas Kapenekakis <lkml@antheas.dev>

commit 18a4895370a79a3efb4a53ccd1efffef6c5b634e upstream.

Bind the realtek codec to TAS2781 I2C audio amps on ASUS Xbox Ally
projects. While these projects work without a quirk, adding it increases
the output volume significantly.

Cc: stable@vger.kernel.org # 6.17
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251026191635.2447593-2-lkml@antheas.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6736,6 +6736,8 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x12f0, "ASUS X541UV", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1313, "Asus K42JZ", ALC269VB_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1314, "ASUS GA605K", ALC285_FIXUP_ASUS_GA605K_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1384, "ASUS RC73XA", ALC287_FIXUP_TXNW2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x1394, "ASUS RC73YA", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x13b0, "ASUS Z550SA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1433, "ASUS GX650PY/PZ/PV/PU/PYV/PZV/PIV/PVV", ALC285_FIXUP_ASUS_I2C_HEADSET_MIC),


