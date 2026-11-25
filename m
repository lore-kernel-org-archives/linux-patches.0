Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617821;
	b=PvZPKe+gkr0kF4OIaPGr1CAWDB0uX14wGjnKH5MoUHDSKQXLJ4bVZzxs+HKXTIJ+R0jM
	 c/p7qzshBLWQWxClshORV+QPK70qfDJ0hZxuIx7nbZvbSCOil8WbkhjJ53LXAD/ILUcdy
	 ZlHMAmge+ssXYZgg9yrOAd6CXO2lOOz2DvK7SnvYR3SXPqorhVIXlBixRBCYk7YRMzH/Y
	 E4S2iQA+mkNi3vAInOhMZlwWBK31pYGnZUKP8FnG5E9YkSpMsM9WqF85CiV51maQ1SCus
	 x2mntFHpwo/XLeN/+e8EvUto2rR23ct7KkGHdeVim+g8f20naNxuOZ1fwlcmogVe7HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rvLJt6cYmtGUWc8MJb2CVBk8ShoxlvrrFyeoX1nPvD4=;
	b=QmEP/EsV7UnRQEq2EwfjYZXI54VX+CWvhAsheq3tqSTBNVEiB0np1c3YqJ3gXVapDCOu
	 xXc/H6vD0jW7gAbVXp/Eu/DdKQBT0d1zQn7FOiJYauqpAhidKkjOTmMPTaRYpQTbH7h5U
	 vgVbVYb7u17WQGCtWWMoy9ErghK0MvsS9TPkzdCbNDjhpUdL22ltcW6Vkp4QC/D8E6YhU
	 cH6+En22q5YvPY0TfTpzys8gYX1W/i9jdCAuGmznaMeCSs2kk3luvbAdrbNnJDOF/dQ91
	 iuJFvOnzFAeG1S+6/KVIev/3Su82Mf24niMQBliXzvVJvZ1UJo36D6ML4nLL6S4Ni5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cEcR7WMt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8A7606A321;
	Wed, 25 Nov 2026 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cEcR7WMt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1561F000C6;
	Wed, 25 Nov 2026 14:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617821;
	bh=rvLJt6cYmtGUWc8MJb2CVBk8ShoxlvrrFyeoX1nPvD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEcR7WMtqTm2HiMd75w+C/YBPVTl/9qH2OHJMBRuknovAKnttUika83uy2EiYFKWr
	 7Jglbtk+6Ix7m8Gi3G0+CLs5Fq9FM+Myvhu6ZTk1FDCHLwG3RBELxpI+sWyBpyOPh3
	 2M0Bsc791lrI7gH3byxbU5WtlFeZooj/kznzhbY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0086/1005] scsi: mpt3sas: Use combined sense codes
Date: Wed, 25 Nov 2026 15:23:44 +0100
Message-ID: <20261125143823.755318513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit f2e04ffb273e60aba6d39fc0c591bd1d8f4d9018 ]

Refactor the mpt3sas driver to replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260908090308.1085097-18-dlemoal@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Stable-dep-of: d58e6d962e5b ("scsi: mpt3sas: Register devices during SANITIZE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 69 +++++++++++++++-------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 0e12009a87f62..085d4672db854 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5401,23 +5401,23 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 static void
 _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 {
-	u8 ascq;
+	u16 sense_code;
 
 	switch (ioc_status) {
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
-		ascq = 0x01;
+		sense_code = LOGICAL_BLOCK_GUARD_CHECK_FAILED;
 		break;
 	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
-		ascq = 0x02;
+		sense_code = LOGICAL_BLOCK_APPLICATION_TAG_CHECK_FAILED;
 		break;
 	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
-		ascq = 0x03;
+		sense_code = LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED;
 		break;
 	default:
-		ascq = 0x00;
+		sense_code = ID_CRC_OR_ECC_ERROR;
 		break;
 	}
-	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x10, ascq);
+	scsi_set_sense(scmd, 0, ILLEGAL_REQUEST, sense_code);
 	set_host_byte(scmd, DID_ABORT);
 }
 
