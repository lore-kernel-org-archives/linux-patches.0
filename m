Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC761547F3;
	Mon,  6 Jan 2025 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177686; cv=none; b=XVcwlqGthr+yaAY+hLS0AZaQN8q01R79pJsc2Qa4wTxZ1M/4Hi7akw/gnFAdUJ+gANf0kPezH1bUtAA8GP5GamhDQQketz/Nm6gOfAJbGJ2ta0YQreFXaojCT0yDnpcsTpjp42FksERWhjUwJT02jrQSmmVN7GqIYgPJhgSV9aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177686; c=relaxed/simple;
	bh=3m0VBCd4DRESMdz94S7evKb/sJ/34+JtalIDvaYw3m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeuNzFw9ynxIjAEiy8hRVI27tLElk5LlSkOzIHEdrwCatBS3kYfkcLEQgDw25B+47G/bvp0NNcgwWXTERCSvU07oSP28dHKRA2xyRN1iXHacR5tpulYfAJQWgLJcs9X7vS/CNExYM8llcdQELaeGTxjpdfQHP3rCU5dSeQvcbvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0sg+OV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0sg+OV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BB8C4CED2;
	Mon,  6 Jan 2025 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177686;
	bh=3m0VBCd4DRESMdz94S7evKb/sJ/34+JtalIDvaYw3m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0sg+OV/C7XQyUjn4nEyF9oy7Bl7eBytyAgcwd2E+X3Xp6Yc66KfwfPLOIOxk+X9P
	 ztqYvhTdMn3ZaRBpGHNUZ5V8SKhUF+2sT+wteRbC5JglYHvoaXSyYMcJBNPHTGI2br
	 gSt0ZHkmmewb675Le/r5GMXuNdv49HstyZ2tYs7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Preethi G <preethi.gurusiddalingeswaraswamy@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/156] RDMA/bnxt_re: Fix reporting hw_ver in query_device
Date: Mon,  6 Jan 2025 16:15:09 +0100
Message-ID: <20250106151142.615850329@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 7179fe0074a3c962e43a9e51169304c4911989ed ]

Driver currently populates subsystem_device id in the
"hw_ver" field of ib_attr structure in query_device.

Updated to populate PCI revision ID.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Reviewed-by: Preethi G <preethi.gurusiddalingeswaraswamy@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241211083931.968831-6-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index a4134a288077..b20cffcc3e7d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -156,7 +156,7 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 
 	ib_attr->vendor_id = rdev->en_dev->pdev->vendor;
 	ib_attr->vendor_part_id = rdev->en_dev->pdev->device;
-	ib_attr->hw_ver = rdev->en_dev->pdev->subsystem_device;
+	ib_attr->hw_ver = rdev->en_dev->pdev->revision;
 	ib_attr->max_qp = dev_attr->max_qp;
 	ib_attr->max_qp_wr = dev_attr->max_qp_wqes;
 	ib_attr->device_cap_flags =
-- 
2.39.5



