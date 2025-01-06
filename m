Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49111C5F11;
	Mon,  6 Jan 2025 15:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177324; cv=none; b=PelrsS3qu4u+nUWoyH2czFCoN2BeeDmwyNUeF1tKp5AFpacEnRwSf7Ev5rfFGtgrMPtQCluVaUsz/R/Ld1g6qbE6SUb/iYYPxR5LzAn5VOza9/s8WxW3Oc7rzhrl5xLVd8KNb9ZLBytL5OaTNEHdg3bry7LDivdwaSIzrVTEux0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177324; c=relaxed/simple;
	bh=hsu5u7xJ2CytjLETgs+My/ziKWQjBOKYSGLVGujzeM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzKFAUzJj42CPDfsHBGNqeIO3J0s1pjSI+MqBroqmy6pn8/uNb30mXkcH3j2Oj+b8GjseZtTlQtO41zAw8AzkNfG05zqsnu9ItOguVrn/oe1CvnnqyDy+HAISsXb2sFyPPAVvDEdEfjE6bcRvh+nzqoOkauArYYC0rcWb0TYqCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHSXH0xq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHSXH0xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C4CC4CED2;
	Mon,  6 Jan 2025 15:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177323;
	bh=hsu5u7xJ2CytjLETgs+My/ziKWQjBOKYSGLVGujzeM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHSXH0xqQkHU8sgBvve/Th30kXmyzfdCmPIVAsuNiMOaqLJwuXdnb9Q7/eTfdYto3
	 qtFLP+ihulMQU2CP+LM+zlTzL6AJlsfXQETFFF8IxBAGeIvqGYHyvZgZYaVBw7oFTS
	 KhR8PUoRoJlHzw8oS+Qzt2nDXC+Kx2c99O/zZ0Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/222] scsi: mpi3mr: Start controller indexing from 0
Date: Mon,  6 Jan 2025 16:14:58 +0100
Message-ID: <20250106151154.154856055@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 0d32014f1e3e7a7adf1583c45387f26b9bb3a49d ]

Instead of displaying the controller index starting from '1' make the
driver display the controller index starting from '0'.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110194405.10108-4-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 3f86f1d0a9be..7880675a68db 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5066,7 +5066,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	mrioc = shost_priv(shost);
-	retval = ida_alloc_range(&mrioc_ida, 1, U8_MAX, GFP_KERNEL);
+	retval = ida_alloc_range(&mrioc_ida, 0, U8_MAX, GFP_KERNEL);
 	if (retval < 0)
 		goto id_alloc_failed;
 	mrioc->id = (u8)retval;
-- 
2.39.5



