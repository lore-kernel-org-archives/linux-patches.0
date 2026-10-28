Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211436;
	b=fYza9s8o9WC7XPnsO6t19eauTjzobjNflrlP0+V2dIyWArnVjtxz4eyAkah9CdEAP5zT
	 j44wY6FPGhMF4sOKwCTjjXRRds/UuapY8HipVUJEelux+ppouPpjqnCl8QU9KE5zn2KAe
	 E+TxF7D7cCy0eFh6AzJLlOwAhPSMUdrINfjmhQMAGCstUuL9vNiyR1Z7odeJFCnFuIANa
	 P8izEGIV1DCxCZYGK6YU9kT01Q9GbQMOHRGqSEXIj0fTMbrJZ8e6I3zcS/9/mVkirvSRp
	 teajljckkxo6lfG9DGLTZFQYX56vSzaC5nZywz7VgioL5Tj+X5YfXzDphbIjQvFEuRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J1Qz4ud6joPRgsyr/N1Ja0pL6efKNgwMMV0vP7AHbcw=;
	b=Opdm0Os/tVdBd8TF2szt7ScjgYbB+3967NYMHuS9ORmx8PqGSK0Ei/ykxlh/NJpA9+ym
	 Iu+grjEKmIv+ersjo9ZoHS+mLNwaBwBoE0NdxB1MjIi5HdEevF5xy95B1iuyLAHyEodzI
	 aMgoAZCrLNfMCgESGZ+67pGO4qiCxPYS7FGy7iLYeIkYrt8jJMbbfj6MIeUH3l+8qQ8Ou
	 t5Gz1a42R+uiNf4UC7FHtSaqEWObWD93IH/Hei82z/CvVWaxeYq8yAleqBqyl53suKm2l
	 sHdVmoQjqLjjc7MB6r1K2jPqI7Ao/55FlwE396LfFcZT5pcjl2XjbI8ZJaf0ddhgOPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qh1G4bkr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC7B606A327;
	Wed, 28 Oct 2026 18:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qh1G4bkr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8062D1F01825;
	Wed, 28 Oct 2026 18:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211436;
	bh=J1Qz4ud6joPRgsyr/N1Ja0pL6efKNgwMMV0vP7AHbcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qh1G4bkrXS7e3cCEsDdqc2eSTMSLgBL4q+GLg32ixtcP2rbWqJQ6fgZlAmwiUm+81
	 pC1bin4HEpS50YfQn5nbr/Asp10iGRQQlMht1BJUvnwtbsDSPapi2HR1qGmqNTTGLT
	 HqqfZdy+hPu2geWKml0KHg7wrb5UFo/1YX2//U9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 378/571] scsi: qedi: Initialize callback state before registration
Date: Wed, 28 Oct 2026 17:58:45 +0100
Message-ID: <20261028170016.980865724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2669,8 +2669,6 @@ retry_probe:
 	snprintf(host_buf, sizeof(host_buf), "host_%d", qedi->shost->host_no);
 	qedi_ops->common->set_name(qedi->cdev, host_buf);
 
-	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
-
 	memset(&params, 0, sizeof(params));
 	params.mtu = DEF_PATH_MTU + IPV6_HDR_LEN + TCP_HDR_LEN;
 	qedi->ll2_mtu = DEF_PATH_MTU;
@@ -2687,6 +2685,7 @@ retry_probe:
 		spin_lock_init(&qedi->task_idx_lock);
 		mutex_init(&qedi->stats_lock);
 	}
+	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
 	qedi_ops->ll2->register_cb_ops(qedi->cdev, &qedi_ll2_cb_ops, qedi);
 	qedi_ops->ll2->start(qedi->cdev, &params);
 


