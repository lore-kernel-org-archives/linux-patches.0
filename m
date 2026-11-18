Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028694;
	b=q97AZLudxIaPLOUOj/BUwSzLttr6CWjcKQZeNYI8vcexaz3Oa0of9vVfwDvs+TPrIHLE
	 tCOVu3fp7kfI3R5YXGpwCaj1raOsZLoB6UD8hYDqhA4Y0XblA66ATeBt/qDeFYzkanN5Q
	 RG77GBeLAfGEagVQxX0Y2Flm8OtXnW+2KLZdfGwH/KotheuQRYyg1dpZfB2UV4IpeovRw
	 1EmjBoscNMd++xksP7/6sXz1shZuULN54M1DLX8H0rQzuOiDZamNoJKbDs2LBdDbTbCQY
	 2Z04jy02HKjt9Sdc69TN2a0nBzbJjB9QU8/WO66WRxZAvnD/Iplgf5WtzELS20vZR9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZPAEWXpPyRAPnN6PeFBKmKfEC2lG6i343rccRQ9j/p4=;
	b=QNec4OZx6M2tLkhXsrft6lL5GXTSHvlkhV5WkhKzRxKwbPHJfnIHZes7EH2EL79qchLh
	 QLOxjsKpSk9pvQdamCMlsg+eu8Sz9fIb6V1o+FbI6y6JjK2AvWRcbZHHtIm0J8OneI+iu
	 tFeemLa2bOiULucR+kMESlGpFK6TFdJ9rmbpLiZLTP9P8JWGKRD31ZiXV6xi3/NcXAQS4
	 XN3rAM1BH0aialE2IJncQPLtMVy1xeNsyfW/S8Z7IRLeFS8sNLG+4sJuPGShUHBLNM27P
	 XFzsIK2u9iJsI5vfF/H8NsSMgki313cSZUefYju6NH/I3vLzw+nwg44XNpoAbKLpEdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MATcreRB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CCE606A320;
	Wed, 18 Nov 2026 19:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MATcreRB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231D51F000C4;
	Wed, 18 Nov 2026 19:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028693;
	bh=ZPAEWXpPyRAPnN6PeFBKmKfEC2lG6i343rccRQ9j/p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MATcreRBYN30zp8vNdAjZGdCyMsuP6Um0wo0ZNjvKQLXaMaoUtbX1jo0ZV7xI+vyT
	 sFdqIkXx0XSUKw6ZNdOrWxJH8rozWz8irvNpVe0B4L/CtZPbczNFGmv93nJ+fwgRIp
	 ZSSIJDCZNP1ckEoTcWvE6MMBTdKa5GKAN0S8WOh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0086/1756] nvme: tuning pr code by using defined structs and macros
Date: Wed, 18 Nov 2026 15:36:53 +0100
Message-ID: <20261118150011.684651130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 029cc98dec2eadb5d0978b5fea9ae6c427f2a020 ]

All the modifications are simply to make the code more readable,
and this patch does not include any functional changes.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: a9d431124fb2 ("nvme: unregister when pr_register() is given a zero new key")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pr.c | 122 +++++++++++++++++++++++++----------------
 1 file changed, 75 insertions(+), 47 deletions(-)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index e1d07f824b13c..fe7dbe2648158 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -92,109 +92,137 @@ static int nvme_status_to_pr_err(int status)
 	}
 }
 
-static int nvme_send_pr_command(struct block_device *bdev,
-		struct nvme_command *c, void *data, unsigned int data_len)
+static int __nvme_send_pr_command(struct block_device *bdev, u32 cdw10,
+		u32 cdw11, u8 op, void *data, unsigned int data_len)
 {
-	if (nvme_disk_is_ns_head(bdev->bd_disk))
-		return nvme_send_ns_head_pr_command(bdev, c, data, data_len);
+	struct nvme_command c = { 0 };
 
-	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, c, data,
-				       data_len);
+	c.common.opcode = op;
+	c.common.cdw10 = cpu_to_le32(cdw10);
+	c.common.cdw11 = cpu_to_le32(cdw11);
+
+	if (nvme_disk_is_ns_head(bdev->bd_disk))
+		return nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
+	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
+				data, data_len);
 }
 
-static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
-				u64 key, u64 sa_key, u8 op)
+static int nvme_send_pr_command(struct block_device *bdev, u32 cdw10, u32 cdw11,
+		u8 op, void *data, unsigned int data_len)
 {
-	struct nvme_command c = { };
-	u8 data[16] = { 0, };
 	int ret;
 
-	put_unaligned_le64(key, &data[0]);
-	put_unaligned_le64(sa_key, &data[8]);
-
-	c.common.opcode = op;
-	c.common.cdw10 = cpu_to_le32(cdw10);
-
-	ret = nvme_send_pr_command(bdev, &c, data, sizeof(data));
-	if (ret < 0)
-		return ret;
-
-	return nvme_status_to_pr_err(ret);
+	ret = __nvme_send_pr_command(bdev, cdw10, cdw11, op, data, data_len);
+	return ret < 0 ? ret : nvme_status_to_pr_err(ret);
 }
 
