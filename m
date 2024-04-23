Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC2A14389F;
	Tue, 23 Apr 2024 21:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908646; cv=none; b=eW0RUQnby4M3R6fSgJuPlcmd7UNOrzAjTaBY+OczpqaSWwstg5iLaMDNKXFq/1gwefkrdUiVJ1ML0Uzo/rNAhIKUDntseIwc1QkM45bnIP9tsDWuU9HDDZSafjksgc7iTS69cj5mgtev0TidDhpQO+OPq0IwlWJ3ze4M1KZkUD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908646; c=relaxed/simple;
	bh=xdxOpHd6UsVmOIlbuMswk4VoW5hsQRaj7Qczhd8YFYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4VCwq4D0OGJbhdDubLic8/EzzQh1HfYQqPATPwwCodt47x/wBVueSAcitFIVAUPfcyPcF+Rht/KrZmE3FWRDs9v2t8NHfw8TK3prP03dP1xbkUBZkKgtsofv/nA9W8+Ohk9OmX3EBXk+IutDbLfh4aGafEymYN5ROuZEiDTsG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzNQo3V9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzNQo3V9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FF2C116B1;
	Tue, 23 Apr 2024 21:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908645;
	bh=xdxOpHd6UsVmOIlbuMswk4VoW5hsQRaj7Qczhd8YFYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzNQo3V9E6k9EuJkG7Fv8ZyUIyRo5D48UbiEY19K7KKlcu3Uf5RP6OH5eIgjibUrO
	 PYFaAqxzn3bINNNl4vmcLEneB2v9W1lcL6eXnkCbus79bLa/0DLOSS5p2+sRVLxn77
	 wdzZ5QK8ZBAjaAwtkBeBsKrKH71qp9IVmHm03G+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 104/158] ALSA: hda/realtek - Enable audio jacks of Haier Boyue G42 with ALC269VC
Date: Tue, 23 Apr 2024 14:39:01 -0700
Message-ID: <20240423213859.137919232@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Ai Chao <aichao@kylinos.cn>

commit 7ee5faad0f8c3ad86c8cfc2f6aac91d2ba29790f upstream.

The Haier Boyue G42 with ALC269VC cannot detect the MIC of headset,
the line out and internal speaker until
ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS quirk applied.

Signed-off-by: Ai Chao <aichao@kylinos.cn>
Cc: <stable@vger.kernel.org>
Message-ID: <20240419082159.476879-1-aichao@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10317,6 +10317,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d05, 0x115c, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),


