Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E487F151CD8;
	Tue, 20 Feb 2024 21:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463755; cv=none; b=IyVe9MpjT4YzoUwvtkphpn75xk66C8vMYYUCHh2hEU2maYvAnegqzJYCauX+88mo+RtD18IwAurwrQ7ELnsGSyl06bVx2VD5i+eH2Tt43r5K5OpPiWbg8q0i7gHoul+QeCP75QERkES89+iUEZ9AN4c3NYpSVNNplZOXsv2+XmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463755; c=relaxed/simple;
	bh=B8bOa+pNkDaKA+Nq/efC7uw6C1moL/3oAa9Ux3vHf8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvmxTvsbDbnd9TVqPvp8n+qbipuGXvAfVx+b6ROR/W6R6o1LpUSOFJsSFpObrIKwlDAfeGQX/N5e5ktGipiAU57qy2O7g3j3ud0F0pJEsAxEZhds8E39MqM8sCq/X4GHJFipkgKYoSxjRBwTfL8WK2YFwPr7Yi36en5i8/oWzsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swqvFiEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swqvFiEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC94C433F1;
	Tue, 20 Feb 2024 21:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463754;
	bh=B8bOa+pNkDaKA+Nq/efC7uw6C1moL/3oAa9Ux3vHf8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swqvFiEcfyWjXtNhZfhtZ+6wrkUL3mx6kmhZgeZvwX/jkj6oqHTSYkOn4g4oWS3GM
	 OUYimbpxpaoJ0De1rFDVmFjX2D3DwKbraxO3U+bYDZmLJhqnD84PFB98PGCRQLc9Tk
	 StLJ7UfSJh5k67ZVbfC+sdtqgoe6Gj5W+UXAm73A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 142/331] ALSA: hda/cs8409: Suppress vmaster control for Dolphin models
Date: Tue, 20 Feb 2024 21:54:18 +0100
Message-ID: <20240220205642.015506071@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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
 


