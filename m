Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22C6481C4;
	Mon,  1 Apr 2024 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989296; cv=none; b=TlzgHz3lbKRcDRgMLWnpFQ6YGv4tdz3m5D1fIq3CY8ha7qQPrUBzeush4GfTJaXSToLJSMifPgG0S7w3itSWOOkvTL7BwKuynn6P+wtUjCyaoaGMNtcbpcLA1TlxQI33aumo4fPBc+gAI4n1ryw4tseKShGvGq7Awizp3AAgyn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989296; c=relaxed/simple;
	bh=ZNvy3HPVKsHGtJkBaYAFzvb0+5iEQ5qSSvDhLu0U3XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjxeJWu/omjSdj6gROeyGp65UvAe2iu8M9ox5JCLmr4elT5qT5KyqfJyUGeEdLUIko9U7hQSWDdNPcMZ/uYdLhkzIa2mzIISJuSBHkgWOVDSVGEDxrkwtQ8HrqWY07Xh8qONeM+ZcIlO90z2Y6dXDGIzJegPJT2v9KSJj1FxjPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8aZKME7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8aZKME7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17866C433F1;
	Mon,  1 Apr 2024 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989295;
	bh=ZNvy3HPVKsHGtJkBaYAFzvb0+5iEQ5qSSvDhLu0U3XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8aZKME7M60fYyK0QqQDkp2NPlhbKLXqjakh6TfTk6CsDsJp+k44SXMShk7xA7M+K
	 2wRpL+Suv/NyhqbFoNtNGvd+uqEyY6JUAm2Ou4vQ8kMBxHyVjtD4ioesJ2UAcW+Dzw
	 jxGUxgTJEYgJpqrOgvBRI/HeVNo77AyPRhPoKYiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 420/432] scsi: qla2xxx: Change debug message during driver unload
Date: Mon,  1 Apr 2024 17:46:47 +0200
Message-ID: <20240401152605.942834023@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


