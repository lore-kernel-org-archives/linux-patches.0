Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7D28468;
	Thu, 25 Jul 2024 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919055; cv=none; b=M9GgLyVRysrzcyktdF3O2ueLgRDzKINC1p0r+5gbNybLk3gM7uVfLADhMEvJ4ASSk5+PW3dF2ESiM7Qg8tzA6wUmDSCNPlTFNWetP/uPHjtuztvzGC1B/XTx6weDAtzfPFrf4gWidG6BQlV7tmQV8JqZk9ECE6yirsAbVI2mJm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919055; c=relaxed/simple;
	bh=KWe1F7qyXB3UAyx9OD1fX7jhZ67AvcySCq8gHAaJrKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCbjKKgDtmjmlnk3R1awrWt10FdkYcJNjQrSwZfnj5P93HqwO1g/Wh9/kcounXbdZCRaBvsrNqnT0b6bvhzuU4dh6PFa2V7UjkLflicKN0qfsIKvMJq+3EDpKIuBNEpXSZi7FkzX9O3QywmFxs+QP9BaGkC8i+lTnkfYiQwf8OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3V/Ot/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3V/Ot/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0B7C116B1;
	Thu, 25 Jul 2024 14:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919055;
	bh=KWe1F7qyXB3UAyx9OD1fX7jhZ67AvcySCq8gHAaJrKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3V/Ot/+0zUXniHu3CGrReTZj1i7QXwMSJQo43OYeJIrH4Lp/aRJE6z8lvIPZ0stX
	 czy88m4RnWhHKfbNVyx/1fPs4kPqg0K54mHezQehnEJq9Ng0R3O+/7dQk1PLhv1ibc
	 WW1JLNVcIjffsBdT0AworTzq6JGnffXw5Kq1lgGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/87] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Thu, 25 Jul 2024 16:36:43 +0200
Message-ID: <20240725142738.818530430@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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
index 1900acfee88ed..690d3464f8766 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3477,6 +3477,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0



