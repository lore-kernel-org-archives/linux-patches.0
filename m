Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD5615821A;
	Tue, 23 Jul 2024 18:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759493; cv=none; b=KwfeX/a62FwCJibyEvz18eU0tAtTlySYu+r9cGyX6xDnD1xSCsJFZggSqO1//pulXlWbcfTMnHy0QY4XvvI5eOPQ/W5Rrp5b/B2f8fjbBiWQct4sPDm+l50s7EAi3CGp5IzY8SrXFLk6f9ml5TvXuNcV30IxRhQulnbCh+yYL5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759493; c=relaxed/simple;
	bh=vUm0/LHETCMxftIRv+0OT0FEkH32E8OZITNhxTewvNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKnVok/wE4MaF6wv9aO4bD/Xb+nPOjA2cHP4jiDLjdpj+37f22jjVHBruEMJIFbF+kAJLNPpYK8UBPnghZSCzYyPYjC/JoGYyjx0gsLvdjW9D5Hg79rZaKZUUO/mDfBlkQIsCXTGldwyiIdcDvZpPbyC+80cmRt1pWZXZiLpHEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCYxqrC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCYxqrC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7255FC4AF0A;
	Tue, 23 Jul 2024 18:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759491;
	bh=vUm0/LHETCMxftIRv+0OT0FEkH32E8OZITNhxTewvNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCYxqrC5DxyA9Tt+KX9Mav4fjWYP4iMlGC6F2vP8zJ1/mT3h2ij6fIkHXwNJJK+nM
	 ORD9erPwYrwcRRm8cgtbjU7FnfPzLTJaZaPqyQgFF/SN28vWBwRkfa3XuryN/xDXdk
	 Dgrr0qKaHa+nMd5RS3Mp7kEiCfAz/vjNEU458QWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/129] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Tue, 23 Jul 2024 20:22:34 +0200
Message-ID: <20240723180405.021365096@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c97e129194f78..14625e6bc8824 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3472,6 +3472,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0



