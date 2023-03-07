Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085DEBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61729C433EF;
	Tue,  7 Mar 2023 18:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213453;
	bh=LshO+HO0q+wl6AI7aR1FOixDz6EAcGqKOhfdtHq9Gm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbypiWIcEIx4ab0yYW/xCaB1fOd85+kud22+99wb08Cvxudh2yDOiWRCSaG8ruQnE
	 KqcoDP0coqbJ+/rF7CZZQpCtl1m+muxDoFfZcEYufDJxaj5UAZ0oLN/b+Jfrll8kOZ
	 aKfvczPqHf+WLSTjbmN66inz4mmeoUAHnd65qz8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 512/885] media: platform: mtk-mdp3: remove unused VIDEO_MEDIATEK_VPU config
Date: Tue,  7 Mar 2023 17:57:26 +0100
Message-Id: <20230307170024.728407149@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moudy Ho <moudy.ho@mediatek.com>

[ Upstream commit 9195a860ef0a384d2ca2065cc61a0cc80d620de5 ]

Since REMOTEPROC completely replaces the VIDEO_MEDIATEK_VPU in MDP3,
unused config should be removed to avoid compilation warnings
reported on i386 or x86_64.

Warning messages:
    WARNING: unmet direct dependencies detected for VIDEO_MEDIATEK_VPU
          Depends on [n]: MEDIA_SUPPORT [=y] && MEDIA_PLATFORM_SUPPORT [=y]
        && MEDIA_PLATFORM_DRIVERS [=y] && V4L_MEM2MEM_DRIVERS [=n] &&
        VIDEO_DEV [=y] && (ARCH_MEDIATEK || COMPILE_TEST [=y])
          Selected by [y]:
          - VIDEO_MEDIATEK_MDP3 [=y] && MEDIA_SUPPORT [=y] &&
        MEDIA_PLATFORM_SUPPORT [=y] && MEDIA_PLATFORM_DRIVERS [=y] &&
        (MTK_IOMMU [=n] || COMPILE_TEST [=y]) && VIDEO_DEV [=y] &&
        (ARCH_MEDIATEK || COMPILE_TEST [=y]) && HAS_DMA [=y] && REMOTEPROC
        [=y]

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Signed-off-by: Moudy Ho <moudy.ho@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: e3f7feb6d893 ("media: platform: mtk-mdp3: fix Kconfig dependencies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/mdp3/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/mdp3/Kconfig b/drivers/media/platform/mediatek/mdp3/Kconfig
index 50ae07b75b5f2..846e759a8f6a9 100644
--- a/drivers/media/platform/mediatek/mdp3/Kconfig
+++ b/drivers/media/platform/mediatek/mdp3/Kconfig
@@ -9,7 +9,6 @@ config VIDEO_MEDIATEK_MDP3
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select MTK_MMSYS
-	select VIDEO_MEDIATEK_VPU
 	select MTK_CMDQ
 	select MTK_SCP
 	default n
-- 
2.39.2