@@ -5474,7 +5474,8 @@ static enum scsi_qc_status scsih_qcmd(struct Scsi_Host *shost,
 	if (handle == MPT3SAS_INVALID_DEVICE_HANDLE || sas_device_priv_data->block) {
 		if (scsi_get_host_state(scmd->device->host) == SHOST_RECOVERY &&
 		    scmd->cmnd[0] == TEST_UNIT_READY) {
-			scsi_build_sense(scmd, 0, UNIT_ATTENTION, 0x29, 0x07);
+			scsi_set_sense(scmd, 0, UNIT_ATTENTION,
+				       I_T_NEXUS_LOSS_OCCURRED);
 			scsi_done(scmd);
 			return 0;
 		}
@@ -5986,7 +5987,7 @@ _scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	event_data = (Mpi2EventDataSasDeviceStatusChange_t *)
 	    event_reply->EventData;
 	event_data->ReasonCode = MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA;
-	event_data->ASC = 0x5D;
+	event_data->ASC = ASC_FAILURE_PREDICTION_THRESHOLD_EXCEEDED;
 	event_data->DevHandle = cpu_to_le16(handle);
 	event_data->SASAddress = cpu_to_le64(sas_target_priv_data->sas_address);
 	mpt3sas_ctl_add_to_event_log(ioc, event_reply);
@@ -6109,8 +6110,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		    le32_to_cpu(mpi_reply->SenseCount));
 		memcpy(scmd->sense_buffer, sense_data, sz);
 		_scsih_normalize_sense(scmd->sense_buffer, &data);
-		/* failure prediction threshold exceeded */
-		if (data.asc == 0x5D)
+		if (data.asc == ASC_FAILURE_PREDICTION_THRESHOLD_EXCEEDED)
 			_scsih_smart_predicted_fault(ioc,
 			    le16_to_cpu(mpi_reply->DevHandle));
 		mpt3sas_trigger_scsi(ioc, data.skey, data.asc, data.ascq);
@@ -6199,8 +6199,8 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		else if (!xfer_cnt && scmd->cmnd[0] == REPORT_LUNS) {
 			mpi_reply->SCSIState = MPI2_SCSI_STATE_AUTOSENSE_VALID;
 			mpi_reply->SCSIStatus = SAM_STAT_CHECK_CONDITION;
-			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST,
-					 0x20, 0);
+			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
+				       INVALID_COMMAND_OP_CODE);
 		}
 		break;
 
@@ -7691,38 +7691,41 @@ _scsih_determine_disposition(struct MPT3SAS_ADAPTER *ioc,
 
 	if (check_sense) {
 		_scsih_normalize_sense(transfer_packet->sense, &sense_info);
-		if (sense_info.skey == UNIT_ATTENTION)
+		if (sense_info.skey == UNIT_ATTENTION) {
 			rc = DEVICE_RETRY_UA;
-		else if (sense_info.skey == NOT_READY) {
-			/* medium isn't present */
-			if (sense_info.asc == 0x3a)
+		} else if (sense_info.skey == NOT_READY) {
+			if (sense_info.asc == ASC_MEDIUM_NOT_PRESENT) {
 				rc = DEVICE_READY;
-			/* LOGICAL UNIT NOT READY */
-			else if (sense_info.asc == 0x04) {
-				if (sense_info.ascq == 0x03 ||
-				   sense_info.ascq == 0x0b ||
-				   sense_info.ascq == 0x0c) {
+			} else if (sense_info.asc == ASC_LU_NOT_READY) {
+				u16 scode = scsi_sense_code(sense_info.asc,
+							    sense_info.ascq);
+
+				if (scode ==
+				    LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED ||
+				    scode ==
+				    LU_NOT_ACCESSIBLE_TARGET_PORT_IN_STANDBY_STATE ||
+				    scode ==
+				    LU_NOT_ACCESSIBLE_TARGET_PORT_IN_UNAVAILABLE_STATE)
 					rc = DEVICE_ERROR;
-				} else
+				else
 					rc = DEVICE_START_UNIT;
-			}
-			/* LOGICAL UNIT HAS NOT SELF-CONFIGURED YET */
-			else if (sense_info.asc == 0x3e && !sense_info.ascq)
+			} else if (sense_info.asc ==
+				   ASC_LU_HAS_NOT_SELF_CONFIGURED_YET &&
+				   !sense_info.ascq) {
 				rc = DEVICE_START_UNIT;
+			}
 		} else if (sense_info.skey == ILLEGAL_REQUEST &&
-		    transfer_packet->cdb[0] == REPORT_LUNS) {
+			   transfer_packet->cdb[0] == REPORT_LUNS) {
 			rc = DEVICE_READY;
 		} else if (sense_info.skey == MEDIUM_ERROR) {
-
-			/* medium is corrupt, lets add the device so
-			 * users can collect some info as needed
+			/*
+			 * medium is corrupt, lets add the device so users can
+			 * collect some info as needed
 			 */
-
-			if (sense_info.asc == 0x31)
+			if (sense_info.asc == ASC_MEDIUM_FORMAT_CORRUPTED)
 				rc = DEVICE_READY;
 		} else if (sense_info.skey == HARDWARE_ERROR) {
-			/* Defect List Error, still add the device */
-			if (sense_info.asc == 0x19)
+			if (sense_info.asc == ASC_DEFECT_LIST_ERROR)
 				rc = DEVICE_READY;
 		}
 	}
-- 
2.53.0



