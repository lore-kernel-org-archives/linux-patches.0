Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A2749652;
	Mon,  6 Jan 2025 15:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176901; cv=none; b=fn7bulhWxWKawQy1F81BecRRVqo0qBNTLXgnkhpPCfH+nWPnVrsuCoM6IJGIvB+8iUPzkoTcG3GnwFhRh9EbeE5pu7bLDrhywU2OJiKk0UwDgfW4yhuEGT8K+oI6LZYkmwaKPSfmQzCnIa5SZt7bYDMVlZX5kESE5+6LPYSwIeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176901; c=relaxed/simple;
	bh=fzgahdhZiOhLr5d+7ne+ZZx4f/7LMu9b+O2OUwYiFVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cw78mvQv+WGctpRfbCI2D7Waog1ILtITTzJlFiNJMc3liUcJTebUwbmv+KYcyZ8T4ihXmGfuYIvk1zCTs0cmuRnHWsXLoz+CleSSjMhVdPiPuz2ll3UdgbWLqbn9fa29ffrXAqq9SL/rlbsiFab/uPiSjq1fZp5v8VGpNMNqf6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7BGPQc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7BGPQc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E100C4CEE2;
	Mon,  6 Jan 2025 15:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176901;
	bh=fzgahdhZiOhLr5d+7ne+ZZx4f/7LMu9b+O2OUwYiFVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7BGPQc5DO47NgfauWnKkDOebHnvhU5jHX87uV2xDEgJH0dZlk+XeKZ9xTDw73IMF
	 FmsWQ9gxxdrvz1x2RYcN/XB5o3z1fxPCnYWZUIHlEgf8KEVIbyjmzbWoYlOzhSAI9y
	 9VGi29IrBs+sdn2RF5lV4SlyLY1HrlICwjUPzjqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	linux@frame.work,
	"Dustin L. Howett" <dustin@howett.net>,
	Daniel Schaefer <dhs@frame.work>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 68/81] ALSA hda/realtek: Add quirk for Framework F111:000C
Date: Mon,  6 Jan 2025 16:16:40 +0100
Message-ID: <20250106151131.998741497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Schaefer <dhs@frame.work>

commit 7b509910b3ad6d7aacead24c8744de10daf8715d upstream.

Similar to commit eb91c456f371
("ALSA: hda/realtek: Add Framework Laptop 13 (Intel Core Ultra) to quirks")
and previous quirks for Framework systems with
Realtek codecs.

000C is a new platform that will also have an ALC285 codec and needs the
same quirk.

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: linux@frame.work
Cc: Dustin L. Howett <dustin@howett.net>
Signed-off-by: Daniel Schaefer <dhs@frame.work>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241231045958.14545-1-dhs@frame.work
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10255,6 +10255,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x000c, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


