Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F4E337B81;
	Wed,  8 Apr 2026 18:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674348; cv=none; b=ELsHi8pwtV0Q0daLN0weV2NowRxopffjdiz6W8WeDRyhUcmsN3wtpPBE6ZBVQ/Kq2iStzGGGyoy6QMQuDNOaTpejnNmS+h4dis2Z5XoXJRG2RmmVAFtO8Ek4Q8/TXujNz63EV7Y4UDpIo4gLYyl/GGaDtP79uoumuRnXa7RyH1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674348; c=relaxed/simple;
	bh=P4Q+XTL9FQIxqqktS9csvUdZG0x0yAH5B8JO5nl4ZkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEa4vCEu9/L5z07AgZysjST58PunMSrtTnUv5hkxbBk2KBdufeuK7J6nszVi7vD5g339VYEQLyvHaVULJ4hSY/y/91COsvilJMbEBjObWbRpeR+NNcKZzI5PVQzEIw71Zh7NuIh7JqSrYP5RkOLovmhJDQ1f8WClnQj/gcPd03A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRGsBE5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRGsBE5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D159C19421;
	Wed,  8 Apr 2026 18:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674347;
	bh=P4Q+XTL9FQIxqqktS9csvUdZG0x0yAH5B8JO5nl4ZkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRGsBE5OuflFoKvpLieV7fQ8r5V4LcvrGNuIyaggICBxalbz9jHd+tie5t66cDKoE
	 nvYqu6k5go4WwXrS+d/+C22rQ6Q24XYjuJeA2YjoEZBn50++Bu4wRfKd/LbbDJFQbU
	 bjwReFoPjLoKDcn/iAkGT8TJZa2H1k4jBr5584h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dag Smedberg <dag@dsmedberg.se>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 061/311] ALSA: usb-audio: Exclude Scarlett Solo 1st Gen from SKIP_IFACE_SETUP
Date: Wed,  8 Apr 2026 20:01:01 +0200
Message-ID: <20260408175941.693642088@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 09ed935107580..f0554f023d3cb 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2427,6 +2427,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_VALIDATE_RATES),
 	DEVICE_FLG(0x1235, 0x8006, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	DEVICE_FLG(0x1235, 0x800a, 0), /* Focusrite Scarlett 2i4 1st Gen */
+	DEVICE_FLG(0x1235, 0x801c, 0), /* Focusrite Scarlett Solo 1st Gen */
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
 		   QUIRK_FLAG_SKIP_IFACE_SETUP),
 	VENDOR_FLG(0x1511, /* AURALiC */
-- 
2.53.0



