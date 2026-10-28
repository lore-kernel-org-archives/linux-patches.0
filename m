Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212425;
	b=MU3qg+VI/vhPWjE74hKRNasXe27A2EbrVK88XZN0L0MR4BgeDDIIobLSYsBYpGFLc4Wu
	 6rLgRH9m+0OzZQgX7uCpXRo8jU4tLHRKr0rv7zjimF6i4g7dZOBNx2nbJVnnMj7/aa6mm
	 QjDsRqv6NRHsyJufWw/DdeeZ1cY+SCfkR39tibpSTz71G1AFwMTraev+4VYpUltpDMoV8
	 xPknjivow1aiRPZ8gJHTgQEfwJtTGLjBF90AifY48N7qzSIREXTZu3m3GgFJD827uLpmY
	 tEoa6emAI8k3aQJAM/BBte5OB/W6dfvjDXYCNJ+uq4vRQq3fmjMsaudJypR+dTBpMIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6IAEhvr8HlYVUDJYX47qAV0vvS+JFUnQHVTJ1R3PvJk=;
	b=1Wnx+uaBOYO6COosGH/10T17uWk4AcmYMitsLQxYeOojaa5aJgrYH3QG+KyFPR3IYJ7I
	 fUxePergkIyuvAaEdnfnKhbPPPc6RHWzjblpDARdV4kWsMGFZOEFaRpzPS4dcq8P63lOm
	 qESCrZ7SnItzOBiE9+b2PZQCH4hDgjwP+GIoJRgkPKt3Z5XrjI+lgibEkRbT73r+erPTP
	 ybHKIUwqD6Tw2+Dqoa7rKFTlZ9t2AzsAMt9HPPVcyyVNzHoPf01oSU/bCb88tlrFAmhrc
	 fA/JGn/UJ2UIhTnSK9TomNvKk4D0ZqC7XwtweA0wbGB9MQKpl6ttHaajAoWYPjM/zxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vFc26c0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B641F606A31C;
	Wed, 28 Oct 2026 18:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vFc26c0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125441F01829;
	Wed, 28 Oct 2026 18:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212424;
	bh=6IAEhvr8HlYVUDJYX47qAV0vvS+JFUnQHVTJ1R3PvJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vFc26c0O+rNrC0Itf56/4wKuHLmaFMmkNg3tuDPmkWV0qjWJqBrnOOD0AsUjGITm
	 D+HApKh00eFR4mpFEv6eg8/Yi743fAOto2BtiUAGtaiGiBE5NFcxlyLnhI55HNWFN8
	 e0ad8UmubZKb6gf/hDyrWaEo4qDJG1HYFdMiXG+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0112/1887] scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature
Date: Wed, 28 Oct 2026 17:36:48 +0100
Message-ID: <20261028170501.784241341@linuxfoundation.org>
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

[ Upstream commit d7e3fa7d06bf7fcaac186d3c4d635caac166d36c ]

qla27xx_copy_multiple_pkt() and qla27xx_copy_fpin_pkt() poll
rsp_q->ring_ptr->signature for RESPONSE_PROCESSED (0xDEADDEAD) to decide
whether the next continuation IOCB has arrived, spinning on cpu_relax()
without advancing the ring or decrementing the entry count while it has
not. response_t::signature lives at byte offset 60, but a continuation
IOCB (sts_cont_entry_t / struct sts_cont_entry_ext) carries raw FC frame
payload at that offset (data[56..59]). A received frame whose payload
bytes happen to equal 0xDEADDEAD is therefore misread as "not yet
arrived", and the loop spins forever in interrupt/DPC context, causing a
CPU soft lockup.

The poll is also unnecessary: callers of qla27xx_copy_multiple_pkt()
(PT_LS4_UNSOL and the NVMe purls path) already gate on
qla_chk_cont_iocb_avail(), which guarantees all entry_count IOCBs are
present before copying begins. The sibling helper
__qla_copy_purex_to_buffer() already drops the signature poll and relies
on the entry_type == STATUS_CONT_TYPE guard instead.

Remove the signature busy-wait from both helpers, keeping the entry_type
guard, and gate the FPIN path with qla_chk_cont_iocb_avail() so it defers
and re-processes on the next interrupt once all continuation IOCBs have
arrived, mirroring the ELS_AUTH_ELS and PT_LS4_UNSOL arms. With this the
signature field is never read on a continuation IOCB, eliminating the
payload-aliasing lockup.

Fixes: 9f2475fe7406 ("scsi: qla2xxx: SAN congestion management implementation")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-15-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ replaced unavailable qla_rsp_ring_rewind_to() with direct ring_ptr and ring_index assignments ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 72ecd39a75830..2b3885bd47ff9 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1053,14 +1053,6 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 
 	do {
 		while ((total_bytes > 0) && (entry_count_remaining > 0)) {
-			if (rsp_q->ring_ptr->signature == RESPONSE_PROCESSED) {
-				ql_dbg(ql_dbg_async, vha, 0x5084,
-				       "Ran out of IOCBs, partial data 0x%x\n",
-				       buffer_copy_offset);
-				cpu_relax();
-				continue;
-			}
-
 			new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
 			*pkt = new_pkt;
 
@@ -3993,9 +3985,24 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 					       "SCM not active for this port\n");
 					break;
 				}
+				if (qla_chk_cont_iocb_avail(vha, rsp,
+				    (response_t *)pkt, rsp_in)) {
+					/*
+					 * ring_ptr and ring_index were
+					 * pre-incremented above. Reset them
+					 * back to current. Wait for next
+					 * interrupt with all IOCBs to arrive
+					 * and re-process.
+					 */
+					rsp->ring_ptr = (response_t *)pkt;
+					rsp->ring_index = cur_ring_index;
+
+					ql_dbg(ql_dbg_init, vha, 0x5095,
+					    "Defer processing FPIN...\n");
+					return;
+				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
-				__update_rsp_in(is_shadow_hba, rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,
-- 
2.53.0



