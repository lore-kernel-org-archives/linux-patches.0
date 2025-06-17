Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897322DFF1B;
	Tue, 17 Jun 2025 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178367; cv=none; b=nYi+WZxCgzWqXi8Dp88AFrlHcmLtyKh/4bFL3zsaDkFwg5cIftDg1/wfbVkjOq9gekM2wnF6dqrvUTjH+bg/t9bY2rFV+UNKJnn15Nw+iHzzkFwIXi0kWTU0YQlsqEksNzSxLsQHhHP6wnAVeXk5WHylIUgEQY9Xr5NY9SCHS5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178367; c=relaxed/simple;
	bh=dGTAhsvYyfl0rbe/q/Kf/vs47VBQjgsDx5XtCbMINbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDoIoMQWEGFfSBfJT8gtXeEfpcr1GnH94IVjze1u9hyEvKLVg+lXFWtGElsef/RnxxAk6oUtsP1CgMuOL9v5u42Dtm6RF5urm+5lDBd3lNe500Mo97sbN+OHiJW09bTluMwoIU8qho7uLHSvtFukUmN38EXKf7lbTa/7ZSrrFwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnUjCuo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnUjCuo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E42BC4CEE7;
	Tue, 17 Jun 2025 16:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178367;
	bh=dGTAhsvYyfl0rbe/q/Kf/vs47VBQjgsDx5XtCbMINbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnUjCuo5tdStzOwliGPLwoLmSYRXG5DKvWjSCQp5QpCWlDsIef8qnBRzhmmLBiXYH
	 ED4TMM7J5BIYcY2oYtu31ib/XLjwHZ8CZ7UN+dcQglkb4h+431Ibngz3YJ7TkspI9r
	 uSPCvG6pnRHc42QxLncXIOQoPmCcpsmSwZ34D8lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heimann <d@dmeh.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 485/512] ALSA: usb-audio: Add implicit feedback quirk for RODE AI-1
Date: Tue, 17 Jun 2025 17:27:31 +0200
Message-ID: <20250617152439.272449266@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: David Heimann <d@dmeh.net>

commit 6a3439a417b910e662c666993798e0691bc81147 upstream.

The RODE AI-1 audio interface requires implicit feedback sync between
playback endpoint 0x03 and feedback endpoint 0x84 on interface 3, but
doesn't advertise this in its USB descriptors.

Without this quirk, the device receives audio data but produces no output.

Signed-off-by: David Heimann <d@dmeh.net>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/084dc88c-1193-4a94-a002-5599adff936c@app.fastmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/implicit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -57,6 +57,7 @@ static const struct snd_usb_implicit_fb_
 	IMPLICIT_FB_FIXED_DEV(0x31e9, 0x0002, 0x81, 2), /* Solid State Logic SSL2+ */
 	IMPLICIT_FB_FIXED_DEV(0x0499, 0x172f, 0x81, 2), /* Steinberg UR22C */
 	IMPLICIT_FB_FIXED_DEV(0x0d9a, 0x00df, 0x81, 2), /* RTX6001 */
+	IMPLICIT_FB_FIXED_DEV(0x19f7, 0x000a, 0x84, 3), /* RODE AI-1 */
 	IMPLICIT_FB_FIXED_DEV(0x22f0, 0x0006, 0x81, 3), /* Allen&Heath Qu-16 */
 	IMPLICIT_FB_FIXED_DEV(0x1686, 0xf029, 0x82, 2), /* Zoom UAC-2 */
 	IMPLICIT_FB_FIXED_DEV(0x2466, 0x8003, 0x86, 2), /* Fractal Audio Axe-Fx II */


