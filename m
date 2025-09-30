Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D951AB6F1;
	Tue, 30 Sep 2025 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244226; cv=none; b=NQmNtDxPq6uk7jzYkEnluMtCG6Ma/gU6T8H+ewlZlAF9VkBznIkrsT800hE64yIjIYomadSIgYhiQH+XxEHoeGNaVsxreCnGVs/Xop+IBFR6BCOK7oar0viYQyCavXYxKzSFSzah6AY19pQLN+dc4/YaQ8EA5saWqA3KkgnTwXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244226; c=relaxed/simple;
	bh=eb7A6ZGXb3vx2+bqWwab4r5i62caa5ILHvJiqDjpIxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSRvqX5YKC2QoGfnWD+twKKItqxC44XpYgH8WDURveqETyrWnKNnf4qXVRHHnRTZldyzZ4/rlfYsVqs2Uj/Mdd9VutZ2xngpeBFSLur82bYMqQxsPlkJgWCZNdd6nlKWUh8JA2b2mad6ETFiPtdoujuthP5SKs34CSBgpXo8Z9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEJ5nPuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEJ5nPuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBF7C4CEF0;
	Tue, 30 Sep 2025 14:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244226;
	bh=eb7A6ZGXb3vx2+bqWwab4r5i62caa5ILHvJiqDjpIxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEJ5nPuSeT1+aaTNIMVBtIhz++F6cwKJrKmtWqbPdYdrzAjnuH1t3huSxRYCbKy56
	 syrVj7zYQslZMSXzk1f7w0ArsZZS48rd3e1CsfV+ud4h3En1Nx3DyNT/LcVykEDrni
	 b70Xhmwo78366P9cl9UhBv4v22WFOXDq/zjWDFSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/122] ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message
Date: Tue, 30 Sep 2025 16:46:37 +0200
Message-ID: <20250930143825.708407410@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 35fc531a59694f24a2456569cf7d1a9c6436841c ]

The dev_err message is reporting an error about capture streams however
it is using the incorrect variable num_playback instead of num_capture.
Fix this by using the correct variable num_capture.

Fixes: a1d1e266b445 ("ASoC: SOF: Intel: Add Intel specific HDA stream operations")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20250902120639.2626861-1-colin.i.king@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-stream.c b/sound/soc/sof/intel/hda-stream.c
index 0e09ede922c7a..ea4fe28cbdace 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -771,7 +771,7 @@ int hda_dsp_stream_init(struct snd_sof_dev *sdev)
 
 	if (num_capture >= SOF_HDA_CAPTURE_STREAMS) {
 		dev_err(sdev->dev, "error: too many capture streams %d\n",
-			num_playback);
+			num_capture);
 		return -EINVAL;
 	}
 
-- 
2.51.0



