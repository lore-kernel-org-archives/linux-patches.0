Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208536;
	b=oqHM+vBQuE8xGYA+b3QxqmdADSD9TeDe/dTYVEIaTE4Q9Edxr7TbBIEv4fHaDXBtj7ib
	 ZN3cX14qgQsufhKSe7i7rhIr5WK7Wc1n1+ZX5HpnAnkHbLj+1ukTDrJiQnm8iYB8gujD0
	 oHjIAEUDxGFG7EY4WhmeO6Cl8DodkP7waezjbev1avJnPxd9TQq7ljdtquAQ03WbKQqBT
	 L5M8XBgyOXGTMbW4NdRs7og+6bTuJvDg7yBHHbx7EqMqPWCYMYylPk496YG1bY6ISM7pO
	 gFV+8renL/0RG3f2/VgNYOhONQ06ZW9OJ7frZO676ZjW50M6YDXYybtD7YKl1CupA/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VNjkik5SlydrxX43oX6BQNoJyP8btHbbt2dVQr5gE+Q=;
	b=pxPJ53lCvI5nsJWV4B+0BpjIlD240wFx5z/3raLugneJEkEw50oLy5a57FD9S/qg73Yv
	 0nKxQRSgj7OhNds5jYh8KwLY5n7UDBsbIYvPmxyoxQ4ZGrF7IRSzU0ddP+qGx9VCc/IOe
	 iIxOE7L9vWgphr3WVdpXQNRHT+G9CiQCP6t2v77CUH0G98ChvFABSe+mu3OTPP/tvE7X8
	 5IHigGL8D2Zfl1jtt+hyhyhlbeH+8Moi3FGY2nDWBpRrGQNWrEAxzmFaHKX33p6rpzGMS
	 4k0jCW4VB+NJnzyGpkSw5BRSMqidj3VMWrrrYV1DavFaCP21AUM5nMfFnMFi7ROSTLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hu0Y4yhM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C37606A31C;
	Wed, 28 Oct 2026 17:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hu0Y4yhM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18191F01825;
	Wed, 28 Oct 2026 17:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208536;
	bh=VNjkik5SlydrxX43oX6BQNoJyP8btHbbt2dVQr5gE+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hu0Y4yhMsbcAMCnLdoGU9fvCb6xy+4b+/lb3sYpxKKLvLWaZdW9+Ae1xVM1YXFf29
	 LkBVWL/bwIAqGjikIpdR5sRm+sBs6zxgyw5SoNYfw5qzycn1A9jr6nDQrV7Lwq4KDg
	 ydELCLn4BYXKNdhyMqzZSfk/08tkcD1XiJBJ8Aoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/516] scsi: qla2xxx: Initialize NVMe abort_work once at submission
Date: Wed, 28 Oct 2026 17:55:07 +0100
Message-ID: <20261028170007.177487636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 7e85f6dbc85616de2172bce8eaf84b387a723cd1 ]

qla_nvme_fcp_abort() and qla_nvme_ls_abort() ran INIT_WORK() on
priv->abort_work immediately before schedule_work(). INIT_WORK()
reinitializes the work_struct, resetting its list head and clearing the
pending bit. If an abort is issued more than once for the same command
(for example, concurrent transport teardown and a timeout-driven abort),
the second INIT_WORK() reinitializes a work item that is already queued,
which can corrupt the workqueue list and lead to crashes or a looping
worker.

Initialize priv->abort_work once at command submission, next to the
existing per-command spin_lock_init(&priv->cmd_lock), and leave only
schedule_work() in the abort paths. schedule_work() already does nothing
when the work item is still pending, so a repeated abort no longer
disturbs an in-flight work item. The command is not returned to the
transport until the final kref_put()/release callback runs after
abort_work has completed, so the work item is idle before priv is reused
and the single submission-time INIT_WORK() is safe.

Fixes: e473b3074104 ("scsi: qla2xxx: Add FC-NVMe abort processing")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-52-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 28a5b40e0f329..45fa0e2b78353 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -278,7 +278,6 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	schedule_work(&priv->abort_work);
 }
 
@@ -317,6 +316,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	priv->sp = sp;
 	kref_init(&sp->cmd_kref);
 	spin_lock_init(&priv->cmd_lock);
+	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	nvme = &sp->u.iocb_cmd;
 	priv->fd = fd;
 	nvme->u.nvme.desc = fd;
@@ -361,7 +361,6 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	schedule_work(&priv->abort_work);
 }
 
@@ -600,6 +599,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 
 	kref_init(&sp->cmd_kref);
 	spin_lock_init(&priv->cmd_lock);
+	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	sp->priv = priv;
 	priv->sp = sp;
 	sp->type = SRB_NVME_CMD;
-- 
2.53.0



