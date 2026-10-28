Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208366;
	b=O7LaxubITeQYdIn4ZIGrNnBMufhLOhQqxaioTlXD+h5B7ueML6EwcKcc8JAvMOKX3DvK
	 XBVqA2PVIRtUEaeWsc2bKrPv2tXZfb20OO0JUXj5ZRmFpnSk3sMV2wesLnFtu8yGD4rQC
	 6bvys/aHUo/0rmpBXlQmipDkyutIbWgNLdKcqk7otnJlyOWLN2UYeQ3XP/QmxYI4a3/uL
	 dvzpucq7/00M8KI9AXJ2BnpffU7wkR/CSctogZzId1lefIBlcSrjaC5PITDED/bmfL17m
	 H2KKgPKMjFZO1ebJ25j2Bl23PYselWzQLjxX9bmQJwjrAXDbRQBgVI+QrqUX3qCe72g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vxVZD9hpERzPH38ArUyNGRHqERZE3uGAb7cRvQDBrGM=;
	b=1lRoeJgoq4VGGKND6ZexhglrrkTTZON3BcE9EUrdOY/y1bIt3JkMvBqsSF9RXOTt2+qI
	 rsLrTCWbca2ZGRPzvowoLVpMPngp5KFokNbnDWtqvvbvWIk8gkP33EqATWICNgGjpVnop
	 4xTAMlg+Pxwm+fyC+YTUzqikUboqLBaL0YrPBEuJoypowdY2ZHWaSJFQVpYWXhnKOWw98
	 J/o7Byfp+qmmyWxfxRLXPmBiNq1M1AZVvgk+7WIkQa7rLpt+VdHWyKWTU4avrjJNspMlJ
	 1fg8mHcRQt8pON92b0oW4mogmRSw5KvPhwbBDw/EIBxlYPTVMDPxFH8ZQhrES9BhLSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OKrSrWR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AF1606A31C;
	Wed, 28 Oct 2026 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OKrSrWR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F011F01825;
	Wed, 28 Oct 2026 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208366;
	bh=vxVZD9hpERzPH38ArUyNGRHqERZE3uGAb7cRvQDBrGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKrSrWR0X7Gk3lCs6SyNltM54DfFbn234JS+MmaBlohj6TPv3X0myzI7vcGYW0XQz
	 /3Iiz9tSn5DPbcL7577UWFD6UTgwpp7lturPKj3RGdcGwKf9O4ZmGPj+yNxQugGMQy
	 5VTTx/ZwQ3oCD8kO0ElnatgPeSyYMhkDo7Nldeek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/516] scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot
Date: Wed, 28 Oct 2026 17:54:04 +0100
Message-ID: <20261028170005.702147044@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 626e44f3d8a924a97a3848a9fd45833947e081e9 ]

For QLAFX00 the request ring is ioremapped device I/O memory
(ha->iobase + req_que_off), not DMA-coherent RAM, which is why the rest
of the FX00 path accesses it through memcpy_toio() and the wrt_reg_*
helpers. __qla2x00_alloc_iocbs() however zeroed the producer slot with a
plain memset(). On architectures such as ARM64 a regular memset() may
emit unaligned or block-zeroing instructions (e.g. DC ZVA) that are
invalid on Device memory, leading to a synchronous external abort.

Use memset_io() to clear the slot for QLAFX00, matching the I/O
accessors used elsewhere on this ring. Other adapters keep the plain
memset() on their DMA-coherent rings. The zero-fill is retained for FX00
because its IOCB builders (e.g. qlafx00_fxdisc_iocb()) copy only part of
the entry and rely on the unused tail being pre-zeroed.

Fixes: 8ae6d9c7eb10 ("[SCSI] qla2xxx: Enhancements to support ISPFx00.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-12-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ replaced qla_req_ring_slot() and qla_req_entry_size() with req->ring_ptr and REQUEST_ENTRY_SIZE. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 1752a62031710..327ffa36774e4 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2363,11 +2363,13 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	/* Prep packet */
 	req->cnt -= req_cnt;
 	pkt = req->ring_ptr;
-	memset(pkt, 0, REQUEST_ENTRY_SIZE);
 	if (IS_QLAFX00(ha)) {
+		memset_io((void __iomem __force *)pkt, 0,
+			  REQUEST_ENTRY_SIZE);
 		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
 		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);
 	} else {
+		memset(pkt, 0, REQUEST_ENTRY_SIZE);
 		pkt->entry_count = req_cnt;
 		pkt->handle = handle;
 	}
-- 
2.53.0



