Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018499;
	b=1t7xtl3UTYm4Oz5/GZ0Mxz0IR39mC938nJdHA9HzCElOEPSBZtZ6OADeZ3Aw/z3s8iYM
	 8SxjEz8xNQKe1in8lGmO0QLzY5u7IEei3LLXYzRn+AX8zFRIYYQGM4ZJnpWjVu/3XA6Vu
	 Zb7fpJYpY62HxNucF2rlUsDB51oLzjE+WtuW62/40gPSnaFR4mETRL8d/RCSNb7AXv+hU
	 M5NFw8YVNBgZH8ZtYkzWdG3248LKCK0XPX+nzuRZRZC9fK5PDidr+p/G+oltJijhZS/PQ
	 o+Vge7rOwfSht0tKe6idqRzFHWWEzlpKVLI1Nas0PaJnodTzfV1SpnCKgvJa9h3CXvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hzv6i0Kcf5EEsMW3APNB6DKDPdYHm1OCN92q5Jl5yE8=;
	b=hphZ3YtALxcd++Dj5ZQ/59yNhwX6ldW+VDjYX6S6oZejci31a0XTVhhba+y7XBcTe5tB
	 mtZbV7oX35mUgNR1ClBog1v4VIx5p+BOR9baY3eXY/8BZZs74ui9sO9sgJUgJRzu7twiu
	 U5mpN1bVpp+ORDStlc6RXEvRRc2dWZVPGoJPCXtFGVdshpLdDmklIbdrlT+csppHmm1cE
	 hAIebEF6fe76e0iLUTszjF3dCsYir42c3rTYh74+Lrd6WG+l61iGb7kZ8naELLxpVqVxH
	 WQa17I2m26Ke4rI2OsGjg+pUo1z/1XBO1XJuJXcaNuF4S+bQJtkUO6Ic+e4hmtxdnuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uOA+3r4K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79F9606A33D;
	Wed, 18 Nov 2026 16:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uOA+3r4K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C791F000C4;
	Wed, 18 Nov 2026 16:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018499;
	bh=hzv6i0Kcf5EEsMW3APNB6DKDPdYHm1OCN92q5Jl5yE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOA+3r4KnZ1MqSu78cLai4E2zINLe2aZDpuZNmFY6F37iSiLzFTx4RqBSZXmNNXIc
	 A97gsA8R/5SrYxPS9i0MrX8iIZTEwqiOI/+nOEkexGUwfo5LHeoo2WQm1apuK98y53
	 +pRk8pnsiRU3VDI06Q6ufHYGXO22WxsSGBFsBcow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1222/2651] scsi: core: Rename sense field of struct scsi_failure
Date: Wed, 18 Nov 2026 15:41:02 +0100
Message-ID: <20261118150331.994915747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit 45cdf8164237277e52af5d8aa4218c3cb6199bf2 ]

Rename the sense field of struct scsi_failure to sense_key. This makes it
clear that this field stores the sense key, and also unifies this structure
field names with the names used in struct scsi_sense_hdr.

To be consistent with this change, the macro SCMD_FAILURE_SENSE_ANY is
renamed SCMD_FAILURE_SENSE_KEY_ANY.

