Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065300;
	b=qpVR/NkPLXWZpg6kKq5SiYM2V3WicCCqMEWMoz63qlwqzqLtro/cvTwgetQHEmBoLsvF
	 RjEjBKmxIMCk9ktGoDhEgFc1HQ4nH2KmYbgDXetEzGkvUSRqOIElaGIxW2VZ1jJ21OVjr
	 nvyrtrVu62U0Cx3u50Gcxx2PzqXXAQzxWBsOZwLElPrPZ84LDlfeJdf24ldaTMdObMpG1
	 YxqeusD7IgPMtHXRjVa21nm+ehPTm2rz5NPxDyXtExlim6006TL6hS1okhoB1Rbmz5m3l
	 Ikad2E5dH0TK3IKCswpzGKGWiOnPLLcm+N/+fEBIzD0qkA71v/S4MV/K+5NtUJrHWEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=79CTNzCCHo2IyYl7Eb+pj1snAJU/Zpx1kLGsVu1bxqg=;
	b=N4rV2DTuh1EFd6fAIjvBaX8iV6jEBxl+5ZA62bfBxSGGoe/wxLZYz31MHFMTILPfPlX3
	 KQaRiBsSJ4B0Ul1U3Tkqzg3OS0pQnbqBrmQE8uoqW80zz2tjiPUnobWW7+b8+7Uc5DDxR
	 XQV8G/cyk2fzZ2l8Xv2VokFjxe3zyHrCddHZpTiWb7g4fy8XHr/lkwtikJIBFI9Bms3nH
	 KjXznwOv1hYpOs/L03Q9HH8AZ8dUqigPfmR99+a+0vAq21twajuMA5u0/ixfDqQpxsF65
	 kivJ/yOuTAB29WnDLDitMgFdp1EaDYJsNrG/iQeLnSwUwRd83fjT2CZNPuaOx6ok03w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFBa8aa4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19D7606A333;
	Sat,  7 Nov 2026 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFBa8aa4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1BA1F0089F;
	Sat,  7 Nov 2026 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065299;
	bh=79CTNzCCHo2IyYl7Eb+pj1snAJU/Zpx1kLGsVu1bxqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFBa8aa4SHp2UM5ElEnQMNjEN7rJ5TWtZ5h49/D+CcBRea1wxNSocF1bXQ2l4O9KD
	 PHKCpOKRm6luM1eGPSjRBRAzVkGP3FLa4xGQ7qxsuUYxyTH5rRu55cX1qdMFZEmvwo
	 e3Ib3f86+N1F5T5oleihFVEl0Brd/2CsrcJGhQXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1054/1257] scsi: libiscsi_tcp: Prevent R2T range check overflow
Date: Sat,  7 Nov 2026 08:55:50 -0500
Message-ID: <20261107135008.402197163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d35f93451ee9b..3c9e736d45e7e 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -601,7 +601,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
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



