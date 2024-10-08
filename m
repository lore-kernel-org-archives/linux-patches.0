Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49D31CF7A2;
	Tue,  8 Oct 2024 12:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390255; cv=none; b=h5F7/Vo64QxnHZhkYQ5H4FxXMo1bU4JOECJX+Har0A+fh1eps4JFkVvKLbiUg8XV4E3oKJ8xum+/+7CtWjjKzH7kCHW1kIaLkAvFGqBenl4WiJgpu9s34TGVW3FGTTum+StYbzJFXPLAmVzQ2vShLryTg2fs4FutCRvBs1BNC+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390255; c=relaxed/simple;
	bh=7nBdqxRv33MHDMAS8LhNDpx3kOpdO2NK1NVAA0rinqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnzRJmXAlNVstojthCb74JpwACuk8qsLe+wX64WvXc7qgLrvlmcEJoy5Pi4rm2KAEwHuQMZx6qZkg6AnV8EdeoXkDMzTBP3QzMDhlVH/qu8qQfQor8m52tYo5tPAZNG9/QhhTsYAD/n8sgy3Z3qpGeP4tiQ7HZi/BiqF48B4OSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmLOq0W0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmLOq0W0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F62C4CEC7;
	Tue,  8 Oct 2024 12:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390255;
	bh=7nBdqxRv33MHDMAS8LhNDpx3kOpdO2NK1NVAA0rinqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmLOq0W0jp/ruDZZLUJNkCipZW+4vR5cd1Wc3d4FRA4/UPD2yRLPbtJF71dhc/QG7
	 0Z7H53a9cMqTDBtBZtBGga5prHSUJprt7Gd2Fed4s15A64QCa7Cr90bTlbdBYSyGZq
	 JpBAP6l9VT1rb+zlXd/VwWxqRVc0/pmN1Zey6JXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jagmeet Randhawa <jagmeet.randhawa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 237/482] drm/xe: Drop warn on xe_guc_pc_gucrc_disable in guc pc fini
Date: Tue,  8 Oct 2024 14:05:00 +0200
Message-ID: <20241008115657.624079187@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit a323782567812ee925e9b7926445532c7afe331b ]

Not a big deal if CT is down as driver is unloading, no need to warn.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Jagmeet Randhawa <jagmeet.randhawa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240820172958.1095143-4-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index 23382ced4ea74..69f8b6fdaeaea 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -897,7 +897,7 @@ static void xe_guc_pc_fini(struct drm_device *drm, void *arg)
 	struct xe_guc_pc *pc = arg;
 
 	XE_WARN_ON(xe_force_wake_get(gt_to_fw(pc_to_gt(pc)), XE_FORCEWAKE_ALL));
-	XE_WARN_ON(xe_guc_pc_gucrc_disable(pc));
+	xe_guc_pc_gucrc_disable(pc);
 	XE_WARN_ON(xe_guc_pc_stop(pc));
 	xe_force_wake_put(gt_to_fw(pc_to_gt(pc)), XE_FORCEWAKE_ALL);
 }
-- 
2.43.0



