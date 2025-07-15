Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D793BBF2;
	Tue, 15 Jul 2025 13:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585388; cv=none; b=ayamHypxEXJ8AzyoT84JZ8h+pS3OWDUcIV+WHp1USxdaRMVwQdER5qCABxceSVw+MFuT0P4nCFpqumjlOLaSvKBRuXhFOvOWD4YXmSNSMh2RtZ1qhWdzuhV9CIgiwG66PaFInqp+PkJYfJl6wg2RNmHlrwPgcS1fD3N4HsDRnBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585388; c=relaxed/simple;
	bh=ozrttte2IVLv9PF7WgJ1GyN6MX5CLPdyRx6Tps45Vog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=elwwu2zovOb/kU426JaQpoyfGXPMZXe/3a+bY5GCfht0PJ+OoxZeRBn33pKx3NVKH0yF8JT6BK304UhAJsjcw3Mf5Dm8l1kKI7dE4T8lfGjhIdVNTHiD2yfD5GJbjVFT1dCBA6J57nXrluXewGX9oLF4fWimnz/rc5oLCqFXhns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfYjgeKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfYjgeKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091C1C4CEE3;
	Tue, 15 Jul 2025 13:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585388;
	bh=ozrttte2IVLv9PF7WgJ1GyN6MX5CLPdyRx6Tps45Vog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfYjgeKRg2dW7nLScTTjFkDmTZqL/Cb3n/mYH+8Zm6nRtsFvt6590vy9P+shl9KXr
	 m+YL+a9MMPqDffnBq75Bo8LNy68AQ3l3OGPswCFRJqZDMWgF+Ut19WJXwen0DNsAca
	 iLlD+QEngj2KigV1OyCzvruGcGfAeQ0zoHkZXnB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/163] ASoC: Intel: soc-acpi: arl: Correct naming of a cs35l56 address struct
Date: Tue, 15 Jul 2025 15:11:17 +0200
Message-ID: <20250715130809.151204921@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit a3003af649efb6f3d86d379d1e9a966ea6d5f5ab ]

As there are many combinations these follow a naming scheme to make
the content of link structures clearer:

cs35l56_<controller link>_<l or r><unique instance id>_adr

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241206075903.195730-10-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a7528e9beadb ("ASoC: Intel: soc-acpi: arl: Correct order of cs42l43 matches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-arl-match.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-arl-match.c b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
index 24d850df77ca8..d7dfb23277d09 100644
--- a/sound/soc/intel/common/soc-acpi-intel-arl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
@@ -138,7 +138,7 @@ static const struct snd_soc_acpi_adr_device cs35l56_2_r1_adr[] = {
 	},
 };
 
-static const struct snd_soc_acpi_adr_device cs35l56_3_l1_adr[] = {
+static const struct snd_soc_acpi_adr_device cs35l56_3_l3_adr[] = {
 	{
 		.adr = 0x00033301fa355601ull,
 		.num_endpoints = 1,
@@ -306,8 +306,8 @@ static const struct snd_soc_acpi_link_adr arl_cs42l43_l0_cs35l56_2_l23[] = {
 	},
 	{
 		.mask = BIT(3),
-		.num_adr = ARRAY_SIZE(cs35l56_3_l1_adr),
-		.adr_d = cs35l56_3_l1_adr,
+		.num_adr = ARRAY_SIZE(cs35l56_3_l3_adr),
+		.adr_d = cs35l56_3_l3_adr,
 	},
 	{}
 };
-- 
2.39.5



