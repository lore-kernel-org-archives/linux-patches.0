Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7DD6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5A2C433CC;
	Sun, 17 Sep 2023 20:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980940;
	bh=97eQxU2/CPhj49e/Ihl5fJxv5iqhT8EYavOOSrb1zkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5Zmf6YRJbItx0b0a+PHwGg9yXtpwVd82EqpOoz7FCEaZNkdJeAGPlkZkpQIl10EJ
	 BOG16Zo3nyfPiYPlAnwucYwKVq2PqkDR8HpQ2gPQQ3rHdbg+dXJnnCr5CAshpEAl1i
	 JzVjdtWIDR6HaNOrMsfwZZ7yqu9YRxzsoSuJY+WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 023/219] scsi: qla2xxx: Error code did not return to upper layer
Date: Sun, 17 Sep 2023 21:12:30 +0200
Message-ID: <20230917191041.832254254@linuxfoundation.org>
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

commit 0ba0b018f94525a6b32f5930f980ce9b62b72e6f upstream.

TMF was returned with an error code. The error code was not preserved to be
returned to upper layer. Instead, the error code from the Marker was
returned.

Preserve error code from TMF and return it to upper layer.

Cc: stable@vger.kernel.org
Fixes: da7c21b72aa8 ("scsi: qla2xxx: Fix command flush during TMF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230821130045.34850-6-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2224,6 +2224,8 @@ __qla2x00_async_tm_cmd(struct tmf_arg *a
 			rval = QLA_FUNCTION_FAILED;
 		}
 	}
+	if (tm_iocb->u.tmf.data)
+		rval = tm_iocb->u.tmf.data;
 
 done_free_sp:
 	/* ref: INIT */


