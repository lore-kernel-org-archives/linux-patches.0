Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD79487BF;
	Wed,  5 Feb 2025 14:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765884; cv=none; b=MP935CoFL/Vh1m/5OPMXa57zEgix9c/BwUdZL0igS+wuF7lh0dg/iX0fWrvW8aGFnVyjRt8dN23ZOebAMFrmKZ82crudZm1+8teVkLdySLg5R07Ib/nWMJe1ZbuQV201nVzHFKKNvq43Fsu9XskjZo5gu2YsC69ekkVAujHfRMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765884; c=relaxed/simple;
	bh=9R9nANFRU1/7P5VaC8m5mtvBwHNVnOchOEmm3l2Ps1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfZHsfDgvaERetWL9bKr+MY1lYYd/GyyX5OSj+RvCZflrsdE7AT0FcMWMJ1z+UdUF4OP89N5QZtoFW7Ir5twNNCMi0F17j5HRWnr6WFg7+ujmTJcD1gTuPZbLL+uZ0Mqayn3d7n8OlmPMGbjIVBG38s48+b0gIfoyYZy8U7ynGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TB+n8Rrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TB+n8Rrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF894C4CED1;
	Wed,  5 Feb 2025 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765884;
	bh=9R9nANFRU1/7P5VaC8m5mtvBwHNVnOchOEmm3l2Ps1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TB+n8Rrx1Fuk5pbX87FSK0GxUs6PHy0n7hkVLZoH9QJSDf7VB7/KoedQJ1wKveAoG
	 BozTS38a796UgdVy11SIAZ/HxbJD91dHart1UnTINGo7lIDHN60HRxDjpTdqQXo88G
	 jF+YbxqmUf5dAaRKi3SB0czlffit6ik+GtUCmA+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/590] ALSA: seq: Make dependency on UMP clearer
Date: Wed,  5 Feb 2025 14:40:19 +0100
Message-ID: <20250205134505.375753237@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9001d515443518d72222ba4d58e247696b625071 ]

CONFIG_SND_SEQ_UMP_CLIENT is a Kconfig for a sequencer client
corresponding to the UMP rawmidi, while we have another major knob
CONFIG_SND_SEQ_UMP that specifies whether the sequencer core supports
UMP packets or not.  Strictly speaking both of them are independent,
but practically seen, it makes no sense to enable
CONFIG_SND_SEQ_UMP_CLIENT without UMP support itself.

This patch makes such an implicit dependency clearer.  Now
CONFIG_SND_SEQ_UMP_CLIENT depends on both CONFIG_SND_UMP and
CONFIG_SND_SEQ_UMP.  Meanwhile, CONFIG_SND_SEQ_UMP is enabled as
default when CONFIG_SND_UMP is set.

Fixes: 81fd444aa371 ("ALSA: seq: Bind UMP device")
Link: https://patch.msgid.link/20250101125548.25961-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/seq/Kconfig b/sound/core/seq/Kconfig
index 0374bbf51cd4d..e4f58cb985d47 100644
--- a/sound/core/seq/Kconfig
+++ b/sound/core/seq/Kconfig
@@ -62,7 +62,7 @@ config SND_SEQ_VIRMIDI
 
 config SND_SEQ_UMP
 	bool "Support for UMP events"
-	default y if SND_SEQ_UMP_CLIENT
+	default SND_UMP
 	help
 	  Say Y here to enable the support for handling UMP (Universal MIDI
 	  Packet) events via ALSA sequencer infrastructure, which is an
@@ -71,6 +71,6 @@ config SND_SEQ_UMP
 	  among legacy and UMP clients.
 
 config SND_SEQ_UMP_CLIENT
-	def_tristate SND_UMP
+	def_tristate SND_UMP && SND_SEQ_UMP
 
 endif # SND_SEQUENCER
-- 
2.39.5



