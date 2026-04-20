Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C603375C5;
	Mon, 20 Apr 2026 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701273; cv=none; b=uPuY3XPXXSj1hsDHnhTStkBHb0cyRxK0WCSHGjnr1bZavxTjb6UKU07diqpttEdygO0PwaDWVS+L+Pvae5B4v6dFdxfGoIgyZA+vCaX56lhWsPx8opcj6vRXkb5HC/LWj5rIz3ZC/K583Gk9Em8NpGOgpSaurw/vnjvakxILIv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701273; c=relaxed/simple;
	bh=EWOE0nTKlSIZN6nKSM2nIBjAqz+9zDf76RYoMMQmtzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMwQi4q5GgxpFgF8LfP3bDQom31+p0t/CGKsaK5YYCq7aaCeEAhjw2RYnnc86Bo/0cQ1yMKO4ax5U3Vma/6R7f8uVPMZ019v5t5H6dkEc6cI7pmFuPE5o+pflmnVeFOqFlAQc+VTGLD5PN9R/UhS4rc7SEHkK/qGmlMuJR5lOKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgFBrci+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgFBrci+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688AFC19425;
	Mon, 20 Apr 2026 16:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701273;
	bh=EWOE0nTKlSIZN6nKSM2nIBjAqz+9zDf76RYoMMQmtzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgFBrci+bd2kU7/ZBtOAFk6o4WBiswMwLd2/q4tREX3G7srmr0eaGNMDE2b+koUwX
	 csSmsZS2/9AQDbZr6io9e/sdBpyvhU3eY5GwyAOMJKIaNFUKBk1dWDk/Yy7kx09ioI
	 04Uv15VwI8G2wMS3+TUXkxklCjwNSZvUkxgarRbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/162] ALSA: hda/realtek: add quirk for Framework F111:000F
Date: Mon, 20 Apr 2026 17:40:49 +0200
Message-ID: <20260420153927.644272222@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dustin L. Howett <dustin@howett.net>

[ Upstream commit bac1e57adf08c9ee33e95fb09cd032f330294e70 ]

Similar to commit 7b509910b3ad ("ALSA hda/realtek: Add quirk for
Framework F111:000C") and previous quirks for Framework systems with
Realtek codecs.

000F is another new platform with an ALC285 which needs the same quirk.

Signed-off-by: Dustin L. Howett <dustin@howett.net>
Link: https://patch.msgid.link/20260327-framework-alsa-000f-v1-1-74013aba1c00@howett.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 440ec4e1528ae..2a32e1ead5e86 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11671,6 +11671,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000b, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000c, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x000f, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
-- 
2.53.0



