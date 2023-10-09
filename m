Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30113419D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKY/p/Jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFDEC433C8;
	Mon,  9 Oct 2023 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859531;
	bh=w6W3R4kPBjmfnG159I8rVefApgnIFI75qUDpAvZb44o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKY/p/JjfzRcWRpNzenO12UvdHTL8SbGjzBFJtvo4W1EdRQW24vGGj7jy13TF89vC
	 jBSm19q3n4jcSd7ZRdlrhSkAyrwXJc6poqqo6jgFxBTxX4ZlSa/bSLAG0PZS/tEEUL
	 prhone+ofrWgtS75ie+KCTXGPVmF/Y0z6q3hQ39M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 51/91] ALSA: hda: Disable power save for solving pop issue on Lenovo ThinkCentre M70q
Date: Mon,  9 Oct 2023 15:06:23 +0200
Message-ID: <20231009130113.288520861@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 057a28ef93bdbe84326d34cdb5543afdaab49fe1 upstream.

Lenovo ThinkCentre M70q had boot up pop noise.
Disable power save will solve pop issue.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/315900e2efef42fd9855eacfeb443abd@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2364,6 +2364,7 @@ static struct snd_pci_quirk power_save_b
 	SND_PCI_QUIRK(0x8086, 0x2068, "Intel NUC7i3BNB", 0),
 	/* https://bugzilla.kernel.org/show_bug.cgi?id=198611 */
 	SND_PCI_QUIRK(0x17aa, 0x2227, "Lenovo X1 Carbon 3rd Gen", 0),
+	SND_PCI_QUIRK(0x17aa, 0x316e, "Lenovo ThinkCentre M70q", 0),
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=1689623 */
 	SND_PCI_QUIRK(0x17aa, 0x367b, "Lenovo IdeaCentre B550", 0),
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=1572975 */


