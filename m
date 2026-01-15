Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84893BFE50;
	Thu, 15 Jan 2026 17:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498246; cv=none; b=RwcTSivB8ph5vyaraeyvjVtXXlFZ+E6VL8We0xfwbAkrKIeiVVphTmgGWqDiBFeUl93TC8wy7xcJtCMFbqOXyXVLxpt7HQQ3uAZE7aLzwBmn2zOOS9FcJwSUtTW3hRlVGoDBQB1qIBCx3i/XRqx+jMEQIb+ng8SgaYbx5niOuBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498246; c=relaxed/simple;
	bh=qzTM8dqqpJW8+8SvpXRaats5zHXi9wChbvWbpWNakFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7hOhgMi6wL/SX8IDSwIGZsi8FIJYxT1AD+m9H+Rb4m4w8vYsOXKrRolNAE9bnkM6FJs5ymUa7GX6l7WzlTlCVWdyElm6gofnk+do8POFAyVT/bRctAt72Hc/9Y/J0h8tFhZTuBOX7GihIyGWQdBJeNqLLTX97kB8fRpW/nUmU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVlcdItm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVlcdItm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4C1C116D0;
	Thu, 15 Jan 2026 17:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498246;
	bh=qzTM8dqqpJW8+8SvpXRaats5zHXi9wChbvWbpWNakFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVlcdItmds8VT4TTiJbKYSFmUsWwJDfM9GqRWCF5+Wl0UcJgTi2zNYKM5qQjGQKqg
	 pvBX1v+uq2J5dZauuRTc8qwgOC16CtO4JxszPQGrk+z/gosGzOsCggLEcVh+HiU0ln
	 ecC3fGMiDIR7tc/BS9wTrMXTa+Z+nmq/J56nZbsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 365/554] RDMA/bnxt_re: Fix to use correct page size for PDE table
Date: Thu, 15 Jan 2026 17:47:11 +0100
Message-ID: <20260115164259.438377591@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 3d70e0fb0f289b0c778041c5bb04d099e1aa7c1c ]

In bnxt_qplib_alloc_init_hwq(), while allocating memory for PDE table
driver incorrectly is using the "pg_size" value passed to the function.
Fixed to use the right value 4K. Also, fixed the allocation size for
PBL table.

Fixes: 0c4dcd602817 ("RDMA/bnxt_re: Refactor hardware queue memory allocation")
Signed-off-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20251223131855.145955-1-kalesh-anakkur.purayil@broadcom.com
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 7585d5a55db2..76fbe52a957c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -242,7 +242,7 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 			if (npbl % BIT(MAX_PDL_LVL_SHIFT))
 				npde++;
 			/* Alloc PDE pages */
-			sginfo.pgsize = npde * pg_size;
+			sginfo.pgsize = npde * ROCE_PG_SIZE_4K;
 			sginfo.npages = 1;
 			rc = __alloc_pbl(res, &hwq->pbl[PBL_LVL_0], &sginfo);
 			if (rc)
@@ -250,7 +250,7 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 
 			/* Alloc PBL pages */
 			sginfo.npages = npbl;
-			sginfo.pgsize = PAGE_SIZE;
+			sginfo.pgsize = ROCE_PG_SIZE_4K;
 			rc = __alloc_pbl(res, &hwq->pbl[PBL_LVL_1], &sginfo);
 			if (rc)
 				goto fail;
-- 
2.51.0



