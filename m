Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210743;
	b=rCgNH4yp+MCWHyYyfn38E50SBNxlQOb65Luz/W5AtxuqJfsiSAGlJmP4fLeIfjDtSdm8
	 UTrzQpiI/LnXMzYUDMNRAOEh6gT8HR1aQ2LQBhGQrQvgWPwtVpc+2ZwPNg7P1RYoin/Bb
	 06J/YGJRBPEQjrNQVkwa+29J2tAcB72YRkvGZvysF4K2z/4mNofAcTlxyzfpzY1YM3Xir
	 /EKOJkRmXoGISlbJQFK4aMRO3kkRMpQvGEBIOPAYE8NDcBimbCiKQLip/nK7InSU2jAhn
	 M4iWVhaxy/ZgrfrnDaGnfc4zhVuXc8mbcsLVdBnCiEKGwaB46jbvBJMt8tw7GeP1Nxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0ZF4qDkq4jxhj1ZqBbA/5xV1UGaW9i0XsGEqDqGfahI=;
	b=i8j+aBLDphRM6zUF6HFxdRHncP0q6sjUHOT7LUoMnmK+o5mqEiwa7NtJ14YKIYOWTzVe
	 kc8aPKS2IpcaHn26LIUpZND8BFhfbXfxI6u8wmwogk0pfzH2P/bxNiPq/QliDF7rSvE7d
	 r6loiNsk/kYHK7gNyGEzuCwnYLAYfN8s4i8Jqbhx3wx83dVGM+LU4XQbvMKNBwfbUtqLh
	 tCOIMGTuUQ/w5GM4euI6RgHVjlaWfyvOcTMmTj6VfQMXjmVXUdqiw7R5FtRUMZatvAVKd
	 YbsZUsjVUDAWiezICTxLeSkAW3bYXmUL72t8xF1JoQijUkbEBYFl3uHzH/2p+oOri0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="18FXj/Wf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859EE606A31A;
	Wed, 28 Oct 2026 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18FXj/Wf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D673A1F01825;
	Wed, 28 Oct 2026 18:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210743;
	bh=0ZF4qDkq4jxhj1ZqBbA/5xV1UGaW9i0XsGEqDqGfahI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18FXj/Wf2TzPz0Li6cbRdBTMb95fofZvMoJ/L1nz3jXEUxBOjPdPzmjP42EZ8qFvj
	 nbBvYnvXnaImb5er2YnrClmpgN8r2Ae1/DBuangmR3AOia/SDwJZwjEHnnpqVOXauH
	 vNBC/SIiOlfb9QW9QNhTOTIWs/UEItIC2/6Zcy70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/571] scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature
Date: Wed, 28 Oct 2026 17:53:56 +0100
Message-ID: <20261028170010.136776288@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ made __update_rsp_in() unconditional before the availability check to accommodate 5.15’s conditional producer-pointer reads. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 509853860ada6..870962df1f9c9 100644
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
 
@@ -3963,10 +3955,25 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 					       "SCM not active for this port\n");
 					break;
 				}
+				__update_rsp_in(1, is_shadow_hba, rsp, rsp_in);
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
-				__update_rsp_in(follow_inptr, is_shadow_hba,
-						rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,
-- 
2.53.0



