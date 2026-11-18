Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058678;
	b=DIh24vkDjWJXsJvFZkUUJAlGRBZE/uZZNqVYWiqEevgyvOw92pIzFni1tiKKtbtWX9vB
	 Q2QprnjwRq7+k3M1vCdPvGYxz3MBlnW31gU4f0+H/WB/BPbkcwfV+qvqT1Bz1OL7CRBss
	 +YhMWtGylJrVxa1K1bQRNboeynoR0qVsEu0jDrqymL1etk0l4xshbfFsfimnTytFUfZLj
	 z98g4VT04P6+BWPj4aZ5OE45NQiziChugL21B5MLmCZxKBGzhltJBkKk9wR0fPn0jQQ0J
	 UAkG/StpN7i0Nm5+oehyCIvGYg6jz2yuSqAn+u9hx+FRnpDS6nt6+BAi30/5y5rZtjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TOycjJxn+m5KyGDDr7yQsn3+mUsE3Fute7Pzcc6T5Ao=;
	b=g9KRqMysdovRO0Lsp6mhza95asnzTXdph2MiqFjIMZdZA4rHakvc0VRT/VsQMuQNq2ui
	 oLIes5vifKv3v0RX61Y8QstKS1rrMxACqWrYvLzJyTvqUnvgvMmIzHgLJ2b+a3JW4D6dy
	 +bYCkM8nHuV1t4nO5atD8sabKaehfXua9N+kNBS0/b4CEbOOSNjpd5IsWbuBK46GGzJds
	 2+P7TJI/iN9WXoK7PkqhK/YEz3lqrK+zSj1IrMEpedNxPo1wFyC/dSghJT737XhdBmKXM
	 5rytekK3dd25BlR8n3TX2q9FaWehx2XMQOxbG+6Fgerch4iGCIRHqK0NwMvtEv5s1ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbGV7opD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E68606A325;
	Thu, 19 Nov 2026 03:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbGV7opD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3EC1F000C5;
	Thu, 19 Nov 2026 03:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058678;
	bh=TOycjJxn+m5KyGDDr7yQsn3+mUsE3Fute7Pzcc6T5Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbGV7opDhlbCyrD0OzRWoKhVRnWiI9M2Qh8QXgXfoaEjTfgd1d5UviF8yqn9qBIS0
	 DMQM2bpnl3riFvc4OQYl/WrY+jM7TFZVLeYugbCLCr6L9IJHz4dcvKjKtVAUQ6YUG1
	 FtRu96C/v630W2jl0cu8uT9N2osx+eeZzM2G3qps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0569/1848] scsi: libiscsi_tcp: Prevent R2T range check overflow
Date: Wed, 18 Nov 2026 15:43:27 +0100
Message-ID: <20261118145938.878084587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>

[ Upstream commit eb7aa7fd673fdc1582223cd133bcc5f54e7af19f ]

An iSCSI target controls the R2T data offset and length as 32-bit
values. Adding them before comparing the result with the SCSI data buffer
length can wrap. An R2T with offset 1 and length U32_MAX then passes the
check for a 4096-byte write.

The transmit path treats the wrapped range as valid, exhausts the command
scatterlist, and dereferences the NULL next entry in
iscsi_tcp_segment_done().

Check the offset first, then compare the length with the remaining bytes in
the data buffer.

Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")
Cc: stable@vger.kernel.org
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Acked-by: Chris Leech <cleech@redhat.com>
Link: https://patch.msgid.link/DB5PR08MB100629CD3750FBF71475B5224FD982@DB5PR08MB10062.eurprd08.prod.outlook.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 3592973407c01..2b51c7223013f 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -577,7 +577,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 			      data_length, session->max_burst);
 
 	data_offset = be32_to_cpu(rhdr->data_offset);
-	if (data_offset + data_length > task->sc->sdb.length) {
+	if (data_offset > task->sc->sdb.length ||
+	    data_length > task->sc->sdb.length - data_offset) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", data_length,
-- 
2.53.0



