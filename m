Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECF11B14FD;
	Thu,  6 Jun 2024 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683390; cv=none; b=hsOowAahqHwvPFIy3coQ+3LjZJP/mfheutDNuc2v+Ry0PcSrYR/GqFTDkX4INds2OzcAJz4LnFPrx0GlD95EjzeZCbKFwtAu9JGrnXxnw/bqdCjPLAeXd9WsgDaVhEEAVOBaQyXbkxQ987ffZLt1jE53IC+/ihshsizh753EDlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683390; c=relaxed/simple;
	bh=ysBhuglUDPo46Iidf9yrsM7ev1XgTcBB/oHiiH+ZTZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNgPQf7c62iM+h5IO0X44DQCTld7Yb7aaTJCxnOii8kRxjAVMU5z7I0MizqscItKS10nAC7WfNpMyajGXxw2DjTUXQd56OW5R1ccgY52BeKYO3z46wrwzslkNKvV5P5IsHftPvrnckGGTPvSQPzlIcYgvYISyFCbNjbxejPK60I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O32bCMzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O32bCMzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C682C2BD10;
	Thu,  6 Jun 2024 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683390;
	bh=ysBhuglUDPo46Iidf9yrsM7ev1XgTcBB/oHiiH+ZTZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O32bCMzLPJ8KnERWqKD1tpduAL4wR6qVk3xbE0l8S9FktsPRRVIEAJJ2OZmsuBU4M
	 RTqwtrfdCLUl4HX/W3I/7pSfi/q8BLl+AEvZkliK+fOfLsmWsUWqwCz/IGG5PN6v5s
	 R2K+EY+meg/pxqqC0R2kh41c+sd5mGiAFCm0thto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 302/744] ASoC: Intel: avs: Test result of avs_get_module_entry()
Date: Thu,  6 Jun 2024 15:59:34 +0200
Message-ID: <20240606131742.071494113@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 41bf4525fadb3d8df3860420d6ac9025c51a3bac ]

While PROBE_MOD_UUID is always part of the base AudioDSP firmware
manifest, from maintenance point of view it is better to check the
result.

Fixes: dab8d000e25c ("ASoC: Intel: avs: Add data probing requests")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240405090929.1184068-9-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/probes.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/sound/soc/intel/avs/probes.c b/sound/soc/intel/avs/probes.c
index 4cab8c6c45766..341773ec49072 100644
--- a/sound/soc/intel/avs/probes.c
+++ b/sound/soc/intel/avs/probes.c
@@ -19,8 +19,11 @@ static int avs_dsp_init_probe(struct avs_dev *adev, union avs_connector_node_id
 	struct avs_probe_cfg cfg = {{0}};
 	struct avs_module_entry mentry;
 	u8 dummy;
+	int ret;
 
-	avs_get_module_entry(adev, &AVS_PROBE_MOD_UUID, &mentry);
+	ret = avs_get_module_entry(adev, &AVS_PROBE_MOD_UUID, &mentry);
+	if (ret)
+		return ret;
 
 	/*
 	 * Probe module uses no cycles, audio data format and input and output
@@ -39,11 +42,12 @@ static int avs_dsp_init_probe(struct avs_dev *adev, union avs_connector_node_id
 static void avs_dsp_delete_probe(struct avs_dev *adev)
 {
 	struct avs_module_entry mentry;
+	int ret;
 
-	avs_get_module_entry(adev, &AVS_PROBE_MOD_UUID, &mentry);
-
-	/* There is only ever one probe module instance. */
-	avs_dsp_delete_module(adev, mentry.module_id, 0, INVALID_PIPELINE_ID, 0);
+	ret = avs_get_module_entry(adev, &AVS_PROBE_MOD_UUID, &mentry);
+	if (!ret)
+		/* There is only ever one probe module instance. */
+		avs_dsp_delete_module(adev, mentry.module_id, 0, INVALID_PIPELINE_ID, 0);
 }
 
 static inline struct hdac_ext_stream *avs_compr_get_host_stream(struct snd_compr_stream *cstream)
-- 
2.43.0



