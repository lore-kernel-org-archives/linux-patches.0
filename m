Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585493;
	b=2b8YrSs1LCeCZ3KHLz2JZTNsHILCqAAil28W2ZSv2JGZ/NrjtiXw/J/pgve9IaTXF4xv
	 YCYQQzQ8diqDr4tfppYlFkCJRrZn4BUiq/HYPZGSxO9caTCVJ4y7C8LGlImxQT1w221j5
	 7aHvCrI4o+SQW657bvPTUCrNu4EQcLH52jmuCURUOVM2nEl917H5B1Obd5jj9SNQfgk+E
	 e6rb/Gto85TyyfdevO6XBjn3WCYoH/fMi4RJcnVNIKRl7Jf+rhRwb75OggR4pCvIX4oQp
	 rcJQ6EMKl9exgZMDR9vWK6XPZdEScyQn/RruBytAk2G4+D80x0UqOOObd3D0/s+lbxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n7/gmC/Slu/bEuB41G/26A90hVwvyEtLTE73th85RVY=;
	b=tdOtpUlxpqRJZP+spye+gNbVC2Tpwcj1v8UGOFk2cgtcxp1OiYCfVEH3V25CWv4MM5XK
	 H0jdD+nc3yj+6CXew4Ig8brcmzhHT0kPYzM9ioIakrB+zunYdPL56WFC+35zWbCIbNm8c
	 uB0zxfsZ4QCUtETR5RvrhENXXKo53pRdodE95OArLvyOjtuMhwdwCIUdyOMKuUSMJUS1c
	 9305tcxriBmEccWnGj3NGI17to4o28k65j43OqKOFx4tD7yI3jt5m4Y4n9e0MVfMlTo8p
	 5tk130sgxIwswSD78NNTdAtCAWhYPsTKRJP1Ju886ZtABQGAqjLOqRgCBPUaHoAfD4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=atOijVlo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5582606AE01;
	Fri, 13 Nov 2026 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=atOijVlo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D3D1F000C5;
	Fri, 13 Nov 2026 15:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585493;
	bh=n7/gmC/Slu/bEuB41G/26A90hVwvyEtLTE73th85RVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=atOijVlod4uBAHvZGvLdLaiMvL1QX9FE/AY1qXdtnBU4786pGsQVeIlxlWKplkdg7
	 ZTjX3yMbU2KOCuzXtsEiHxVXf8+rdJQYYgnB4i87Bjf/fZarnWm2sfhuWKmWHap7qi
	 IYkZJA1GCoNpUDFsNTiC/p0uY2AhbZRt1Yf7rEbo=
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
Subject: [PATCH 7.3 101/507] scsi: target: Verify the iSCSI ISID is null-terminated
Date: Fri, 13 Nov 2026 10:46:45 -0500
Message-ID: <20261113153757.750563841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 2853b95b2c597..ad024009df56b 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -371,6 +371,16 @@ static bool iscsi_parse_pr_out_transport_id(
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



