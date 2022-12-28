Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F3D1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4198FC433D2;
	Wed, 28 Dec 2022 15:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242477;
	bh=XkPe3dJ9RRR1N8aSr2mMb0JFqzW72j2gCtbe4xfFdds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IH7SRlDQgeH0ynufnxigfQo5iQhpX+4KAlXKFsMfg+mQRWyyigM7/9/sWviXFJU2r
	 6ad+cI/nZ0i3kIEXJluICUA0GDz7sbyGlOisdkwpi6qgC9iu9dE2PygRNjBydHB8WI
	 /koafmBN9Bv039515Ie1mTRsNkrTiQNF7cbMp+Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Chang <junxiao.chang@intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Lili Li <lili.li@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0374/1146] ASoC: Intel: Skylake: Fix Kconfig dependency
Date: Wed, 28 Dec 2022 15:31:53 +0100
Message-Id: <20221228144340.322316385@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lili Li <lili.li@intel.com>

[ Upstream commit e5d4d2b23aed20a7815d1b500dbcd50af1da0023 ]

Commit e4746d94d00c ("ASoC: Intel: Skylake: Introduce HDA codec init and
exit routines") introduced HDA codec init routine which depends on SND_HDA.
Select SND_SOC_HDAC_HDA unconditionally to fix following compile error:
ERROR: modpost: "snd_hda_codec_device_init" [sound/soc/intel/skylake/snd-soc-skl.ko] undefined!

Fixes: e4746d94d00c ("ASoC: Intel: Skylake: Introduce HDA codec init and exit routines")
Reviewed-by: Junxiao Chang <junxiao.chang@intel.com>
Suggested-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Lili Li <lili.li@intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20221121104742.1007486-1-lili.li@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/Kconfig b/sound/soc/intel/Kconfig
index d2ca710ac3fa..ac799de4f7fd 100644
--- a/sound/soc/intel/Kconfig
+++ b/sound/soc/intel/Kconfig
@@ -177,7 +177,7 @@ config SND_SOC_INTEL_SKYLAKE_COMMON
 	select SND_HDA_DSP_LOADER
 	select SND_SOC_TOPOLOGY
 	select SND_SOC_INTEL_SST
-	select SND_SOC_HDAC_HDA if SND_SOC_INTEL_SKYLAKE_HDAUDIO_CODEC
+	select SND_SOC_HDAC_HDA
 	select SND_SOC_ACPI_INTEL_MATCH
 	select SND_INTEL_DSP_CONFIG
 	help
-- 
2.35.1



