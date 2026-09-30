Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5FB263F4A;
	Wed, 30 Sep 2026 17:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790791; cv=none; b=uuqyQ6nq8toWmf5PfcI2fpWkOOnJMcvzWhJv2zkToxBsKbpzOWwEHltQCYcRo993BJl6P7ZBqNpcFyl7jJsl0s87IeWUKBl0zHoTF/XtcIyXWwX9Dck8prOLzTKmjncgsfSjABAGdCjN8/BeDfYtCMh0V79sjQ1+sNYwg0AIJ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790791; c=relaxed/simple;
	bh=b2CzXUj13bjOJzc0/slXAn1+nd49yQ33pLfggQcOrr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IfnmCp+lvuye7vnLJLTVRm/riSOsBWn3AFfKQqkuGnt9mlg5bmabzgakWK3VtYhPqS4or93RaJjiHmIEUwA2xccVOn+TTV+6ABORQb1JYBHRsUMk4O+4rR5z1u4cFzrotQYf9Jyy80DeuZIlTQUhEIasoq3CR6Uqm2uF+aaQY1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9YSdv49; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9YSdv49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A6A1F000FF;
	Wed, 30 Sep 2026 17:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790790;
	bh=8bOlMh40CCSTOqUqoiT9N4AbxQKlINzVtoWGNI2w/hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9YSdv49bssSFV9DoyZV6FzZuzCCK424jHH+6Z0GAClwwRsqorek/nOjVB0ysmjux
	 RSyG/LA1m2AaD2VqeWfbaFKVYAWrhQAXG6vP7Ry12XvzaaxK4ArZHSdUn9LAgS+bwS
	 w+Xuy4wsK3ymH5hTt2GqVMFfoZNoEufHHMtwHQqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20K=C3=BCchler?= <uwe@kuechler.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/752] ALSA: usb-audio: Add quirk for Novation Mininova
Date: Wed, 30 Sep 2026 17:19:03 +0200
Message-ID: <20260930152359.745824979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Küchler <uwe@kuechler.org>

[ Upstream commit b2e9d2cbbb71b00faf3e27fb741a27b9ad455edd ]

Add a device-specific quirk for the Novation Mininova synthesizer
(USB ID 1235:001e) to enable proper recognition and functionality
as a MIDI device.

Signed-off-by: Uwe Küchler <uwe@kuechler.org>
Link: https://patch.msgid.link/20260526162033.7513-1-uwe@kuechler.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 4690b44987c05..8e0e44b1f5262 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2841,6 +2841,14 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	USB_DEVICE(0x1235, 0x001e),
+	QUIRK_DRIVER_INFO {
+		/* .vendor_name = "Novation", */
+		/* .product_name = "Mininova", */
+		QUIRK_DATA_RAW_BYTES(0)
+	}
+},
 {
 	USB_DEVICE_VENDOR_SPEC(0x1235, 0x4661),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
-- 
2.53.0



