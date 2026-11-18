Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039823;
	b=3s89nfgOqHDx0oK7kN2BTYXchRb/EyioY9QdEf13Ws+eWkTjWjwGXlfE3s68Z5NDQlpg
	 AxbCpeJ1l3QkzWWgGFrtx9/eBcjrFiDGW7vuk9tZqJqWI3jdraV/3HBCbWRRdrbV6t7FL
	 IiKrvzl55s/glj3MSIduuJRSIep+QDGC00d4obybRiC29OoGGqVqMaGPyBnHYgf6BsWJ3
	 zD2a51wTixzcgSlIB+uzz+JqjW7giY4EYugU1XBrFA/6a5Xg7hS2UZFCpW99m9eN7pITD
	 kJZqI1z3RnKo3eIoE2LzEb8/YmPd5q2NGqB7+B2X3JxOzMAeVuZltIO9dDqWcc6GgvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rJAWRjIk1ybNKXp0PwCHga+sBzkUTT9st/upV0Va3/M=;
	b=wTrtOIocsp931VVMVF9vYVxcDb7dODZWiyk1SLPkYnMUU0MyFOQ8OgB7eNc1NXH8t8sG
	 boCOljRGP5MpnsbAVozE3c1LvEejz2oGHcghZUYf0yfaXahTLMgHKjJQ+NgJg3KNJKL2p
	 g18CxOanztv09Cpk3Gbtw/Cavt6+g0RBXvPcS/lrKA31lzdWLs7FxEBcsOF5zTjuUdTr9
	 EIFnO07EuVODTNmTFMa1lOMai9VIZ/kHKW+TqpyNzF4IBAxmiVNpcOqKS5YWvRMnZ4anO
	 7PwXPrHUFsyoJdS1VijSL5rxzy4mSfkVRLdZLEpRfmqIzwRqaqInXLYPTr+DvhyAAQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5sG288W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91D2606A320;
	Wed, 18 Nov 2026 22:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5sG288W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F581F000C4;
	Wed, 18 Nov 2026 22:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039823;
	bh=rJAWRjIk1ybNKXp0PwCHga+sBzkUTT9st/upV0Va3/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5sG288WEdt0Jl0sjgb4Knnsh2qerSGwyEFZEq/+2Tc8T9KI/pgM+3S098yomxAeY
	 rtw3CCwFEO+j6rI93twYbSqaHFCjJwde/JvjXzya2Euzf03zVuk4RRemLp7SZvrSsJ
	 dDd9uZqJdKMw8R1pI3CD8sjIoTmXvz/RbHblCzGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2239/3318] scsi: pm8001: Fix SATA FIS offset in struct hw_event_resp
Date: Wed, 18 Nov 2026 15:47:41 +0100
Message-ID: <20261118150429.024982543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit cdc97921de02a0c1a8324afa03e8b3e30a72bbe6 ]

In struct hw_event_resp, sas_identify was defined using struct
sas_identify_frame, which is 32 bytes long because it includes a 4-byte CRC
field. However, PM8001 and PM80xx hardware does not send the CRC in the
event response frame, providing only the 28-byte identify payload.

Because sas_identify had a size of 32 bytes, the following sata_fis member
was located at byte offset 44 instead of the actual hardware offset 40. In
hw_event_sata_phy_up(), this discrepancy was worked around with negative
pointer arithmetic: ((u8 *)&pPayload->sata_fis - 4).  This triggers a
compiler error under Clang with -Wstringop-overread:

  error: 'memcpy' reading 20 bytes from a region of size 0
  [-Werror,-Wstringop-overread]
          memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),

Move struct sas_identify_frame_local (28 bytes) into pm8001_defs.h, and
update struct hw_event_resp in both pm8001_hwi.h and pm80xx_hwi.h to use
struct sas_identify_frame_local followed by sata_fis and a 4-byte padding
word. This correctly aligns sata_fis at byte offset 40 while maintaining
the 64-byte total payload size.

Update hw_event_sata_phy_up() in pm8001_hwi.c and pm80xx_hwi.c to copy
directly from &pPayload->sata_fis.

