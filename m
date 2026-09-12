Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894363C0A15;
	Sat, 12 Sep 2026 10:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207676; cv=none; b=N7icxpAYqLm2B5R0moOrOe5oc7Ye1Zy1JEW4vI6rlv8Fzo7bGw6T6XqwKNZkr4ErfRVbZie+Vpfwe7XcgEWL4ylwDAWtsw8YjOLke1yRC78w/QLgWKVXsRB8PLZvtwwzxUzY38zxw6r4R4GFXBnrSXkkoviK2berlMJM3awkVvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207676; c=relaxed/simple;
	bh=92Diz5gkQS7m9QBLfnGgzLBVNctZsZYdrW0vmadk4s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LScW0XYbfueAmEbO4WkjzJokSsvDFBBhXW0IoIGm+G4n7n2hYRErMpV79yGck2qdCCxzwXgWZrkhABr00cXV999e7DEySQZmEcTA0F/HXDH5IHzwn0rve4gXbe4tDg4YqAOjBOlxKwG5QxEpCEq0tSBSpmV4JJjtN0I6tjw0Vho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6VE+hPf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6VE+hPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167DF1F000FF;
	Sat, 12 Sep 2026 10:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207675;
	bh=au9uXw8VfVTpGhj7ZCKEfAxM7TJ8qaSKcMn1EWh/PTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6VE+hPfsO4oiJAMrZLliXOO+ZN0806S3cX23FVWRu6RBChNupQwEY6brdCKZfxrF
	 tvRPqV5KeFmPaXZKXocC/cCdJrdvuWisGEv2EguyHNOX95Nui++KzGnjnrYmCNcwLh
	 QaPKUsaH7gEMealqGkGYQGYW9AsC0BqML63TP9tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0418/1518] clk: qcom: gcc-glymur: Enable runtime PM
Date: Sat, 12 Sep 2026 08:43:07 +0200
Message-ID: <20260912065632.908208534@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 8d4f342369d0d77f32a0211692442d3b6d455872 ]

Enable runtime PM for the controller so the common GCC probe path resumes
the attached domain while registering clocks, resets and GDSCs.

This lets GDSC consumers propagate their votes through the GCC provider to
the CX parent domain.

Fixes: efe504300a17 ("clk: qcom: gcc: Add support for Global Clock Controller")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260715-glymur-fix-gcc-cx-scaling-v3-2-72eb5adad156@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-glymur.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-glymur.c b/drivers/clk/qcom/gcc-glymur.c
index 9e84f3e7c6a9b..7adbe59915f0f 100644
--- a/drivers/clk/qcom/gcc-glymur.c
+++ b/drivers/clk/qcom/gcc-glymur.c
@@ -8551,6 +8551,7 @@ static const struct qcom_cc_desc gcc_glymur_desc = {
 	.num_resets = ARRAY_SIZE(gcc_glymur_resets),
 	.gdscs = gcc_glymur_gdscs,
 	.num_gdscs = ARRAY_SIZE(gcc_glymur_gdscs),
+	.use_rpm = true,
 	.driver_data = &gcc_glymur_driver_data,
 };
 
-- 
2.53.0



