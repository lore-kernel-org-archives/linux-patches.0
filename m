Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8951F75B7;
	Tue,  3 Dec 2024 14:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237786; cv=none; b=jOM/uMF/bmlmFO0zANVLBAzGIlJ+/5KGAGIIjkTxcDU8guQ4umWPGycXkpK8I6wWgTLoKsVOvxd7BEOZLw3W9jcj+QJ3ZFz77wE3j1IwXi+bMWMH9AiipVVOSYwf9oOcyT8Mw4VDQvFcSx5dEEaAQpBERciDYdgFMO81QqjrMXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237786; c=relaxed/simple;
	bh=6y7yTZDPKOmj9dmG4D0WSZnvAlNt9/5ZVN3M5ySWz7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4rI3EUi3YOjvZ4pVsPM+3jazWUAHwXvdqR8SAF5hHiFCJ7VNnl8K13D56KZs+Qzljmbg92uspn7LBNZ+iSeqXlsoi1Z4iOiFUrx5FPR6Vq9HuVflZt2ejW1bU+re2CqBIVc1Y5+UXodM2lflkZmv6q9fhw5B4AKOPAT/IXRmeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXb+mCLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXb+mCLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9870CC4CED8;
	Tue,  3 Dec 2024 14:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237786;
	bh=6y7yTZDPKOmj9dmG4D0WSZnvAlNt9/5ZVN3M5ySWz7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXb+mCLRwsD/M7IPl2/x366tL6qR2yt13Ammn0qw6ug9w47mbQsNBB1KjDWhpH6tk
	 kfK9SFbGQ4qtN4YVoIc6qTy1a1erc+7lKKksT2EKZlppXFfVT/KsSwEj+cc3MZC9GG
	 UEb9ZjJt9QigRMP5+55daJHCsO84b4QVGK++TJPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Watts <contact@jookia.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 038/817] ASoC: audio-graph-card2: Purge absent supplies for device tree nodes
Date: Tue,  3 Dec 2024 15:33:30 +0100
Message-ID: <20241203143957.141618429@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Watts <contact@jookia.org>

[ Upstream commit f8da001ae7af0abd9f6250c02c01a1121074ca60 ]

The audio graph card doesn't mark its subnodes such as multi {}, dpcm {}
and c2c {} as not requiring any suppliers. This causes a hang as Linux
waits for these phantom suppliers to show up on boot.
Make it clear these nodes have no suppliers.

Example error message:
[   15.208558] platform 2034000.i2s: deferred probe pending: platform: wait for supplier /sound/multi
[   15.208584] platform sound: deferred probe pending: asoc-audio-graph-card2: parse error

Signed-off-by: John Watts <contact@jookia.org>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20241108-graph_dt_fix-v1-1-173e2f9603d6@jookia.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/generic/audio-graph-card2.c b/sound/soc/generic/audio-graph-card2.c
index 56f7f946882e8..68f1da6931af2 100644
--- a/sound/soc/generic/audio-graph-card2.c
+++ b/sound/soc/generic/audio-graph-card2.c
@@ -270,16 +270,19 @@ static enum graph_type __graph_get_type(struct device_node *lnk)
 
 	if (of_node_name_eq(np, GRAPH_NODENAME_MULTI)) {
 		ret = GRAPH_MULTI;
+		fw_devlink_purge_absent_suppliers(&np->fwnode);
 		goto out_put;
 	}
 
 	if (of_node_name_eq(np, GRAPH_NODENAME_DPCM)) {
 		ret = GRAPH_DPCM;
+		fw_devlink_purge_absent_suppliers(&np->fwnode);
 		goto out_put;
 	}
 
 	if (of_node_name_eq(np, GRAPH_NODENAME_C2C)) {
 		ret = GRAPH_C2C;
+		fw_devlink_purge_absent_suppliers(&np->fwnode);
 		goto out_put;
 	}
 
-- 
2.43.0



