Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441131ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7802C433CA;
	Fri, 21 Jul 2023 18:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965466;
	bh=gkB3REGsF5o97wgZvMRxcjRg28/5XzpN7gib3dDo0Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPyOYNN+07VNbycLSP+Yfvmgy5q1C+ly1UrcaGL+4FgD17T4llU5t5EeP0WfirZuH
	 9n9859gzUIM5bAd8iSgFyErPKNBkZN7zdX8YhdfbJwkC86twUBOJ+BYUKIqYwaZmy2
	 9Qt+GJMynolpr43ptg7cS4f6QD8TRmG8B4dwsHIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.4 283/292] scsi: qla2xxx: Fix buffer overrun
Date: Fri, 21 Jul 2023 18:06:32 +0200
Message-ID: <20230721160541.125804754@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Quinn Tran <qutran@marvell.com>

commit b68710a8094fdffe8dd4f7a82c82649f479bb453 upstream.

Klocwork warning: Buffer Overflow - Array Index Out of Bounds

Driver uses fc_els_flogi to calculate size of buffer.  The actual buffer is
nested inside of fc_els_flogi which is smaller.

Replace structure name to allow proper size calculation.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230607113843.37185-6-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5549,7 +5549,7 @@ static void qla_get_login_template(scsi_
 	__be32 *q;
 
 	memset(ha->init_cb, 0, ha->init_cb_size);
-	sz = min_t(int, sizeof(struct fc_els_flogi), ha->init_cb_size);
+	sz = min_t(int, sizeof(struct fc_els_csp), ha->init_cb_size);
 	rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
 					    ha->init_cb, sz);
 	if (rval != QLA_SUCCESS) {


