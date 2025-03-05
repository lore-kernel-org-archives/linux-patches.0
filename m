Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E353481DD;
	Wed,  5 Mar 2025 17:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197419; cv=none; b=SdGha0LZfqWAdLVzWiGn9Ns81LXsR2EJPIulfhPKZpcUs6UvwdSdYDLPOH1K0bymquir18N4Kd46mt7DyMQfTLFfTtGtGmAEPF/+l2vRUgCoV6qDGX0qS6JTQJoz4zOkRu4n7ra7GJtvcx4l0CMIx7L3jxr0LJMDVpyCsHqY4mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197419; c=relaxed/simple;
	bh=t0ffan+qAdIdqlYWOs4H7/Ey0qxmtkK4LYLroZRia0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUwWRsFYwraOdEd31DDMPOj7RVTlkex6nDuyaQPTo6Y6NarbP7bJPAG8+0cPEwNHb4ZGJmvWCDnUH/fBslCMowk8j9/ff8X0WhzcMfy9i/FDAvgobdPx0DtL7HEAcOYqI+Ra8q4j5G1yd68QQLJsIkGSM9snlp+2GUcrxouM2i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFZ5hEUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFZ5hEUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDC8C4CED1;
	Wed,  5 Mar 2025 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197419;
	bh=t0ffan+qAdIdqlYWOs4H7/Ey0qxmtkK4LYLroZRia0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFZ5hEUGk2/g59OqsUSuXYejjRlhcY78fWWOCn1We77BurGM8/DKjF2BYCBOlQu72
	 ykqMKzJ9N0H+EKpogB3sHnKpgUt54/yHqS2ZIZC2IR8ACYWaHGnYifticfufhH2+kj
	 py2weFDrz+/dPWU7lZ1nCIkLKf+fQLV6F1YIU6XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Panchenko <dmitry@d-systems.ee>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 150/176] ALSA: usb-audio: Re-add sample rate quirk for Pioneer DJM-900NXS2
Date: Wed,  5 Mar 2025 18:48:39 +0100
Message-ID: <20250305174511.461812705@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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
@@ -1773,6 +1773,7 @@ void snd_usb_set_format_quirk(struct snd
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;
+	case USB_ID(0x2b73, 0x000a): /* Pioneer DJM-900NXS2 */
 	case USB_ID(0x2b73, 0x0013): /* Pioneer DJM-450 */
 		pioneer_djm_set_format_quirk(subs, 0x0082);
 		break;


