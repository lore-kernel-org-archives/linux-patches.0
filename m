Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1C77461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C13C433C7;
	Sun, 17 Sep 2023 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980818;
	bh=/muYivB32C3VPQHy5jwEFGCS5vK7WmGUiaY9T/F6vRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sm0871r+KG9RTYYf6JZDqb46Zn2INV0iH0pIc2++TdpaZgAH8fupqZvI9TACN60O1
	 aHwU3PamBnFNcAFbXri5NmKgS2ejjRla/6e2yeH5U8JkW1k359Solrr0VC55fVcTtw
	 uuku/5h8k4fox6j3DqBs4kOBLB+/XfetFYj3+NAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 017/219] scsi: qla2xxx: Turn off noisy message log
Date: Sun, 17 Sep 2023 21:12:24 +0200
Message-ID: <20230917191041.603493329@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

commit 8ebaa45163a3fedc885c1dc7d43ea987a2f00a06 upstream.

Some consider noisy log as test failure.  Turn off noisy message log.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230714070104.40052-8-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -664,7 +664,7 @@ static int qla_nvme_post_cmd(struct nvme
 
 	rval = qla2x00_start_nvme_mq(sp);
 	if (rval != QLA_SUCCESS) {
-		ql_log(ql_log_warn, vha, 0x212d,
+		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x212d,
 		    "qla2x00_start_nvme_mq failed = %d\n", rval);
 		sp->priv = NULL;
 		priv->sp = NULL;


