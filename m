Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454B1612D7;
	Tue, 20 Feb 2024 21:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463931; cv=none; b=MM+wHkVhD+UV+RlqxDIFv4kJEEnXQgu/QLxJgvuBQC+PJZt+Kq8TI4VmXGrgPKAac8U+agcAjRMFVEvalESv+qNxDxOaGICqbMptCTpw/7N0ppAtJ+1eX9kRfEtXG3fIzu/++Jpwuq+Yuzis6J5aAyXbkfN/rZwKv1tswqA7Q7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463931; c=relaxed/simple;
	bh=jZ4Ax3Pl9ugaSs/RAzHT6WElsCRDKRUaIc4x7ylHJWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2kxtnRBqy7HeM+AtbX2ctuEV5KvE08xE3ggNbqr2L0qs7MMleUg+f18sjdkp6uNVRzAeOTjjMSgJGJmnl69d0CH3hbAT2mC/X0DNwX4i2kA6WoBGWBtlAHtSXFjjUf0jH9JpCG6Vy+ZQVogNWWu0+IdA2fOKHvu5YlTSmmIOag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNXAdDk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNXAdDk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA16BC433F1;
	Tue, 20 Feb 2024 21:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463931;
	bh=jZ4Ax3Pl9ugaSs/RAzHT6WElsCRDKRUaIc4x7ylHJWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNXAdDk4LJk7Xq4H9pyEngQuL5HCHQpxZqN/H1mO1iNBiBOPMNJk0G722FmU8LLcM
	 oWsWnzH4ql7t9dq50g0X2Aw2sTCgytUViRAU2R9S16/YQTTr8ng8RJFNW0i8YAd5ee
	 pjxYRd+ZbV6uyIl6VYGy7N1kBSR2YmmulwB4+X7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 198/331] ALSA: hda/realtek: add IDs for Dell dual spk platform
Date: Tue, 20 Feb 2024 21:55:14 +0100
Message-ID: <20240220205643.851607369@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Shuming Fan <shumingf@realtek.com>

commit fddab35fd064414c677e9488c4fb3a1f67725d37 upstream.

This patch adds another two IDs for the Dell dual speaker platform.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240205072252.3791500-1-shumingf@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9631,7 +9631,9 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0b71, "Dell Inspiron 16 Plus 7620", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x0beb, "Dell XPS 15 9530 (2023)", ALC289_FIXUP_DELL_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1028, 0x0c03, "Dell Precision 5340", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0c0b, "Dell Oasis 14 RPL-P", ALC289_FIXUP_RTK_AMP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0c0d, "Dell Oasis", ALC289_FIXUP_RTK_AMP_DUAL_SPK),
+	SND_PCI_QUIRK(0x1028, 0x0c0e, "Dell Oasis 16", ALC289_FIXUP_RTK_AMP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0c19, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1a, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1b, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),


