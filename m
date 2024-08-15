Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADB619DF85;
	Thu, 15 Aug 2024 14:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731885; cv=none; b=faoNVbgzGy9lGTGVkxqqkvCkl5XkmnoW+JAZuySx9YDvqjDdASqx+GjTPmMFJeKtpeRPGrOQC/JNrn8m/Ymd+gVRyFRkbW54yj3ClJy0CgBEqFkZPfg+pJu6SpLoYvLc6QYw5tEAPMvRYq9qzwp4i6f2lbYZKgVIgvoskqMZllc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731885; c=relaxed/simple;
	bh=GnC6FigxygLuXiw7A4JxutTn7jH7BKst+WboPnoFd/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bf/wd2PjMldPYCCuo4O3mQsEmMGMYhidET7RuTKyrzgb4qkciuEaqYq6ThkEzsHHLWTHtXScfLBELA7tCQ5YOj4h/6qYihIaiga0o/2E7znvCIWnhzwf+L/0HtJh7xRN9SeorJY7UnDvD9Yp5NWqSsa5lJkopEhHxbfhQszHMiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tqw+LJZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tqw+LJZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53789C32786;
	Thu, 15 Aug 2024 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731884;
	bh=GnC6FigxygLuXiw7A4JxutTn7jH7BKst+WboPnoFd/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tqw+LJZTdBFRwU1wxHmvnurbswo3Huzno84r+BNoyfTLOo9IDrENFiU/IxC8IaU9z
	 pLPe1Ob2919i3s4V18cbh06cYt/4hHXiUSf8tIYpH1cnO7GoP7ErFPDVEeCq6zRFLT
	 IsJ/ai4TocUHStoDuLgp62vxpZyJWdOsXRg0SwKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Steve Kendall <skend@chromium.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 229/259] ALSA: hda: Add HP MP9 G4 Retail System AMS to force connect list
Date: Thu, 15 Aug 2024 15:26:02 +0200
Message-ID: <20240815131911.622585330@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven 'Steve' Kendall <skend@chromium.org>

commit 7e1e206b99f4b3345aeb49d94584a420b7887f1d upstream.

In recent HP UEFI firmware (likely v2.15 and above, tested on 2.27),
these pins are incorrectly set for HDMI/DP audio. Tested on
HP MP9 G4 Retail System AMS. Tested audio with two monitors connected
via DisplayPort.

Link: https://forum.manjaro.org/t/intel-cannon-lake-pch-cavs-conexant-cx20632-no-sound-at-hdmi-or-displayport/133494
Link: https://bbs.archlinux.org/viewtopic.php?id=270523
Signed-off-by: Steven 'Steve' Kendall <skend@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240806-hdmi-audio-hp-wrongpins-v2-1-d9eb4ad41043@chromium.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1818,6 +1818,7 @@ static int hdmi_add_cvt(struct hda_codec
 }
 
 static const struct snd_pci_quirk force_connect_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),


