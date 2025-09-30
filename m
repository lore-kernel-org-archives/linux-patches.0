Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029772FD1DD;
	Tue, 30 Sep 2025 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245227; cv=none; b=Pi492GqcRpmTHOaiNy1zNwIq1LLko1nue0sRPADfXidQRI57CbLPqoOkTn87idCM2lMk6cV7FBh8mGwkMuVV7dI/sxp6U04IT6rZHyNPyeAHW9l0J5MJvDLAQYdBgP3lK1aZKTLW9A9oR70yFK7L78X/dmCiSkYZgcymagYDBrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245227; c=relaxed/simple;
	bh=S38bVnM6Mxeg02kYSXXIN6ORKn2Yemz5bjQ0Fy/IO50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaTi/HOl+UHb8rXEGxCXaAvFQxv380lcgE3W+LcLKW27706BR+6XT4yQsJhR+ZyXc1kHMSeuFxFvYSefzmx8oNrXnwLs5YiEpr9OhAryGPM5mDOdYS63Ql5QC0pG1siXgQlezGIY38+JoIShNvzVUBAUmFEaV9+NQd9ZBh0B54I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0T8nRg0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T8nRg0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FC8C4CEF0;
	Tue, 30 Sep 2025 15:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245226;
	bh=S38bVnM6Mxeg02kYSXXIN6ORKn2Yemz5bjQ0Fy/IO50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0T8nRg0fW/yaA9arLTywVsnXGvRsmXvA1wrG08lT2C1xmi6fbSxdWbHrdjw88Vadq
	 fa6vH7GB+JlehswbxsTutABIaJtQeok0uEGq5lOEAjz5R3AGW3Tx46/Xm3Pwoxh9iw
	 V8Ehirefgwf7fahehdFjHlib/SziGrlPowuEZCzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/151] ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message
Date: Tue, 30 Sep 2025 16:46:57 +0200
Message-ID: <20250930143831.063587157@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 63c367478f1c9..bf91ac39af1c7 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -776,7 +776,7 @@ int hda_dsp_stream_init(struct snd_sof_dev *sdev)
 
 	if (num_capture >= SOF_HDA_CAPTURE_STREAMS) {
 		dev_err(sdev->dev, "error: too many capture streams %d\n",
-			num_playback);
+			num_capture);
 		return -EINVAL;
 	}
 
-- 
2.51.0



