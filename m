Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213337;
	b=vxRjw1b+ItWrxcVrs6KIx8HQQJvGKwgwpwAuYNLal/tuKod9Dx3keRe4oIz2CqFJ1K3Y
	 rcI+fIvqQab5k33LSNpgyM975qUDzndVTdy97XPjC9+cpWRSlkrPpKbdi87XymJvIkhqa
	 K3vWzAbjUHQFMM542Uoj3HkHzxba0eLFPPEaA77RNY8hRkk814s+Au6TtToqc1ZjMF7jM
	 elI9peFqK/1E58wbroshZrTbn13z+XDLFXYE/SDhxefgcIsLbS+k7AaIhGfD/jrDBVmw1
	 PFovLNB0COqMecRrbVkMBFLr2SjRSQTXVDpYxiUdyKxcfsWHnraGhU7dP0xwAiyRxWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uzYf49qjh2z4KqATIXMXNWcOzFC2SRz1itEOsoJtOMg=;
	b=vdfK3gmfq6AdpbxhyFUYVXYzxJUn+v4ssnYDwD2KOI5clzN2j1EgBtqxPnTzeJ39rdNG
	 K32QmWgyWrMuP0KBfcxCR1vFbjOWK4FqHTXt2Edzjp8mKyvQrYbUEhmsgxt/UrINSWA8r
	 m2K/NKJupd9JCKazS97k20Y4peUiIFc1yVi4CYJDgkGeQ5RFlu67lUXWHr9XpV4Fq7yQo
	 PEf3WKflrmWVdZ8o2i2lln5/mdcDo1HB6aysfb4DdSpbKlvmjSfnQsHaNSTcVaZtydm57
	 wrutRQvEiMAs0+Xogw7sMnsOwSM/dwbSs/3+knepAmJGWZ3ZF5XFwOTOZptbpCWHsFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfQHsOOv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163F3606A31C;
	Wed, 28 Oct 2026 18:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfQHsOOv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687301F01825;
	Wed, 28 Oct 2026 18:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213336;
	bh=uzYf49qjh2z4KqATIXMXNWcOzFC2SRz1itEOsoJtOMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FfQHsOOvmYP4t/bdnTrrEx+cbBYQQM8w9ELJcnyp646FmNyd6kpYo/BQllPEEGBrx
	 QiXoggTjbEEfF/JYAMdflrxdIQCvkutI2Oj1elxCPNMxs3ldrDjtOZqqQjaeVPSwWi
	 nX0sjfAwsHHnlgk45dWxvZ6uDYHgK3BpzxcIFY5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0469/1887] scsi: qedi: Initialize callback state before registration
Date: Wed, 28 Oct 2026 17:42:45 +0100
Message-ID: <20261028170509.907229867@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 85de8b3a5eaa23d153aff4c7c83dddbc949064c9 upstream.

qedi_get_protocol_tlv_data() can be called asynchronously by QED after
qedi_ops->register_ops(). It takes stats_lock and reads ll2_mtu, but
__qedi_probe() currently registers the callback before initializing the
mutex and assigning the default MTU on the normal probe path.

Initialize the callback-visible state before registering qedi_cb_ops. Keep
the recovery path from reinitializing state because it reuses the existing
qedi context.

Fixes: 3cc5746e5ad7 ("scsi: qedi: Initialize the stats mutex lock")
Cc: stable@vger.kernel.org
Assisted-by: LLM Codex
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260910092405.1300129-1-runyu.xiao@seu.edu.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qedi/qedi_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2664,8 +2664,6 @@ retry_probe:
 	snprintf(host_buf, sizeof(host_buf), "host_%d", qedi->shost->host_no);
 	qedi_ops->common->set_name(qedi->cdev, host_buf);
 
-	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
-
 	memset(&params, 0, sizeof(params));
 	params.mtu = DEF_PATH_MTU + IPV6_HDR_LEN + TCP_HDR_LEN;
 	qedi->ll2_mtu = DEF_PATH_MTU;
@@ -2682,6 +2680,7 @@ retry_probe:
 		spin_lock_init(&qedi->task_idx_lock);
 		mutex_init(&qedi->stats_lock);
 	}
+	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
 	qedi_ops->ll2->register_cb_ops(qedi->cdev, &qedi_ll2_cb_ops, qedi);
 	qedi_ops->ll2->start(qedi->cdev, &params);
 


