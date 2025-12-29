Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FED332912;
	Mon, 29 Dec 2025 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025879; cv=none; b=AxgtwgVwRz14UU0MStCSqNCU50XrZ526oMckHatQPUUgQdAAtUELK02jwAmPlVrNUHZ/3x7TEKWhwzROnVBCKhD2zcAkjfkn46Mlda+fzU8wwHPXeqcHHxzNVX01PGPK7DFvrW++aQgRa6ajPTEmLnliKSWGX+ZFwZyx4G4ZP4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025879; c=relaxed/simple;
	bh=XYbDLxsDlxJAVma/NNQNu9SRj4vRLjHu4Yp1lY5q0ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6feFxaI9rIjjQeTgcbwHZ9N95l8/vQ51FCZvRhTPvlaZ07InC7ajyI5AkcLWNFc/RBQoD2WwvovlFJlmuKw3JQ4/KVthSMvJNMeFnyjcO8mBzH5iMD7nO1Mi+/W1dHZV138dFjLuk9dKEu7jlUMGB8enI6Bcuw835H9j2SWhvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzUMA4S1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzUMA4S1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522BCC4CEF7;
	Mon, 29 Dec 2025 16:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025879;
	bh=XYbDLxsDlxJAVma/NNQNu9SRj4vRLjHu4Yp1lY5q0ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzUMA4S1uiXqOzRTb7myNEX3bYg1CmWOcYLKba8VL39wlmeg0FMmEEI0j6vo6baca
	 3z6y9B29M41PfZJytpgY+faRgmnuozY3nmRvER68c+O0mzITNT9Sg1oU0iib/55IM5
	 M0cMigfR3kFwhuGDEaStYDyIGPJRpT5nduU38gj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 369/430] ASoC: SOF: ipc4-topology: Prefer 32-bit DMIC blobs for 8-bit formats as well
Date: Mon, 29 Dec 2025 17:12:51 +0100
Message-ID: <20251229160737.904577199@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 26e455064983e00013c0a63ffe0eed9e9ec2fa89 upstream.

With the introduction of 8-bit formats the DMIC blob lookup also needs to
be modified to prefer the 32-bit blob when 8-bit format is used on FE.

At the same time we also need to make sure that in case 8-bit format is
used, but only 16-bit blob is available for DMIC then we will not try to
look for 8-bit blob (which is invalid) as fallback, but for a 16-bit one.

Fixes: c04c2e829649 ("ASoC: SOF: ipc4-topology: Add support for 8-bit formats")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20251215120648.4827-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 221e9d4052b8..47959f182f4b 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1752,11 +1752,9 @@ snd_sof_get_nhlt_endpoint_data(struct snd_sof_dev *sdev, struct snd_sof_dai *dai
 		channel_count = params_channels(params);
 		sample_rate = params_rate(params);
 		bit_depth = params_width(params);
-		/*
-		 * Look for 32-bit blob first instead of 16-bit if copier
-		 * supports multiple formats
-		 */
-		if (bit_depth == 16 && !single_bitdepth) {
+
+		/* Prefer 32-bit blob if copier supports multiple formats */
+		if (bit_depth <= 16 && !single_bitdepth) {
 			dev_dbg(sdev->dev, "Looking for 32-bit blob first for DMIC\n");
 			format_change = true;
 			bit_depth = 32;
@@ -1799,10 +1797,18 @@ snd_sof_get_nhlt_endpoint_data(struct snd_sof_dev *sdev, struct snd_sof_dai *dai
 		if (format_change) {
 			/*
 			 * The 32-bit blob was not found in NHLT table, try to
-			 * look for one based on the params
+			 * look for 16-bit for DMIC or based on the params for
+			 * SSP
 			 */
-			bit_depth = params_width(params);
-			format_change = false;
+			if (linktype == SOF_DAI_INTEL_DMIC) {
+				bit_depth = 16;
+				if (params_width(params) == 16)
+					format_change = false;
+			} else {
+				bit_depth = params_width(params);
+				format_change = false;
+			}
+
 			get_new_blob = true;
 		} else if (linktype == SOF_DAI_INTEL_DMIC && !single_bitdepth) {
 			/*
-- 
2.52.0



