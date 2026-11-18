Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034532;
	b=oDbRIiXVhmm3mwASThpbxEl0QdjvEYAHE4POYGzkhANWnkTCuPtSx+ztAufLy1KHHl7b
	 7HMDkxVtK3qUORy7jFlqNYwUrBvlpJr8heZoJV9XXEv0UDeXKPDWnz047ubfCXyq1EKdz
	 b5Rf/WoN2ZpJlAaYhT9caVA5dw1qkopHkH/cszgaehSxLBlqkb5KKR79SiK651bjID16O
	 G96S6xRxuYcxTswqmk0UPkkIDCTeQLBHXnBcnc8epUPl/4nBLp5NCw49pJQNkXpr7bVcF
	 psyyWxjp0l+FiiH6aWlyw4wrYAN3DFighr3SGUF8y6tRUxi58Wi3qqyf/+lWKkJKCaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eFaeCslYaIG6bMAaDp+Mp5hKHyRjfn8HhdcF6ROJdww=;
	b=Qprnc4r9xM+GPNystpwyggMOly+ZnxyajWT6uzUEShUHovntwveyF92VICMjX8EWxys5
	 J7ZkPC+RN/Fu4BF2kGM/kpPjM8prlhLBY6aLMfZh2rOM+s8oZyAmpnrD7qDoJLLaakq1d
	 mSflTSdHAzuUL7PuGXIulQYU1yjJc2uLrmRA1hJYB2x3ZIKrAHMTYRIlJRGjyJNE1myJ2
	 oacQZFhg0nMhbW7Wy3R0yPcEhkpXwogRkaqRlCUKMKFv74atTM7qVWjl/6+g6zrPLFRgZ
	 6jMX1WEq5TKpJjHTntiQD4xtkxgk2H83e3zPYCfmZOL6b9DNEjxoN2wcmyXmCtCvb4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nkcxj8Bd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1109E606A32A;
	Wed, 18 Nov 2026 20:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nkcxj8Bd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6615F1F000C7;
	Wed, 18 Nov 2026 20:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034531;
	bh=eFaeCslYaIG6bMAaDp+Mp5hKHyRjfn8HhdcF6ROJdww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nkcxj8Bd8s3PLrDUeZLooHvpFT4szOP18Vj6Ygr2yMO4QZQiY/vsj8Z+nlLE6DP5/
	 8yoQghNKHOJH7NbbT56pOvSX2lO6MEFl5e+cRFN4IFdsQYmXLaaVx8/T6XW5HiS3l0
	 fOHqil2nQRpXzN3wkamjwGMJVOVzfwYNN0LwxAk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0403/3318] scsi: qla2xxx: Clamp max_npiv_vports to VP_CTRL bitmap capacity
Date: Wed, 18 Nov 2026 15:17:05 +0100
Message-ID: <20261118150328.523719966@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 2ac6a829843cf3df522d19e091276109b94c4c7a ]

ha->max_npiv_vports is taken from firmware (mcp->mb[11]) and only
constrained so that (max_npiv_vports + 1) is a multiple of
MIN_MULTI_ID_FABRIC, which permits values of 63, 127, 191 and 255.
NPIV vports are then allocated up to that count.

VP enable uses the VP_CONFIG IOCB, which addresses a vport through a
plain vp_index byte, so a vp_index beyond 128 is enabled without issue.
VP disable, however, uses the VP_CTRL IOCB, which selects target vports
through the fixed 128-bit vp_idx_map bitmap. qla24xx_control_vp()
rejects a vp_index past that bitmap and the IOCB builder cannot set a bit
beyond 127, yet qla24xx_vport_delete() frees the local state regardless.
A vport with vp_index > 128 can therefore be created and enabled but
never disabled, leaving it permanently active in firmware: a resource
leak.

Cap ha->max_npiv_vports at init to the vp_idx_map capacity so such
vports are never created. This collapses 191/255 to 127 (still
modulo-valid) and leaves the real-world 63/127 cases unaffected.

Fixes: 4d0ea24769c8 ("[SCSI] qla2xxx: Retrieve max-NPIV support capabilities from FW.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-20-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_fw.h   |  4 ++++
 drivers/scsi/qla2xxx/qla_init.c | 13 +++++++++++++
 drivers/scsi/qla2xxx/qla_mid.c  |  2 +-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index f307beed9d29d..e7ded95afb9a8 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1442,6 +1442,10 @@ struct vp_ctrl_entry_24xx {
 	uint8_t reserved_5[24];
 };
 
+/* vp_idx_map is a 128-bit (16-byte) bitmap selecting target VPs. */
+#define VP_CTRL_IDX_MAP_BITS \
+	(sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
+
 /*
  * Modify Virtual Port Configuration IOCB
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 914b5993d110f..374dba3216ad5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4408,6 +4408,19 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 					    MIN_MULTI_ID_FABRIC))
 						ha->max_npiv_vports =
 						    MIN_MULTI_ID_FABRIC - 1;
+
+					/*
+					 * The VP_CTRL IOCB selects target VPs
+					 * through the fixed vp_idx_map bitmap,
+					 * so a vp_index beyond it can be enabled
+					 * via VP_CONFIG but never disabled via
+					 * VP_CTRL, leaking the VP.  Cap the count
+					 * to the bitmap capacity.
+					 */
+					if (ha->max_npiv_vports >=
+					    VP_CTRL_IDX_MAP_BITS)
+						ha->max_npiv_vports =
+						    VP_CTRL_IDX_MAP_BITS - 1;
 				}
 				qla2x00_get_resource_cnts(vha);
 				qla_init_iocb_limit(vha);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 86c0217d1763e..27ca16a7f1aab 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -967,7 +967,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	 * (16-byte) vp_idx_map bitmap, so vp_index must fit within it even
 	 * if firmware advertises more NPIV vports.
 	 */
-	if (vp_index > sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
+	if (vp_index > VP_CTRL_IDX_MAP_BITS)
 		return QLA_PARAMETER_ERROR;
 
 	/* ref: INIT */
-- 
2.53.0



