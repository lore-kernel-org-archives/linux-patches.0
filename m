Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B01E3D3D1B;
	Thu, 17 Sep 2026 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667439; cv=none; b=rAe8Mlrcs8qSHmD9irCdHJznQsUhB3vTUGPubBDyECl0QEdUc2KigwU9+s7u8NvT2Gl4pkD1iBRFfQzX7M+ivgDGoReuAlM+b3rqXQdk6rfWRRIjbcQKSsC7EQ4mPQ5m4QWHm5Jm/M88llgijavE/3iDpIQQ/3wl7c7fpbgBR+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667439; c=relaxed/simple;
	bh=P5ydGFm71ppTcnQ6Vn5Awlk4RWhLrk1LezwCpNI3bF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thgoZ805yq4nJN0MVjPzoaw5vg9uRrS9yB2b8qj772MgzkLYkeCh2Qogr1I5jEmMm8V1FQUePkCMZmmS9ovQz+OMeuWU2hw5fo6ujF9bXhQOVIU2mTkkUJOnr+Dcu7y1gGRDOK82BPYF3X1nm3shoPWLgGn0vq1vXd10CbdQPjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfLf1fFU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfLf1fFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842CB1F000FF;
	Thu, 17 Sep 2026 17:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667438;
	bh=ioVpBAqrGcLSzTDTf27HXDPa2laRBOxC+I/hWKQiNyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UfLf1fFUo6LnpMezZQhu6wLaUGXeBbcDQZzRWYx7Y1a6zkSZ55sDkp30V53lj5am2
	 blDLfQXgRBiEVY+qRrzQDBpR/aWpRy77CXJsVO1gVAurtY/1+z1gX43eAxNt+QsirP
	 AUcTLs0C3Mz/Dwa44VjD2xyjBbPrmXERpfwAvxyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0086/1102] ASoC: Intel: sof_sdw: append dai type to dai link name unconditionally
Date: Thu, 17 Sep 2026 16:00:29 +0100
Message-ID: <20260917151541.637212453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 00d840d5e585c..ba53b67530e5a 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -748,10 +748,16 @@ static int create_sdw_dailink(struct snd_soc_card *card,
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
@@ -778,15 +784,10 @@ static int create_sdw_dailink(struct snd_soc_card *card,
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



