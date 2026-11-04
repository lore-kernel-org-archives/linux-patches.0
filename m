Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829487;
	b=Uxr64rmvyQbYajUIGleeFk3cbhpHl3I7VZtPKHy8WwOL5xorguXSglN2nOVfZWB1moi3
	 +D9DdSjWO3GTmYGFF5Pp2/lW3FaFuLv0vSKZYS/3DlJhU175rHxd3/qvX8DlFuJF1kIO9
	 Wzl4SvPHWPXdizDE49LEAXuuPi8cCOwGqrhOZRdKUK8BhPRsvUb9+Sq945ASc53f5qZdw
	 jYhlPf5YSFvlUYf6Ve31AzWvI0PjZx6oZuGyix5I5C2aouusgd+4UQcFIpE0YVAnjHpcl
	 WoO8ewlWBVeKoffFiiImrJ77n62awc/E+EB4tjM8RGv4Y5cImTWpdrILIqvxDGWyviQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uSEaRNuAVOfFfjmvfk3En3DMEFkKjURBqeBXzDwZqOI=;
	b=kPXe3qUX3pbvC/75Rf9fYi8FmmL6tcOBamDLww51dSazMT9ltBNgzploU01C2FOeCv+E
	 WtFAomquYhOdIjL0S0pHxeIabN0YOrU4PdfJREfU3CQQBMWkillgVxexepYYQ0U5+0EP0
	 Y6Bp+k3lYcpwU4HDXnsJ1UNpp7ESnPGdiN+eZsAmOGCC1Bs97e5pq9DBT4eOPWxTVBryU
	 JfoUy31saYt0jJKQQ6Yb5fhLswAZDTBQplOFTsKPkrowf4uVPvJzYWuhL0I4Pu2FweLBu
	 /Z0w6Jp8vUT/xOlngAZ86sGP6pJmux/NTAkCaXAQsMzEm2GrkP4IFh5umNYJnctAB8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nh3CMoTM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9C46082BE9;
	Wed,  4 Nov 2026 21:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nh3CMoTM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112501F000C1;
	Wed,  4 Nov 2026 21:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829486;
	bh=uSEaRNuAVOfFfjmvfk3En3DMEFkKjURBqeBXzDwZqOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nh3CMoTMydzsdItr/MbVJCOgSp7z0W4ycJ4Hf9N+sTY95yC1fDuAHlqAW1Yupmuvy
	 EPBZWPNGPD0Df8v/a5Su7W897Wp5XdZjXOrIeL+JRDXVb/C3Pu0DvwqTlRscEOpJ7A
	 sPBtrRMOq6a0AWcwHWagkDwn0VLvmWdjMcyWBkNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0155/1005] remoteproc: qcom: Check subdev start status in rproc_stop()
Date: Wed,  4 Nov 2026 15:58:08 -0500
Message-ID: <20261104211048.099075102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>

[ Upstream commit f44ae8ce156a387b07d40e2d6a0ef979a2748aa1 ]

For rproc that doing attach, rproc_start_subdevices() is called only when
attach successfully. If rproc_report_crash() is called in the attach
function, rproc_boot_recovery()->rproc_stop()->rproc_stop_subdevices()->
glink_subdev_stop() could be called and cause NULL pointer dereference:

 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000300
 Mem abort info:
 ...
 pc : qcom_glink_smem_unregister+0x14/0x48 [qcom_glink_smem]
 lr : glink_subdev_stop+0x1c/0x30 [qcom_common]
 ...
 Call trace:
  qcom_glink_smem_unregister+0x14/0x48 [qcom_glink_smem] (P)
  glink_subdev_stop+0x1c/0x30 [qcom_common]
  rproc_stop+0x58/0x17c
  rproc_trigger_recovery+0xb0/0x150
  rproc_crash_handler_work+0xa4/0xc4
  process_scheduled_works+0x18c/0x2d8
  worker_thread+0x144/0x280
  kthread+0x124/0x138
  ret_from_fork+0x10/0x20
 Code: a9be7bfd 910003fd a90153f3 aa0003f3 (b9430000)
 ---[ end trace 0000000000000000 ]---

Introduce "subdevs_started" flag to indicate rproc_start_subdevices() has
been called successfully. Ensure subdevices are only stopped if they have
been started.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623-rproc-attach-issue-v3-2-8e24310707ce@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 7 +++++++
 include/linux/remoteproc.h           | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 2336c55eb021d..068a3ef467f78 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1104,6 +1104,8 @@ static int rproc_start_subdevices(struct rproc *rproc)
 		}
 	}
 
+	rproc->subdevs_started = true;
+
 	return 0;
 
 unroll_registration:
@@ -1119,10 +1121,15 @@ static void rproc_stop_subdevices(struct rproc *rproc, bool crashed)
 {
 	struct rproc_subdev *subdev;
 
+	if (!rproc->subdevs_started)
+		return;
+
 	list_for_each_entry_reverse(subdev, &rproc->subdevs, node) {
 		if (subdev->stop)
 			subdev->stop(subdev, crashed);
 	}
+
+	rproc->subdevs_started = false;
 }
 
 static void rproc_unprepare_subdevices(struct rproc *rproc)
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index de98462d58889..ef711a5b1a7f2 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -273,6 +273,7 @@ enum rproc_features {
  * @has_iommu: flag to indicate if remote processor is behind an MMU
  * @auto_boot: flag to indicate if remote processor should be auto-started
  * @sysfs_read_only: flag to make remoteproc sysfs files read only
+ * @subdevs_started: flag to indicate if subdevs have started
  * @dump_segments: list of segments in the firmware
  * @nb_vdev: number of vdev currently handled by rproc
  * @elf_class: firmware ELF class
@@ -317,6 +318,7 @@ struct rproc {
 	bool has_iommu;
 	bool auto_boot;
 	bool sysfs_read_only;
+	bool subdevs_started;
 	struct list_head dump_segments;
 	int nb_vdev;
 	u8 elf_class;
-- 
2.53.0



