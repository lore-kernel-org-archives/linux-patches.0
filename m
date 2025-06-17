Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBECD285045;
	Tue, 17 Jun 2025 16:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176995; cv=none; b=ZS926HRmAJ+XTDk0IqlNf1hilL6VdyYsa44Lk0TWhm+i41fCldz1X2SXgvUDveJlnN21Q1HWwWthaQTSunSWd9n84EzHx8ZKckfKXlMH3QghYrfvfw6gLNx/fRs3z5943lUotSLfBAmjl1Sn2vUbBJRXYWCjPUzBEpeOLY7nAx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176995; c=relaxed/simple;
	bh=Vooa8az4y3M3ajEBID6eXJboL1o++emRPvVWZ0M8Uf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Si4S+zI2gjyDHQ3DmMeVn30j5kaMyTZIbm2xukqJN2gTP5pbo9u9kBHHBNK67NrNI8Xt5Cv2a4GnpSsSHh7KYEzkANtNJFrhqkbDsCNtX/pU9qCmOK+mM6l1F7joNmwhOOeN8k3KekM589aMCzzl/GH3KwJizzqLoTH405X+gRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fic6qAVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fic6qAVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C0DC4CEF0;
	Tue, 17 Jun 2025 16:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176994;
	bh=Vooa8az4y3M3ajEBID6eXJboL1o++emRPvVWZ0M8Uf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fic6qAVxzsgbiP2VWFx7lxC2FkdXMWUrZwqSsCqiXY/zekSgl+D5EqW8ZTI4mgo4q
	 QQYsSRJDpEBWtBeH1eJTjqHPjfnNNlveej4y4knA43PgsCqGAw1yUEdytqAT2StdvM
	 7REOfzJYwblxC3GicRMkiajdTZhjEu7rDy5P7Heo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heimann <d@dmeh.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 337/356] ALSA: usb-audio: Add implicit feedback quirk for RODE AI-1
Date: Tue, 17 Jun 2025 17:27:32 +0200
Message-ID: <20250617152351.697563218@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


