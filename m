Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96191581EB;
	Tue, 23 Jul 2024 18:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759132; cv=none; b=GGNmgK5a69jEe7qxRf1rI/Ma+rVjo7i3hnEGSQugPEwANv0A0vrzv2BjGJY9sAhbSm3gUBKd/rzTqaaAiAQBAAmFLb0bkwHI8FloTk1FoWtFI83a8DGt5z0d+tPy8UYIFj5C3tB5Q9OoR4O7wWN74oEmyFFp300oe1dR2G/Y2dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759132; c=relaxed/simple;
	bh=4FGm1l23MvhjzgzKgf66nQjAEyTen+bycr5SWZjgQiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbnu0ByXiK1G3Yp6mG47O+kE89cshlW+SNRU8kSNzf48l+3wN4Dh1aK8Ue+33Xrp0seEw6S/pIH5eZ9++XyhHv9lkotS89sOv9b/72wzNo2I/0Xuh/q5oVHE/41E0mEbsiGwXGSTI0gKxxCN0MCow0RyY3/z9MDW4GwHuKL7Klw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IX7t+XCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IX7t+XCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02F4C4AF09;
	Tue, 23 Jul 2024 18:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759131;
	bh=4FGm1l23MvhjzgzKgf66nQjAEyTen+bycr5SWZjgQiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IX7t+XCpmocT3HxZ2pqkUiX5ahY+PMebxJb+NV1Zq0CV1+RUajmkWfJhmSbO5R9zX
	 yKirni4DxprD55Qu9Ur8fYSmlCM2qMZnhY5S7qO8qEYWaK/US31eKvMnkJyPN8QIhI
	 0TpSsemsXvKXtuf7QRlJCAFIbzRGdo67KclxodIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/105] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Tue, 23 Jul 2024 20:22:50 +0200
Message-ID: <20240723180403.298709815@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 524807f9f4eb1..179967774cc8c 100644
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



