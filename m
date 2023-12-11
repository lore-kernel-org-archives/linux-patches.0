Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16263524B8;
	Mon, 11 Dec 2023 18:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUIscgpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91832C433CB;
	Mon, 11 Dec 2023 18:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319618;
	bh=p+sr3coFEfmsTAa0RMHhto+Xq6bxA4yJ9tMMve845/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUIscgpLAt8h1D7wOEuKKGm82QXslgT5sSA0tga1O/mOmauHeVAasdKXXSQDoCD/x
	 v4Jt/JedjFvmbkGEvCbqTgi9/skLE5rEm05jCc1zhG7BFkkalQx0qiFcFo0ceBEuZL
	 P2RSwpZxIguvzd6q0cUZFIQF5sqTWVe8p3mBSKnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Bosse <flinn@timbos.se>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 142/244] ALSA: hda/realtek: add new Framework laptop to quirks
Date: Mon, 11 Dec 2023 19:20:35 +0100
Message-ID: <20231211182052.153747368@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Tim Bosse <flinn@timbos.se>

commit 33038efb64f7576bac635164021f5c984d4c755f upstream.

The Framework Laptop 13 (AMD Ryzen 7040Series) has an ALC295 with
a disconnected or faulty headset mic presence detect similar to the
previous models.  It works with the same quirk chain as
309d7363ca3d9fcdb92ff2d958be14d7e8707f68.  This model has a VID:PID
of f111:0006.

Signed-off-by: Tim Bosse <flinn@timbos.se>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231206142629.388615-1-flinn@timbos.se
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10182,6 +10182,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
 	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


