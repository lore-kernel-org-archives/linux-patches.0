Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E1847A5D;
	Mon,  1 Apr 2024 17:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991431; cv=none; b=reGBPcP6KkSyBtmSyUBLv/mLLLAzyjJ2J8sIRG2y2AftdfuGYHDAu8/QXi+QnLqNgMUwWFGypW7tCy4R26bL+3G9QMYiJApeCo6xZZPda3log9HG/ScJH577HGYIC44QGmhhcStVnpoRGXuc7tP1RWgNWK+27AeVzNsB/CBQ+eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991431; c=relaxed/simple;
	bh=mcbj6c87sDHsDppQOhNeCNMf6WCXGMmIAoknmIRfGgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5pKtVVN5dT/GvfzGRIkMg4IGv85N1BUNGJsLX0wpP02Z0P57QrIx5KTtQbIfUyoB3ses2l+B8V8zfLNaGv1+XmvvnFVzsniKfB+NyPApqqEukRrxxb60ln7kWzCilSqQ1Qs3Sc/RPdebq4urlMQYw6NXGClOnVXrHIp/WD0zCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL04BWSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL04BWSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12396C43390;
	Mon,  1 Apr 2024 17:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991431;
	bh=mcbj6c87sDHsDppQOhNeCNMf6WCXGMmIAoknmIRfGgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eL04BWSAmkjAWC+LYIXMJCnTaZK0arMG2MkeaI80N8DFna7RRbwN68huHY7Fughaq
	 LibHW3S5JXU/eMSdZq2vXToMtORfH/K6YeYIopuBTvI+6w8+KQfaGjwUWX4ARS0t5p
	 jPT0wVr4/ajHEuMhVBh89ZEgWuyPJnTawG41xkC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 262/272] scsi: qla2xxx: Change debug message during driver unload
Date: Mon,  1 Apr 2024 17:47:32 +0200
Message-ID: <20240401152539.226690102@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Saurav Kashyap <skashyap@marvell.com>

commit b5a30840727a3e41d12a336d19f6c0716b299161 upstream.

Upon driver unload, purge_mbox flag is set and the heartbeat monitor thread
detects this flag and does not send the mailbox command down to FW with a
debug message "Error detected: purge[1] eeh[0] cmd=0x0, Exiting".  This
being not a real error, change the debug message.

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240227164127.36465-10-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -194,7 +194,7 @@ qla2x00_mailbox_command(scsi_qla_host_t
 	if (ha->flags.purge_mbox || chip_reset != ha->chip_reset ||
 	    ha->flags.eeh_busy) {
 		ql_log(ql_log_warn, vha, 0xd035,
-		       "Error detected: purge[%d] eeh[%d] cmd=0x%x, Exiting.\n",
+		       "Purge mbox: purge[%d] eeh[%d] cmd=0x%x, Exiting.\n",
 		       ha->flags.purge_mbox, ha->flags.eeh_busy, mcp->mb[0]);
 		rval = QLA_ABORTED;
 		goto premature_exit;


