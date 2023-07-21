Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DB620F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4848EC433C8;
	Fri, 21 Jul 2023 19:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966963;
	bh=w6iWPnh/1Xbuu1/r8j3Ks4DZgcoMTO+xXfF5PLtY0p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sqfuo2Jn4OoM5/QfD4P/97vvpCs4sCOYnCXiakZD5fgdMdDzkdOUy0dJkHCR9iRM2
	 VRKaodMn+xfqFwaEj1J9mX8h37CzjNz+cEvEF9IbBLG2A7sI2Gcq/6ch68+MNYlFA8
	 oICzPH8OQkygFnL9MSYkERWzp+GyP711/TIA/Z98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 529/532] scsi: qla2xxx: Pointer may be dereferenced
Date: Fri, 21 Jul 2023 18:07:13 +0200
Message-ID: <20230721160643.320930652@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
@@ -2903,6 +2903,8 @@ qla24xx_bsg_request(struct bsg_job *bsg_
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = fc_bsg_to_rport(bsg_job);
+		if (!rport)
+			return ret;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
 	} else {


