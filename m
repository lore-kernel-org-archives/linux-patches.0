Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209068;
	b=tcSWX1g73APRn5Nu/AkuDsmnvxxPZld9OWm9e0BirhPZhsU+Am2JelDX2gmBdLe8RpqB
	 XtDTVTfzc/BVfNI/fuB2pFRcFhAlbFGjprbCofLGeInaYfBy3QtDxJJQYXYPFKmwAQ5yj
	 LucYUaM8R8PiXHAWAHGjsQVQ5RcmB0biZM7eG0+w7VUqScT85hCyw1JanOHTvaUW5pl0/
	 446xGG091VOxbMCKEtN4L5ZOZFZKuzqRgQcmCFfUhu0CCGT/5HPzqI6tVMPqLoFcl3qQh
	 hPJIrqILzwkM2P2dBrVmHKlnW4b3fvY3Do4oIU9L7EXG/ILH5Xnm3YHXAiiPzUFnfqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=40fmYs2XtzWCLY/VZQp9/Oh4zJphjCCEzoQBmO+jxeo=;
	b=SNf9R8RZxu83QXAv8aDukT+lr+iyEHl4VXSOh2GRmRcf7oGJ57n2hOdEUGon0gelKio6
	 xwxm7kgacIQhuqE5oCtUYGX1h2SZxwuUhrEOv8DdZ5mtAplLy4YMoIFaeJ6rAMj+k0EqZ
	 DcjxTue7bqP8krkvOjcjDBiE22OBX0XkClOMo3WpYjCXu8Gw4Knz4IwiXfJ5DcnyxSj0A
	 yL/cvSmPCxRwQw13YtRXxe0NbmdKmElIWKZ6oXdqgMBbD2XMVVBHV75DyKbMPJlfZ3z4d
	 0BiMQUAyO5R+GBgROYJxAs86TIxr+KV38bDle8VpiL0rR/pS40oold24uFf0AdYHXzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ayFWALV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83584606A326;
	Wed, 28 Oct 2026 17:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ayFWALV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9009F1F01825;
	Wed, 28 Oct 2026 17:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209068;
	bh=40fmYs2XtzWCLY/VZQp9/Oh4zJphjCCEzoQBmO+jxeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ayFWALVOEnv4zjMItDr7oDl39PWZPoDS9KbivM8txeN4FAp9hRoiWLfnLKAiRoVF
	 CYa54nUlDR0w7kDj2JHQUPy2ICWZRiYW8czUqK1SId6KsKGWACb+wz0Y+B/GJxdk92
	 Z7iJ2T1LP01kedwBpIKT5lbkUMfZh/4OSssw1oiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 342/516] scsi: qedi: Initialize callback state before registration
Date: Wed, 28 Oct 2026 17:58:14 +0100
Message-ID: <20261028170011.589459353@linuxfoundation.org>
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
@@ -2671,8 +2671,6 @@ retry_probe:
 	snprintf(host_buf, sizeof(host_buf), "host_%d", qedi->shost->host_no);
 	qedi_ops->common->set_name(qedi->cdev, host_buf);
 
-	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
-
 	memset(&params, 0, sizeof(params));
 	params.mtu = DEF_PATH_MTU + IPV6_HDR_LEN + TCP_HDR_LEN;
 	qedi->ll2_mtu = DEF_PATH_MTU;
@@ -2689,6 +2687,7 @@ retry_probe:
 		spin_lock_init(&qedi->task_idx_lock);
 		mutex_init(&qedi->stats_lock);
 	}
+	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
 	qedi_ops->ll2->register_cb_ops(qedi->cdev, &qedi_ll2_cb_ops, qedi);
 	qedi_ops->ll2->start(qedi->cdev, &params);
 


