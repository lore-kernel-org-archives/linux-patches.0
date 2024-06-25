Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9097D1487E9;
	Tue, 25 Jun 2024 09:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309535; cv=none; b=Q1rLd/U66FPgxTCeH0IgrYAGJ2m8QNMsRegcuymxVlpXfCVKnv9t52BXhexiHDp7TaxieU5E+XjLmQgZTeFi7XkmBR5GiMhEqR5amcciYruRGYhsIdvG0yP3SPXMY8qeExlOTiNQbk2cZgIb0XN6GLClbhZ65foZ8bg9MRJUdME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309535; c=relaxed/simple;
	bh=JbVu1FZd15yg/6Dl9lwbmUrfT2xZ4BR3dPCdU693gKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AO5j90rctM69HA/1a/6sRKJ/Zp0FOVtq/doI5et6ON3v9AnkVMZKhiF2wH28PyzpL7MnnBKgHxxNXvXrYO3BWzZghPlapwd4cY1B28BsXpDmoqWmnVFAyRbK4Jo19xJhAAj4uwkxiHiEFGCbTs7QsQE3ASNKgt2sXuSVSzr0GBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G615/TuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G615/TuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9F2C32781;
	Tue, 25 Jun 2024 09:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309535;
	bh=JbVu1FZd15yg/6Dl9lwbmUrfT2xZ4BR3dPCdU693gKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G615/TuZ0/6clNzlHAGmKDDBwJIMdL6f0n3TjpIWN6+/GdScVCxPC9g2++bcUREi1
	 LnKAVds2P7Up8nEpzGALfmYg00KxMNkFPkeRl0z3FBIpKg/RET+7scxIxlQfhgpCD5
	 wVs+hsAaXkeJz17TgGvJ3O7YfP+jijC7d0geYTec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/131] ALSA/hda: intel-dsp-config: Document AVS as dsp_driver option
Date: Tue, 25 Jun 2024 11:33:24 +0200
Message-ID: <20240625085527.815082964@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 2646b43910c0e6d7f4ad535919b44b88f98c688d ]

dsp_driver=4 will force the AVS driver stack to be used, it is better to
docuement this.

Fixes: 1affc44ea5dd ("ASoC: Intel: avs: PCI driver implementation")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20240607060021.11503-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index f1de386604a10..5ada28b5515c9 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -16,7 +16,7 @@
 static int dsp_driver;
 
 module_param(dsp_driver, int, 0444);
-MODULE_PARM_DESC(dsp_driver, "Force the DSP driver for Intel DSP (0=auto, 1=legacy, 2=SST, 3=SOF)");
+MODULE_PARM_DESC(dsp_driver, "Force the DSP driver for Intel DSP (0=auto, 1=legacy, 2=SST, 3=SOF, 4=AVS)");
 
 #define FLAG_SST			BIT(0)
 #define FLAG_SOF			BIT(1)
-- 
2.43.0



