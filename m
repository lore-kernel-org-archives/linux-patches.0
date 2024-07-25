Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111E819CD17;
	Thu, 25 Jul 2024 14:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918524; cv=none; b=X3U/TMc1pcyadqN+7VkutCHZ2YAp2zWCEOGQLEAJqFLggG0Xa7hIMg5qGLloB6gHCfFeBcqWAx1RxQYMKnCY4twL/dTt3devbvphSNBMPrxEJM35EdbGWtLYyWMtB4cIqcTUS6un+xTBhVrIcnk4gcD9YcVZDwPYCqmnqsjt0As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918524; c=relaxed/simple;
	bh=ErosN4zbN64cj3WK2a2OH4GYvwON52bFk/vtFi7GwuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYJPj0hH4LWGiUGEFGdHtKpCxSExmidAfITMnThuCPYUYFJrq4fGKWA7Q5nmsC3JNoqJhILmSHOZ5ZPcUDWxnkgWG7tP+Z2pe/2ad9YGLL1PU6C3kmmVCRW2UwPXdaTenJzHIftntk8Kwdd4Y1XfXQiGLp0QbnDIxcCBHxEU4P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbUFTvU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbUFTvU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90243C116B1;
	Thu, 25 Jul 2024 14:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918524;
	bh=ErosN4zbN64cj3WK2a2OH4GYvwON52bFk/vtFi7GwuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbUFTvU+ZEipnprprKpkT+UTNS3GJhVHRhEVu90Cox9Fd7DnSyU0ifzkw9RDFuone
	 a7pvvDFPi6nQxgfpDo4jCSAG626si2GqKLKwZc5i/JKqbFZyTHmiOWhmy+NDzrGwCm
	 bUSteME56pGhGZEgzv8EvSiFaCNmbcMPHiP7Pesc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/43] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Thu, 25 Jul 2024 16:36:26 +0200
Message-ID: <20240725142730.601454506@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 6c3bb589debd763dc4b94803ddf3c13b4fcca776 ]

Zero qed_slowpath_params before use.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240515091101.18754-4-skashyap@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 858058f228191..e0601b5520b78 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3299,6 +3299,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0



