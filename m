Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0348911710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE4AC433C8;
	Mon, 11 Sep 2023 15:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446004;
	bh=kvooBjwJGhsV+k6f/GA9QE4/9h1HcKOQk/ZCFamfymU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=repEoMNjn9FiwqGzwR7r7Hs06FITowXqBC3xgQ+gMl8ifo6iJWGfk6HWbwLYiUO2w
	 3lrmC9naj/rYNoxJ5kr9krmvQSbw4I+pOsvFPkOJx5+fa/zO7F8fBwQ/gM7YxSeUhL
	 NaEHCrnrTxw+W41VMBW0EZYXO+ufKdRxvyG43G3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 549/600] Revert "scsi: qla2xxx: Fix buffer overrun"
Date: Mon, 11 Sep 2023 15:49:42 +0200
Message-ID: <20230911134649.824811536@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit 641671d97b9199f1ba35ccc2222d4b189a6a5de5 upstream.

Revert due to Get PLOGI Template failed.
This reverts commit b68710a8094fdffe8dd4f7a82c82649f479bb453.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230821130045.34850-9-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5571,7 +5571,7 @@ static void qla_get_login_template(scsi_
 	__be32 *q;
 
 	memset(ha->init_cb, 0, ha->init_cb_size);
-	sz = min_t(int, sizeof(struct fc_els_csp), ha->init_cb_size);
+	sz = min_t(int, sizeof(struct fc_els_flogi), ha->init_cb_size);
 	rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
 					    ha->init_cb, sz);
 	if (rval != QLA_SUCCESS) {


