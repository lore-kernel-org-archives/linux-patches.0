Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB8B1F75BE;
	Tue, 17 Dec 2024 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456333; cv=none; b=u3w4lNiqk+PcqO1kyPKnww3VPC8dmQxAO9nZBEIes8AuCSvkJmfcgB5lbxTC21evY22IrcMh1zrdSgTCiFzjNCjwcIpCMhwc1ErwyQPmrUWlHWBLF2lSG1RhM4JqiN/V0JDtHJFEZlCvLrh58Ra5cnGQkbmjrCT0ntGkjkOOJLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456333; c=relaxed/simple;
	bh=OkZuZX+oiDrusezrOTYEI4L4CeQhEdouxp5EPJhHZy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOtdgeHbM6QTyEYC5h3iFYa3utfSXlC7IPJyksScaTmh6q6A0IGnlUEaCY+wJec06x2y4TskCo1qjdmAa1kRktU6r8RUzIde2WD4p2x0NPpT4SWciLGJNZzAR0BAd+71KNfmRuhJDQymp7dOoPEl7r/ZS8+fzPv5Q4lnvfCcgtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qzn0Md7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qzn0Md7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18E2C4CED3;
	Tue, 17 Dec 2024 17:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456333;
	bh=OkZuZX+oiDrusezrOTYEI4L4CeQhEdouxp5EPJhHZy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qzn0Md7dg+k+OMo7iAad7r5mVGOqL0jIw3bdUoKkR9k4UNXhHjvWEjvMv+v1L5YkZ
	 xtS0K1kHz9r17lkRTcrFJ7T8KrpiHrjizyvnWBw37fRHYIF5Si7lsqAL/q/B0vEtg4
	 69ayERTQvPIJpjzQVS7xQ6YYsxL2h5xfl/YdBFVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hridesh MG <hridesh699@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 026/172] ALSA: hda/realtek: Fix headset mic on Acer Nitro 5
Date: Tue, 17 Dec 2024 18:06:22 +0100
Message-ID: <20241217170547.346630440@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hridesh MG <hridesh699@gmail.com>

commit 5a69e3d0a1b0f07e58c353560cfcb1ea20a6f040 upstream.

Add a PCI quirk to enable microphone input on the headphone jack on
the Acer Nitro 5 AN515-58 laptop.

Signed-off-by: Hridesh MG <hridesh699@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241205171843.7787-1-hridesh699@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10127,6 +10127,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),


