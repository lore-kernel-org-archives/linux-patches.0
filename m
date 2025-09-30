Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DE13C465;
	Tue, 30 Sep 2025 15:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246019; cv=none; b=tghRx+HE8nFKJ2oN3AQ1al0oMF/8oFpIz7Hv1e8mvBHEYfVEcYJO3QQJpMsxfKSQv0cQMIO9z6im5JKsqEHhu9pE5Bvnnn2cKKnYqK+5OGlaH9mMUYiUMZsrBdbQ6Y0MooAYt/hsvru3CdbQ8FYaXsM+AxeCwZmwT4FJ0Dnd9dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246019; c=relaxed/simple;
	bh=gEyNwmuiRYuvH0pcJKJiPmbrQPH2oA8F3bsKhEKIj1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzIdFjn025FUxdKknqcWlxQg4zEIZmNv/bAlfKjGpDQeBQEb9EHQIPy8axkSZvuTgyQlIT1pi5xxoUz5V7kFjaWJ7UbZBHDAbxQmpsLrsPYoSTv59w/CG5PRNJn7LC0egkGwT5tZhgjEaE9nQSHhn2iExVbqn7Ppz+r6WhuF2Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRwxhknI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRwxhknI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4F1C4CEF0;
	Tue, 30 Sep 2025 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246018;
	bh=gEyNwmuiRYuvH0pcJKJiPmbrQPH2oA8F3bsKhEKIj1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRwxhknIsvKpjJQdXt5uQMM371w0z+a1fCO5tpMXLpNAZb/91SgyoDu7WIjGiDj3F
	 xO3kZ6cND6BZ7niOyGMrV/ABYcc0JBBAm9Tg+lrI7buYI4SivaXXAfnb5GCEWqeOTe
	 0NqfOQRG9r2U2lYgatyd2iO4WtrMpAI23O4v0Dc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Prakruthi SP <Prakruthi.SP@amd.com>,
	Akshata MukundShetty <akshata.mukundshetty@amd.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 27/89] HID: amd_sfh: Add sync across amd sfh work functions
Date: Tue, 30 Sep 2025 16:47:41 +0200
Message-ID: <20250930143823.032152263@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit bba920e6f803138587248079de47ad3464a396f6 ]

The process of the report is delegated across different work functions.
Hence, add a sync mechanism to protect SFH work data across functions.

Fixes: 4b2c53d93a4b ("SFH:Transport Driver to add support of AMD Sensor Fusion Hub (SFH)")
Reported-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Closes: https://lore.kernel.org/all/a21abca5-4268-449d-95f1-bdd7a25894a5@linux.dev/
Tested-by: Prakruthi SP <Prakruthi.SP@amd.com>
Co-developed-by: Akshata MukundShetty <akshata.mukundshetty@amd.com>
Signed-off-by: Akshata MukundShetty <akshata.mukundshetty@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c | 12 ++++++++++--
 drivers/hid/amd-sfh-hid/amd_sfh_common.h |  3 +++
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c   |  4 ++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index 3438d392920fa..8dae9a7766853 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -39,8 +39,12 @@ int amd_sfh_get_report(struct hid_device *hid, int report_id, int report_type)
 	struct amdtp_hid_data *hid_data = hid->driver_data;
 	struct amdtp_cl_data *cli_data = hid_data->cli_data;
 	struct request_list *req_list = &cli_data->req_list;
+	struct amd_input_data *in_data = cli_data->in_data;
+	struct amd_mp2_dev *mp2;
 	int i;
 
+	mp2 = container_of(in_data, struct amd_mp2_dev, in_data);
+	guard(mutex)(&mp2->lock);
 	for (i = 0; i < cli_data->num_hid_devices; i++) {
 		if (cli_data->hid_sensor_hubs[i] == hid) {
 			struct request_list *new = kzalloc(sizeof(*new), GFP_KERNEL);
@@ -75,6 +79,8 @@ void amd_sfh_work(struct work_struct *work)
 	u8 report_id, node_type;
 	u8 report_size = 0;
 
+	mp2 = container_of(in_data, struct amd_mp2_dev, in_data);
+	guard(mutex)(&mp2->lock);
 	req_node = list_last_entry(&req_list->list, struct request_list, list);
 	list_del(&req_node->list);
 	current_index = req_node->current_index;
@@ -83,7 +89,6 @@ void amd_sfh_work(struct work_struct *work)
 	node_type = req_node->report_type;
 	kfree(req_node);
 
-	mp2 = container_of(in_data, struct amd_mp2_dev, in_data);
 	mp2_ops = mp2->mp2_ops;
 	if (node_type == HID_FEATURE_REPORT) {
 		report_size = mp2_ops->get_feat_rep(sensor_index, report_id,
@@ -107,6 +112,8 @@ void amd_sfh_work(struct work_struct *work)
 	cli_data->cur_hid_dev = current_index;
 	cli_data->sensor_requested_cnt[current_index] = 0;
 	amdtp_hid_wakeup(cli_data->hid_sensor_hubs[current_index]);
+	if (!list_empty(&req_list->list))
+		schedule_delayed_work(&cli_data->work, 0);
 }
 
 void amd_sfh_work_buffer(struct work_struct *work)
@@ -117,9 +124,10 @@ void amd_sfh_work_buffer(struct work_struct *work)
 	u8 report_size;
 	int i;
 
+	mp2 = container_of(in_data, struct amd_mp2_dev, in_data);
+	guard(mutex)(&mp2->lock);
 	for (i = 0; i < cli_data->num_hid_devices; i++) {
 		if (cli_data->sensor_sts[i] == SENSOR_ENABLED) {
-			mp2 = container_of(in_data, struct amd_mp2_dev, in_data);
 			report_size = mp2->mp2_ops->get_in_rep(i, cli_data->sensor_idx[i],
 							       cli_data->report_id[i], in_data);
 			hid_input_report(cli_data->hid_sensor_hubs[i], HID_INPUT_REPORT,
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_common.h b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
index e5620d7db5690..00308d8998d4d 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_common.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
@@ -10,6 +10,7 @@
 #ifndef AMD_SFH_COMMON_H
 #define AMD_SFH_COMMON_H
 
+#include <linux/mutex.h>
 #include <linux/pci.h>
 #include "amd_sfh_hid.h"
 
@@ -57,6 +58,8 @@ struct amd_mp2_dev {
 	u32 mp2_acs;
 	struct sfh_dev_status dev_en;
 	struct work_struct work;
+	/* mp2 to protect data */
+	struct mutex lock;
 	u8 init_done;
 	u8 rver;
 };
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 0c28ca349bcd3..9739f66e925c0 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -405,6 +405,10 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	if (!privdata->cl_data)
 		return -ENOMEM;
 
+	rc = devm_mutex_init(&pdev->dev, &privdata->lock);
+	if (rc)
+		return rc;
+
 	privdata->sfh1_1_ops = (const struct amd_sfh1_1_ops *)id->driver_data;
 	if (privdata->sfh1_1_ops) {
 		if (boot_cpu_data.x86 >= 0x1A)
-- 
2.51.0



