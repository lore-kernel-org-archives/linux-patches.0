Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2146D1A9;
	Mon,  8 Apr 2024 13:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583550; cv=none; b=TiqhLk3W9KHTEbOi0L3/Tnpqqpr5mz2qnUR2NcrmRr4tkgYD6pDGzb4/o8P+UJ+6Sra7lXl0n7wTPo4orfMsRsPJAkovtyhT4pdQU0O4aoOx/RWHzUtL5z0KAc5yKr1DA7jBI4Erf5eImPku0gblrkx1SLJmKF099jV8LRyBz1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583550; c=relaxed/simple;
	bh=K+nQGlhHonBNpLq4NMQR6bNywHNXPpuIYKDftVcZA6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRrfKCbVjc7GthYAt0oEmAMiKcon6kp3RoZLqn3PbPZCElvV6VXkiJNbQi2ner8+BtDHGsjST0yzGq0BDiI9HLPsEFtIYeRJt/mOZBpIDEHdPdMpVV03PRrhqYaOET5gRm+dDgRIlMH9Rk+wxPb3JQz96kbJtmW/0ZTrgLhH3KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4Qw+miz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4Qw+miz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65711C433C7;
	Mon,  8 Apr 2024 13:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583549;
	bh=K+nQGlhHonBNpLq4NMQR6bNywHNXPpuIYKDftVcZA6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4Qw+mizV3YU0LSNgzxd7g3/oOOoTbBhdpTmb1uV/HDjhG9lhT7nCT/vbgH8aamYC
	 n9Yan5yBp5l5GXcWx/7g0vr9G+sTYoiEjO5N4nsdJTm6HeMLTtNNc9Pg4FVopTl+2n
	 O3lueepcng/sVHhjgJiJ/RSOJH/PzrhEhzLdtVZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 207/252] ALSA: hda/realtek - Fix inactive headset mic jack
Date: Mon,  8 Apr 2024 14:58:26 +0200
Message-ID: <20240408125313.074626350@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit daf6c4681a74034d5723e2fb761e0d7f3a1ca18f upstream.

This patch adds the existing fixup to certain TF platforms implementing
the ALC274 codec with a headset jack. It fixes/activates the inactive
microphone of the headset.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Message-ID: <20240328102757.50310-1-wse@tuxedocomputers.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10302,6 +10302,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d05, 0x1147, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x115c, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),


