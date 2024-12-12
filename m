Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03C92358A4;
	Thu, 12 Dec 2024 16:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022500; cv=none; b=uPsOpjpPPjorGyLVC/yoHU7AahR1WWS7VOdhTPtzQMviqiyOvdAc9moI04Im5RDGJV/Fbp388Cdnkf3VM+GlZGrymitYS6NSX8Wnbl53es+pbn4Qo40flrurOlig6eULbQqXQj3AMGoXgP2NILZ6WcwXt/arXuM5AUKlMvwcZ/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022500; c=relaxed/simple;
	bh=fbCblDGm96sPLwoU3BDKFhOciotNZxvt3D9g96Yd+jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cx8tCrhhtefC9eVn2r/1DwfokujRuz+aMyuOiqkG3Uf09dpPnNhy145f5Np8ys4dViKHD6tRA0WIxrT2Ec7cwd2loudIQEszEcidEVSNYmpeT1NF323gflbAHFctMx9V9ChYR53mxXPKRAUirohk+lvoznPWBTH1HNYYqDpvKJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIxuPHwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIxuPHwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322CDC4CECE;
	Thu, 12 Dec 2024 16:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022500;
	bh=fbCblDGm96sPLwoU3BDKFhOciotNZxvt3D9g96Yd+jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIxuPHwai/yXmaHAfiqkD57urdNIZujgPG9bUBmtPlHHSMwSMOQgIv2afTcyMroi7
	 xafrRDMWZvFhLcyyjasCdMC1en6t+0p46ejO8OUNMTT5viu/xPNsczCpxP1NTvc7bq
	 w4jWC5lOqtOZNBSBI5UtvwMfr7OkOtvIk+Nz8ZqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/565] scsi: fusion: Remove unused variable rc
Date: Thu, 12 Dec 2024 15:57:02 +0100
Message-ID: <20241212144320.460465908@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 85285ba8e8179..3241e998b2360 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4232,10 +4232,8 @@ mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 phys_disk_num,
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



