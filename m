Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045890;
	b=QRgHYVKf1Y5U5Ajo4YCxXOb7LCR/anN/3fcDV72TUomsXOpWVQ1wygXxLhB5/tmGIzME
	 pt5JLJnpL78gqD/R0UUOECG5yISeuV7nHgkPKNQBwu3Xq90C1kxHj7ckI0DxGOlJpyyER
	 Ga10eMYm8QrQRUlRtpQRs5cwQhO6qVI8LDE9Bpt+1ak8g0e0y8r+pgCDR79/VQWqwxLVL
	 HeEu1pf/fSssDQUuFTrBtAxxZR4ZlHmHt4yKwg5gz24zGlYegQ+yqaV2i5nK6TyIPeNcy
	 WJLcqMORAtvGzXEHnODzBnYnZxoEpiJiFZRXcUWB4WeTmlS6BcZiXeOIhKk/dRPBlMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UiKJXpDHpULACOXEsSbvP2kfnxvhYX0p0YWf6cO7dGA=;
	b=ULLq1oEBCQAYkNQQQUqciDxbHAmX38KDCVmxEfheH9sqYIIKKt0rrPW/0xJzOj3RHlMv
	 oCnxz8C6otG7tIltAqSDI2xOY8YYAHGCwbQwsv77iyW77Y6pIvEx7TmSW9DuL+NzMEFwr
	 WZdbwwn5V3lAwvmI/MRnnJdjK7fcHtEF4mjE3MFRJp5ZSZY+80kBjX/gwnOsiGGvxVoO9
	 EYyrdBYQBZb6GsTSoY8q8mqv0e4bjFf47XJZc681M667s+bnamig4Q1FJd4/qFCa82qir
	 WDRyowbmt4GlRnInSMCtHKcKLDtLHZTqx5FGj++Gi+IU/rMgX5qnBWUM49sm1je8j0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZNRdwG5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788FB60A260C;
	Wed, 18 Nov 2026 23:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZNRdwG5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DA41F000C7;
	Wed, 18 Nov 2026 23:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045890;
	bh=UiKJXpDHpULACOXEsSbvP2kfnxvhYX0p0YWf6cO7dGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZNRdwG5p/VqbrOk4x0Jo6rJa2aXA2XlDCUr05GNQ2n6kdGZ1yVoZEYtaANerkFHe
	 zboYwNuDtfUqBVdPk8H9oMmFbZrOIgfeV8FvyN5JUoOUc8aHrWko3lwLAO7baQ3Q7I
	 FQcdiKZXcFv4J6+1wOmCzPuzn1iB+jzoCNrShumw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1086/2857] nvmet: Free the old negotiation state when restarting authentication
Date: Wed, 18 Nov 2026 15:35:20 +0100
Message-ID: <20261118150240.727263445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 5c279fcabb0ea7ba61881c13027b15d8054b8abd ]

Restarting a DH-HMAC-CHAP negotiation with SEND(NEGOTIATE) resets
sq->dhchap_step but does not release the previous c1/c2/skey, which
are only freed in nvmet_auth_sq_free() at teardown.  The next
CHALLENGE/REPLY exchange then overwrites those pointers with fresh
allocations.

An unauthenticated host can repeat the negotiate message endlessly,
leaking a few dozen bytes per round and slowly exhausting target
memory.

Clear the old negotiation state with nvmet_auth_sq_free() before
setting up the new one.  Also reset dhchap_skey_len to zero: if a DH
session key was already established, a following round with dhvlen=0
would otherwise pass a NULL skey with a stale non-zero length to the
HMAC code and dereference it.

Fixes: db1312dd95488 ("nvmet: implement basic In-Band Authentication")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c             | 1 +
 drivers/nvme/target/fabrics-cmd-auth.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 59762bbb98da3..6ed832c4ec964 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -226,6 +226,7 @@ void nvmet_auth_sq_free(struct nvmet_sq *sq)
 	sq->dhchap_c2 = NULL;
 	kfree(sq->dhchap_skey);
 	sq->dhchap_skey = NULL;
+	sq->dhchap_skey_len = 0;
 }
 
 void nvmet_auth_sq_destroy(struct nvmet_sq *sq)
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 2050f543c171b..68815afd41fed 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -270,6 +270,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 			/* Restart negotiation */
 			pr_debug("%s: ctrl %d qid %d reset negotiation\n",
 				 __func__, ctrl->cntlid, req->sq->qid);
+			nvmet_auth_sq_free(req->sq);
 			if (!req->sq->qid) {
 				dhchap_status = nvmet_setup_auth(ctrl);
 				if (dhchap_status) {
-- 
2.53.0



