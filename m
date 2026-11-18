Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026905;
	b=RyzUVh2V6w9krBfd/e5/PAhHNTFYsqw9LiLYTyCfGzdSz8NcBpC9U2IGz20jnfn7kQ9J
	 vZLKVMmpJ5gob8ERD2+SpRehz1CgnDJ50IS196R5dHNYinS0QN3cBqm4qIZPPW6RWHXH8
	 8W7FnGUp5Nn5OFFsUhahuq+TTWEHEE8uTKE7cQ1htsrLlOQPVpOK0TYBYE0nwEzmQbnCD
	 ZomxZfb9E4RVJGmj+z79tQkzcsZqntakYtk9J8DXsEX1JhMH/E7uW+9rK0h3BoQqbOmYA
	 3hh/dBW3ool0CJtwfw6XNYYIS9Jrqa0rrcx0qBYVBNBBdDy/eAXaEzE4a+0il5p4HgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mh2ikmqa6g1/hDJcE28C1H80OuPsbt0kjYAhKKNWEWA=;
	b=vxBVgNtBYfzpISRnUtTD5qekpn1jVKe4atth80VVs1ATWGJR1DwvuNN9XNn1OuBPDSjh
	 rx+RoG30dEOaFs7B6NGdo641CClzTbk7sRbBrqyEhfQsP88PtE7FR+SLsXXKoSGiCI/Ty
	 Gjxwzmbtkytnjns3QsqM71BzXWtSIrLSpWCAC2re5KzXGEDGaCbIB9XoI6CgMGfUAqk/i
	 y6iHfKPXtNnaespSxCjr/yWxe7rw/lQa/DzTVBCChAZ7M/l8oC1DPFdUZ1h2XL8CXnYPv
	 IFeVdvswNWa+37hbefY4R1qjPIe4UTGykBVHyPkTOX5nEPjfGB5UYGXYWOxvDJPB6JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1IL+KcF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF80606A31C;
	Wed, 18 Nov 2026 18:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1IL+KcF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616971F000C4;
	Wed, 18 Nov 2026 18:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026904;
	bh=Mh2ikmqa6g1/hDJcE28C1H80OuPsbt0kjYAhKKNWEWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w1IL+KcFlTbRK1V/nKQ2+cxvfkYQxJiIGg2Gx5bXM926ezja5hgdrH7On52dJNlP6
	 j/lzSVruEJhAai/pIHWqTac3XYvxag15ami7ZOW4CYcjGSCPV26v6GKMQwJR85h6g+
	 1AVJfFltb1/g2xYVhOvzZvvEdDXE6ugnjqyLW9KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1560/2151] scsi: scsi_debug: move ASC and ASCQ definitions to scsi_proto.h
Date: Wed, 18 Nov 2026 15:54:55 +0100
Message-ID: <20261118150218.716921529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 7c8b3f6578bb874ba9d334aef0e51fe931ce6c04 ]

