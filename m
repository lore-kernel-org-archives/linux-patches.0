Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11036FA4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41265C433C8;
	Sun, 17 Sep 2023 19:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979078;
	bh=kD7D9ArMiE/oft0ZoRUzTEBKdBqBUhK7s66gG8dXOho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vn1DW6DGJ4RcJdw4Ut1faqUBs/BjYHUB+aOpbkJlVD5Z4A5hDTQ7yN+CyxD8LwCgt
	 CwVufteCm9QyBW+Wh963kpASj6Y117bB7hinQyqB4HIfcRhDeUqjYexkO+7Q1AaY2d
	 feql9pjuX638aWv1Mv/ayTDO8dDBODPfZKoaN4+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Jiaxing <luojiaxing@huawei.com>,
	John Garry <john.garry@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/406] scsi: hisi_sas: Print SAS address for v3 hw erroneous completion print
Date: Sun, 17 Sep 2023 21:11:02 +0200
Message-ID: <20230917191106.680918938@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

From: Luo Jiaxing <luojiaxing@huawei.com>

[ Upstream commit 4da0b7f6fac331f2d2336df3ca88a335f545b4dc ]

To help debugging efforts, print the device SAS address for v3 hw erroneous
completion log.

Here is an example print:

hisi_sas_v3_hw 0000:b4:02.0: erroneous completion iptt=2193 task=000000002b0c13f8 dev id=17 addr=570fd45f9d17b001

Link: https://lore.kernel.org/r/1617709711-195853-3-git-send-email-john.garry@huawei.com
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: f5393a5602ca ("scsi: hisi_sas: Fix normally completed I/O analysed as failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 65971bd80186b..e025855609336 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2240,8 +2240,9 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 
 		slot_err_v3_hw(hisi_hba, task, slot);
 		if (ts->stat != SAS_DATA_UNDERRUN)
-			dev_info(dev, "erroneous completion iptt=%d task=%pK dev id=%d CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
+			dev_info(dev, "erroneous completion iptt=%d task=%pK dev id=%d addr=%016llx CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
 				 slot->idx, task, sas_dev->device_id,
+				 SAS_ADDR(device->sas_addr),
 				 dw0, dw1, complete_hdr->act, dw3,
 				 error_info[0], error_info[1],
 				 error_info[2], error_info[3]);
-- 
2.40.1



