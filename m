Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55EB173;
	Tue, 30 Sep 2025 15:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245474; cv=none; b=FCn26vJp4eOX/UV9ijVf0Q0aKq2/PDPcCEIEs4CvOWFr8Rd4vjQrbmzdod7DD9WMWCbGjXopGLNpIWkmGsVeddPVzWMdNBpGnRiksVIzdm8C9RPVz1HdziHIVjMCNgrp/M28G+6uq4kYXgqU5v+9DdNcjlPrycx8otOYrNuOL+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245474; c=relaxed/simple;
	bh=977DQ5STxipD3O1p00pwaHxmdBaJoeFHTft8oW4K0M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfdSeRZWWJmB39HKhP2ACW1WedbgHBB8Jg1f2jMc63V22dhfbbFxSEO3OlbjzCZqsDToL9RRs7HTT9a5+hkQi1Bf6oabr8dL5+CUavtl/NnmK0wKSBRks5J4U3zm6QXP7fH/da4VZgvOBqgrFTWmqumdywQ/5QXxDH10OCUwYS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQVQedtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQVQedtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3560BC4CEF0;
	Tue, 30 Sep 2025 15:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245474;
	bh=977DQ5STxipD3O1p00pwaHxmdBaJoeFHTft8oW4K0M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQVQedtVesJPNgUjux7II+s622xIRummXUTF9iCvCzKqjAmG5mB+GluZA6cdt71aK
	 U1kkhO3saYHKS4dne2b2ULEicIrVtpiIXKj6dRxkHo4dWsM1GzPJBavddJGsN/C/jz
	 NC4PJNIytag3Q7qjw+fRdUbd11l28SJ2H31KTMkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 04/73] ALSA: usb-audio: Simplify NULL comparison in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:08 +0200
Message-ID: <20250930143820.721859017@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit f2d6d660e8fd5f4467e80743f82119201e67fa9c ]

Handle report from checkpatch.pl:

  CHECK: Comparison to NULL could be written "t->name"

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-7-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index f91dbc9255f12..9a5e8c47ce0d2 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -126,7 +126,7 @@ static int snd_create_std_mono_table(struct usb_mixer_interface *mixer,
 {
 	int err;
 
-	while (t->name != NULL) {
+	while (t->name) {
 		err = snd_create_std_mono_ctl(mixer, t->unitid, t->control,
 				t->cmask, t->val_type, t->name, t->tlv_callback);
 		if (err < 0)
-- 
2.51.0



