Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033713;
	b=J0zISwpVy+3uPr+ZQrYgEj0b/tq859wAWfVQzEQ2V8N1i0k177tTQ4i1HLU1n0+8PUwH
	 OYsp+bcOcGaifPUQX7WC3MdFtk7vkwrvolxBCf8ZBebvEF2LBhANWAR1GYWQ644eJbada
	 8MeVNvejgC08XWxMuUsUoBWSaz4Le+6lute3+I33F5CtmVleWgE7qI04NTDleVSucSHhp
	 iLPxrgUQ59rMGuR0K39R9nz0+hbze8YufxWOfqYYsM4xpUwSM+S6c6mG2u+ATtFsy+4Pk
	 KezyGWAUrOSf0Uh7z5Pgl+Cn30Haiup8vTYfapFihHG+7izI91+4ItKGC9NeMUAYZZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J6R4D7Fzkcjz4n2t0t9PWZ/7j7U+E2XchIMUyzr9y30=;
	b=pyMR8iOqnjSpZnq8UDTQJgBqlGkURRdekUi9c3DHMzimKSX28DhLjnwGvvf+EWraYvq3
	 jQIdjdFtsR8aZAsUFxcWbZRzlSPOLCl+lYpriucwfYs/blEY0oa4TH5Sut3jOqfcoD2eV
	 j8UEgjgbxZzPe1dqVuKMzvP8tpPu0scJkPBE1cdvqYPBqm/RrRl/i1KL26GV06yykYlhb
	 fxbb17OFG/4sQaEzu0cgu86Atun/r7PraTPMYRJnHncw2OhRO6oltvcXuJvUMuEC4uCmq
	 fyKpSWRpuNNSgcjWJk0LHztU+Y6pLk7UcCUkf50JFpMFf+PBxbQ7pxOT42hkIJGv9eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R6jpeNUD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C1F606A320;
	Wed, 18 Nov 2026 20:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R6jpeNUD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785351F000C4;
	Wed, 18 Nov 2026 20:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033713;
	bh=J6R4D7Fzkcjz4n2t0t9PWZ/7j7U+E2XchIMUyzr9y30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6jpeNUDPNVnhRzNYsy/JpnhnO1Wvx62a8x1PpvXPZfasBsh5U/t2VTsuwwzgAUwu
	 yfthU2X0AXLL+5J3GkBO/j/YOvVh97Dt3DsFmVs0On+aBdQ/VrL1LSU6+JH4egOER2
	 auKwWlV03gjSU4avcSw/Gabjjfq56rSTzqoDiuFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0110/3318] remoteproc: qcom: Check subdev start status in rproc_stop()
Date: Wed, 18 Nov 2026 15:12:12 +0100
Message-ID: <20261118150317.577828737@linuxfoundation.org>
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
index a6f800a00e7db..c90aa87a94030 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1103,6 +1103,8 @@ static int rproc_start_subdevices(struct rproc *rproc)
 		}
 	}
 
+	rproc->subdevs_started = true;
+
 	return 0;
 
 unroll_registration:
@@ -1118,10 +1120,15 @@ static void rproc_stop_subdevices(struct rproc *rproc, bool crashed)
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



