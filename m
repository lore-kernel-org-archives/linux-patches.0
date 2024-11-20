Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8CC19F41C;
	Wed, 20 Nov 2024 13:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107615; cv=none; b=b4GpJMMSZy9sH/tFmJQZUnS1ylTS3OEQyVsxfgGI8nSeWUhLPHjASmikbY5aJIVlbHJOfqq3TsGOLbbsszsjcBxaRpBUx2Xe7L5AXhw1n7Xj3QKuT0KypkpiCQNLlY15nQhS4iz3CEIHlFWhsqThBlB5ARm1o7UzUaF8FCQCk6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107615; c=relaxed/simple;
	bh=JIz9enraK5EHTQp4TF9PtbF42/jC1CIaYUlzSSae8HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFptCtW7Z4z19LiOo0Y9aqBEeRo2lmo/Op4wOOKxDWLxzA8oLS4dPAga0utYJquHCVVgIUX1sqdn85MFPs1hkXUXonkP7ubtwurUHa1JXJ2VnN/0nUqMdEonLUR8gUlWOpTu4VT1foSxAKh8r7Agf9jJvjq3rxtxvgfUpeOoYnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSP+1ZYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSP+1ZYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914BEC4CECD;
	Wed, 20 Nov 2024 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107615;
	bh=JIz9enraK5EHTQp4TF9PtbF42/jC1CIaYUlzSSae8HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSP+1ZYhfee/eKxb32blrkPtGZoxm5fDgcib9x5UlIJut9M12ZOqBs4ENeVbaN/Et
	 jNqgHo6+yx1zBY4gLZY6WyWtRVtsZgJhTDjAEzf9a087zm0eJUhYXEVgFVpitaKWRC
	 dlGgh8+Yu8xoNO1SZDqLjrma45cVhTn7q9pFPOv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 41/82] ALSA: hda/realtek - Fixed Clevo platform headset Mic issue
Date: Wed, 20 Nov 2024 13:56:51 +0100
Message-ID: <20241120125630.538404550@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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
@@ -11064,6 +11064,8 @@ static const struct snd_hda_pin_quirk al
 		{0x1a, 0x40000000}),
 	SND_HDA_PIN_QUIRK(0x10ec0256, 0x1043, "ASUS", ALC2XX_FIXUP_HEADSET_MIC,
 		{0x19, 0x40000000}),
+	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1558, "Clevo", ALC2XX_FIXUP_HEADSET_MIC,
+		{0x19, 0x40000000}),
 	{}
 };
 


