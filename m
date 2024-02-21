Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7A469E08;
	Wed, 21 Feb 2024 13:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521427; cv=none; b=WCf7umRVdkdmZZbtOhDBGaO5nQiXM80vA6cmf30tbPckQUHSpIrLjaJvxZVtWOAxMCLP/K8nYgx73P8WdqyGX3242nyiABEZpigaMP84Xg90bxazHAOtjImxdF9hMgWAib5SjNSL6Eceb87Eildq2VjOjLgwd/hCGH4Pj1v3stw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521427; c=relaxed/simple;
	bh=nxQLd+Sn+E4Dp0POb2WH9ZqQfKtm17Z+sSrQ5b+Fhno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hg6km0fXNFJ3Ix32Czc3a8iIQmkiiHBF3vTo92Ery+beHwZx78cbbeDTiZDYUBZt0LRuWEetOlYP2Ob5neGFI/mVmBgqlxk2sRs1BS2Lh9N20bnwyriKmfhlRc1nFM46T/V+oHh3v7KrG9Phz29NUGFWO1G4T+gn4M9UW3zOHdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVz0eRDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVz0eRDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C15C43390;
	Wed, 21 Feb 2024 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521426;
	bh=nxQLd+Sn+E4Dp0POb2WH9ZqQfKtm17Z+sSrQ5b+Fhno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVz0eRDfFXps7CkqpjsOyZemThYEuVhCiat2Pub9yW/ysX56QuBUv/iUUtaPDniRd
	 FM3NUDE1hbsk1Fo85B68gKkJFCs+sd5JvcFyLoXGbVPveeJbU1+HmI3D/QORHsSrX6
	 SRDEQfT+Lrl/eFGLxbJfQsKgvkZtaCfjSVuIPm74=
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
Subject: [PATCH 4.19 106/202] ALSA: hda: Intel: add HDA_ARL PCI ID support
Date: Wed, 21 Feb 2024 14:06:47 +0100
Message-ID: <20240221125935.182264985@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit a31014ebad617868c246d3985ff80d891f03711e ]

Yet another PCI ID.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20231204212710.185976-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index e66d8729c72f..94a97832cf0f 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2615,6 +2615,8 @@ static const struct pci_device_id azx_ids[] = {
 	/* Icelake */
 	{ PCI_DEVICE(0x8086, 0x34c8),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	/* Arrow Lake */
+	{ PCI_DEVICE_DATA(INTEL, HDA_ARL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE) },
 	/* Broxton-P(Apollolake) */
 	{ PCI_DEVICE(0x8086, 0x5a98),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_BROXTON },
-- 
2.43.0



