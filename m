Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215734;
	b=Cc7kgv6h7Wsk6wKvlcxzSixwJ3pLlaYwK8QILHjJ0iqvF6QdQNRsOuGnaDmnZXxhK6Mr
	 vpDqujLFDPBmT05QbyXAcfyNzANP3E2WYwQBXCum38+i0D8bRXFL0Ylck0ylLVfNwk0Gp
	 hXb/IHyV7gA3fyhr853D587wwcJNPWzKsa6IV2GQif4XFB/Naw5UZhGIChwfLeiJ9ls4D
	 IH33UDBFL7FwauhbifxwrBN9bpIeYlhJ6vpiDw1sh659YtqSbXhEK8+3W2kthvHlH0ttQ
	 e/2T5PdDS6IwDe2/ypSHyFFa80iSGS8cSV0VmiXH3gC9DSQMgxjc6GxwFBE6+thn2eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0s78ASaOXfOLQ7Xng4Zv7ib81HZV1IDqKeaZ5fugxOU=;
	b=Ez8sAk3vV2Ku9+h6R66eDZbc9b9HeMLTUJeT2yZFZTZy+EAC2V8hPgHSxi2QurWhCMeP
	 5ofnwDkxjCY37sBL21jVGDJWYgapgmle017CBeLEvzN+6zNW1+8adGQQqLlTxAEctOfuX
	 I4pnm7U1SBAcCZE6NTybFkyWZamyMqYNqqA0xPz+iF77uMlzyNRFkBBRJ0xqSRIAs15I6
	 tjcK09urLPvSf/ffUsKezLc/LLrRO7BwUU63OD1tqn6u6RNwl0PLg1cbZG8rVcKr86nGX
	 KpyWErZLb/DgH+Nx4gG+n22EYN5KT07dgRigTeOWWcxHQToY/n9FEbFr6zMhXfqtiOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01AamFr0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C1E606A31A;
	Wed, 28 Oct 2026 19:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01AamFr0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E6C1F01825;
	Wed, 28 Oct 2026 19:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215734;
	bh=0s78ASaOXfOLQ7Xng4Zv7ib81HZV1IDqKeaZ5fugxOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01AamFr02ieIfpgLFhWGs4VW2CxI4BfLoU/Oz8mh/ndgDMXbi8UrF8fF8ceSsjK7m
	 U6Ulw5qL9CUMiaBRzGFvrUb8cPDkUVsGqDOhWAC65tYCFA53TDFwwuebUQFznOmJTE
	 ayMiCVo6dKI5/96UVpES3Lem+HMMJmLuFoGJ5DeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjie Fang <hongjiefang@asrmicro.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1312/1887] scsi: core: pair EH runtime PM get and put
Date: Wed, 28 Oct 2026 17:56:48 +0100
Message-ID: <20261028170529.286593468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongjie Fang <hongjiefang@asrmicro.com>

[ Upstream commit 872f486259ae0bc6b73ca4735a15d013241f73e9 ]

shost->eh_noresume is currently consulted twice in one error handling
iteration: once before scsi_autopm_get_host() and once again before
scsi_autopm_put_host().

That is racy when a PM-triggered error path flips shost->eh_noresume
while the SCSI EH thread is still running.

The problem flow looks like this:
PM path
  ufshcd_set_dev_pwr_mode()
    shost->eh_noresume = 1
    ufshcd_execute_start_stop  <-- trigger EH
    ...
    shost->eh_noresume = 0

EH path
  scsi_error_handler()
    if (!shost->eh_noresume)
      scsi_autopm_get_host()  <-- skipped
    ...
    if (!shost->eh_noresume)
       scsi_autopm_put_host()  <-- executed later

In that case one EH iteration can skip autoresume on entry and still
drop a runtime PM reference on exit. That leaves an unmatched runtime PM
put and can trigger a runtime PM usage count underflow.

Fix this by making eh_noresume a regular bool so it can be accessed with
READ_ONCE() and WRITE_ONCE(). Snapshot it once per EH iteration and use
that snapshot for both runtime PM get and put decisions.

Fixes: ae0751ffc77e ("[SCSI] add flag to skip the runtime PM calls on the host")
Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20260729111614.2407559-1-hongjiefang@asrmicro.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c | 6 ++++--
 drivers/ufs/core/ufshcd.c | 4 ++--
 include/scsi/scsi_host.h  | 6 +++---
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 8063ec6c82645..b458a8cb619f9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2277,6 +2277,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
+	bool eh_noresume;
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
@@ -2318,7 +2319,8 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
+		eh_noresume = READ_ONCE(shost->eh_noresume);
+		if (!eh_noresume && scsi_autopm_get_host(shost) != 0) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				shost_printk(KERN_ERR, shost,
 					     "scsi_eh_%d: unable to autoresume\n",
@@ -2342,7 +2344,7 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		if (!shost->eh_noresume)
+		if (!eh_noresume)
 			scsi_autopm_put_host(shost);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f8f64b8f111c9..0e9ea032711b9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8838,7 +8838,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * we are functional while we are here, skip host resume in error
 	 * handling context.
 	 */
-	hba->host->eh_noresume = 1;
+	WRITE_ONCE(hba->host->eh_noresume, 1);
 
 	cmd[4] = pwr_mode << 4;
 
@@ -8872,7 +8872,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		hba->curr_dev_pwr_mode = pwr_mode;
 
 	scsi_device_put(sdp);
-	hba->host->eh_noresume = 0;
+	WRITE_ONCE(hba->host->eh_noresume, 0);
 	return ret;
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 71d47d4ec04d9..4be73c771ed0c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -623,6 +623,9 @@ struct Scsi_Host {
 	 */
 	unsigned nr_hw_queues;
 	unsigned nr_maps;
+	/* Don't resume host in EH */
+	bool eh_noresume;
+
 	unsigned active_mode:2;
 
 	/*
@@ -644,9 +647,6 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
-	/* Don't resume host in EH */
-	unsigned eh_noresume:1;
-
 	/* The controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
-- 
2.53.0



