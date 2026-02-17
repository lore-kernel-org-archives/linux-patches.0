Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B4529B8E8;
	Tue, 17 Feb 2026 20:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361058; cv=none; b=CEYuObIpAX+bT+G69rGPtH0Q6ozTusxyWxEx5LOw2bbSBWZqXhKTSO3Y545t6PXrKPc73U4zKzhJYU38fWByQGH+diuj6hjS6M9mPRKupjXl2inFVvSrhtiwr/90TynTzgRfo61FfTuIuprhVmJE1gFcwMC/P5/0fHi83cM4vag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361058; c=relaxed/simple;
	bh=ZqXuNWszsvHDkVmBrNhX/Fk/XAIW57B5n6J8QXt67kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6QEWOlSotMLZOpakEv1i+jyhnHN8YCQMgNwa8NhpnxRYHe10kBvThJLij71CPHXGrY/Gl0r6ibjy0xTrQxbynl8HOeaBqqz4AlngYt8yqMoKuVuVS7EyabupXFfVOiUnChyTVsk+ObGejUx4AEJo1X/KRGFCGQxelY9nZ7wS/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHghswyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHghswyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE1BC4CEF7;
	Tue, 17 Feb 2026 20:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361058;
	bh=ZqXuNWszsvHDkVmBrNhX/Fk/XAIW57B5n6J8QXt67kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHghswySZt7DaORnAvsu+Sq8WdhxPE0eqZZXovJNziJiwwpbdXa++h51i+4LBxZ69
	 XNT85YLLc8WDTcu/ORbI/P9AYK0xb0Ljlm+nqAX15m0gl0wOeQPCb129yU17jqg9yG
	 I0jgvuwOxjkDqLrziHi5lhbL4x23VipRPu6+INx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Gleb Chesnokov <Chesnokov.G@raidix.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/39] scsi: qla2xxx: Use named initializers for port_[d]state_str
Date: Tue, 17 Feb 2026 21:31:37 +0100
Message-ID: <20260217200004.022832008@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Chesnokov <Chesnokov.G@raidix.com>

[ Upstream commit 6e0e85d39e528da2915a2da261195f81bfde6915 ]

Make port_state_str and port_dstate_str a little more readable and
maintainable by using named initializers.

Also convert FCS_* macros into an enum.

Link: https://lore.kernel.org/r/AS8PR10MB495215841EB25C16DBC0CB409D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 7adbd2b78090 ("scsi: qla2xxx: Free sp in error path to fix system crash")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_def.h |   35 +++++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_isr.c |   10 +++++-----
 2 files changed, 24 insertions(+), 21 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2689,25 +2689,28 @@ struct event_arg {
 /*
  * Fibre channel port/lun states.
  */
-#define FCS_UNCONFIGURED	1
-#define FCS_DEVICE_DEAD		2
-#define FCS_DEVICE_LOST		3
-#define FCS_ONLINE		4
+enum {
+	FCS_UNKNOWN,
+	FCS_UNCONFIGURED,
+	FCS_DEVICE_DEAD,
+	FCS_DEVICE_LOST,
+	FCS_ONLINE,
+};
 
 extern const char *const port_state_str[5];
 
-static const char * const port_dstate_str[] = {
-	"DELETED",
-	"GNN_ID",
-	"GNL",
-	"LOGIN_PEND",
-	"LOGIN_FAILED",
-	"GPDB",
-	"UPD_FCPORT",
-	"LOGIN_COMPLETE",
-	"ADISC",
-	"DELETE_PEND",
-	"LOGIN_AUTH_PEND",
+static const char *const port_dstate_str[] = {
+	[DSC_DELETED]		= "DELETED",
+	[DSC_GNN_ID]		= "GNN_ID",
+	[DSC_GNL]		= "GNL",
+	[DSC_LOGIN_PEND]	= "LOGIN_PEND",
+	[DSC_LOGIN_FAILED]	= "LOGIN_FAILED",
+	[DSC_GPDB]		= "GPDB",
+	[DSC_UPD_FCPORT]	= "UPD_FCPORT",
+	[DSC_LOGIN_COMPLETE]	= "LOGIN_COMPLETE",
+	[DSC_ADISC]		= "ADISC",
+	[DSC_DELETE_PEND]	= "DELETE_PEND",
+	[DSC_LOGIN_AUTH_PEND]	= "LOGIN_AUTH_PEND",
 };
 
 /*
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -49,11 +49,11 @@ qla27xx_process_purex_fpin(struct scsi_q
 }
 
 const char *const port_state_str[] = {
-	"Unknown",
-	"UNCONFIGURED",
-	"DEAD",
-	"LOST",
-	"ONLINE"
+	[FCS_UNKNOWN]		= "Unknown",
+	[FCS_UNCONFIGURED]	= "UNCONFIGURED",
+	[FCS_DEVICE_DEAD]	= "DEAD",
+	[FCS_DEVICE_LOST]	= "LOST",
+	[FCS_ONLINE]		= "ONLINE"
 };
 
 static void


