Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D733219303;
	Sat, 30 May 2026 18:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165463; cv=none; b=rzfv6651Fkr/Xgm8m3SBOmoqlOECaMJGMzS+czPzbq2aSMm+fesLTCc78xD8pQ38rxdPXrWncA7S/Qoram6k0KaqarIQ/tbUHo6fZcJrF0BnUaMs/QTo6gvnFjlwRbwzniw1ohrKVNO6HDS1exBWeU+pbMKcsL61/7wQ7LxTZYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165463; c=relaxed/simple;
	bh=C8CYzjzHloGKjDZ9RvX2UVKIQPpXjOwJWxcc9ewj0/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/FaQHbq4KX7tOwV+an4KQX4kLdWufpBMN9zXUwKI16NtH0yNBJuS6jmFU8AAdpFbLohIElNqmhmZqIcm5JpzJukt+bMEV7768CfHIA+5rttDdFbhGabQcyE5kwZCHfWyEIFaCH1WF2VKEb9iP5Qfcp4A3GZFTNFB+tTVSNSfNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6Cw3vpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6Cw3vpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E581F00893;
	Sat, 30 May 2026 18:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165462;
	bh=exU3kZgJEnaGRbimMrqxXEPuJP5Ew6Cyv782l9gRAj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6Cw3vpQrEQ4tROI8zQ/q4hXxOTxx1ALj5frPENX2fVwe50XWtLt9J1nzfJRYokNl
	 rOm4MScIlJJkPay9jCZH7xTRS39vebZEbhR96cYMSm2MH448Xolk6HJinyzHSZ9jt3
	 G7QQ0A5uyzeUsO/Jmi0LEKHwNR9/iymmjCBE2uQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/589] scsi: qla2xxx: Fix warning message due to adisc being flushed
Date: Sat, 30 May 2026 17:59:26 +0200
Message-ID: <20260530160226.903035689@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinn Tran <qutran@marvell.com>

commit 64f24af75b79cba3b86b0760e27e0fa904db570f upstream.

Fix warning message due to adisc being flushed.  Linux kernel triggered a
warning message where a different error code type is not matching up with
the expected type. Add additional translation of one error code type to
another.

WARNING: CPU: 2 PID: 1131623 at drivers/scsi/qla2xxx/qla_init.c:498
qla2x00_async_adisc_sp_done+0x294/0x2b0 [qla2xxx]
CPU: 2 PID: 1131623 Comm: drmgr Not tainted 5.13.0-rc1-autotest #1
..
GPR28: c000000aaa9c8890 c0080000079ab678 c00000140a104800 c00000002bd19000
NIP [c00800000790857c] qla2x00_async_adisc_sp_done+0x294/0x2b0 [qla2xxx]
LR [c008000007908578] qla2x00_async_adisc_sp_done+0x290/0x2b0 [qla2xxx]
Call Trace:
[c00000001cdc3620] [c008000007908578] qla2x00_async_adisc_sp_done+0x290/0x2b0 [qla2xxx] (unreliable)
[c00000001cdc3710] [c0080000078f3080] __qla2x00_abort_all_cmds+0x1b8/0x580 [qla2xxx]
[c00000001cdc3840] [c0080000078f589c] qla2x00_abort_all_cmds+0x34/0xd0 [qla2xxx]
[c00000001cdc3880] [c0080000079153d8] qla2x00_abort_isp_cleanup+0x3f0/0x570 [qla2xxx]
[c00000001cdc3920] [c0080000078fb7e8] qla2x00_remove_one+0x3d0/0x480 [qla2xxx]
[c00000001cdc39b0] [c00000000071c274] pci_device_remove+0x64/0x120
[c00000001cdc39f0] [c0000000007fb818] device_release_driver_internal+0x168/0x2a0
[c00000001cdc3a30] [c00000000070e304] pci_stop_bus_device+0xb4/0x100
[c00000001cdc3a70] [c00000000070e4f0] pci_stop_and_remove_bus_device+0x20/0x40
[c00000001cdc3aa0] [c000000000073940] pci_hp_remove_devices+0x90/0x130
[c00000001cdc3b30] [c0080000070704d0] disable_slot+0x38/0x90 [rpaphp] [
c00000001cdc3b60] [c00000000073eb4c] power_write_file+0xcc/0x180
[c00000001cdc3be0] [c0000000007354bc] pci_slot_attr_store+0x3c/0x60
[c00000001cdc3c00] [c00000000055f820] sysfs_kf_write+0x60/0x80 [c00000001cdc3c20]
[c00000000055df10] kernfs_fop_write_iter+0x1a0/0x290
[c00000001cdc3c70] [c000000000447c4c] new_sync_write+0x14c/0x1d0
[c00000001cdc3d10] [c00000000044b134] vfs_write+0x224/0x330
[c00000001cdc3d60] [c00000000044b3f4] ksys_write+0x74/0x130
[c00000001cdc3db0] [c00000000002df70] system_call_exception+0x150/0x2d0
[c00000001cdc3e10] [c00000000000d45c] system_call_common+0xec/0x278

Link: https://lore.kernel.org/r/20220110050218.3958-5-njavali@marvell.com
Cc: stable@vger.kernel.org
Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ kovalev: bp to fix CVE-2022-49158; in qla2x00_async_prli_sp_done used
  'if (res)' instead of 'else if (res)' due to the older kernel not having
  the preceding QLA_OS_TIMER_EXPIRED check (see upstream commit 4de067e5df12) ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7b6227fde7beb..79b9571f63508 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -283,6 +283,8 @@ static void qla2x00_async_login_sp_done(srb_t *sp, int res)
 		ea.iop[0] = lio->u.logio.iop[0];
 		ea.iop[1] = lio->u.logio.iop[1];
 		ea.sp = sp;
+		if (res)
+			ea.data[0] = MBS_COMMAND_ERROR;
 		qla24xx_handle_plogi_done_event(vha, &ea);
 	}
 
@@ -563,6 +565,8 @@ static void qla2x00_async_adisc_sp_done(srb_t *sp, int res)
 	ea.iop[1] = lio->u.logio.iop[1];
 	ea.fcport = sp->fcport;
 	ea.sp = sp;
+	if (res)
+		ea.data[0] = MBS_COMMAND_ERROR;
 
 	qla24xx_handle_adisc_event(vha, &ea);
 
@@ -1238,6 +1242,8 @@ static void qla2x00_async_prli_sp_done(srb_t *sp, int res)
 		ea.iop[0] = lio->u.logio.iop[0];
 		ea.iop[1] = lio->u.logio.iop[1];
 		ea.sp = sp;
+		if (res)
+			ea.data[0] = MBS_COMMAND_ERROR;
 
 		qla24xx_handle_prli_done_event(vha, &ea);
 	}
-- 
2.53.0



