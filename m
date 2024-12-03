Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1033D1F666F;
	Tue,  3 Dec 2024 14:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236479; cv=none; b=U3blMDczCaLw8WFwhba72FnqgVYt5KZYRXSFqrkBTQSJx2TC//UOHXF0ZFBB5o3NNKOBIM9JaBcYse2csBHDxk18Ygc7Ip+2tbau9efWHXKVF1ME9HHHlR4v2pY+xmEMvE1AD+rBkOMJOJOKB/QvUqk+CfpLrbztC9Yr4Bc3Eas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236479; c=relaxed/simple;
	bh=VBkkYDm1aRzmF1dSwgKuphZxxLqM0mtu5UchqJD/92U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IguYSfPy/EmD5mzT/VdoU5kJfmlMnPGtxgE52JTjdPv9M5KPaiqH9ei6U8wTi+u0SIGa6ARpCCoxg83wXGVl1griYUOrdKoF1FzmY5h2eYpufoNN8kcshztRYpozdNiTPYMEFGZSKXvPkjSQdVU1xu6dBropvYcJV0IuXtvsraE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OedCTkEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OedCTkEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751EFC4CECF;
	Tue,  3 Dec 2024 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236478;
	bh=VBkkYDm1aRzmF1dSwgKuphZxxLqM0mtu5UchqJD/92U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OedCTkECGyyaT85+xa3779hRktNJU70p2PwCiMqN/TvGImUxFFQ7kYTpV/LG33R70
	 21kqut7WOfC8RhSvLB3hsKB9sgH5HObKVaVZUzD88B4j6EvfuWoInfGSVOPnhHN6HI
	 90y4XUKZYW7B4pNStxNhx2bfnayHmwWx0ojUAdoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 006/138] Revert "mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K"
Date: Tue,  3 Dec 2024 15:30:35 +0100
Message-ID: <20241203141923.779882913@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2857,8 +2857,8 @@ static int dw_mci_init_slot(struct dw_mc
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


