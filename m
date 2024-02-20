Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98061509BF;
	Tue, 20 Feb 2024 21:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462971; cv=none; b=K3sWSrvVo5EOGTxC2d9mitztiTI8kGv/6ZKgaGONiU2VTjm6fyjaONft8dTAtLIdfswIhDJZ532at9j/wPnGHRFl/AX0/L5U06Nxu1wq/P6y6SW/rg3YKpdYvcME2wEUP0kkIeuqPUx7SyxSgXeBbnAXHeTOu1Upx+drGgRQzow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462971; c=relaxed/simple;
	bh=IadwbtgQanTooLTGF6wblOKrQ7xQehd5xr22mUtZX1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0LmAcy0AUstwN53wTyowEWtRiXmbf/t+JLU2sMuqk1cypp5+ZoTsDj5VMSymaZc+qwUGs0DcTFHSfJc8xCCxk7eAlPa5Vf/+NwgIveaudpUOzFYv+8szO/+nkxAFC3GsGN/31CuavFkLOl5H7M2CTMPWIbPOm9AkDgGzAfv6po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cer5i1Hi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cer5i1Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49406C433C7;
	Tue, 20 Feb 2024 21:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462971;
	bh=IadwbtgQanTooLTGF6wblOKrQ7xQehd5xr22mUtZX1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cer5i1Hi7Z97q1OkPDIub//JsU5v7lnW1VCFzzisqupqagxrCvQV1AmPW8c6qpg7h
	 VZD9oxDYdh9sAeClHp4EVWFczke85al0kwZQLfKZWH1Y13hjO01hpUR0hWpvI7Fhmw
	 wHhRnwj3s0tV2x/wCPxRMhZSZ8HBysboBO1TCT5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 094/197] ALSA: hda/cs8409: Suppress vmaster control for Dolphin models
Date: Tue, 20 Feb 2024 21:50:53 +0100
Message-ID: <20240220204843.898873957@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


