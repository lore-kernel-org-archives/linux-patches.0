Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053249;
	b=qz5wMLOU/IZ8ZnqJgFaCvRsTQB6Mx61rpepn5KY5Z1fJNk9FoJJAegGifOHEp/oshamP
	 ukfs8w2H7CE6Afuo8CL4S0t+IC3sIwXFJnpOXLwYJ8SGNgG4r+mSRk7n6nEf1J4HD9Mqj
	 hraHrEaGUFAtDnr7gMmtQr54yTxZJghrGxeHP79fbIc8EU+lHtzUrwRaJnnkWjE1ardtB
	 myStfSzx8/CyCedsuCmqPz54cVLUINE3AePQFt8sOYYqes00XCuGcojKrkvGqKN+QSrbR
	 A71eAD+Pxjmtfwllcg/17Kdx4geOYCeymHTXwX2blrTPrS13sop0jzIjkMZficuMtcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CNfrJm4q4FJmPJPKa4RBqyW7lZp75A/gydKlAOc7Z1o=;
	b=bzoPtg08n9H3iLo6BhOLckoZvdM/ma61kt1nSpK2zxugM/Z342Drs1XfZh1MIu9YlZ/V
	 yJ37yvYZsVp2vHvOLZ65go1Iuhz9WdIjTrG17RUHmYaix23a955uFsj0sHWoemtpzlRd3
	 ndn/lNfkTeAb9lN4Jx424R5WSxfMir+InJAwfTJUP61PGLeM7FZEEozyDo0Pj2V+9YO1Z
	 1E4V1DJFVgfI02BOnUZiasaQzQaKt/RkxT/GIwLgZRCVHsVgnLVxh54masU5kXO+YWUVG
	 lARUC8TAoBQp7nTUAPzF7VKMAC5OmrpiUcwdXbm7vnsvOlVdLdu4KYDmxt90OL5P5fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDcidzQp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CAC606A31C;
	Thu, 19 Nov 2026 01:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDcidzQp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EA01F000C4;
	Thu, 19 Nov 2026 01:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053248;
	bh=CNfrJm4q4FJmPJPKa4RBqyW7lZp75A/gydKlAOc7Z1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDcidzQpC2k4I72Emp/Zgm+VxMssQmwOJNAtLVvmizSWvww2/CRqxXrYWnkaas3GF
	 qbt4Ua10p+mx/KwgTqwWxeUxN5bxFuvjTheyNGiJ2ThSyX3Q3meqxKI2TiSej3h/IL
	 WnVlfrUCGvS2wreTW+rW5R6HLwuTRXtbjLP7eUJY=
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
Subject: [PATCH 5.15 0853/2214] scsi: target: Verify the iSCSI ISID is null-terminated
Date: Wed, 18 Nov 2026 15:42:09 +0100
Message-ID: <20261118150046.281770581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



