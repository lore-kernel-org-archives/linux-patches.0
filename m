Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05304DDB2B;
	Thu, 17 Sep 2026 16:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661325; cv=none; b=l9UyycvBIvcYGmfkrBTUzfkAN/S+Ee9zwKfxfyUf3z2fBaMfoM/oR1TpWbaA6ih9sui0mx7/tg6Sc6VM1dbAt+sZWN+P3M8IJh80pDbOblz6B+Bp8vsPqZLtT61sBLrxkDuMNChgEB6JHQ0cgwkdqT7E2jqfl0oFElyPn+l/PzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661325; c=relaxed/simple;
	bh=zvu2riwAgmj2BO22Y+PBXSJ2svUaMaGnj+cl13sf/L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwg239WUHgq+CTfrAnoWlibA5x1VmdPfJCoy/j9R/GepFaHRuzlx3Xr9s9H95w5vTorMfXOIRH28poM4jVd8h8NQPyGd1ggPaxHA0Daa0jAFAQ+MKZyi/0t88bUno4igurG/MMOHfbImi5VI9cpxwVCt3Lw3O3pJXDpKppoM8KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Z6s3IjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Z6s3IjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD941F000FF;
	Thu, 17 Sep 2026 16:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661323;
	bh=/ZDjtpw1ZBuABjbgu38Gy4baKXDOYxOzqw5Q5k5XDeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Z6s3IjL7Fni6wLEAuBvdotzQXM5jzOQxchmvAXt0D4VUrWH3YkKYmnhsoZf5tksk
	 /5NPnf5+IxfO+lqS9Z+mgsFrtNIbsJwFZsvh+Cf8/2kYb+wqGLuKpwY5fh81y8anAJ
	 ZcZCyh5BjWxKuN1iTweswHf8o7kQPucy0OXB/CN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0121/1250] ASoC: Intel: sof_sdw: append dai type to dai link name unconditionally
Date: Thu, 17 Sep 2026 15:58:36 +0100
Message-ID: <20260917151555.301514518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit c84179a1d36bebe99d9694502737ae9f3a90d2bc ]

The dai_type is used to select function topologies. Since the topology
stream name and DAI link name use partial matching, unconditionally
appending the dai_type provides necessary selection metadata
without breaking existing topologies.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20260515083043.1864426-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 465bf5fafecf7..c9f4fe84c7eed 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -865,10 +865,16 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		}
 	}
 
+	/*
+	 * The dai_type is used to select function topologies. Since the topology stream name
+	 * and DAI link name use partial matching, unconditionally appending the dai_type provides
+	 * necessary selection metadata without breaking existing topologies. Although
+	 * ctx->append_dai_type is not checked here, we overwrite it to ensure consistency in case
+	 * it is referenced elsewhere.
+	 */
+	ctx->append_dai_type = true;
 	for_each_pcm_streams(stream) {
 		static const char * const sdw_stream_name[] = {
-			"SDW%d-Playback",
-			"SDW%d-Capture",
 			"SDW%d-Playback-%s",
 			"SDW%d-Capture-%s",
 		};
@@ -896,15 +902,10 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		}
 
 		/* create stream name according to first link id */
-		if (ctx->append_dai_type)
-			name = devm_kasprintf(dev, GFP_KERNEL,
-					      sdw_stream_name[stream + 2],
-					      ffs(sof_end->link_mask) - 1,
-					      type_strings[sof_end->dai_info->dai_type]);
-		else
-			name = devm_kasprintf(dev, GFP_KERNEL,
-					      sdw_stream_name[stream],
-					      ffs(sof_end->link_mask) - 1);
+		name = devm_kasprintf(dev, GFP_KERNEL,
+				      sdw_stream_name[stream],
+				      ffs(sof_end->link_mask) - 1,
+				      type_strings[sof_end->dai_info->dai_type]);
 		if (!name)
 			return -ENOMEM;
 
-- 
2.53.0



