Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6533D8134;
	Wed,  8 Apr 2026 18:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673202; cv=none; b=TBzo7wV+futmaIrPkKoFJFFdYLjT/s6nA69TAMns+1b7L1unV+qN8W+s2VrNn3eEPaD2kPxziKGAqlNiWOtSsoyPoVzMIcW4Ty/m+J1fOr/rJQHPhb0Ajg0DQaLphlb7nCPvw6jLebDeE3VylfN1tDpBtMs2pjdcvY+2d6+zvhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673202; c=relaxed/simple;
	bh=HOa31KTSDjQCMZnvQrEIpc+kcbe64I/WgixEn8YLO4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUqHFeotq/q3wBSd5wRX//Ndu9BJKMFneLj4JbvRcdUr5c6QQLaiFkFo4M0S1UhwQ3t8Ee5jQ/6UtZDhTqI8zO4tlJ6tlJVD30k/S3/FV+NrwMu9J0ReY9OY6H97KtRsIboyGvJaoH+whmxpMocigz9rZLO3qSd02zjZpcyKMyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCn46VF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCn46VF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42C8C19425;
	Wed,  8 Apr 2026 18:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673202;
	bh=HOa31KTSDjQCMZnvQrEIpc+kcbe64I/WgixEn8YLO4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCn46VF9gSwQBIdzXZdGYvrGd6UQh4V6QQ7eIQ9fe9EL1+gBFLwGHA1sm2gilvY8f
	 UrMA+8piYg6xLv0+IPDFBh6f0Fa/QVySf8u5/HvIWaPNVUom+/ohFMoC2cXYl6tJHW
	 9RpgGLf40Cy7h6s7geikjSyG8KLCjdM272sxSHPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 139/277] ALSA: hda/realtek: Add quirk for ASUS ROG Strix SCAR 15
Date: Wed,  8 Apr 2026 20:02:04 +0200
Message-ID: <20260408175939.065974282@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

commit f1af71d568e55536d9297bfa7907ad497108cf30 upstream.

ASUS ROG Strix SCAR 15, like the Strix G15, requires the
ALC285_FIXUP_ASUS_G533Z_PINS quirk to work properly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221247
Cc: <stable@vger.kernel.org>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260330075334.50962-2-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7067,6 +7067,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA/XJ/XQ/XU/XV/XI", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301VV/VQ/VU/VJ/VA/VC/VE/VVC/VQC/VUC/VJC/VEC/VCC", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1584, "ASUS UM3406GA ", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1602, "ASUS ROG Strix SCAR 15", ALC285_FIXUP_ASUS_G533Z_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1652, "ASUS ROG Zephyrus Do 15 SE", ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZI/ZJ/ZQ/ZU/ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),


