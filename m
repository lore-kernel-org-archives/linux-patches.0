Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023350;
	b=M3TPQx5HCn33bcor+uQdtb854/WGUaAnvjPOpN7bvS5NL9OhrtR7tKNImYyqHxNbpwO3
	 v3z9rGwcK/ec5dcv3NQ7gSEQ5cp757nZTvIld0uZc0EdwzsXxbj+yPzMA+uQ3QEn+UcO7
	 BxZqBmAUL3aSImzRvt2G5s7VQSDnqGAK9LiCiVkfa4e4DDhm8ivRJ0u1dfypQ+Md0EGbn
	 KLI+qIkGUSS9Y7d7vIQVHm/b3E0DErDEazsDnGrN1TBVCKTkb1I33jFYevJ3vLX7VFgZc
	 EiYinp0XTI5lSKdk6ZV2QAQRP9UMDiw48a2gugiUqhvFMdHZkPrEqAk8cUfY3OFUysA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Y5Gfh8awU6ZMw2SUoi8+W/M6J9zXritQhqeJ6EVp1E=;
	b=BgZnM7eQfJbg6oOQNZDfH0R18lLZq+QyIr5icL4CepxXOeRprCbP7uaAA5Sny+0DNNS6
	 GONz2Sn+I062xlvDn3V/9UvjG3ClNq85/ZWfgkTD1l5eIZWTNR/vSzbOkmok+T/A4iwyg
	 uIkZ4CbWPWwsw9NKQsgBfGKKKaf/BmfhhFBUfNqrCClOo2bqgjZpnthOI5U2ycNDczjAZ
	 9Gol3eFQ0D64Me5yg2fA5KjpjlVzRDLahVcPbVRQ4clJxauZ5iU/cGbvf2lJrwgwC+w8O
	 0Q4NLCyIvVJaEWl6Z76PUjprvSGLHb7roZywyCeapPwGFgwlL31ncD9wXkLcQ1IRo1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZjZUhdl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE92606CA40;
	Wed, 18 Nov 2026 17:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZjZUhdl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09281F000C7;
	Wed, 18 Nov 2026 17:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023350;
	bh=4Y5Gfh8awU6ZMw2SUoi8+W/M6J9zXritQhqeJ6EVp1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZjZUhdldGchVZdRBVdfvR9wRax+ZPOWywRZLDtAMBko6OkZ6PfwLLtBo8zd1bUGY
	 umLXSotXnJIDHg3/gmXZLaXdj3Kysg7+jdtMvlk4eKzwqtbyqoP6Gvv5iXLGP3nOjn
	 gztu5JVDkPF5O0/Pc9iSC67XpfPTQ5olWXJ00Juc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0336/2151] scsi: mpi3mr: Rename log data save helper to reflect threaded/BH context
Date: Wed, 18 Nov 2026 15:34:31 +0100
Message-ID: <20261118150134.242307122@linuxfoundation.org>
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit d0d19250ed81907eac707be8221eb31e5b96b647 ]

Log data events can be processed from BH and threaded contexts.  Rename
the save helper to document its intended usage and improve readability
of the event handling flow.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://patch.msgid.link/20260116060719.32937-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 77554f01187d ("scsi: mpi3mr: Fix out-of-bounds read of event data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h     | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c  | 7 ++++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 31d68c151b207..611a51a353c97 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1508,7 +1508,7 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
 int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
-void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size);
 struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
 	struct mpi3mr_ioc *mrioc, u16 handle);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 552db18da1219..85315ee17c70b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2932,7 +2932,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 }
 
 /**
- * mpi3mr_app_save_logdata - Save Log Data events
+ * mpi3mr_app_save_logdata_th - Save Log Data events
  * @mrioc: Adapter instance reference
  * @event_data: event data associated with log data event
  * @event_data_size: event data size to copy
@@ -2944,7 +2944,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
  *
  * Return:Nothing
  */
-void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
 	u32 index = mrioc->logdata_buf_idx;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 7c94897e458cf..a2496f11ab991 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1962,7 +1962,7 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 static void mpi3mr_logdata_evt_bh(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_fwevt *fwevt)
 {
-	mpi3mr_app_save_logdata(mrioc, fwevt->event_data,
+	mpi3mr_app_save_logdata_th(mrioc, fwevt->event_data,
 	    fwevt->event_data_size);
 }
 
@@ -3092,6 +3092,11 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
 	case MPI3_EVENT_LOG_DATA:
+
+		sz = event_reply->event_data_length * 4;
+		mpi3mr_app_save_logdata_th(mrioc,
+			(char *)event_reply->event_data, sz);
+		break;
 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
 	case MPI3_EVENT_ENCL_DEVICE_ADDED:
 	{
-- 
2.53.0



