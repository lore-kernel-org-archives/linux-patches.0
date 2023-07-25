Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5245F1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C842AC433C7;
	Tue, 25 Jul 2023 11:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285629;
	bh=FsBQwe/LR40mZejpYDDJio1rA/pEEYK/3D7+3ulprLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zb6VWTazUYhmeI5Hksg48rhYLaupcNv6g+DMm6no2VAsXb+pDSB3unMz5Zled3XkQ
	 9jW0fgq8BC9j8NH9V2rbCKmemldLt6/daLsMObpyCYLR1RDqNkgSfGYmTaFJuB43Id
	 g4h9k0d2VL/r60EmQEg73Ygvurtxs58107CsInIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 273/313] scsi: qla2xxx: Pointer may be dereferenced
Date: Tue, 25 Jul 2023 12:47:06 +0200
Message-ID: <20230725104532.879511096@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shreyas Deodhar <sdeodhar@marvell.com>

commit 00eca15319d9ce8c31cdf22f32a3467775423df4 upstream.

Klocwork tool reported pointer 'rport' returned from call to function
fc_bsg_to_rport() may be NULL and will be dereferenced.

Add a fix to validate rport before dereferencing.

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230607113843.37185-7-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2530,6 +2530,8 @@ qla24xx_bsg_request(struct bsg_job *bsg_
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = fc_bsg_to_rport(bsg_job);
+		if (!rport)
+			return ret;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
 	} else {