Of note is that the definition of the array any_sense_failure_defs in
scsi_lib_test_any_sense() is modified to change the initialization of the
result field to use SCMD_FAILURE_RESULT_ANY and add the .sense_key field
initialization to SCMD_FAILURE_SENSE_KEY_ANY to match the test target case.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260908090308.1085097-5-dlemoal@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Stable-dep-of: 63cb3900be26 ("scsi: scsi_debug: Enforce physical block alignment of zoned writes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ch.c                           |  2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 10 ++++-----
 drivers/scsi/scsi_lib.c                     |  6 ++---
 drivers/scsi/scsi_lib_test.c                | 25 +++++++++++----------
 drivers/scsi/scsi_scan.c                    |  8 +++----
 drivers/scsi/scsi_transport_spi.c           |  2 +-
 drivers/scsi/sd.c                           | 20 ++++++++---------
 drivers/scsi/ses.c                          |  8 +++----
 include/scsi/scsi_device.h                  | 12 +++++-----
 10 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index c36539c83ed1a..cc4532c7782f1 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -190,7 +190,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = 3,
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 6e8849d7f0a32..3431e1ce95fd9 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -84,7 +84,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SCMD_FAILURE_NO_LIMIT,
@@ -138,7 +138,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 			 *
 			 * Switch-over in progress, retry.
 			 */
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = 0x04,
 			.ascq = 0x03,
 			.allowed = HP_SW_RETRIES,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 88c8e36b221e2..75c9cc291e385 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -514,33 +514,33 @@ static void send_mode_select(struct work_struct *work)
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = NO_SENSE,
+			.sense_key = NO_SENSE,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = ABORTED_COMMAND,
+			.sense_key = ABORTED_COMMAND,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* LUN Not Ready and is in the Process of Becoming Ready */
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = 0x04,
 			.ascq = 0x01,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Command Lock contention */
 		{
-			.sense = ILLEGAL_REQUEST,
+			.sense_key = ILLEGAL_REQUEST,
 			.asc = 0x91,
 			.ascq = 0x36,
 			.allowed = SCMD_FAILURE_NO_LIMIT,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index af27fd3df8d46..4901b2dff6538 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -243,13 +243,13 @@ static int scsi_check_passthrough(struct scsi_cmnd *scmd,
 			continue;
 
 		if (status_byte(failure->result) != SAM_STAT_CHECK_CONDITION ||
-		    failure->sense == SCMD_FAILURE_SENSE_ANY)
+		    failure->sense_key == SCMD_FAILURE_SENSE_KEY_ANY)
 			goto maybe_retry;
 
 		if (!scsi_command_normalize_sense(scmd, &sshdr))
 			return 0;
 
-		if (failure->sense != sshdr.sense_key)
+		if (failure->sense_key != sshdr.sense_key)
 			continue;
 
 		if (failure->asc == SCMD_FAILURE_ASC_ANY)
@@ -2372,7 +2372,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 	struct scsi_sense_hdr my_sshdr;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = retries,
diff --git a/drivers/scsi/scsi_lib_test.c b/drivers/scsi/scsi_lib_test.c
index ae8af0e0047a8..4558dc853e26e 100644
--- a/drivers/scsi/scsi_lib_test.c
+++ b/drivers/scsi/scsi_lib_test.c
@@ -17,40 +17,40 @@ static void scsi_lib_test_multiple_sense(struct kunit *test)
 {
 	struct scsi_failure multiple_sense_failure_defs[] = {
 		{
-			.sense = DATA_PROTECT,
+			.sense_key = DATA_PROTECT,
 			.asc = 0x1,
 			.ascq = 0x1,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x11,
 			.ascq = 0x0,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = 0x11,
 			.ascq = 0x22,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = ABORTED_COMMAND,
+			.sense_key = ABORTED_COMMAND,
 			.asc = 0x11,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = HARDWARE_ERROR,
+			.sense_key = HARDWARE_ERROR,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = ILLEGAL_REQUEST,
+			.sense_key = ILLEGAL_REQUEST,
 			.asc = 0x91,
 			.ascq = 0x36,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
@@ -116,8 +116,9 @@ static void scsi_lib_test_any_sense(struct kunit *test)
 {
 	struct scsi_failure any_sense_failure_defs[] = {
 		{
-			.result = SCMD_FAILURE_SENSE_ANY,
+			.sense_key = SCMD_FAILURE_SENSE_KEY_ANY,
 			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SCMD_FAILURE_RESULT_ANY,
 		},
 		{}
 	};
@@ -129,7 +130,7 @@ static void scsi_lib_test_any_sense(struct kunit *test)
 		.sense_buffer = sense,
 	};
 
-	/* Match using SCMD_FAILURE_SENSE_ANY */
+	/* Match using SCMD_FAILURE_SENSE_KEY_ANY */
 	failures.failure_definitions = any_sense_failure_defs;
 	scsi_build_sense(&sc, 0, MEDIUM_ERROR, 0x11, 0x22);
 	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
@@ -215,14 +216,14 @@ static void scsi_lib_test_total_allowed(struct kunit *test)
 {
 	struct scsi_failure total_allowed_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Fail all CCs except the UA above */
 		{
-			.sense = SCMD_FAILURE_SENSE_ANY,
+			.sense_key = SCMD_FAILURE_SENSE_KEY_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Retry any other errors not listed above */
@@ -259,12 +260,12 @@ static void scsi_lib_test_mixed_total(struct kunit *test)
 {
 	struct scsi_failure mixed_total_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x28,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0f0f243c25615..6cd77b0592e45 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -658,12 +658,12 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		 * so anyway.
 		 */
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x28,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -1457,14 +1457,14 @@ static int scsi_report_lun_scan(struct Scsi_Host *shost,
 	struct scsi_device *sdev;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Fail all CCs except the UA above */
 		{
-			.sense = SCMD_FAILURE_SENSE_ANY,
+			.sense_key = SCMD_FAILURE_SENSE_KEY_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		/* Retry any other errors not listed above */
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 3e3da8c2ff26f..ec3884a6657f6 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -112,7 +112,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 			REQ_FAILFAST_DRIVER;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = DV_RETRIES,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 208b915f25a2c..66664d08c15a0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2033,7 +2033,7 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 	u8 cmd[10] = { PERSISTENT_RESERVE_IN, sa };
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = 5,
@@ -2145,7 +2145,7 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = 5,
@@ -2494,13 +2494,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	struct scsi_failure failure_defs[] = {
 		/* Do not retry Medium Not Present */
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x3A,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = 0x3A,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
@@ -2817,18 +2817,18 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	struct scsi_failure failure_defs[] = {
 		/* Do not retry Medium Not Present */
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x3A,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = 0x3A,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		 /* Device reset might occur several times so retry a lot */
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
 			.result = SAM_STAT_CHECK_CONDITION,
@@ -4159,21 +4159,21 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	struct scsi_failure failure_defs[] = {
 		{
 			/* Power on, reset, or bus device reset occurred */
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.ascq = 0,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			/* Power on occurred */
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.ascq = 1,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			/* SCSI bus reset */
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.ascq = 2,
 			.result = SAM_STAT_CHECK_CONDITION,
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 4c348645b04ee..454886c245704 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -88,14 +88,14 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	unsigned char recv_page_code;
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SES_RETRIES,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SES_RETRIES,
@@ -145,14 +145,14 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	};
 	struct scsi_failure failure_defs[] = {
 		{
-			.sense = UNIT_ATTENTION,
+			.sense_key = UNIT_ATTENTION,
 			.asc = 0x29,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SES_RETRIES,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
-			.sense = NOT_READY,
+			.sense_key = NOT_READY,
 			.asc = SCMD_FAILURE_ASC_ANY,
 			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.allowed = SES_RETRIES,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8694eeadd753e..e321471e8ca22 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -514,18 +514,18 @@ extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
  */
 #define SCMD_FAILURE_STAT_ANY	0xff
 /*
- * The following can be set to the scsi_failure sense, asc and ascq fields to
- * match on any sense, ASC, or ASCQ value.
+ * The following can be set to the scsi_failure sense key, asc and ascq fields
+ * to match any sense key, ASC, and ASCQ value.
  */
-#define SCMD_FAILURE_SENSE_ANY	0xff
-#define SCMD_FAILURE_ASC_ANY	0xff
-#define SCMD_FAILURE_ASCQ_ANY	0xff
+#define SCMD_FAILURE_SENSE_KEY_ANY	0xff
+#define SCMD_FAILURE_ASC_ANY		0xff
+#define SCMD_FAILURE_ASCQ_ANY		0xff
 /* Always retry a matching failure. */
 #define SCMD_FAILURE_NO_LIMIT	-1
 
 struct scsi_failure {
 	int result;
-	u8 sense;
+	u8 sense_key;
 	u8 asc;
 	u8 ascq;
 	/*
-- 
2.53.0



