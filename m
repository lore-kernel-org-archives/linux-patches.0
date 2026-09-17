Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D8A4FDA79;
	Thu, 17 Sep 2026 17:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664931; cv=none; b=kY6XvuNxS0T5WVmkL/BfT5nb2UeKk7o6vECPuU40CiXyCjRk9ROdt8a8RAU/qOtpTJXNpRemXHaAIRsr8qnuE7xKhEYuPP5ykm9md9dxE4Ib/VS5e0l0oYDjanMl4u95pyN5/rTGxOrrgHUMsvlCAYBNY1rVAlP6GVj/jSft62A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664931; c=relaxed/simple;
	bh=a+EtIKC/c5P0WVZO4FsLV7+XbZsv8j9PT+c/emH6bdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adBS1Zx+TsvekxO71v1jmTOZGNkD5n+Ws89Zas4Hc1Q1CC8RvwaZ13sgB596MqaFZCuHvWL6LWhcnFc9sA/WORhZfc+Ujup3rmifPhh4AMi3Aud2IwDbNbE9paIsJ1bLXm/I9JYCdrGwWEdm0aWNO3h6gPlJEJckRGgexMqbqos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpfVMkGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpfVMkGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF001F000FF;
	Thu, 17 Sep 2026 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664930;
	bh=9UZAJK+hHtkAIQ5RlEd8tTH4f4iVCG5Q2kd3Iz+wjCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpfVMkGvjhPgl8nD5sHccTxJF6pr0pGM5fA6geGt0u2FAL6FWRde+MWkFFXk+hqCl
	 LF75ugRY65iWQlFSb4lD3QHOuonu34EijJSC0dIk855KNIJygVhF3anqf7YHMKptKK
	 jpxP/xl7QLH8lwV5SUMuA7mNwh0gA1IZVUXhQ2g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel C. Ribeiro" <dcoutinho.96@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0536/1250] ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum650 Wireless
Date: Thu, 17 Sep 2026 16:05:31 +0100
Message-ID: <20260917151606.466076004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Daniel C. Ribeiro <dcoutinho.96@gmail.com>

[ Upstream commit f6d6a4147ace0c417035f65b021027c209c75190 ]

JBL Quantum650 Wireless (0ecb:2125) requires the same workaround that
was used for JBL Quantum610 and Quantum810 for limiting the sample rate.
Without it, the capture (microphone) stream fails to work.  Setting the
QUIRK_FLAG_FIXED_RATE flag, as done for the sibling models, makes both
playback and capture work correctly.

Signed-off-by: Daniel C. Ribeiro <dcoutinho.96@gmail.com>
Link: https://patch.msgid.link/20260719090037.40149-1-dcoutinho.96@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index d879569914ac6..860257cc72457 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2273,6 +2273,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
+	DEVICE_FLG(0x0ecb, 0x2125, /* JBL Quantum650 Wireless */
+		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0fd9, 0x0008, /* Hauppauge HVR-950Q */
-- 
2.53.0



