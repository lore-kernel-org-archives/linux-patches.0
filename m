Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED241BBBED;
	Wed, 20 Nov 2024 13:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107671; cv=none; b=f1kNED+9J6vj0khDgkH4GkS7/cQqpdPi1tZLVYTIK1H8v1Kplpo7tDuoW+FeLs4LcKGlwvnGe3R/M/xQzv61Um5qR7I9MZy62mcWczA5mJjuf9pHxgSkX2PjbJaqO5WtYdIUZ2K1WHCOJOyQkxKtjN4UTnlZ5+mdF1gDKPi7D1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107671; c=relaxed/simple;
	bh=KdBhprWoyKzCwcIuF2nziNuOQtH//Ef0WF5nMaY0xgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QE+u4ThkoxzMeQEJ2q2+662Rgcq0lKUsKHiw7nWAG3NVl/j3UH8b11nMeXFQMCo9iL3QGG5Cyx/Aor27RpP76APRr4TnvmhgKraUl2dRDFxAfdUKii/uWuEDXTaBhJJrCLNc5EyIc1fS8lVSzgsq1LKj1ubqQozkA9CuAGSN0h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/wF3TKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/wF3TKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB23AC4CECD;
	Wed, 20 Nov 2024 13:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107670;
	bh=KdBhprWoyKzCwcIuF2nziNuOQtH//Ef0WF5nMaY0xgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/wF3TKGH2OAoLyhNTo3fp/7nduyRW1nyEwJniNCB4NXT440SkHR/ZuJDFQwPZOJo
	 c96od1DqkvEaGjQGpDaU4YlZmCX6ntgpT+6Wn2NBBRYhRD1RaVh+oxR5LVFy3AGSTp
	 nGZ29Q9PncNZtQlw2Gs8TGj/qApam8HHBlozKsoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 26/73] ALSA: hda/realtek - Fixed Clevo platform headset Mic issue
Date: Wed, 20 Nov 2024 13:58:12 +0100
Message-ID: <20241120125810.239240981@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 42ee87df8530150d637aa48363b72b22a9bbd78f upstream.

Clevo platform with ALC255 Headset Mic was disable by default.
Assigned verb table for Mic pin will enable it.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/b2dcac3e09ef4f82b36d6712194e1ea4@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10872,6 +10872,8 @@ static const struct snd_hda_pin_quirk al
 		{0x1a, 0x40000000}),
 	SND_HDA_PIN_QUIRK(0x10ec0256, 0x1043, "ASUS", ALC2XX_FIXUP_HEADSET_MIC,
 		{0x19, 0x40000000}),
+	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1558, "Clevo", ALC2XX_FIXUP_HEADSET_MIC,
+		{0x19, 0x40000000}),
 	{}
 };
 


