Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CD815884E;
	Tue, 23 Jul 2024 18:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759902; cv=none; b=CdmyhlKgLT7BUJ/4iP0Le9xAMDRQJfi2EkeogromRPoXm8zUVQ1lucpi0bd+v0bfPQZiWYioElmUKJcmBk+6MZ+VjI3JGJ4+rxAXhHU85Z2Xfv3spAOXJKSGOgZ/cYId81QUbBPjPopzXsaaMPWRuAqzSt6mG1w3nSpCae21Sas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759902; c=relaxed/simple;
	bh=CRDGgyPudSAIMwgfVajwGRFNPS3Xzd0hkah23s3J6Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wiy8193fjTvI6j660TSPlKOnVW/beI2fxa+YCxx4E6QK/zoh3Rw1SSlwL0gDE6CmyY6y83XqIqu71yTfqTVAWr7ZEsJmwYPMq1vwYQwAdsHjA+3v1qZextO+/Y2nHZm8j5iI8pY2QugFylH58vSH+7ycUlE9e+F3ieJW6O/If2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8d7GIbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8d7GIbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7415BC4AF0B;
	Tue, 23 Jul 2024 18:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759901;
	bh=CRDGgyPudSAIMwgfVajwGRFNPS3Xzd0hkah23s3J6Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8d7GIbBSVkUiD6Ukp6dHdLMHX7KEAm+Bb0qDcF7Y9ozkZcFe5jjQvfZ9P15X6Kq0
	 ajXXOWAcJEgFVMHyzrer2CvKQz26PoyPunyyi475LSeeMdj+WrHhCEPuTMyi1VeON2
	 +4AzNuNN5eiMZzBf9SoRupoc40SVFhWeLJujAmaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 006/163] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Tue, 23 Jul 2024 20:22:15 +0200
Message-ID: <20240723180143.711461499@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index c98cc666e3e9c..b97a8712d3f66 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3473,6 +3473,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0