The scsi_debug driver internally defines lots of SCSI additional sense
codes (ASC) and additional sense code qualifiers (ASCQ). Move these
definitions to include/scsi/scsi_proto.h so that they can be reused
elsewhere in the SCSI and ATA code. This also makes the scsi_debug.c file
a little smaller.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 92821c2358c7 ("scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 46 -----------------------------------
 include/scsi/scsi_proto.h | 51 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index bc0fe470f66fd..78504ee4d5161 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -67,52 +67,6 @@ static const char *sdebug_version_date = "20210520";
 
 #define MY_NAME "scsi_debug"
 
-/* Additional Sense Code (ASC) */
-#define NO_ADDITIONAL_SENSE 0x0
-#define OVERLAP_ATOMIC_COMMAND_ASC 0x0
-#define OVERLAP_ATOMIC_COMMAND_ASCQ 0x23
-#define FILEMARK_DETECTED_ASCQ 0x1
-#define EOP_EOM_DETECTED_ASCQ 0x2
-#define BEGINNING_OF_P_M_DETECTED_ASCQ 0x4
-#define EOD_DETECTED_ASCQ 0x5
-#define LOGICAL_UNIT_NOT_READY 0x4
-#define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
-#define UNRECOVERED_READ_ERR 0x11
-#define PARAMETER_LIST_LENGTH_ERR 0x1a
-#define INVALID_OPCODE 0x20
-#define LBA_OUT_OF_RANGE 0x21
-#define INVALID_FIELD_IN_CDB 0x24
-#define INVALID_FIELD_IN_PARAM_LIST 0x26
-#define WRITE_PROTECTED 0x27
-#define UA_READY_ASC 0x28
-#define UA_RESET_ASC 0x29
-#define UA_CHANGED_ASC 0x2a
-#define TOO_MANY_IN_PARTITION_ASC 0x3b
-#define TARGET_CHANGED_ASC 0x3f
-#define LUNS_CHANGED_ASCQ 0x0e
-#define INSUFF_RES_ASC 0x55
-#define INSUFF_RES_ASCQ 0x3
-#define POWER_ON_RESET_ASCQ 0x0
-#define POWER_ON_OCCURRED_ASCQ 0x1
-#define BUS_RESET_ASCQ 0x2	/* scsi bus reset occurred */
-#define MODE_CHANGED_ASCQ 0x1	/* mode parameters changed */
-#define CAPACITY_CHANGED_ASCQ 0x9
-#define SAVING_PARAMS_UNSUP 0x39
-#define TRANSPORT_PROBLEM 0x4b
-#define THRESHOLD_EXCEEDED 0x5d
-#define LOW_POWER_COND_ON 0x5e
-#define MISCOMPARE_VERIFY_ASC 0x1d
-#define MICROCODE_CHANGED_ASCQ 0x1	/* with TARGET_CHANGED_ASC */
-#define MICROCODE_CHANGED_WO_RESET_ASCQ 0x16
-#define WRITE_ERROR_ASC 0xc
-#define UNALIGNED_WRITE_ASCQ 0x4
-#define WRITE_BOUNDARY_ASCQ 0x5
-#define READ_INVDATA_ASCQ 0x6
-#define READ_BOUNDARY_ASCQ 0x7
-#define ATTEMPT_ACCESS_GAP 0x9
-#define INSUFF_ZONE_ASCQ 0xe
-/* see drivers/scsi/sense_codes.h */
-
 /* Additional Sense Code Qualifier (ASCQ) */
 #define ACK_NAK_TO 0x3
 
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index f64385cde5b93..965cde7ebc5b2 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -233,6 +233,57 @@ enum sam_status {
 #define MISCOMPARE          0x0e
 #define COMPLETED	    0x0f
 
+/*
+ * Additional Sense Codes (ASC).
+ */
+#define NO_ADDITIONAL_SENSE		0x00
+#define OVERLAP_ATOMIC_COMMAND_ASC	0x00
+#define LOGICAL_UNIT_NOT_READY		0x04
+#define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
+#define WRITE_ERROR_ASC			0x0c
+#define UNRECOVERED_READ_ERR		0x11
+#define PARAMETER_LIST_LENGTH_ERR	0x1a
+#define MISCOMPARE_VERIFY_ASC		0x1d
+#define INVALID_OPCODE			0x20
+#define LBA_OUT_OF_RANGE		0x21
+#define INVALID_FIELD_IN_CDB		0x24
+#define INVALID_FIELD_IN_PARAM_LIST	0x26
+#define WRITE_PROTECTED			0x27
+#define UA_READY_ASC			0x28
+#define UA_RESET_ASC			0x29
+#define UA_CHANGED_ASC			0x2a
+#define TOO_MANY_IN_PARTITION_ASC	0x3b
+#define TARGET_CHANGED_ASC		0x3f
+#define SAVING_PARAMS_UNSUP		0x39
+#define TRANSPORT_PROBLEM		0x4b
+#define INSUFF_RES_ASC			0x55
+#define LOW_POWER_COND_ON		0x5e
+#define THRESHOLD_EXCEEDED		0x5d
+
+/*
+ * Additional Sense Code Qualifiers (ASCQ).
+ */
+#define POWER_ON_RESET_ASCQ		0x00
+#define MODE_CHANGED_ASCQ		0x01	/* mode parameters changed */
+#define FILEMARK_DETECTED_ASCQ		0x01
+#define POWER_ON_OCCURRED_ASCQ		0x01
+#define MICROCODE_CHANGED_ASCQ		0x01	/* with TARGET_CHANGED_ASC */
+#define BUS_RESET_ASCQ			0x02	/* scsi bus reset occurred */
+#define EOP_EOM_DETECTED_ASCQ		0x02
+#define INSUFF_RES_ASCQ			0x03
+#define BEGINNING_OF_P_M_DETECTED_ASCQ	0x04
+#define UNALIGNED_WRITE_ASCQ		0x04
+#define EOD_DETECTED_ASCQ		0x05
+#define WRITE_BOUNDARY_ASCQ		0x05
+#define READ_INVDATA_ASCQ		0x06
+#define READ_BOUNDARY_ASCQ		0x07
+#define CAPACITY_CHANGED_ASCQ		0x09
+#define ATTEMPT_ACCESS_GAP		0x09
+#define LUNS_CHANGED_ASCQ		0x0e
+#define INSUFF_ZONE_ASCQ		0x0e
+#define MICROCODE_CHANGED_WO_RESET_ASCQ 0x16
+#define OVERLAP_ATOMIC_COMMAND_ASCQ	0x23
+
 /*
  *  DEVICE TYPES
  *  Please keep them in 0x%02x format for $MODALIAS to work
-- 
2.53.0



