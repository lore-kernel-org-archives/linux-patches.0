Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059008;
	b=JwdOOpOfUAHRVXL7srqh2wZNQhcaxUmiaWaPWVSWXiqV6XH5pJckCeSFxAYuyzBj7y14
	 Qk1F7ik5Gjiu0Qa7s4j141fev7UlwR+4H46YWkIo+wyaDCDG38gD+aKS0WFTxfPDsh7lB
	 9ZfmPdIfgm0UJT/s0edMCZaPQvR+o+C1KZWvuy6snPKjR9IbJlkgOvWc6y5zC2LI9RFxM
	 81Jpac+SjIhO+jANOZQnOAJld48p32PrcKbpR3R5Zb93k2+FXYM7nJtTOXZAfIjfFPJCA
	 UYn6IWE6GZb1OOUDElH3vz2LlGYIr1BRyCpZ9fOFTSX5JBJ24eNrhya3MW751jBUdzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Kf/vbOXQRdoMoYc6N2bLBNgyj25e07YDmT99kxjRbE=;
	b=LU+HfSdTZZnQ1HuyNZKhp0RWzxyxubTutKBKdAcvkw9k78Gdg3f1RxTCin31O7DSKIB+
	 5AkBkvYgP4HCIoJY6l0798i7yuZ/W0d14aRejmtL8NVmtFBNrvEMN2NSsabqK1KgpGbpn
	 T9ta2Scv1c3SCs+AKsxILde89yj9KIJsIciDxZJGWZdBLcTLvn5To6c6hdkjCXm/+/SzI
	 cf/uqGUccipVWJpKgZ8wgjozRI2rJTGibuSYPwjM4JfMMt/kZCFHRE/GCcl/2jWP6p745
	 PBukbxnwYy2IBUAzQ22JhVDQP1iI2g/zsD5BK32aFETRG6kcECKMrlno2XNdYGAQ7/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UHy4fq1h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C15F606A31C;
	Thu, 19 Nov 2026 03:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UHy4fq1h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DC51F000C9;
	Thu, 19 Nov 2026 03:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059008;
	bh=/Kf/vbOXQRdoMoYc6N2bLBNgyj25e07YDmT99kxjRbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHy4fq1hmWrg0KMLp9Tk3CIrXBuQj3zP4kZVULFOtocJTiiCD+j5zmUGsUoaG+TKU
	 xYeyKblmWyfJeWY+GIFFBFviEqSR5g73490wVAI/6wE6qzNT5CoqWtk5bMPZO9hzvB
	 7c9C9qWjD3ggaQxQa35mBDeNJKqY+tCK1Z6m8TBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kitta <kitta@linux.alibaba.com>,
	sashiko AI review <sashiko-bot@kernel.org>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	John Garry <john.garry@linux.dev>,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0689/1848] scsi: target: Verify the iSCSI ISID is null-terminated
Date: Wed, 18 Nov 2026 15:45:27 +0100
Message-ID: <20261118145944.782865275@linuxfoundation.org>
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

From: Yuanhe Shu <xiangzao@linux.alibaba.com>

[ Upstream commit cdf4b87a18cb6a0ee26865cb1b7b5660a491d302 ]

iscsi_parse_pr_out_transport_id() returns the ISID of a FORMAT CODE 01b
TransportID as a pointer into the PERSISTENT RESERVE OUT parameter list,
lowercased in place and never null-terminated.  spc4r37 Table 508 requires
the field to be null-terminated, but a non-conforming initiator can omit
the NULL; when the ISID ends at the end of the received buffer, the pointer
is not a C string.

The registration code still consumes it as one: strcmp() in
__core_scsi3_locate_pr_reg() and in the REGISTER AND MOVE path, and
snprintf("%s") in __core_scsi3_do_alloc_registration(), which also reads
its first 8 bytes unconditionally with get_unaligned_be64() - a NUL check
does not bound that read.

When the parameter list spans more than one page, transport_kmap_data_sg()
maps it with vmap(), and the over-read walks off the end of the mapping
into the vmalloc() guard page and oopses.  Reproduced with a PR OUT
REGISTER + SPEC_I_PT parameter list of exactly 8192 bytes whose final
TransportID carries a 12-byte ISID without a terminating NUL:

  BUG: unable to handle page fault for address: ffffc9000138c000
  RIP: 0010:strcmp+0xc/0x30
  Call Trace:
   __core_scsi3_locate_pr_reg+0xd3/0x120 [target_core_mod]
   core_scsi3_decode_spec_i_port+0x8fc/0x13a0 [target_core_mod]
   core_scsi3_emulate_pro_register+0x73c/0x900 [target_core_mod]
   ...
   iscsi_target_rx_thread+0xef/0x1d0 [iscsi_target_mod]

With a single-page parameter list the buffer is a kmap() direct mapping, so
the over-read continues into the physically adjacent page instead of
faulting.  snprintf("%s") then copies whatever follows the ISID in memory
into pr_reg_isid, and PR IN READ FULL STATUS reports the registration back
to any initiator, turning the over-read into an info leak of kernel heap
contents.  Reproduced with a 4096-byte parameter list whose last
TransportID ends at the end of the buffer with a 4-byte ISID and no NUL,
interleaved with I/O to populate adjacent pages: the READ FULL STATUS
response returned the ISID as "0xleak" followed by raw bytes that were not
part of the parameter list.  The snprintf() into
pr_reg_isid[PR_REG_ISID_LEN] caps the echoed ISID at 15 characters, so at
most 11 bytes past the buffer are leaked per command, but the PR OUT
command is not rate limited.

Any initiator that can send PR OUT to an iSCSI-exported LUN can trigger
either variant, including a guest via vhost-scsi.

Require 8 bytes to remain after the ",i,0x" separator, and a NUL inside the
rest of the descriptor, before the ISID pointer is returned.  REGISTER AND
MOVE fails with TCM_INVALID_PARAMETER_LIST; on SPEC_I_PT no target port
claims the malformed TransportID, and the command fails the same way.

Fixes: d04a179085c2 ("scsi: target: Bound PR-OUT TransportID parsing to the received buffer")
Reported-by: kitta <kitta@linux.alibaba.com>
Reported-by: sashiko AI review <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/sashiko-outbox-184760@kernel.org/
Cc: stable@vger.kernel.org
Cc: Bryam Vargas <hexlabsecurity@proton.me>
Cc: John Garry <john.garry@linux.dev>
Assisted-by: LLM
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Link: https://patch.msgid.link/20261026124138.2708365-1-xiangzao@linux.alibaba.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_fabric_lib.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 8deadabca8884..be92cd880d207 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -370,6 +370,16 @@ static bool iscsi_parse_pr_out_transport_id(
 			pr_err("Missing ISID in iSCSI Initiator port TransportID\n");
 			return false;
 		}
+		/*
+		 * The registration code reads the ISID as a C string,
+		 * and its first 8 bytes with get_unaligned_be64(), so
+		 * require 8 bytes after the separator and a NUL inside
+		 * the rest of the descriptor.
+		 */
+		if (buf + tid_len - p < 8 || !memchr(p, '\0', buf + tid_len - p)) {
+			pr_err("Incomplete or unterminated ISID in iSCSI Initiator port TransportID\n");
+			return false;
+		}
 		*port_nexus_ptr = p;
 		/*
 		 * Go ahead and do the lower case conversion of the received
-- 
2.53.0



