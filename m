Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021E51F8ACC;
	Thu, 12 Dec 2024 16:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019563; cv=none; b=EBpNzQ+RcbKD6++jizXDqXIpVhrIa0o3vQ6hl4Dg0Pnzfo56sY5lomFUDOc7KWTWCIrtv9k3SCNMAWz+ztOc87vhYq9CDUl5l2vO8YWu3BGj20EE2VRt7ZSzYoPvvHhrgDdwIofdAxhpC8q8itaC1/YuC/vi07B7Pdj/Y2untx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019563; c=relaxed/simple;
	bh=Ow49ahcFM7fqDe7EKzh0IbYzLDOq6ZC0WIxcIaeLHlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mi7Khrq9RJP4qYOigwykbGf/Sjmk21rf6TpuyctQrQmDORSDRkIToA8Xr1Xj8wvyS3LcaxJoWiQ2fLnTeL0Geh6yIQlUMBNaMEEk0tIZBIDkuR3NKCngmEik20ZCTQ88KL4WLr9bmDpamkaLvu7K0gGm/sCXdg0rgPBQeAWeppw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4V/dUKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4V/dUKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1A4C4CECE;
	Thu, 12 Dec 2024 16:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019562;
	bh=Ow49ahcFM7fqDe7EKzh0IbYzLDOq6ZC0WIxcIaeLHlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4V/dUKnlCR1EvPuep4K00UbxSSRlb1r51wWIwRCgR2N7j5iWnVQuJQSq7neVh+Em
	 PE0F8hf6BrB4xlMxpp//Dgg51zPGpDwJhJqrfbn2S2eLRpDoWbosWFlUwhxGGjs+e6
	 t5dLKL/coJPSyqc2lQe8cGgL2aWln5x2hokyslrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 240/772] scsi: fusion: Remove unused variable rc
Date: Thu, 12 Dec 2024 15:53:05 +0100
Message-ID: <20241212144359.831302967@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit bd65694223f7ad11c790ab63ad1af87a771192ee ]

The return value of scsi_device_reprobe() is currently ignored in
_scsih_reprobe_lun(). Fixing the calling code to deal with the potential
error is non-trivial, so for now just WARN_ON().

The handling of scsi_device_reprobe()'s return value refers to
_scsih_reprobe_lun() and the following link:

https://lore.kernel.org/all/094fdbf57487af4f395238c0525b2a560c8f68f0.1469766027.git.calvinowens@fb.com/

Fixes: f99be43b3024 ("[SCSI] fusion: power pc and miscellaneous bug fixs")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Link: https://lore.kernel.org/r/20241024084417.154655-1-zengheng4@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/message/fusion/mptsas.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 34901bcd1ce81..452774cf40cb6 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4234,10 +4234,8 @@ mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 phys_disk_num,
 static void
 mptsas_reprobe_lun(struct scsi_device *sdev, void *data)
 {
-	int rc;
-
 	sdev->no_uld_attach = data ? 1 : 0;
-	rc = scsi_device_reprobe(sdev);
+	WARN_ON(scsi_device_reprobe(sdev));
 }
 
 static void
-- 
2.43.0



