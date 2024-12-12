Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A247205501;
	Thu, 12 Dec 2024 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024076; cv=none; b=ZXd5cHB2yqJy+NF1Pe4eWvnnqd2o+7KqnGatoJbee1T7/teLe9S53jiSGlAb9bPBEqNz8/o85nBtmK4y4XzK8m3KM7DUAdt28StSdVdVnL2AZ2oENHEe0SQDHIQXGTonbgmxL4jkgb413W/zZ3OQQT0R7S0BAp6BmFeBBAdGvns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024076; c=relaxed/simple;
	bh=wq3U8CEZeoyrfazSPJI6mwuiDuNHEEg2GNC+P7lkflQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8ftGKQiy0wDkfHxJ05ieKueZuIzRra0SsjbyEc/tiBT4i9ocdtudePrDtFvM5iys9iCwisvCwIwvpFHRQsC5nFLHhovQ+Zd6adZH/K5FLbh9W8IIZrKYOTAuEmeVZtBfFvNAeAeBg19qvCJo+OapLb1Io0xfSnSdy+T+DXCiAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzJtlwOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzJtlwOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B414C4CECE;
	Thu, 12 Dec 2024 17:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024075;
	bh=wq3U8CEZeoyrfazSPJI6mwuiDuNHEEg2GNC+P7lkflQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzJtlwOCc//Yv6naFEEVV25V2bJdKt6NL7NMj4qMoiRNFfkERaAVirIQbsUautmXb
	 2988JMZ++imr/B9vICde3WgvpBMA8xzZ1uY+ecWaXejg78lg9SUNOhgMHm9G8Nlwpo
	 n0lInrLWszqVd+h3moSFvooeMMJtwB3CpvClvfT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/459] scsi: fusion: Remove unused variable rc
Date: Thu, 12 Dec 2024 15:58:35 +0100
Message-ID: <20241212144300.515591452@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 18b91ea1a353f..e56e96671da99 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4205,10 +4205,8 @@ mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 phys_disk_num,
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



