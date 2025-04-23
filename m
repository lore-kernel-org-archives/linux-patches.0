Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0140D280A22;
	Wed, 23 Apr 2025 15:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420609; cv=none; b=ohu+2CG0hAotr9N2FkIcrVbkJA6jXUPS2rDHJHYCjlhHBNU95sstb0HcPUUBLGDmIPNCUGZZKmlZ+7m/raFSgAkw4v5MkuMHG3+3UK26cI0gw++Z2BXD6+Q+NAob335HwLWczmOwjpIeYCkS1DsxobSpd0G4IdOcvpkV1aoXMMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420609; c=relaxed/simple;
	bh=I1st/aNNUKMYE7yT1wVv5CNVrvpDX0ppQJ1Iwj1G2k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQiRdyvJheTQzCqPvrZPUPA/7GbjI4JrOMluRMZSI7Xi/12xXZBsMKj94+fN7z+4gV0bzs+i22NnETu1rWs2py341daMS5LzbuC4BalURlVjV+FUNrXzB2N8PRC8Ovx/v0RVlp8rBY7zOfo5OGBL2iQduMF/XlscZS1D0c+9oJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELYqS5F+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELYqS5F+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BECC4CEE2;
	Wed, 23 Apr 2025 15:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420608;
	bh=I1st/aNNUKMYE7yT1wVv5CNVrvpDX0ppQJ1Iwj1G2k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELYqS5F+eQ9ruqdlwpiqf6KKwzZSosy0RyHX8OeIC+ExgUedapQqfojOrn8sgth1V
	 beM0zMgIhcYDMJsfJvSXJppZQlrFOalHVVOHWmqDyZeZG5UY0gj1aFs1+hXp+VBSoX
	 PnYOC1xP4a9AbDJ1PBFS605Na+P/nbrDw6omNW5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 107/241] ASoC: Intel: sof_sdw: Add quirk for Asus Zenbook S16
Date: Wed, 23 Apr 2025 16:42:51 +0200
Message-ID: <20250423142624.955852300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit dfcf3dde45df383f2695c3d3475fec153d2c7dbe upstream.

Asus laptops with sound PCI subsystem ID 1043:1f43 have the DMICs
connected to the host instead of the CS42L43 so need the
SOC_SDW_CODEC_MIC quirk.

Link: https://github.com/thesofproject/sof/issues/9930
Fixes: 084344970808 ("ASoC: Intel: sof_sdw: Add quirk for Asus Zenbook S14")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Simon Trimmer <simont@opensource.cirrus.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250404133213.4658-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/sof_sdw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -764,6 +764,7 @@ static const struct dmi_system_id sof_sd
 
 static const struct snd_pci_quirk sof_sdw_ssid_quirk_table[] = {
 	SND_PCI_QUIRK(0x1043, 0x1e13, "ASUS Zenbook S14", SOC_SDW_CODEC_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1f43, "ASUS Zenbook S16", SOC_SDW_CODEC_MIC),
 	{}
 };
 


