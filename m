Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A458B32A3F1;
	Wed, 25 Feb 2026 06:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002789; cv=none; b=fh9FRoP1hmErmrM8kML81/EomEt0AfOQ9p+0JDSeIG3R7cyiQQq1HCETEx6ceJmDmw9AOPyC/SzMJXPo7FHYI3mAMnrfFfV3PLWAlktlhzvN0ftf0zh/BUvVYuCqCMbsgBMGxVp1hwsbuQe4kvh7n87X9P9H/FdX+0C3epRD2dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002789; c=relaxed/simple;
	bh=NrLiPYHNqmgEACxpVZQahZkUX23hz3Ot7UlSYVU/Mpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkZ4EnXPSLaey/PTxyynPW4GBF75K+tcWZh3taI87ZgHbtodME5N4culzeudwLy7HjG65reSy+DGb04tg5ieJEL1wgkaAPgExjzdHYqL6K3hnQSOBzdtMEsoDdPfDCgpn7m0RvTeSlB5ua96sxivpjDM6Z6e0lVU4asY9ecaCX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOjiTQJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOjiTQJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC9FC116D0;
	Wed, 25 Feb 2026 06:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002789;
	bh=NrLiPYHNqmgEACxpVZQahZkUX23hz3Ot7UlSYVU/Mpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOjiTQJmrn1A45gZdciXmyWOqxn56Ka4EZUvLGhhRiNqLlRYVLN0pmPE88+76Vps0
	 gO+eG+wm/k1fWy//xicALBJ/QnlKSFaIwnNH+a1b9HKlXqOoBznvTabxafPqH0Bnx5
	 Nj2AgkSTvpWCvLQMRY4Dm3igKMMuwDWh83Q8PxEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Naim <dnaim@cachyos.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 632/641] ALSA: hda/realtek: Add quirk for Gigabyte G5 KF5 (2023)
Date: Tue, 24 Feb 2026 17:25:58 -0800
Message-ID: <20260225012403.820724442@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Eric Naim <dnaim@cachyos.org>

commit 405d59fdd2038a65790eaad8c1013d37a2af6561 upstream.

Fixes microphone detection when a headset is connected to the audio jack
using the ALC256.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Naim <dnaim@cachyos.org>
Link: https://patch.msgid.link/20260210093403.21514-1-dnaim@cachyos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6952,6 +6952,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x144d, 0xc886, "Samsung Galaxy Book3 Pro (NP964XFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1ca, "Samsung Galaxy Book3 Pro 360 (NP960QFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1cc, "Samsung Galaxy Book3 Ultra (NT960XFH)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
+	SND_PCI_QUIRK(0x1458, 0x900e, "Gigabyte G5 KF5 (2023)", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),


