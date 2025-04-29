Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25238250C15;
	Tue, 29 Apr 2025 17:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947810; cv=none; b=ucEbRIKlxiqC7/4Y7CrDyfhs2IpgYvG7FoIpBP9s4RjN+oDE9JnBukL0XoBW32Gn7h53Kh7NG8rGXoMYbkRsp88jpUSwCU0ldkgWkuWciaVxlRcCGshhCyXNpx4XvJYJ8uKr5b0sqgmycV3XNheSBze4uAeDQIvO0ONr4emwTWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947810; c=relaxed/simple;
	bh=Pnqej/TGd8CeXl3hXA8/yFyJpZXlKM9OgsSm+ZV8reI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/LqyNtJ+dMSngJqaAjurWFNemMx4ruKV9uoNXCn67JLaCrXv2Yjw5m2qDThLJTPyt7bZRxTZlDyyBkGAQGVhdCquPU4exWx4/n3Y6fDRnhcVLQkgHG7+7fg9vy8SSsJ+5uy0dzFmdRLr2U6GuQ3np15VCgIgac7UQAaDOe3xBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANcDy8Vz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANcDy8Vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4171C4CEEA;
	Tue, 29 Apr 2025 17:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947810;
	bh=Pnqej/TGd8CeXl3hXA8/yFyJpZXlKM9OgsSm+ZV8reI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANcDy8VzZE1/bynFOAEsjTA1tIHAiYska9wfuUXU9NvK+aVnAqujPNvY3hLTz24Sb
	 xVVEadbMuEF4M9AppsR9jDtQMw6aCFmyCNIPwbg/VN7OB70H/A4WCxqzKncbhPCsdw
	 duq50d7KumBF/Yikk/7X5r2Er0KKZCTGao1q3yA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/280] scsi: ufs: core: Add NULL check in ufshcd_mcq_compl_pending_transfer()
Date: Tue, 29 Apr 2025 18:40:10 +0200
Message-ID: <20250429161117.932958542@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 08a966a917fe3d92150fa3cc15793ad5e57051eb ]

Add a NULL check for the returned hwq pointer by ufshcd_mcq_req_to_hwq().

This is similar to the fix in commit 74736103fb41 ("scsi: ufs: core: Fix
ufshcd_abort_one racing issue").

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250412195909.315418-1-chenyuan0y@gmail.com
Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 89fc0b5662919..8d4a5b8371b63 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5689,6 +5689,8 @@ static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 			continue;
 
 		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
+		if (!hwq)
+			continue;
 
 		if (force_compl) {
 			ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-- 
2.39.5



