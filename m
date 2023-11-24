Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B851381DE;
	Fri, 24 Nov 2023 18:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1OsNQnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A991AC433C9;
	Fri, 24 Nov 2023 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850140;
	bh=FC94BhG6fauXsAK2RAsf+R9swewSnNlFc0+Q09c5vmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1OsNQnhpXMoIJWwGA9tM4uilAcLGCuEHeIRq6koSRoJ9tcwx6YqXtDNTUiVKt6iE
	 bufKCEWVXvWl1/6bMPg5SioFM05OfntX9WqB+rybuJzVJkd+2lojM/miIA7LENoN0t
	 f2kRSz0WTfVhGqLdIvLpN8ySiumBbkWeG9nS4xC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandradeep Dey <codesigning@chandradeepdey.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 435/530] ALSA: hda/realtek - Enable internal speaker of ASUS K6500ZC
Date: Fri, 24 Nov 2023 17:50:01 +0000
Message-ID: <20231124172041.327481919@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Chandradeep Dey <codesigning@chandradeepdey.com>

commit 713f040cd22285fcc506f40a0d259566e6758c3c upstream.

Apply the already existing quirk chain ALC294_FIXUP_ASUS_SPK to enable
the internal speaker of ASUS K6500ZC.

Signed-off-by: Chandradeep Dey <codesigning@chandradeepdey.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/NizcVHQ--3-9@chandradeepdey.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9821,6 +9821,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x115d, "Asus 1015E", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x11c0, "ASUS X556UR", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x125e, "ASUS Q524UQK", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),


