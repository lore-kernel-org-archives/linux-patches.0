Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68399446C9;
	Tue, 20 Feb 2024 21:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464848; cv=none; b=CTr+eycxgJToK4svGoNfXXsTjCD+W74AL75zJsdFg0fCx4nksIxwTNBaZi4k3Hf0Ur4+T7iGqsyLGLPcIKJS+LXmwWXpLoS9wxONkIul385lGGPSjwErc4r/sAhQwzv8bInGBqh4Zp6BZi5xjVpq8VFXpB9moXnprp89JjYzvAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464848; c=relaxed/simple;
	bh=tyK2jAEZzSpmvQvWiInSW7A7Ru4PGtDWrAn0wHtq7yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GetKjz9vCnWZJrIHpyyRWBRNcpkMVPCE1YB84FwimYK1GVvl4T/lIMXQJncNNH4ecE6NWs8y4J0v+I2j41k4WJ/YRYLKemF0BnYOOEuKSyUNr68kEW58iWiYiCZasizxi2U4kPbkQeOVBE3OhCp0UaSquaIqcT6exnVpXptysyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqWPn7sg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqWPn7sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D012FC433C7;
	Tue, 20 Feb 2024 21:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464848;
	bh=tyK2jAEZzSpmvQvWiInSW7A7Ru4PGtDWrAn0wHtq7yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqWPn7sgtzYOWkul/QFNyOSdEL0rtZFfK+CR6kgsSwYNcG1lejZPsi42w2wsoTkf8
	 LrMLAlDmpQBL5xuoL12rXt/12dSDQpa5yTapHCI6mTWQanjtWgloBxEgR/v3/jFVAM
	 DrwbXHh9bN4XgFGyTuu6FSOJoT06PDyZJ8GxDHH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 155/309] ALSA: hda/cs8409: Suppress vmaster control for Dolphin models
Date: Tue, 20 Feb 2024 21:55:14 +0100
Message-ID: <20240220205638.013483925@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Rodionov <vitalyr@opensource.cirrus.com>

commit a2ed0a44d637ef9deca595054c206da7d6cbdcbc upstream.

Customer has reported an issue with specific desktop platform
where two CS42L42 codecs are connected to CS8409 HDA bridge.
If "Master Volume Control" is created then on Ubuntu OS UCM
left/right balance slider in UI audio settings has no effect.
This patch will fix this issue for a target paltform.

Fixes: 20e507724113 ("ALSA: hda/cs8409: Add support for dolphin")
Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240122184710.5802-1-vitalyr@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_cs8409.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -1371,6 +1371,7 @@ void dolphin_fixups(struct hda_codec *co
 		spec->scodecs[CS8409_CODEC1] = &dolphin_cs42l42_1;
 		spec->scodecs[CS8409_CODEC1]->codec = codec;
 		spec->num_scodecs = 2;
+		spec->gen.suppress_vmaster = 1;
 
 		codec->patch_ops = cs8409_dolphin_patch_ops;
 