-static int nvme_pr_register(struct block_device *bdev, u64 old,
-		u64 new, unsigned flags)
+static int nvme_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
+		unsigned int flags)
 {
+	struct nvmet_pr_register_data data = { 0 };
 	u32 cdw10;
 
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
 
-	cdw10 = old ? 2 : 0;
-	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
-	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
+	data.crkey = cpu_to_le64(old_key);
+	data.nrkey = cpu_to_le64(new_key);
+
+	cdw10 = old_key ? NVME_PR_REGISTER_ACT_REPLACE :
+		NVME_PR_REGISTER_ACT_REG;
+	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? NVME_PR_IGNORE_KEY : 0;
+	cdw10 |= NVME_PR_CPTPL_PERSIST;
+
+	return nvme_send_pr_command(bdev, cdw10, 0, nvme_cmd_resv_register,
+			&data, sizeof(data));
 }
 
 static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 		enum pr_type type, unsigned flags)
 {
+	struct nvmet_pr_acquire_data data = { 0 };
 	u32 cdw10;
 
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
 
-	cdw10 = nvme_pr_type_from_blk(type) << 8;
-	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
+	data.crkey = cpu_to_le64(key);
+
+	cdw10 = NVME_PR_ACQUIRE_ACT_ACQUIRE;
+	cdw10 |= nvme_pr_type_from_blk(type) << 8;
+	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? NVME_PR_IGNORE_KEY : 0;
+
+	return nvme_send_pr_command(bdev, cdw10, 0, nvme_cmd_resv_acquire,
+			&data, sizeof(data));
 }
 
 static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 		enum pr_type type, bool abort)
 {
-	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (abort ? 2 : 1);
+	struct nvmet_pr_acquire_data data = { 0 };
+	u32 cdw10;
+
+	data.crkey = cpu_to_le64(old);
+	data.prkey = cpu_to_le64(new);
 
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
+	cdw10 = abort ? NVME_PR_ACQUIRE_ACT_PREEMPT_AND_ABORT :
+			NVME_PR_ACQUIRE_ACT_PREEMPT;
+	cdw10 |= nvme_pr_type_from_blk(type) << 8;
+
+	return nvme_send_pr_command(bdev, cdw10, 0, nvme_cmd_resv_acquire,
+			&data, sizeof(data));
 }
 
 static int nvme_pr_clear(struct block_device *bdev, u64 key)
 {
-	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
+	struct nvmet_pr_release_data data = { 0 };
+	u32 cdw10;
+
+	data.crkey = cpu_to_le64(key);
 
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+	cdw10 = NVME_PR_RELEASE_ACT_CLEAR;
+	cdw10 |= key ? 0 : NVME_PR_IGNORE_KEY;
+
+	return nvme_send_pr_command(bdev, cdw10, 0, nvme_cmd_resv_release,
+			&data, sizeof(data));
 }
 
 static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (key ? 0 : 1 << 3);
+	struct nvmet_pr_release_data data = { 0 };
+	u32 cdw10;
+
+	data.crkey = cpu_to_le64(key);
 
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+	cdw10 = NVME_PR_RELEASE_ACT_RELEASE;
+	cdw10 |= nvme_pr_type_from_blk(type) << 8;
+	cdw10 |= key ? 0 : NVME_PR_IGNORE_KEY;
+
+	return nvme_send_pr_command(bdev, cdw10, 0, nvme_cmd_resv_release,
+			&data, sizeof(data));
 }
 
 static int nvme_pr_resv_report(struct block_device *bdev, void *data,
 		u32 data_len, bool *eds)
 {
-	struct nvme_command c = { };
+	u32 cdw10, cdw11;
 	int ret;
 
-	c.common.opcode = nvme_cmd_resv_report;
-	c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
-	c.common.cdw11 = cpu_to_le32(NVME_EXTENDED_DATA_STRUCT);
+	cdw10 = nvme_bytes_to_numd(data_len);
+	cdw11 = NVME_EXTENDED_DATA_STRUCT;
 	*eds = true;
 
 retry:
-	ret = nvme_send_pr_command(bdev, &c, data, data_len);
+	ret = __nvme_send_pr_command(bdev, cdw10, cdw11, nvme_cmd_resv_report,
+			data, data_len);
 	if (ret == NVME_SC_HOST_ID_INCONSIST &&
-	    c.common.cdw11 == cpu_to_le32(NVME_EXTENDED_DATA_STRUCT)) {
-		c.common.cdw11 = 0;
+	    cdw11 == NVME_EXTENDED_DATA_STRUCT) {
+		cdw11 = 0;
 		*eds = false;
 		goto retry;
 	}
 
-	if (ret < 0)
-		return ret;
-
-	return nvme_status_to_pr_err(ret);
+	return ret < 0 ? ret : nvme_status_to_pr_err(ret);
 }
 
 static int nvme_pr_read_keys(struct block_device *bdev,
-- 
2.53.0



