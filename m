Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62042D978B;
	Tue, 10 Mar 2026 11:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141058; cv=none; b=FKMpeD7ERBmWfjk7VBxwJPV759y48T49TceZ9Ude5BGCj/z2gsWvsayuyi9FwLR672KOrmrdVL2lcHdRobaCZNuXdx6fz6uAzsBFNMIlhID2AVj+8VNIVByjsAuPTBqVrmsILxTy9XDMNSAZK59CMKF6FiIxclHjCjIX413q4xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141058; c=relaxed/simple;
	bh=v1OKiO81FA8sFLXPhny59loS1kvZlX35ktDlxjboCd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Agahp+G7d3RHRl9SW/eC7jimCoohz2OKyC8ph6vaQAwao6wPQFJ/TXtm/84V1eKIOUIxIpyRR+6/JFsNVtxVKjD4j8TJptsBVGOmx0w3zLnwExTN8KPkhLWETtuXyBRQcOvMObcS7TvLDXkOPXDT0aadNgbT4WpYgmteqK1n0HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RHVwJHmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RHVwJHmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E47EC2BC9E;
	Tue, 10 Mar 2026 11:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141058;
	bh=v1OKiO81FA8sFLXPhny59loS1kvZlX35ktDlxjboCd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHVwJHmA1V9smbGHQciz0wI78y7gKxJSumLF5SQJv0A+WzTptLvMcPeBVGCUNOWYv
	 c4zb/vhQCuQlDIqQ4JlbP0N/0SvS9j4ohVyEnKND4EEMt9fNZCn3L6ZQNaqNt72/wB
	 WHEpoor53AytL2o+h3Y03Srnu41ws+RAJYDEsTv2gUtyeS4MxNmgv0i9MzPnlMJl6j
	 FhgEYr+Y6gp+zZj733He3EDoRVkgupH6y+prG6HNa/fCCGF9oksPzc8vA/AiG/Cp9Z
	 dyBxEuS0tzXKKymY/xTLRhD7HAQ6++xXATBLQetvytXhGsu70HewrHTpXFxoWAUkwz
	 0ncPCgw7wbnOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 058/311] ALSA: usb-audio: Use inclusive terms
Date: Tue, 10 Mar 2026 07:01:45 -0400
Message-ID: <aab39e3873437fb3c7a6c384ab85583d133de3d0.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4e9113c533acee2ba1f72fd68ee6ecd36b64484e ]

Replace the remaining with inclusive terms; it's only this function
name we overlooked at the previous conversion.

Fixes: 53837b4ac2bd ("ALSA: usb-audio: Replace slave/master terms")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index bd035ab414531..686f095290673 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -160,8 +160,8 @@ int snd_usb_endpoint_implicit_feedback_sink(struct snd_usb_endpoint *ep)
  * This won't be used for implicit feedback which takes the packet size
  * returned from the sync source
  */
-static int slave_next_packet_size(struct snd_usb_endpoint *ep,
-				  unsigned int avail)
+static int synced_next_packet_size(struct snd_usb_endpoint *ep,
+				   unsigned int avail)
 {
 	unsigned int phase;
 	int ret;
@@ -227,7 +227,7 @@ int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 	}
 
 	if (ep->sync_source)
-		return slave_next_packet_size(ep, avail);
+		return synced_next_packet_size(ep, avail);
 	else
 		return next_packet_size(ep, avail);
 }
-- 
2.51.0

