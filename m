Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18E2359A73
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302425; cv=none; b=IDlHkshZv6Vgfj5CNoq3ad7Cp7SO6RbOJ0zDetEQ2mbnt48wqD8uqtdZXcZ12dwH7nM2hWW3mgXePYG2HWCla3k3l8Bwi5wI7vqnO9eJNb+nFv8zFPjMK7L+bJl/dlESmQ4kDXirfHCMjHdYW6QgVBy5I0irXQfrW3Tl2R/Bjdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302425; c=relaxed/simple;
	bh=dcslQzVOek8mdv4HHDxcKOG8iAEYxslgDlUnrCv3dFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9Mv3N/mc9QQLZ5FAAmVbnfVPzkoYMini6QPjWyVk4fBUvJaCXg/yTqi0OfGXmFLsGk+R8GC9HxsEMsJeDjarmMAMqrw9u6Ki54h86vukMt5SGA5lY+yi26Bq+w46H5HM4BIwoo5T785nVp9EOdhfFqmDewAGkl9LLqL0KgqquE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qoCRwClL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qoCRwClL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1A4C19423;
	Sat, 28 Feb 2026 18:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302425;
	bh=dcslQzVOek8mdv4HHDxcKOG8iAEYxslgDlUnrCv3dFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoCRwClLr/ZTB915C9H3QtHDBbFfHhCOeXNeB2P8ArdoRY/48roQJRhOLaaKd2s81
	 K5YnokXymkaooe5bua/uE/BrJVAs1Z2YTM+G0zcoXvtr2sfC1os8/eFY961hH2V9JX
	 XJirYAlSK0JcgRpfV4/dlSNQV16VxiQt7px7d0YWbCL/bpVJfteDA7/vz/6+re+mPP
	 lhxuH0eSjOzyeU8wUh+xjw6hz9LWPTspXqcbYbsWWMkixkdyGLOKJ5hQmYdnfWGSPL
	 8acVZB7aVdj6c2SLQm6JAykOia5ClhTawl0hE5OEOxvxISMQVGzk3XofKak2oubHMw
	 3VfYRw9UKqsOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/232] scsi: smartpqi: Replace one-element arrays with flexible-array members
Date: Sat, 28 Feb 2026 13:10:15 -0500
Message-ID: <20260228181127.1592657-162-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit 6f0a92fd7db1507b203111ee53632eeeba2daca5 ]

One-element arrays are deprecated, and we are replacing them with flexible
array members instead. So, replace one-element arrays with flexible-array
members in a couple of structures, and refactor the rest of the code,
accordingly.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
on memcpy().

This results in no differences in binary output.

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/204
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/ZJNdKDkuRbFZpASS@work
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 41b37312bd97 ("scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi.h      | 4 ++--
 drivers/scsi/smartpqi/smartpqi_init.c | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 5b40e7ad5e02d..7a5c51cf58005 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -982,12 +982,12 @@ struct report_phys_lun_16byte_wwid {
 
 struct report_phys_lun_8byte_wwid_list {
 	struct report_lun_header header;
-	struct report_phys_lun_8byte_wwid lun_entries[1];
+	struct report_phys_lun_8byte_wwid lun_entries[];
 };
 
 struct report_phys_lun_16byte_wwid_list {
 	struct report_lun_header header;
-	struct report_phys_lun_16byte_wwid lun_entries[1];
+	struct report_phys_lun_16byte_wwid lun_entries[];
 };
 
 struct raid_map_disk_data {
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index a9f504959dd56..5c0f23dd808c4 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1194,7 +1194,6 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 	unsigned int i;
 	u8 rpl_response_format;
 	u32 num_physicals;
-	size_t rpl_16byte_wwid_list_length;
 	void *rpl_list;
 	struct report_lun_header *rpl_header;
 	struct report_phys_lun_8byte_wwid_list *rpl_8byte_wwid_list;
@@ -1223,9 +1222,9 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 
 	rpl_8byte_wwid_list = rpl_list;
 	num_physicals = get_unaligned_be32(&rpl_8byte_wwid_list->header.list_length) / sizeof(rpl_8byte_wwid_list->lun_entries[0]);
-	rpl_16byte_wwid_list_length = sizeof(struct report_lun_header) + (num_physicals * sizeof(struct report_phys_lun_16byte_wwid));
 
-	rpl_16byte_wwid_list = kmalloc(rpl_16byte_wwid_list_length, GFP_KERNEL);
+	rpl_16byte_wwid_list = kmalloc(struct_size(rpl_16byte_wwid_list, lun_entries,
+						   num_physicals), GFP_KERNEL);
 	if (!rpl_16byte_wwid_list)
 		return -ENOMEM;
 
-- 
2.51.0

