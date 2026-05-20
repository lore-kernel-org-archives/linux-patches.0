Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CF23AC00;
	Wed, 20 May 2026 16:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295641; cv=none; b=CI/MUMSd3g9a/BtLu2jRECNGAdsdvAo/MPVngDzikdDw7/erW6iUlAYo7nvCk9pRQF6YVDHahWfj3/AB1+35ckAuwOWB/1Y2/zAOatEN4zzgvmDN7pep+2hWAcbrWLY+phkHMIbb/NQwLaduxduRalh5pqFKYZlZOTfsrb83Jfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295641; c=relaxed/simple;
	bh=un1YBxDKrD7Qwz23GNWofqb5jBNRDJAkXAfcwtanE9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGI+bHCDVy2NmLMTBktj7c84KwERkT81sV4gRvK4cGTsdUDe/DUjwNnIjeJZEXD4WSJM6zMBPfa9ivxKu8f2kHk9RO29jAy+hKgmjq0WEza7/xPicfPMtVbYyHNYYDI0rxG0tI6z5RDrwCXT9+3AufGkUwoCYm/XwTTHNguWzA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BM2zPBtg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BM2zPBtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F021F000E9;
	Wed, 20 May 2026 16:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295639;
	bh=m5Uh8eeaZIzSK3ZUIF6uHhXq8etVu7gbPJILzm1uSpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BM2zPBtgVixenS+uEaQ2xGbkrdul/ti4NKy0r9V4xi13zn9H3LPuovD27rjAiRNtY
	 byfUF1FV9ueiGECkr99p7eG0sF4LVwzADK0DEO9nnZkjXxs7qSga/YOYgAPpR0JcJK
	 ucCF1SsdRwheSVVyzkZKGg0uW6/OG7659GzWJuG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0496/1146] firmware: qcom_scm: dont opencode kmemdup
Date: Wed, 20 May 2026 18:12:26 +0200
Message-ID: <20260520162159.417282368@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit e32701726c0e6312aabd83aa1c00f59b0d7df276 ]

Lets not opencode kmemdup which is reported by coccinelle tool.
Fix it using kmemdup.

cocci warnings: (new ones prefixed by >>)
>> drivers/firmware/qcom/qcom_scm.c:916:11-18: WARNING opportunity for kmemdup

Fixes: 8b9d2050cfa0 ("firmware: qcom_scm: Add qcom_scm_pas_get_rsc_table() to get resource table")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601142144.HvSlBSI9-lkp@intel.com/
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260310140255.2520230-1-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 8fbc96693a55f..d439a9f5b62b8 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -923,14 +923,13 @@ struct resource_table *qcom_scm_pas_get_rsc_table(struct qcom_scm_pas_context *c
 		goto free_input_rt;
 	}
 
-	tbl_ptr = kzalloc(size, GFP_KERNEL);
+	tbl_ptr = kmemdup(output_rt_tzm, size, GFP_KERNEL);
 	if (!tbl_ptr) {
 		qcom_tzmem_free(output_rt_tzm);
 		ret = -ENOMEM;
 		goto free_input_rt;
 	}
 
-	memcpy(tbl_ptr, output_rt_tzm, size);
 	*output_rt_size = size;
 	qcom_tzmem_free(output_rt_tzm);
 
-- 
2.53.0



