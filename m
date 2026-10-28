Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215777;
	b=DwpNCRpY7RxdtYEVspXCrZ9vodLpRFepUBOqJJ9EZ1Q54hMtIUfzbcPqtMp05U1n7f35
	 l73fYNtKP4TFNVHQHObmBKCEbt6Im4ewRknyUh3ltstUv+asZh0VQVZFQjXDwYehQsP+z
	 r4BvgjHOabHxGWmAyCWXsZLkscpxzr9SyrpaIIRGccslwuYI7bRwJCFJvIPPeTtGGvNWw
	 dyJCaf4FbxD4Qeyxr2/EjbcWnuggZHR7JfjyPwEN0IUbsfZz6lPog+x6OEFMTEdmcx17b
	 KxZs6muXp/erZPhjIJqSqN+K+fcRuncZHt8utX/jcvMx0M/V8ogKpiodlhax3Q73oVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LNtjjtcHGyvR68Dd2djINTEL3QWk0Q0rhDAy6Q8W7to=;
	b=G1LqTocaUW/w5BoszwxXG0M+8B1xopISaKfFxxYawUpOzkxWJxPgiUtoGwPybb/hMd28
	 qSFs65+SdrbicEBMxiyEEP19NY6nvqTO2Z2AMJI1FfnwfckiBhM72dbQEaFJqA/nsEYlP
	 YLUzxkrW/t4iZ+yTIuNgKRdJGWTdZRJADEOAU/7G1Ft0TRAhRjuDY3PAOywRh89JLMQms
	 01FjxwbcF+LoWwZg0vsXSeZfJGQNR+WgOyQ33U0Ow7IlYAj71t+CsNVVThDbLYN9OnqXF
	 W2o1Om7NPxZmb+VCutRnxLdQ92xz2GkCC/0BQgWeCIgODrbslWf6NPzpVlMzrGIm4HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NpA3g43n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E9A606A31A;
	Wed, 28 Oct 2026 19:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NpA3g43n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23471F01825;
	Wed, 28 Oct 2026 19:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215777;
	bh=LNtjjtcHGyvR68Dd2djINTEL3QWk0Q0rhDAy6Q8W7to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NpA3g43n+AVs5E7CTrYDQpz/+qhWqTghFiUEw7UPlvZ2p3TFLIwvGXvR/1rA0ghW+
	 GATXOe7oRACtNyPx6y53M3eiAW6ycg/TBBTrcz0m5E8aRPRC3bnmIDmV4IksGQmPib
	 3H6mPgCfLAp4He74HvCKsnuyTsxgTeET5GMEq3rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1330/1887] scsi: hisi_sas: Add slave_destroy interface for v3 hw
Date: Wed, 28 Oct 2026 17:57:06 +0100
Message-ID: <20261028170529.696586331@linuxfoundation.org>
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit 67b85a88265df19f049241d8c00571a5408f4eeb ]

WARNING is triggered when executing link reset of remote PHY and rmmod
SAS driver simultaneously. Following is the WARNING log:

WARNING: CPU: 61 PID: 21818 at drivers/base/core.c:1347 __device_links_no_driver+0xb4/0xc0
 Call trace:
  __device_links_no_driver+0xb4/0xc0
  device_links_driver_cleanup+0xb0/0xfc
  __device_release_driver+0x198/0x23c
  device_release_driver+0x38/0x50
  bus_remove_device+0x130/0x140
  device_del+0x184/0x434
  __scsi_remove_device+0x118/0x150
  scsi_remove_target+0x1bc/0x240
  sas_rphy_remove+0x90/0x94
  sas_rphy_delete+0x24/0x3c
  sas_destruct_devices+0x64/0xa0 [libsas]
  sas_revalidate_domain+0xe4/0x150 [libsas]
  process_one_work+0x1e0/0x46c
  worker_thread+0x15c/0x464
  kthread+0x160/0x170
  ret_from_fork+0x10/0x20
 ---[ end trace 71e059eb58f85d4a ]---

During SAS phy up, link->status is set to DL_STATE_AVAILABLE in
device_links_driver_bound, then this setting influences
__device_links_no_driver() before driver rmmod and caused WARNING.

Add the slave_destroy interface to make sure link is removed after flush
workque.

Fixes: 16fd4a7c5917 ("scsi: hisi_sas: Add device link between SCSI devices and hisi_hba")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Link: https://patch.msgid.link/20260425082056.2749910-1-liyihang9@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3979e1cc43572..bfd4639b11987 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2860,7 +2860,7 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 		return 0;
 
 	if (!device_link_add(&sdev->sdev_gendev, dev,
-			     DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)) {
+			     DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)) {
 		if (pm_runtime_enabled(dev)) {
 			dev_info(dev, "add device link failed, disable runtime PM for the host\n");
 			pm_runtime_disable(dev);
@@ -2870,6 +2870,15 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 	return 0;
 }
 
+static void hisi_sas_sdev_destroy(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(&sdev->sdev_gendev);
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	struct device *dev = hisi_hba->dev;
+
+	device_link_remove(&sdev->sdev_gendev, dev);
+}
+
 static struct attribute *host_v3_hw_attrs[] = {
 	&dev_attr_phy_event_threshold.attr,
 	&dev_attr_intr_conv_v3_hw.attr,
@@ -3258,6 +3267,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.slave_alloc		= hisi_sas_slave_alloc,
+	.slave_destroy		= hisi_sas_sdev_destroy,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 #ifdef CONFIG_COMPAT
-- 
2.53.0



