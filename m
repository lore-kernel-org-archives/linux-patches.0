Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F3E4F5E0;
	Wed, 20 May 2026 17:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299856; cv=none; b=XKmhi65bwrNJkW+tdFD6PMDrYhhsX1QKMLohT3okK45JBeEtKv4vB62reYjfcmz9teWRUZXgFDr8jAZVn9Mwq9k4KSnZtq/b+PXYaGcy7HordUB4WEZwY5kxHAJZPnrYUrzwUGLDVOslCWwKclDpIWYJa0uhIdbNsE6VYKRJ+UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299856; c=relaxed/simple;
	bh=gVyfvMrsHGFUci+MPqg6fB9ex+ivIDXk5ogi5vgvdnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amNOBVWUQz479MozyuArc1lNOavegqx2t7PjHGCYGGeeOYLJ5a5aosoy502taKfmD+vt8i5ohoclHMfYmEGYQfz9kE3Kd2twIAolgCSvRt2xr/V1SN0PNxAM/8AOBsEDThbm7t6BsJZ2jAf6VYNg2LVWGkSEWvrbLGN2RvKXM6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0RGbPFrx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0RGbPFrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8924B1F000E9;
	Wed, 20 May 2026 17:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299855;
	bh=zV1FOF4seFOVIVZpcyg5YLjOcq7KFv0gGdwnPMCPK2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0RGbPFrxANFQHQw6Ba2FUVSr3TBFfIK3WCtRWo6LdzuwVk/TN5Trdr2UArOXJ3JmM
	 I0/VyM4yMa9ieLWyAml52WsuTiJu7SjcV33aKAo2hQiBRzA9AuDkn/6PLLqU1uyd0l
	 NbTmp/2Ci4uCCFu2LAFuoht1RaqLA05aW2fXgNKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Kramer <linux@markus-kramer.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 912/957] ALSA: hda/realtek: Add quirk for Samsung Galaxy Book5 360 headphone
Date: Wed, 20 May 2026 18:23:15 +0200
Message-ID: <20260520162154.354147800@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Markus Kramer <linux@markus-kramer.de>

commit fd87b510f5f543125ecf51e7c706a9f4bc3352be upstream.

The Samsung Galaxy Book5 360 (NP750QHA, PCI subsystem ID 0x144d:0xc902)
has severe audio distortion on the 3.5mm headphone jack. Applying
ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET corrects the output path
configuration, consistent with fixes already applied to other Samsung
Galaxy Book models using the same ALC256 codec.

Cc: stable@vger.kernel.org
Link: https://github.com/thesofproject/linux/issues/5648
Signed-off-by: Markus Kramer <linux@markus-kramer.de>
Link: https://patch.msgid.link/20260513222818.14351-1-linux@markus-kramer.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7240,6 +7240,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x144d, 0xc870, "Samsung Galaxy Book2 Pro (NP950XED)", ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc872, "Samsung Galaxy Book2 Pro (NP950XEE)", ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc886, "Samsung Galaxy Book3 Pro (NP964XFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
+	SND_PCI_QUIRK(0x144d, 0xc902, "Samsung Galaxy Book5 360 (NP750QHA)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc1ca, "Samsung Galaxy Book3 Pro 360 (NP960QFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1cb, "Samsung Galaxy Book3 Pro 360 (NP965QFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1cc, "Samsung Galaxy Book3 Ultra (NT960XFH)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),


