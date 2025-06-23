Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CD3218580;
	Mon, 23 Jun 2025 22:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716503; cv=none; b=CymWvUDdkU9qC7tKinMNifVmGNaom2yg6XxxfjzJuHQZmVrFU3/s/Fd+6Mo6N8iJCvrP0+TPsJnvqO/MI3tyVNRVJGgxJl03IRm98v8ChzJRIKIfxd4+Ahg4ps6Trec/ubkkGBpdLb4Fq/b9Lepk/w/jO5D41hFxP47webn4dik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716503; c=relaxed/simple;
	bh=f1Ot9nmDzHqSZhlaOcmUKhTlqbieoogB7wjfx6gVBLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REL1fJhd06dy6oNr5kAYhAkllh3dL+QmpQ2mksdVG/DCVR1cHSeoOW5xGIF0mxpjfVKurbbaMbCPPmjexrKTgc3ILUJ8qA3VJolfezdK1D2bZTPoDWv8GB1Eae756II/OV9IkaM2lPe09+aKyBuUUth0qhxVue7ElN9hvP2JXGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6Fs5u0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6Fs5u0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCDEC4CEEA;
	Mon, 23 Jun 2025 22:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716502;
	bh=f1Ot9nmDzHqSZhlaOcmUKhTlqbieoogB7wjfx6gVBLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6Fs5u0H7p2ez9sLyDB+dcu5kM5g8nZAEmHYumsDpvHtAjWWtTHhF2g0R7eXMxaW3
	 YDFnbUvDz5gsl6OhsuQkCdmA2SZ0kfMZFceeShRd3BBwrah0bsUHBLzSNtKyCp2Ovv
	 uCBi+FLbAh3jEbkNp9nAighNziSe6ff39pR0rw08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 359/411] ALSA: hda/intel: Add Thinkpad E15 to PM deny list
Date: Mon, 23 Jun 2025 15:08:23 +0200
Message-ID: <20250623130642.680185078@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c987a390f1b3b8bdac11031d7004e3410fe259bd upstream.

Lenovo Thinkpad E15 with Conexant CX8070 codec seems causing ugly
noises after runtime-PM suspend.  Disable the codec runtime PM as a
workaround.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220210
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250608091415.21170-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2227,6 +2227,8 @@ static const struct snd_pci_quirk power_
 	SND_PCI_QUIRK(0x1734, 0x1232, "KONTRON SinglePC", 0),
 	/* Dell ALC3271 */
 	SND_PCI_QUIRK(0x1028, 0x0962, "Dell ALC3271", 0),
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=220210 */
+	SND_PCI_QUIRK(0x17aa, 0x5079, "Lenovo Thinkpad E15", 0),
 	{}
 };
 #endif /* CONFIG_PM */