Compile-tested only. Both the patch and its description have been generated
by Gemini.

Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware functionalities and relevant changes in common files")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/31963d53810f42970447e78ef46030ab13d2e91f.1788198434.git.bvanassche@acm.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_defs.h |  98 +++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm8001_hwi.c  |   2 +-
 drivers/scsi/pm8001/pm8001_hwi.h  |   4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  |   2 +-
 drivers/scsi/pm8001/pm80xx_hwi.h  | 100 +-----------------------------
 5 files changed, 106 insertions(+), 100 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index 501b574239e8b..ff7b282090792 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -41,6 +41,104 @@
 #ifndef _PM8001_DEFS_H_
 #define _PM8001_DEFS_H_
 
+#include <scsi/sas.h>
+
+#ifdef __LITTLE_ENDIAN_BITFIELD
+struct sas_identify_frame_local {
+	/* Byte 0 */
+	u8  frame_type:4;
+	u8  dev_type:3;
+	u8  _un0:1;
+
+	/* Byte 1 */
+	u8  _un1;
+
+	/* Byte 2 */
+	union {
+		struct {
+			u8  _un20:1;
+			u8  smp_iport:1;
+			u8  stp_iport:1;
+			u8  ssp_iport:1;
+			u8  _un247:4;
+		};
+		u8 initiator_bits;
+	};
+
+	/* Byte 3 */
+	union {
+		struct {
+			u8  _un30:1;
+			u8 smp_tport:1;
+			u8 stp_tport:1;
+			u8 ssp_tport:1;
+			u8 _un347:4;
+		};
+		u8 target_bits;
+	};
+
+	/* Byte 4 - 11 */
+	u8 _un4_11[8];
+
+	/* Byte 12 - 19 */
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	/* Byte 20 */
+	u8 phy_id;
+
+	u8 _un21_27[7];
+
+} __packed;
+
+#elif defined(__BIG_ENDIAN_BITFIELD)
+struct sas_identify_frame_local {
+	/* Byte 0 */
+	u8  _un0:1;
+	u8  dev_type:3;
+	u8  frame_type:4;
+
+	/* Byte 1 */
+	u8  _un1;
+
+	/* Byte 2 */
+	union {
+		struct {
+			u8  _un247:4;
+			u8  ssp_iport:1;
+			u8  stp_iport:1;
+			u8  smp_iport:1;
+			u8  _un20:1;
+		};
+		u8 initiator_bits;
+	};
+
+	/* Byte 3 */
+	union {
+		struct {
+			u8 _un347:4;
+			u8 ssp_tport:1;
+			u8 stp_tport:1;
+			u8 smp_tport:1;
+			u8 _un30:1;
+		};
+		u8 target_bits;
+	};
+
+	/* Byte 4 - 11 */
+	u8 _un4_11[8];
+
+	/* Byte 12 - 19 */
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	/* Byte 20 */
+	u8 phy_id;
+
+	u8 _un21_27[7];
+} __packed;
+#else
+#error "Bitfield order not defined!"
+#endif
+
 enum chip_flavors {
 	chip_8001,
 	chip_8008,
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 90069c7b16425..ad2a4ab74d543 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3265,7 +3265,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
 	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
-	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
+	memcpy(phy->frame_rcvd, &pPayload->sata_fis,
 		sizeof(struct dev_to_host_fis));
 	phy->frame_rcvd_size = sizeof(struct dev_to_host_fis);
 	phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index fc2127dcb58d9..b44edcd8be52f 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -42,6 +42,7 @@
 
 #include <linux/types.h>
 #include <scsi/libsas.h>
+#include "pm8001_defs.h"
 
 
 /* for Request Opcode of IOMB */
@@ -229,8 +230,9 @@ struct hw_event_resp {
 	__le32	lr_evt_status_phyid_portid;
 	__le32	evt_param;
 	__le32	npip_portstate;
-	struct sas_identify_frame	sas_identify;
+	struct sas_identify_frame_local	sas_identify;
 	struct dev_to_host_fis	sata_fis;
+	u32	_r_a;
 } __attribute__((packed, aligned(4)));
 
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index a84447b674207..ab8e5b3fbd05d 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3261,7 +3261,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
 	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
-	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
+	memcpy(phy->frame_rcvd, &pPayload->sata_fis,
 		sizeof(struct dev_to_host_fis));
 	phy->frame_rcvd_size = sizeof(struct dev_to_host_fis);
 	phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index eb8fd37b20661..dd735102c7706 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -43,6 +43,7 @@
 
 #include <linux/types.h>
 #include <scsi/libsas.h>
+#include "pm8001_defs.h"
 
 /* for Request Opcode of IOMB */
 #define OPC_INB_ECHO				1	/* 0x000 */
@@ -236,102 +237,6 @@
 /* Port recovery timeout, 10000 ms for PM8006 controller */
 #define CHIP_8006_PORT_RECOVERY_TIMEOUT 0x640000
 
-#ifdef __LITTLE_ENDIAN_BITFIELD
-struct sas_identify_frame_local {
-	/* Byte 0 */
-	u8  frame_type:4;
-	u8  dev_type:3;
-	u8  _un0:1;
-
-	/* Byte 1 */
-	u8  _un1;
-
-	/* Byte 2 */
-	union {
-		struct {
-			u8  _un20:1;
-			u8  smp_iport:1;
-			u8  stp_iport:1;
-			u8  ssp_iport:1;
-			u8  _un247:4;
-		};
-		u8 initiator_bits;
-	};
-
-	/* Byte 3 */
-	union {
-		struct {
-			u8  _un30:1;
-			u8 smp_tport:1;
-			u8 stp_tport:1;
-			u8 ssp_tport:1;
-			u8 _un347:4;
-		};
-		u8 target_bits;
-	};
-
-	/* Byte 4 - 11 */
-	u8 _un4_11[8];
-
-	/* Byte 12 - 19 */
-	u8 sas_addr[SAS_ADDR_SIZE];
-
-	/* Byte 20 */
-	u8 phy_id;
-
-	u8 _un21_27[7];
-
-} __packed;
-
-#elif defined(__BIG_ENDIAN_BITFIELD)
-struct sas_identify_frame_local {
-	/* Byte 0 */
-	u8  _un0:1;
-	u8  dev_type:3;
-	u8  frame_type:4;
-
-	/* Byte 1 */
-	u8  _un1;
-
-	/* Byte 2 */
-	union {
-		struct {
-			u8  _un247:4;
-			u8  ssp_iport:1;
-			u8  stp_iport:1;
-			u8  smp_iport:1;
-			u8  _un20:1;
-		};
-		u8 initiator_bits;
-	};
-
-	/* Byte 3 */
-	union {
-		struct {
-			u8 _un347:4;
-			u8 ssp_tport:1;
-			u8 stp_tport:1;
-			u8 smp_tport:1;
-			u8 _un30:1;
-		};
-		u8 target_bits;
-	};
-
-	/* Byte 4 - 11 */
-	u8 _un4_11[8];
-
-	/* Byte 12 - 19 */
-	u8 sas_addr[SAS_ADDR_SIZE];
-
-	/* Byte 20 */
-	u8 phy_id;
-
-	u8 _un21_27[7];
-} __packed;
-#else
-#error "Bitfield order not defined!"
-#endif
-
 struct mpi_msg_hdr {
 	__le32	header;	/* Bits [11:0] - Message operation code */
 	/* Bits [15:12] - Message Category */
@@ -427,8 +332,9 @@ struct hw_event_resp {
 	__le32	lr_status_evt_portid;
 	__le32	evt_param;
 	__le32	phyid_npip_portstate;
-	struct sas_identify_frame	sas_identify;
+	struct sas_identify_frame_local	sas_identify;
 	struct dev_to_host_fis	sata_fis;
+	u32	_r_a;
 } __attribute__((packed, aligned(4)));
 
 /*
-- 
2.53.0



