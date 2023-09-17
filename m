Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2BE6FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AADC433C8;
	Sun, 17 Sep 2023 19:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979815;
	bh=cdrEBvqpyUCSjpTzNEQV5yphANDHyXE8A9QLU25yA+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVx0npt5Nkxg63y3oc0chdgEMHxx9czDviQKI2Y1ESbad/tgmoqh1MyVDyFZ1eaPB
	 CnK5DdPOe3SZdGM/pllb/Y8HyyxIhDcJz3iBRAtfe0xFccMnVscbmKEsgmELM26xX2
	 uEH5mTGs8UkrS9UpFE/Kqb5Y2PB0pBTMq+fyvsls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.5 015/285] scsi: qla2xxx: Fix smatch warn for qla_init_iocb_limit()
Date: Sun, 17 Sep 2023 21:10:15 +0200
Message-ID: <20230917191052.148824561@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit b496953dd0444001b12f425ea07d78c1f47e3193 upstream.

Fix indentation for warning reported by smatch:

drivers/scsi/qla2xxx/qla_init.c:4199 qla_init_iocb_limit() warn: inconsistent indenting

Fixes: efa74a62aaa2 ("scsi: qla2xxx: Adjust IOCB resource on qpair create")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230821130045.34850-8-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4203,7 +4203,7 @@ void qla_init_iocb_limit(scsi_qla_host_t
 	u8 i;
 	struct qla_hw_data *ha = vha->hw;
 
-	 __qla_adjust_iocb_limit(ha->base_qpair);
+	__qla_adjust_iocb_limit(ha->base_qpair);
 	ha->base_qpair->fwres.iocbs_used = 0;
 	ha->base_qpair->fwres.exch_used  = 0;
 


