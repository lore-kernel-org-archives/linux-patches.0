Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14D9472541;
	Sat, 12 Sep 2026 11:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210886; cv=none; b=O/ebAzAEfCJfBPyt8nsSCrL9PpaOyNW4Y/d8OJKShDLvubFOEOs2wI/9/x/wHA0CGNAHT76HYydkZOW8dKG4+bGOdO9htMsbY3E5mI1c8Y5nLcodR7KX2wl5bVdsFX7Q5A17hu1+VyavnNKKYVBUwGv275QXthSkCzdtn3IEKQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210886; c=relaxed/simple;
	bh=anno6m7J2igexW1qzUCKxeY99cXpxbJhQNwNhrMaoks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHTZGoVDQUlnd+GdFuvVnrXs0qNs84tS8Xj4l20e+dVZHHs+18AHud73iWQC2Qv8WjfW1DbqKUcyCCiben+PxXd5f1fag6+iz2CocpeKJ226sWGOJtgd+XxeTxcMXuCAHXXE3CIqnKMzhATLTJJ9EviyZF9Q7E2xkVlWR+nqf1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAzEKlMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAzEKlMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B465F1F000FF;
	Sat, 12 Sep 2026 11:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210884;
	bh=+BdZA1qGVqKETvV+Z51Ij1qkwGRoMEw0hrgkoD3RisY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAzEKlMfWSd2bmR9mAfmyLj9XYo04pUKMK38lslKC/LygHOfefmL/3I+QRcHjWAgW
	 i0wyS7OAHFdTxtJbyI6NxAPGio8jCJ+Vpu4dUVwsIQBoS1zoKP2lNh5/s312DL1OdY
	 5iIny+ixjtNAAbeg6mAZsG6+oHmgN3aDMIa6m8Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Meneghini <jmeneghi@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1118/1518] nvme: expose active quirks in sysfs
Date: Sat, 12 Sep 2026 08:54:47 +0200
Message-ID: <20260912065648.742953631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit ddfb8b322bbd8ae996f4ac0192f0190feb0a01ce ]

Currently, there is no straightforward way for a user to inspect
which quirks are active for a given device from userspace.

Add a new "quirks" sysfs attribute to the nvme controller device.

Reading this file will display a human-readable list
of all active quirks, with each quirk name on a new line.
If no quirks are active, it will display "none".

Tested-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: ea2160c7b781 ("nvme-apple: Require page aligned buffers on the admin queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/nvme.h  | 54 +++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/sysfs.c | 23 +++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 7f7cb823d60d8..0b8b91506b1f4 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -180,6 +180,60 @@ enum nvme_quirks {
 	NVME_QUIRK_DMAPOOL_ALIGN_512		= (1 << 22),
 };
 
+static inline char *nvme_quirk_name(enum nvme_quirks q)
+{
+	switch (q) {
+	case NVME_QUIRK_STRIPE_SIZE:
+		return "stripe_size";
+	case NVME_QUIRK_IDENTIFY_CNS:
+		return "identify_cns";
+	case NVME_QUIRK_DEALLOCATE_ZEROES:
+		return "deallocate_zeroes";
+	case NVME_QUIRK_DELAY_BEFORE_CHK_RDY:
+		return "delay_before_chk_rdy";
+	case NVME_QUIRK_NO_APST:
+		return "no_apst";
+	case NVME_QUIRK_NO_DEEPEST_PS:
+		return "no_deepest_ps";
+	case NVME_QUIRK_QDEPTH_ONE:
+		return "qdepth_one";
+	case NVME_QUIRK_MEDIUM_PRIO_SQ:
+		return "medium_prio_sq";
+	case NVME_QUIRK_IGNORE_DEV_SUBNQN:
+		return "ignore_dev_subnqn";
+	case NVME_QUIRK_DISABLE_WRITE_ZEROES:
+		return "disable_write_zeroes";
+	case NVME_QUIRK_SIMPLE_SUSPEND:
+		return "simple_suspend";
+	case NVME_QUIRK_SINGLE_VECTOR:
+		return "single_vector";
+	case NVME_QUIRK_128_BYTES_SQES:
+		return "128_bytes_sqes";
+	case NVME_QUIRK_SHARED_TAGS:
+		return "shared_tags";
+	case NVME_QUIRK_NO_TEMP_THRESH_CHANGE:
+		return "no_temp_thresh_change";
+	case NVME_QUIRK_NO_NS_DESC_LIST:
+		return "no_ns_desc_list";
+	case NVME_QUIRK_DMA_ADDRESS_BITS_48:
+		return "dma_address_bits_48";
+	case NVME_QUIRK_SKIP_CID_GEN:
+		return "skip_cid_gen";
+	case NVME_QUIRK_BOGUS_NID:
+		return "bogus_nid";
+	case NVME_QUIRK_NO_SECONDARY_TEMP_THRESH:
+		return "no_secondary_temp_thresh";
+	case NVME_QUIRK_FORCE_NO_SIMPLE_SUSPEND:
+		return "force_no_simple_suspend";
+	case NVME_QUIRK_BROKEN_MSI:
+		return "broken_msi";
+	case NVME_QUIRK_DMAPOOL_ALIGN_512:
+		return "dmapool_align_512";
+	}
+
+	return "unknown";
+}
+
 /*
  * Common request structure for NVMe passthrough.  All drivers must have
  * this structure as the first member of their request-private data.
diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index 29430949ce2f0..16c6fea4b2db6 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -601,6 +601,28 @@ static ssize_t dctype_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(dctype);
 
+static ssize_t quirks_show(struct device *dev, struct device_attribute *attr,
+                char *buf)
+{
+	int count = 0, i;
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+	unsigned long quirks = ctrl->quirks;
+
+	if (!quirks)
+		return sysfs_emit(buf, "none\n");
+
+	for (i = 0; quirks; ++i) {
+		if (quirks & 1) {
+			count += sysfs_emit_at(buf, count, "%s\n",
+					nvme_quirk_name(BIT(i)));
+		}
+		quirks >>= 1;
+	}
+
+	return count;
+}
+static DEVICE_ATTR_RO(quirks);
+
 #ifdef CONFIG_NVME_HOST_AUTH
 static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
@@ -742,6 +764,7 @@ static struct attribute *nvme_dev_attrs[] = {
 	&dev_attr_kato.attr,
 	&dev_attr_cntrltype.attr,
 	&dev_attr_dctype.attr,
+	&dev_attr_quirks.attr,
 #ifdef CONFIG_NVME_HOST_AUTH
 	&dev_attr_dhchap_secret.attr,
 	&dev_attr_dhchap_ctrl_secret.attr,
-- 
2.53.0



