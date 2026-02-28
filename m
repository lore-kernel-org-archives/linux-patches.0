Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7100447CC7E;
	Sat, 28 Feb 2026 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301326; cv=none; b=ISmQcHNUes13Zmhs3nDGXekGm8hB2IC6cNir1r+V3ROa5JktT8qDkib5eiAvSMr5IklUWg2MIATLWOqSZvbQXmGIXb5FlzrYj6qVG+lyF5MoUuy8kEUgjUQHHbAlolL6A35znrSGF7wcmsr59W2HoNL9UM+EQFh8jiSa8ksrpjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301326; c=relaxed/simple;
	bh=WVArMy5lotm7UNiAO5vjByf5lyQ+wjhKYbVg3xx3mUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9TnfU3NInAWoGBV6roJ8J85D3fHvQB0p9tmkBxO6y2IwmmLc/VEXUYPEv0TngkucYvxe7Ez+GbrRhnGqdeThIEc0otx5FpfOqHptNDtKaUvHB5/PIWpRstWJFGUg03OYv5M3zthSvQYN3mTp6W2h9LWRwzpX1nAPiWtMd384to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjRnL1fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjRnL1fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD772C19423;
	Sat, 28 Feb 2026 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301326;
	bh=WVArMy5lotm7UNiAO5vjByf5lyQ+wjhKYbVg3xx3mUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjRnL1fnv1I7GmDYM2NYDqWdBVJ1fHmoN/V0WfADSIY8WmU7eqlwSYB+DfB9gFqbp
	 QgRfCpGIz5uH7JfbD4U9kgAzcv/IjwAffP8sY1PMlO1q9elvNyRkl5i82doHGKCSM5
	 v6ObucWJNo4mRsslCCrpnjN460RU5d5k+vuqt/keNCFbz3ECtM7P7OHU4wIZWlYp0h
	 GloxCjVmyiFNwWqDx1mZTC9i0CJoX/0iH1zkk2SUMZCj/XiTqCmArBFEc62VUh13aX
	 aMaPMumdZsHc49vrl3wCntbofARe9+4WCux9ca1LaPzTeV6w9Pu36hcRFUg4J6H1Kx
	 jj/qY0ZIp8HPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 513/752] media: cx25821: Add missing unmap in snd_cx25821_hw_params()
Date: Sat, 28 Feb 2026 12:43:44 -0500
Message-ID: <20260228174750.1542406-513-sashal@kernel.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 863f50d583445c3c8b28a0fc4bb9c18fd9656f41 ]

In error path, add cx25821_alsa_dma_unmap() to release the
resource acquired by cx25821_alsa_dma_map()

Fixes: 8d8e6d6005de ("[media] cx28521: drop videobuf abuse in cx25821-alsa")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx25821/cx25821-alsa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index a42f0c03a7ca8..f463365163b7e 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -535,6 +535,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 			chip->period_size, chip->num_periods, 1);
 	if (ret < 0) {
 		pr_info("DEBUG: ERROR after cx25821_risc_databuffer_audio()\n");
+		cx25821_alsa_dma_unmap(chip);
 		goto error;
 	}
 
-- 
2.51.0

