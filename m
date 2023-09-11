Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F51A11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1690C433C9;
	Mon, 11 Sep 2023 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444372;
	bh=VqJwHl95cPbEKie0uiibHg5QP8Wo1lpzwjzb27+11uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q47eXek21q2HjmL3dBnqeLCS9klPFawmEkvEgipEZalI25iDAoPGuCpLfyM9wBRkN
	 4h2GDl6J+LHBKgXdMVyX1rmk350/MKLSGjc9/3JsnByRq8H3iKpgt2oHlqD0ClC72n
	 mW5RtAuprMz4yusPaVgERmBhgQ2v92w20x2gB4wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.4 677/737] Revert "scsi: qla2xxx: Fix buffer overrun"
Date: Mon, 11 Sep 2023 15:48:56 +0200
Message-ID: <20230911134709.449313786@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5549,7 +5549,7 @@ static void qla_get_login_template(scsi_
 	__be32 *q;
 
 	memset(ha->init_cb, 0, ha->init_cb_size);
-	sz = min_t(int, sizeof(struct fc_els_csp), ha->init_cb_size);
+	sz = min_t(int, sizeof(struct fc_els_flogi), ha->init_cb_size);
 	rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
 					    ha->init_cb, sz);
 	if (rval != QLA_SUCCESS) {


