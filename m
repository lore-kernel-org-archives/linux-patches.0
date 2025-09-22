Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2BA2DEA79;
	Mon, 22 Sep 2025 19:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570035; cv=none; b=PgBFV1d9cpqhd026xnThk/Pf6p1Uq0/eNeQnCELUpuxzKg/wkSlfp/zOPwGfE5kb/Ja6VjwcBnvLtOLaVHGGrMduke2m8j13USwfCQbxrPHBbiVBETgXtOR28ssdFBDJ9SkdvdkoxhQNfLmHejfxy87C08F/oalX5z/spjkrdUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570035; c=relaxed/simple;
	bh=0KVgWfmqb85K7fdCZISPvNOGq6cN/8R1osdLZzNfkmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwyUlHOhEv9U+TPhyJAINQAG7j+UITnd8szmP1nCTYaE2PZa72P9lecP3JO5Ej7aK+oe2ZsXsIccTWAYqI+8NmHtyXEWDpLjoLkd/68bI6M86SO8EJFmiO6EfP9TV6iccvkKcUQhAWBXWoog++n6xHXq7Osn9IFIgIYGqGpucKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQYkZ7It; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQYkZ7It"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5B2C4CEF0;
	Mon, 22 Sep 2025 19:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570034;
	bh=0KVgWfmqb85K7fdCZISPvNOGq6cN/8R1osdLZzNfkmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQYkZ7ItnTuI6OjqLDDsB4u85+6T8M3tvuPFwID46tsyuHp9fWmrUuo58326qfWKT
	 2hfLey4zh7i/F0njPUUsEoBsSSeGX/wQQgDf3SIqYorVLGfdoWwFrZzSeYg/KW0Y7J
	 O+qZjROMka7BSiRiXbvKRuvvT+t6l0XxTQzZimcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/105] ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message
Date: Mon, 22 Sep 2025 21:29:57 +0200
Message-ID: <20250922192410.836054099@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3ac63ce67ab1c..24f3cc7676142 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -864,7 +864,7 @@ int hda_dsp_stream_init(struct snd_sof_dev *sdev)
 
 	if (num_capture >= SOF_HDA_CAPTURE_STREAMS) {
 		dev_err(sdev->dev, "error: too many capture streams %d\n",
-			num_playback);
+			num_capture);
 		return -EINVAL;
 	}
 
-- 
2.51.0



