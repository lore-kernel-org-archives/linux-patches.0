Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367BEBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE0EC433EF;
	Tue,  7 Mar 2023 18:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214524;
	bh=zbHdM+cbzGQiOmIbpd0CNF9byRk2JC9BkULvN/xnVw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEkFciuYwJutQA1evrEuFthfyCAIpsVCuT7Rp9/0JxLwVl1bUFfkoGHyliNWAHDkl
	 5kl1UU2BsOVLUa54FcQc5rlRiEjfSmpo6hkkss12DBEoZpq2rPDPtB5uCnsEK7s2m7
	 HOnvcGasf4TnnflLyKQ3kLSAaysAy14Qdlp/tbvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 850/885] scsi: qla2xxx: Remove increment of interface err cnt
Date: Tue,  7 Mar 2023 18:03:04 +0100
Message-Id: <20230307170038.729811265@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saurav Kashyap <skashyap@marvell.com>

commit d676a9e3d9efb7e93df460bcf4c445496c16314f upstream.

Residual underrun is not an interface error, hence no need to increment
that count.

Fixes: dbf1f53cfd23 ("scsi: qla2xxx: Implementation to get and manage host, target stats and initiator port")
Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3363,8 +3363,6 @@ qla2x00_status_entry(scsi_qla_host_t *vh
 				       "Dropped frame(s) detected (0x%x of 0x%x bytes).\n",
 				       resid, scsi_bufflen(cp));
 
-				vha->interface_err_cnt++;
-
 				res = DID_ERROR << 16 | lscsi_status;
 				goto check_scsi_status;
 			}


