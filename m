Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086121C3F34;
	Mon, 10 Mar 2025 18:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630732; cv=none; b=NsFPSuJEjrdSzonkWuXvqHNU1JHaOEAcSyzufh2dIMjBpTln2K17j/JYV34fFgV9H7Nn6m7qBJHHTYfBGC5PmvmxglYq7ZjPuJoj71EkulCYrr/ctkXVmBGF/rR0ZVuCQPLaVUahkDNqdFItQ0bWP4dVzCEbxIUE7uzw0gN8bFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630732; c=relaxed/simple;
	bh=JKD2xUJzO9Vwk6eYujsieFSxF0s33oBgSiqGoJ/K3+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwZAIioZU4b9ioOYotksFhNQyJaNgDKft1mTafEfQCzk0lEKRny57u+evdAZC+inyLiZ+tahzKBgGIB7RK5LGX0a1z0rXGn7+t+iuGklXBc6N57+/fYaLxX7/ZLUz5ytiKxbpirMONxvxP6yDjpuOF4+IW8yKByrYNzV4jXTDw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUAdZbsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUAdZbsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2FFC4CEE5;
	Mon, 10 Mar 2025 18:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630731;
	bh=JKD2xUJzO9Vwk6eYujsieFSxF0s33oBgSiqGoJ/K3+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUAdZbsyaAQu9vl7j378yE6TNJCiowUb9Rjbk2SA+AGMlLzjqv5YscoRTxtDisy6B
	 i/Sa3uFt8mPktzuLG/Cr78wtZdk1shcdNRVmZR2rAcWUXQvA00zyRcbkTLI0qQBjYA
	 azByS21TPsqwfV2G2mJGySoW/uA1bW6Htq5Weff0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Panchenko <dmitry@d-systems.ee>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 515/620] ALSA: usb-audio: Re-add sample rate quirk for Pioneer DJM-900NXS2
Date: Mon, 10 Mar 2025 18:06:01 +0100
Message-ID: <20250310170605.886144727@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Dmitry Panchenko <dmitry@d-systems.ee>

commit 9af3b4f2d879da01192d6168e6c651e7fb5b652d upstream.

Re-add the sample-rate quirk for the Pioneer DJM-900NXS2. This
device does not work without setting sample-rate.

Signed-off-by: Dmitry Panchenko <dmitry@d-systems.ee>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250220161540.3624660-1-dmitry@d-systems.ee
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1502,6 +1502,7 @@ void snd_usb_set_format_quirk(struct snd
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;
+	case USB_ID(0x2b73, 0x000a): /* Pioneer DJM-900NXS2 */
 	case USB_ID(0x2b73, 0x0013): /* Pioneer DJM-450 */
 		pioneer_djm_set_format_quirk(subs, 0x0082);
 		break;


