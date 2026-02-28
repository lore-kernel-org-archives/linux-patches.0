Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E05A340A51;
	Sat, 28 Feb 2026 17:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301277; cv=none; b=eRDjbaYfS2qGN/U8UgCzy2pgWrmyv4XQjAJFsbVcXiqz3jZqjM+orMUzcFIz721kMf1Llwu0eON90HDbW4I1rLs0CcjfBFR7oqnpoHgpTR2ZmwMwUmg5qpoC8PWQ96ietvGeL4fhXuU4gX7JqeclmkjwGEdo1q25GlGhMSVyZkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301277; c=relaxed/simple;
	bh=uTqbPw591zXdfTsTtnbae2IXUOtbUZZJRiNlboZWmbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRfpWwgUeb+wxKgoDJwH2ybROSC/13VyU7o2dTKAk/HDLUlAjM8T1tcHgsJvLUpGD26pNYE4iUcrxy612Z9cM+nv0xnX1TLSDF9KejjCSr3uCI7xoqTbTUUf7f5LpNH0fKccqvIRY6oMNr0iD/M8PAWnPnV3Z0CLFswqKEXKv3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjytiZTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjytiZTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1719AC19424;
	Sat, 28 Feb 2026 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301277;
	bh=uTqbPw591zXdfTsTtnbae2IXUOtbUZZJRiNlboZWmbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjytiZTIYsYEH9YPzuSt/7FReRETnVdmkLK5IAW2bgoHVTG0uVT8TOVERKij7NLkw
	 xhFeiM89/4vKf9EWSSIwob158rckVsqTApZ7DTfYKRnxWYd3IgXHLtipYAPn+0opyE
	 qYo1WLIjrHw2PxcI5x7+dqnTHlFiB19SWAQtA+RYLQTec3pi4Q2iVUbjPEGx/zzUJZ
	 WnaGOtSCJlc8sPbjRtgd+kXEmDE40JKz4Hou2LjrglESgwBcmpWQirtjlb0Xw4nODU
	 Zw0KkkCugu6wfKePtUuxN6yU1exFEJClCzXYPByOi7iEvYDrAbYswAYHn40HmaTRSl
	 SXCf2314BDdNw==
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
Subject: [PATCH 6.18 461/752] ASoC: SOF: ipc4-control: If there is no data do not send bytes update
Date: Sat, 28 Feb 2026 12:42:52 -0500
Message-ID: <20260228174750.1542406-461-sashal@kernel.org>
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

[ Upstream commit 2fa74713744dc5e908fff851c20f5f89fd665fb7 ]

When the bytes control have no data (payload) then there is no need to send
an IPC message as there is nothing to send.

Fixes: a062c8899fed ("ASoC: SOF: ipc4-control: Add support for bytes control get and put")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20251217143945.2667-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-control.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-control.c b/sound/soc/sof/ipc4-control.c
index 976a4794d6100..0a05f66ec7d92 100644
--- a/sound/soc/sof/ipc4-control.c
+++ b/sound/soc/sof/ipc4-control.c
@@ -412,8 +412,16 @@ static int sof_ipc4_set_get_bytes_data(struct snd_sof_dev *sdev,
 	int ret = 0;
 
 	/* Send the new data to the firmware only if it is powered up */
-	if (set && !pm_runtime_active(sdev->dev))
-		return 0;
+	if (set) {
+		if (!pm_runtime_active(sdev->dev))
+			return 0;
+
+		if (!data->size) {
+			dev_dbg(sdev->dev, "%s: No data to be sent.\n",
+				scontrol->name);
+			return 0;
+		}
+	}
 
 	msg->extension = SOF_IPC4_MOD_EXT_MSG_PARAM_ID(data->type);
 
-- 
2.51.0

