Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B591E86F;
	Tue, 30 Jul 2024 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359023; cv=none; b=stRvrGLlP/mUx6dWMC0SMnHiP4dPHAfsGA/edJpIqatQeqjG+hrIgElrutJIgQeafjrX6avK42HynsiliS6AxBRF+M7CBS8S2zxsxWtR441FugJlflTbEnJ0YMWzpbU35wzRYKH/edhuQoutVeNJzOvf7szlfs2J0lKIjBmldN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359023; c=relaxed/simple;
	bh=MjNGzKcqtOJmF8vSpxJ2OLYzg+Wy3V3LNYgmbW/Lsxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGu0zUM5t6Ahq7wmJIQC39DvDbFrS6pxngUeO3Pwrgxwy1YycHpQsekbjQodVmQuESwNxDtbPA5BiHQXuaAe9SvrcY8B1Q8owfTIZVBlYkDMJSPK8izO2FpJqu19zImwNEkPWio2ATP6Q6Ln+kg2plX2K1im4NcxYI88IpqRBno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zaseMITB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaseMITB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAAFC32782;
	Tue, 30 Jul 2024 17:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359022;
	bh=MjNGzKcqtOJmF8vSpxJ2OLYzg+Wy3V3LNYgmbW/Lsxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaseMITBL53uCoJgsG9qbUPC6JESZFgeRoy2T+8AF5tYu0MT0YwPBAuaEv0Ryo4au
	 wML/48gczXH9u+oAA4G/aHHosOVDsWJtirrADPUxpYKNiFzs3HbYVP3Pz6TiZrvnHr
	 m5797rFidIWdflMPAI7p0923SvBrR/62mNFL+npc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 421/568] ALSA: usb-audio: Add a quirk for Sonix HD USB Camera
Date: Tue, 30 Jul 2024 17:48:48 +0200
Message-ID: <20240730151656.323379180@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: wangdicheng <wangdicheng@kylinos.cn>

commit 21451dfd853e7d8e6e3fbd7ef1fbdb2f2ead12f5 upstream.

Sonix HD USB Camera does not support reading the sample rate which leads
to many lines of "cannot get freq at ep 0x84".
This patch adds the USB ID to quirks.c and avoids those error messages.

(snip)
[1.789698] usb 3-3: new high-speed USB device number 2 using xhci_hcd
[1.984121] usb 3-3: New USB device found, idVendor=0c45, idProduct=6340, bcdDevice= 0.00
[1.984124] usb 3-3: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[1.984127] usb 3-3: Product: USB 2.0 Camera
[1.984128] usb 3-3: Manufacturer: Sonix Technology Co., Ltd.
[5.440957] usb 3-3: 3:1: cannot get freq at ep 0x84
[12.130679] usb 3-3: 3:1: cannot get freq at ep 0x84
[12.175065] usb 3-3: 3:1: cannot get freq at ep 0x84

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240722084822.31620-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2085,6 +2085,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0b0e, 0x0349, /* Jabra 550a */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
+	DEVICE_FLG(0x0c45, 0x6340, /* Sonix HD USB Camera */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */


