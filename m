Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A34B32AABE;
	Sat, 28 Feb 2026 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301279; cv=none; b=fhFmBQjQg7+S/bXLrSMKfwEP+vdcQ3SKm3mlGOzYmjGUclUHxdrmq6XYt99rCBjdUAGqmbQeuNg2/MovMCRD+JCaKOXLK/HECE/66x1S4zWaWVapYNpJOL9MZFJt3vUqNn8J+zA+K/gOn+fQfF53OcNX8zyXgIZ4S9qqFdnjTtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301279; c=relaxed/simple;
	bh=kU/f+89gQX8msH1ELgzNKPQu5/7ZsX59MFBTN+0lF0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NV2EdGqJeFGxbucGgwxPDJBPibXfb6OM4jT3Mc46BtQRr+c60Ak7panVr9rpXeYMREPI0GBakX2EFH2AObMgF1C2ubDWCvzStRfciAn2AcChNhX6H2ddf0Z1Y01fdP43qhYzmmhMGQG1wMZPshlQgmr23spkQHH7T7APvYRvQQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGFhZMUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGFhZMUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F7FC116D0;
	Sat, 28 Feb 2026 17:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301279;
	bh=kU/f+89gQX8msH1ELgzNKPQu5/7ZsX59MFBTN+0lF0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGFhZMUA+nADDHLFhsWsUZJa8I8YYo4SDxz+b8BB+Ac2RcuDd7HEtf7yBNcWw7uTq
	 j3zbxndwFc+UvuixZtnoV/VIyKGdO6VnwkETo89J799YRbnNsRMiwuV4eowFmG4N6A
	 Qmb3+HyRyIcccoTsWyClyaGy2V3xU4Z80mkUpyd5Grm6R3JHwHycjReepSpK0adGC2
	 gj0oS5prOJPNLi++iPHoHVthvJvQC7W2YG9vkwYn/OaVT3w5xd8awLMglx8Eovftod
	 7hAxjc9+zikBKuZM+8vVkONtBYQei6MHnZ2aSuN55YuoWkICwiYX+OrqBHU0V4ELk3
	 MLS1ZM6qfMh6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	stable@vger.kernel.org,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 463/752] ASoC: SOF: ipc4-control: Use the correct size for scontrol->ipc_control_data
Date: Sat, 28 Feb 2026 12:42:54 -0500
Message-ID: <20260228174750.1542406-463-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit c1876fc33c5976837e4c73719c7582617efc6919 ]

The size of the data behind scontrol->ipc_control_data is stored in
scontrol->size, use this when copying data for backup/restore.

Fixes: db38d86d0c54 ("ASoC: sof: Improve sof_ipc4_bytes_ext_put function")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20251217143945.2667-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-control.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/ipc4-control.c b/sound/soc/sof/ipc4-control.c
index 0a05f66ec7d92..80111672c1796 100644
--- a/sound/soc/sof/ipc4-control.c
+++ b/sound/soc/sof/ipc4-control.c
@@ -66,7 +66,7 @@ static int sof_ipc4_set_get_kcontrol_data(struct snd_sof_control *scontrol,
 		 * configuration
 		 */
 		memcpy(scontrol->ipc_control_data, scontrol->old_ipc_control_data,
-		       scontrol->max_size);
+		       scontrol->size);
 		kfree(scontrol->old_ipc_control_data);
 		scontrol->old_ipc_control_data = NULL;
 		/* Send the last known good configuration to firmware */
@@ -567,7 +567,7 @@ static int sof_ipc4_bytes_ext_put(struct snd_sof_control *scontrol,
 	if (!scontrol->old_ipc_control_data) {
 		/* Create a backup of the current, valid bytes control */
 		scontrol->old_ipc_control_data = kmemdup(scontrol->ipc_control_data,
-							 scontrol->max_size, GFP_KERNEL);
+							 scontrol->size, GFP_KERNEL);
 		if (!scontrol->old_ipc_control_data)
 			return -ENOMEM;
 	}
@@ -575,7 +575,7 @@ static int sof_ipc4_bytes_ext_put(struct snd_sof_control *scontrol,
 	/* Copy the whole binary data which includes the ABI header and the payload */
 	if (copy_from_user(data, tlvd->tlv, header.length)) {
 		memcpy(scontrol->ipc_control_data, scontrol->old_ipc_control_data,
-		       scontrol->max_size);
+		       scontrol->size);
 		kfree(scontrol->old_ipc_control_data);
 		scontrol->old_ipc_control_data = NULL;
 		return -EFAULT;
-- 
2.51.0

