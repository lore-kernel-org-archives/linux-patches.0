Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212723;
	b=AuMHUZJhknjMkeK+th86WIxh0ewUGKrGgdDK0lduKDVpQm4jA3j1OxwsUGFd3nTRsj6G
	 crvysIxbeGkbjbNo0i5EX8r8WvzXNklv3G0NGglwSHzgnbPuHwhdWbRTOOicSs1nSQw/E
	 3vTJdBHsPF7yX0pSf+dilzo8cRF/osXy6fg/jqOfgEZQPHb2GpAf0er297p/3U2oUUyte
	 4x9ITo0RTqTjBO3FILY2zK7fBBbqN6p9QrzBV6vYhN/iWK+4cDMWOq0GiVFz2J4n5JDNx
	 aGaO6DwbLAwMXGrJfKCIgKSQSvWKtgCB9K3zEMSgvIQvgYmjMn3LCmKfQIKJibYqySA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Tnt/+5yO3cCBlct1Q83IyxgMGIdIxM2Jd1GQ4uq034=;
	b=XzeYG31J1pSwQdNYIWRTtpS4DqNIqelMRtkwJCc5MyQu2hJdFuyC6jyHeWYHZPMa1iej
	 mqlYidZM14nA1LqToHjUPFIf6sc2uRd597rTOQm6PylU0ZETxAYMswsO99hDAADRKghO2
	 NA8FgKKxsgq5HCXmOAbl7LU9jjZkluOBO4w77QrdvpV9YFByfi+iyc8FgsGACHxs+84kH
	 XbBl9UrGnYULrFrWVFr6+vNUaX8ZTzHidK2yrK7V8d8p1GkKvbPMWBr1Tb8SCgbpNOAuN
	 ZX/qHxBYRKzytKET2dFaCcNmPH/+kCoN3Pd0eNpWkZSRyXULbOIqmQ1hg8000tnDX+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KH6s0yRf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD90606A31A;
	Wed, 28 Oct 2026 18:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KH6s0yRf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED58D1F01825;
	Wed, 28 Oct 2026 18:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212723;
	bh=6Tnt/+5yO3cCBlct1Q83IyxgMGIdIxM2Jd1GQ4uq034=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KH6s0yRfDKyQH9dIBZEqvsAOx6h7G1VukDfYF/eP0rjD0zyGbXfiI/Sgly6PY+Sxo
	 n2h6nCqntL9YDbh+QQFFK8e6FGXVSAaBrYvQIke5vg9vfh6XCjzOpcB9G/VI/bVXmf
	 BS7BVYlzn8WOyOgLvpSqlH0Y8GeESFOStWCX4UYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0210/1887] scsi: qla2xxx: Initialize NVMe abort_work once at submission
Date: Wed, 28 Oct 2026 17:38:26 +0100
Message-ID: <20261028170504.013691141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 622b11660b67c..2c1b17a594206 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -309,7 +309,6 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	schedule_work(&priv->abort_work);
 }
 
@@ -347,6 +346,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	priv->sp = sp;
 	kref_init(&sp->cmd_kref);
 	spin_lock_init(&priv->cmd_lock);
+	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	nvme = &sp->u.iocb_cmd;
 	priv->fd = fd;
 	nvme->u.nvme.desc = fd;
@@ -391,7 +391,6 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	schedule_work(&priv->abort_work);
 }
 
@@ -657,6 +656,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 
 	kref_init(&sp->cmd_kref);
 	spin_lock_init(&priv->cmd_lock);
+	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	sp->priv = priv;
 	priv->sp = sp;
 	sp->type = SRB_NVME_CMD;
-- 
2.53.0



