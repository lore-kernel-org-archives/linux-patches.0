Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953A620F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16875C433C8;
	Fri, 21 Jul 2023 19:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967577;
	bh=XvClX4yZTvnZ9ZOLA6zltWsGWlPvEwqF3CPqWjyqBqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0PZVqCbW1v9J8J4NWFrHAiwoiW1VghonSIcS5vnmzve09OYqJbNy8YoDTi/lRIQm
	 Uor3ZKlr9hjX5iZn5MMhQO0mXHSUF+SoO7+sFFAPpw2Lo/lHVgUkTOc39LttL7sCUL
	 9y8ckXwGHk0r+d4cRkG0ECg0L5sSGaJODGvAuwOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 212/223] scsi: qla2xxx: Avoid fcport pointer dereference
Date: Fri, 21 Jul 2023 18:07:45 +0200
Message-ID: <20230721160529.910035184@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nilesh Javali <njavali@marvell.com>

commit 6b504d06976fe4a61cc05dedc68b84fadb397f77 upstream.

Klocwork reported warning of NULL pointer may be dereferenced.  The routine
exits when sa_ctl is NULL and fcport is allocated after the exit call thus
causing NULL fcport pointer to dereference at the time of exit.

To avoid fcport pointer dereference, exit the routine when sa_ctl is NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230607113843.37185-4-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_edif.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2319,8 +2319,8 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_h
 	if (!sa_ctl) {
 		ql_dbg(ql_dbg_edif, vha, 0x70e6,
 		    "sa_ctl allocation failed\n");
-		rval =  -ENOMEM;
-		goto done;
+		rval = -ENOMEM;
+		return rval;
 	}
 
 	fcport = sa_ctl->fcport;


