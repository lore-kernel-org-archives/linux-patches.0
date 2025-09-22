Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D6A2517AC;
	Mon, 22 Sep 2025 19:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570374; cv=none; b=rWhti442cVK0XwtCijoez0KrN5B+3C5xeryGhv4mR9hvLgKfUHQ7mbrs2LFVOYHzbSTM6UF0GK3TSQwNFwG6OcVLQ8XMb34HnDCrqChxquJ1kndLjsW9xhrESQpmsmM6hezeIjoiPxVoeXaLVOf6ZW5GX5PSAJR3pcRs3xoVe0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570374; c=relaxed/simple;
	bh=ouwKnYS0us8+omkEKsKl3RpAfkI08CeqWs8qYU/Psew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B61Ltmd4RMvyZdL4jp7T15MmUUT/aualtCW4vBD6poNtsUD1M73hrCCGgztwKcIq5KgoLpbBqj98JaP42KgwX6Wbd4MBmXgiuepHokzqZNYl1eHYDIjGKH8v7zYqxuGa19fY92Hglp3ag7jw9S5chc5qitN6+lIBSBwkEl8WI38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbnJfXS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbnJfXS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6015AC4CEF0;
	Mon, 22 Sep 2025 19:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570374;
	bh=ouwKnYS0us8+omkEKsKl3RpAfkI08CeqWs8qYU/Psew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbnJfXS+aPUOK++vyry7DYzqOaBAUT3NCfgoG5ppVjb/CEDlwaQSUj+30i4J0lK43
	 5JzBQxuQJ5ztWowfnWW+SKsICX0SF/wi8IBhxOFgk31l13bi8M7EKfpwEYEiyCtsBl
	 n7N+EH7E3mPtXJQ4dhuNxi9eASEkogMz+6TgUWCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 112/149] ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message
Date: Mon, 22 Sep 2025 21:30:12 +0200
Message-ID: <20250922192415.698910151@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index aa6b0247d5c99..a34f472ef1751 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -890,7 +890,7 @@ int hda_dsp_stream_init(struct snd_sof_dev *sdev)
 
 	if (num_capture >= SOF_HDA_CAPTURE_STREAMS) {
 		dev_err(sdev->dev, "error: too many capture streams %d\n",
-			num_playback);
+			num_capture);
 		return -EINVAL;
 	}
 
-- 
2.51.0



