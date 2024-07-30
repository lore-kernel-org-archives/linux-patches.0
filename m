Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7854F1A616E;
	Tue, 30 Jul 2024 16:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356018; cv=none; b=Cnjfns8BSOhLP3HUR7fK9h21IxFALg/XGyRpwBZilPxBWCLz98hLT2CQgJEsBcKn5Worw9ajf6lLC5lQ5i6Al7GWD6sH2uu4K65WlznRQzZYpE68t+f7zT2frBOZKfi6+hT0OkskS4AqfKPjVIcvMNuF/xcrU6R1FAc1YyjzYcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356018; c=relaxed/simple;
	bh=G8sGy22I+Epb4tSUHpDmHTzNHOLPPkK8ynBdRtLwmgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bt9BSD20k+inWVmIAMvrXaeYv8LTINUUeozuKfUdSj4jqS9grDZkhhsunnBlp4vPDYpmc4e7LL8AHwwboAt0mTdK/GDsEmDC5IFN5nwVZ3Y2PchzAsf+qI7WDIHTjwGbHM3sFTTOGR7hny7og1UxrUWsbl9HjafFWkVEFDJGq2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8tSodAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8tSodAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1315C4AF0A;
	Tue, 30 Jul 2024 16:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356018;
	bh=G8sGy22I+Epb4tSUHpDmHTzNHOLPPkK8ynBdRtLwmgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8tSodAsJqt67pdAZv4576y5g+Gam0yk8uIca7rHShyZ9ZY94jTuNghNwAtrQSMvP
	 +6oi+tgJCKHnaM4RyvnHm7c8Gc+mATI07CUu2Xf4nxXByUnl0K2QqaVpSpZPqgZuP1
	 naRQfhF4k54MpP0uEeRxBxR87k6LnSnVHYQyCYMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 109/809] soc: mediatek: mtk-mutex: Add MDP_TCC0 mod to MT8188 mutex table
Date: Tue, 30 Jul 2024 17:39:45 +0200
Message-ID: <20240730151728.928992535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 161ee1eb9ab2440553dac55ada8329de704b1ffd ]

MT8188's MDP3 is able to use MDP_TCC0, this mutex_mod bit does
actually exist and it's the same as MT8195: add it to the table.

Fixes: 26bb17dae6fa ("soc: mediatek: mtk-mutex: Add support for MT8188 VPPSYS")
Reviewed-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20240619103034.110377-1-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-mutex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/mediatek/mtk-mutex.c b/drivers/soc/mediatek/mtk-mutex.c
index b5af1fb5847ea..01b129caf1eb2 100644
--- a/drivers/soc/mediatek/mtk-mutex.c
+++ b/drivers/soc/mediatek/mtk-mutex.c
@@ -524,6 +524,7 @@ static const unsigned int mt8188_mdp_mutex_table_mod[MUTEX_MOD_IDX_MAX] = {
 	[MUTEX_MOD_IDX_MDP_PAD0] = MT8195_MUTEX_MOD_MDP_PAD0,
 	[MUTEX_MOD_IDX_MDP_PAD2] = MT8195_MUTEX_MOD_MDP_PAD2,
 	[MUTEX_MOD_IDX_MDP_PAD3] = MT8195_MUTEX_MOD_MDP_PAD3,
+	[MUTEX_MOD_IDX_MDP_TCC0] = MT8195_MUTEX_MOD_MDP_TCC0,
 	[MUTEX_MOD_IDX_MDP_WROT0] = MT8195_MUTEX_MOD_MDP_WROT0,
 	[MUTEX_MOD_IDX_MDP_WROT2] = MT8195_MUTEX_MOD_MDP_WROT2,
 	[MUTEX_MOD_IDX_MDP_WROT3] = MT8195_MUTEX_MOD_MDP_WROT3,
-- 
2.43.0



