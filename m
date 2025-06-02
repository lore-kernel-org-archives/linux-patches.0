Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5AC2153CB;
	Mon,  2 Jun 2025 14:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875038; cv=none; b=LtNw3W9rg/b8SyiS2e46x3TG7bf6itG/9D+oPndl96dMvDL/eF0MhLHEO5A2O1ZaIHya33dtoAxa8bQaDvrK6hSCUj7lYbo9/ZrqCIDjZjSQdTtsXs8jH7HZt5bpotv+ZUiwu3Z5HKO8+Yg5NE7XBSts0tOTI61biGRoFkurP/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875038; c=relaxed/simple;
	bh=8o4z1RWm65IjEfsojQaFDxgRotB6/GQTUH3h03H/cas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaJ8VzpA0HYUqewoTDFW7cEtL8xNG87hKe6+3XG3sDcx7XuVgCXIUx31E1dVrw/Dpn79pYlRfw1X1KexIVyv05NwP5PbJIao4mhMLUioVjl1evj0+0tGkIEKoAzTIsKwq9KhTXuNhnwkVUPWqGSqK14g6uOVyIzjuo+yXW6iXvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbsJJr9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbsJJr9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC9BC4CEEB;
	Mon,  2 Jun 2025 14:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875038;
	bh=8o4z1RWm65IjEfsojQaFDxgRotB6/GQTUH3h03H/cas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbsJJr9Hm0TIr6JAxEQ/e4MYGABpP3MAbOuKkySi/es1wONl2Xs7MoCV+gPmEajVA
	 Cr1I1Ex6mbEos2/oD9/nazfX3eKldVBtBokDHvl40rxSrrj2OxdOAYzBPmoThJE2ot
	 5kLzAk8/SH/7bKBHU9LFiP5QNKgZnrJtsLNRjDX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Priesner <joachim.priesner@web.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 001/270] ALSA: usb-audio: Add second USB ID for Jabra Evolve 65 headset
Date: Mon,  2 Jun 2025 15:44:46 +0200
Message-ID: <20250602134307.259014641@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joachim Priesner <joachim.priesner@web.de>

commit 1149719442d28c96dc63cad432b5a6db7c300e1a upstream.

There seem to be multiple USB device IDs used for these;
the one I have reports as 0b0e:030c when powered on.
(When powered off, it reports as 0b0e:0311.)

Signed-off-by: Joachim Priesner <joachim.priesner@web.de>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250428053606.9237-1-joachim.priesner@web.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/format.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -251,7 +251,8 @@ static int parse_audio_format_rates_v1(s
 	}
 
 	/* Jabra Evolve 65 headset */
-	if (chip->usb_id == USB_ID(0x0b0e, 0x030b)) {
+	if (chip->usb_id == USB_ID(0x0b0e, 0x030b) ||
+	    chip->usb_id == USB_ID(0x0b0e, 0x030c)) {
 		/* only 48kHz for playback while keeping 16kHz for capture */
 		if (fp->nr_rates != 1)
 			return set_fixed_rate(fp, 48000, SNDRV_PCM_RATE_48000);


