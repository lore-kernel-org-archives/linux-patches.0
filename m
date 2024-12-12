Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609F0223C49;
	Thu, 12 Dec 2024 16:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021681; cv=none; b=fjldjB4TsPRrnzeGSWS9shb1BFoJkHUHehP4SIm184bfe9sXJCk4V64leIZtXeIKl80K4Nc0eCaAxK2ugMv4kNJ6nqKmn4TjrhD+I6MufMJQ60RreNFykpfU9UOs8jcHfLqjQFuBLdw4B9dqUEaJRisd0Znbimsi+ZpUG6Y8dDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021681; c=relaxed/simple;
	bh=vpoxC+ggmNCYxL8EYsuotcyoKF6RR2uByX38YYAYqAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFoJ7b1KKbN9UYpalP4FBLEx39hW2omzltFOA3KMuQiL6Y6s2wNbqqJb64Qq+41/FDOcOUusvQ+JQY8wTqIR5NAa59oAm6mWeQd9+DF6/R7XmOpM1amm/sgV92J5HLv8733IgpLJ4FektuUK95uBV+TAdtRUsP/3pYUafd+0fck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Loal4bPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Loal4bPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BF8C4CECE;
	Thu, 12 Dec 2024 16:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021681;
	bh=vpoxC+ggmNCYxL8EYsuotcyoKF6RR2uByX38YYAYqAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Loal4bPbneKjsLnI/M/P4TW19BQYeCZ2jN2x1DIgyuGlY9J4O/jit1sBNX0RF4+8q
	 LmmtBbWl0ZVxT/sm4XlWep4kEFtzbSd+0Q4Au6SL1T53yuxaVL7afgXh+zMko8FVX9
	 +a1U53NkjVeIW48oIplArz+ihaeZ6YZKjDfHws+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 033/565] Revert "mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K"
Date: Thu, 12 Dec 2024 15:53:48 +0100
Message-ID: <20241212144312.759098932@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

commit 1635e407a4a64d08a8517ac59ca14ad4fc785e75 upstream.

The commit 8396c793ffdf ("mmc: dw_mmc: Fix IDMAC operation with pages
bigger than 4K") increased the max_req_size, even for 4K pages, causing
various issues:
- Panic booting the kernel/rootfs from an SD card on Rockchip RK3566
- Panic booting the kernel/rootfs from an SD card on StarFive JH7100
- "swiotlb buffer is full" and data corruption on StarFive JH7110

At this stage no fix have been found, so it's probably better to just
revert the change.

This reverts commit 8396c793ffdf28bb8aee7cfe0891080f8cab7890.

Cc: stable@vger.kernel.org
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Fixes: 8396c793ffdf ("mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K")
Closes: https://lore.kernel.org/linux-mmc/614692b4-1dbe-31b8-a34d-cb6db1909bb7@w6rz.net/
Closes: https://lore.kernel.org/linux-mmc/CAC8uq=Ppnmv98mpa1CrWLawWoPnu5abtU69v-=G-P7ysATQ2Pw@mail.gmail.com/
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Message-ID: <20241110114700.622372-1-aurelien@aurel32.net>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2903,8 +2903,8 @@ static int dw_mci_init_slot(struct dw_mc
 	if (host->use_dma == TRANS_MODE_IDMAC) {
 		mmc->max_segs = host->ring_size;
 		mmc->max_blk_size = 65535;
-		mmc->max_req_size = DW_MCI_DESC_DATA_LENGTH * host->ring_size;
-		mmc->max_seg_size = mmc->max_req_size;
+		mmc->max_seg_size = 0x1000;
+		mmc->max_req_size = mmc->max_seg_size * host->ring_size;
 		mmc->max_blk_count = mmc->max_req_size / 512;
 	} else if (host->use_dma == TRANS_MODE_EDMAC) {
 		mmc->max_segs = 64;


