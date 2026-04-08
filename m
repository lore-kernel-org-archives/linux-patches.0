Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B088E3859FE;
	Wed,  8 Apr 2026 18:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673039; cv=none; b=Cru77wx0ishvsDA3zCKPiFkY7LNPW3vFljuS7OwiojgVsCdaUeLQjVWj8b/ApuqM9UGt6CZ3+2m5pHFGM1ex9kZepbxhvWsstONzz/CVccX/iAlQ3rcqmRR4xpeZ8pkEkboCdwv8rXf7VM9I2FjAIkIo9E3gzd3BuQkrcHu/98M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673039; c=relaxed/simple;
	bh=eXxCyytGJBOUrAuDkOahyEKRK0cIa2CYMfbh3KscotU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjp+cVocgrvn/VFGfkvvuHUENd7XvWwBlOzeRizHoaLaJfTvBwvDpunTVcvdqlOBKd22rnPEIHo0SnPPZIe3ZcRqkC4CVsrGf/sbWpE+hgORiVmG0AMb9RjzHc1yqHERL4j+rm6MI34IOUzPs3RPQbnghfZh8vgyAsInhbvAp1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sS9AajwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sS9AajwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0040BC19421;
	Wed,  8 Apr 2026 18:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673039;
	bh=eXxCyytGJBOUrAuDkOahyEKRK0cIa2CYMfbh3KscotU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS9AajwU7Q3kum+aHaIkkAYaD5G3m8HQTSLjc0k/iSzqydzEmCI3rFFSeBo3h/Mad
	 vADfjA349ZqhSdJyLipQIS8u6ufMUx6EZLMqMfrUO7xltzHrRhTizuYJSvGON3dmyY
	 wowpGpsiuh/vGEwwcCh27mxJlYDZLNPTmcrwrMs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dag Smedberg <dag@dsmedberg.se>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/277] ALSA: usb-audio: Exclude Scarlett Solo 1st Gen from SKIP_IFACE_SETUP
Date: Wed,  8 Apr 2026 20:00:30 +0200
Message-ID: <20260408175935.539684950@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Dag Smedberg <dag@dsmedberg.se>

[ Upstream commit f025ac8c698ac7d29eb3b5025bcdaf7ad675785d ]

Same issue that the Scarlett 2i2 1st Gen had:
QUIRK_FLAG_SKIP_IFACE_SETUP causes distorted audio on the
Scarlett Solo 1st Gen (1235:801c).

Fixes: 38c322068a26 ("ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP")
Reported-by: Dag Smedberg <dag@dsmedberg.se>
Tested-by: Dag Smedberg <dag@dsmedberg.se>
Signed-off-by: Dag Smedberg <dag@dsmedberg.se>
Link: https://patch.msgid.link/20260329170420.4122-1-dag@dsmedberg.se
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 45d0e1364dd98..2c01412a225ef 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2424,6 +2424,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_VALIDATE_RATES),
 	DEVICE_FLG(0x1235, 0x8006, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	DEVICE_FLG(0x1235, 0x800a, 0), /* Focusrite Scarlett 2i4 1st Gen */
+	DEVICE_FLG(0x1235, 0x801c, 0), /* Focusrite Scarlett Solo 1st Gen */
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
 		   QUIRK_FLAG_SKIP_IFACE_SETUP),
 	VENDOR_FLG(0x1511, /* AURALiC */
-- 
2.53.0



