Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212104;
	b=uoa8eew8cQj3+rld6vXlruproAsX6vudNWyWQJGsLTEjNaT2Ldf89xXTM1B+ExiQYXDO
	 C9dAEbXcBvEcRl5GN2xMlu8iD2uyoSTphqEBBARKOJt6JMnOAHf0J45PkixjOo/W3iq6V
	 y2fuJOcIMiRb/gqp+wFKLYTRUfWsR1U2I5hDkBwb7J2AC4MrJ+bYH0peSUzq/IfpIOsu2
	 0flDCixCa79VqJLusDBXcEum0gD2/56x4uWnaUBW1xefxAY5odikhaPU30swCDO7kKSar
	 Agnh19DrDXOKU3w3c83OstHIKSX0/Ei7sLW0ZX1fXE8L3Cr6te2vw122sFaXR1ZrnMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=shgBdnvpO6BEI2DUfsWE/Y7ebnIE75G6l7i41LnIvDg=;
	b=pFMzYoRR7ajFd67IcaB8sHZCrcWjoU4oMwM/PVpGTg+sPzLZzuAb/+c1E3Yb+Q/q+NRz
	 GWIlaqg10fr2jcyzaaCiCPJNz7+cdzcxtXrAJ29gqR4fEa1e35BUtevJCcAHJ64n02hv3
	 2nroAuEZiOzn/nacf478Lc/4kPh1dnLqY3HmC6SnjRxwEa7IAXkrNLkt4gmFOYyu+91gr
	 fWbVd8F2eTUX/VJGeG3RiYCzda5HyLU2lOrRQ5gX6mMqEqL2urOtougIlGVy+ZzXisrSR
	 EiVDVdXy4cNAePKiCHz8b10HCXqCIJ8Wi9IslPJfuOaGay7CsnXzpbU+wnrOKCBleAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MqwtQfqW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8A9606A31A;
	Wed, 28 Oct 2026 18:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MqwtQfqW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4171F01825;
	Wed, 28 Oct 2026 18:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212104;
	bh=shgBdnvpO6BEI2DUfsWE/Y7ebnIE75G6l7i41LnIvDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MqwtQfqWtbu7ScwQfRdfCVg63cHHkQuDApChlVZPq/uZShXZKwUmmgrsXr93VnU0/
	 xs5c6p8ACqE2RWi12/ewsEKEurFHH9G5+1SNDEq+7+bWU6vpUD6VtcS/oVltis8Iao
	 FX9LAiDS723lMfoSAD9uQPKfekTCUUJcejdeS6+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0039/1887] scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
Date: Wed, 28 Oct 2026 17:35:35 +0100
Message-ID: <20261028170500.113066377@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit a152edab3854f01dd2daf3eaf8f32cbabdb3834e ]

qla2x00_do_dport_diagnostics() allocates the qla_dport_diag response
buffer with kmalloc_obj() (non-zeroing) and, on success, copies the full
sizeof(*dd) back to user space via sg_copy_from_buffer(). The inbound
sg_copy_to_buffer() only fills as many bytes as the user request payload
provides, and qla26xx_dport_diagnostics() zeroes only dd->buf. The
options and unused[] fields are therefore copied out uninitialized,
leaking kernel heap contents to user space.

Allocate with kzalloc_obj(), matching qla2x00_do_dport_diagnostics_v2().

Fixes: ec89146215d1 ("qla2xxx: Add bsg interface to support D_Port Diagnostics.")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-54-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ Adapted kzalloc_obj(*dd) to kzalloc(sizeof(*dd), GFP_KERNEL) to match the branch’s allocation syntax. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 3982f7d576a83..8e859d79bdee1 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2412,7 +2412,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	    !IS_QLA28XX(vha->hw))
 		return -EPERM;
 
-	dd = kmalloc(sizeof(*dd), GFP_KERNEL);
+	dd = kzalloc(sizeof(*dd), GFP_KERNEL);
 	if (!dd) {
 		ql_log(ql_log_warn, vha, 0x70db,
 		    "Failed to allocate memory for dport.\n");
-- 
2.53.0



