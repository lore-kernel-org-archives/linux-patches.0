Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD232F9EB;
	Sat,  3 Feb 2024 04:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933606; cv=none; b=aKjBaTC0Fn1mNIprA3YmI9frkQSE+ma3bVJiKbYVC1BcTHAL/AFX9SeL6GF4jeV842gs9ZlPLULT2uNidxthONxBGoUaZnmBUyNI47IcAof16GmZQ22DpZ+MACDl2qmSrOofCIigd2VjyKTi1B6BsD77UUvVXtmXYMTwt5DfKGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933606; c=relaxed/simple;
	bh=D86GhkRz++rH3dTTqbuva/YkcMMAuTRbWHNIQaDidMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXePL+BDj4JvepHVoI8oVpGdDSEoXHEOHDwPDJdUGwWQKdIiBFovABWdGNe3gUGP/ATBSiwJGepa2QhJk8w9P8xQlueanzKUfs0A9j08F4sAwnrnykBhWnAdeOoiIRxRnYce6K0DjKNkcvK5FcouIUVqspT9aZ/AKylZ7MLPKRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dycx81mi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dycx81mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8333AC433C7;
	Sat,  3 Feb 2024 04:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933606;
	bh=D86GhkRz++rH3dTTqbuva/YkcMMAuTRbWHNIQaDidMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dycx81miCAGkcndKG6Kgb2VzheLyJLNT1Z2xcTIeeuHd+IBwOyphuFrpUTyXhad4G
	 r3O1v0MT50TNX/PoT3tp8KdUvTpv+eI7vg/OrLU/74DsQqk8m+ffvWDw/KHlC83Oqq
	 yLd3e8QTY0DOEB0LhHt7P9WLoDFzwHfFxyRO2JdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/322] ALSA: hda: intel-dspcfg: add filters for ARL-S and ARL
Date: Fri,  2 Feb 2024 20:04:33 -0800
Message-ID: <20240203035404.935739492@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 7a9d6bbe8a663c817080be55d9fecf19a4a8fd8f ]

Same usual filters, SOF is required for DMIC and/or SoundWire support.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20231204212710.185976-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 756fa0aa69bb..6a384b922e4f 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -521,6 +521,16 @@ static const struct config_entry config_table[] = {
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = PCI_DEVICE_ID_INTEL_HDA_MTL,
 	},
+	/* ArrowLake-S */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = PCI_DEVICE_ID_INTEL_HDA_ARL_S,
+	},
+	/* ArrowLake */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = PCI_DEVICE_ID_INTEL_HDA_ARL,
+	},
 #endif
 
 /* Lunar Lake */
-- 
2.43.0



