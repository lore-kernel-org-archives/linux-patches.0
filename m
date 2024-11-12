Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5854719E992;
	Tue, 12 Nov 2024 10:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408487; cv=none; b=dKaXQP55s3Irovz/9s+XznLCA+0PNiiRXW737dfe1Hg/TfiZ2Kf3qDUEcYXg9Ao6NLRmUjviS3pxxGIt/3dXgLPW9xB3o2cv8DJVLSIHvYQu6WN0VKV9+Y1yjb7o1XEg1DTsxJcbVApw25NhZpzS3Aq3PrjFLc+jPp2C6RM1B5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408487; c=relaxed/simple;
	bh=zYeu6R/TH5JBTb53uUtEmeT8NmCNHzdG8gJp+NHEWPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcFNrPph8RL+ZEL8RT2lVET8psjxHHu3hOkguOgxbgyxJDTPyJZL3aSlJcCdJDxkhZ0bJ67PWWInzZ4dzhn0eawcPlJLP55uwZZGyKj9dm06lOXD1xyc8hu4Hd6a8R6h9MA3gbEu9fdpefNSjIZkvRwEVQKsXBBEqovkXq2e5CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNA5iS27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNA5iS27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C955FC4CECD;
	Tue, 12 Nov 2024 10:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408487;
	bh=zYeu6R/TH5JBTb53uUtEmeT8NmCNHzdG8gJp+NHEWPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNA5iS275TecwrFIsPad+6IUiUFVy9+01FdXT5kCgCfoolschJHIHxD8zUUdOryt9
	 EO0TUN6Ih2jD+sDu6qMcyQ9sSTRHXU9qV99EchtiCh11uw5slH26qmaPe6GsStSeul
	 6URdo6/c8Thf0lMQNr67N5T9Tr9X5bbTs7lYjlbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badal Nilawar <badal.nilawar@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 178/184] drm/xe: Move LNL scheduling WA to xe_device.h
Date: Tue, 12 Nov 2024 11:22:16 +0100
Message-ID: <20241112101907.692988332@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 55e8a3f37e54eb1c7b914d6d5565a37282ec1978 ]

Move LNL scheduling WA to xe_device.h so this can be used in other
places without needing keep the same comment about removal of this WA
in the future. The WA, which flushes work or workqueues, is now wrapped
in macros and can be reused wherever needed.

Cc: Badal Nilawar <badal.nilawar@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
cc: stable@vger.kernel.org # v6.11+
Suggested-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241029120117.449694-1-nirmoy.das@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit cbe006a6492c01a0058912ae15d473f4c149896c)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.h | 14 ++++++++++++++
 drivers/gpu/drm/xe/xe_guc_ct.c | 11 +----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.h b/drivers/gpu/drm/xe/xe_device.h
index 533ccfb2567a2..41d6ca3cce96a 100644
--- a/drivers/gpu/drm/xe/xe_device.h
+++ b/drivers/gpu/drm/xe/xe_device.h
@@ -174,4 +174,18 @@ void xe_device_declare_wedged(struct xe_device *xe);
 struct xe_file *xe_file_get(struct xe_file *xef);
 void xe_file_put(struct xe_file *xef);
 
+/*
+ * Occasionally it is seen that the G2H worker starts running after a delay of more than
+ * a second even after being queued and activated by the Linux workqueue subsystem. This
+ * leads to G2H timeout error. The root cause of issue lies with scheduling latency of
+ * Lunarlake Hybrid CPU. Issue disappears if we disable Lunarlake atom cores from BIOS
+ * and this is beyond xe kmd.
+ *
+ * TODO: Drop this change once workqueue scheduling delay issue is fixed on LNL Hybrid CPU.
+ */
+#define LNL_FLUSH_WORKQUEUE(wq__) \
+	flush_workqueue(wq__)
+#define LNL_FLUSH_WORK(wrk__) \
+	flush_work(wrk__)
+
 #endif
diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index ab24053f8766f..12e1fe6a8da28 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -888,17 +888,8 @@ static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 
 	ret = wait_event_timeout(ct->g2h_fence_wq, g2h_fence.done, HZ);
 
-	/*
-	 * Occasionally it is seen that the G2H worker starts running after a delay of more than
-	 * a second even after being queued and activated by the Linux workqueue subsystem. This
-	 * leads to G2H timeout error. The root cause of issue lies with scheduling latency of
-	 * Lunarlake Hybrid CPU. Issue dissappears if we disable Lunarlake atom cores from BIOS
-	 * and this is beyond xe kmd.
-	 *
-	 * TODO: Drop this change once workqueue scheduling delay issue is fixed on LNL Hybrid CPU.
-	 */
 	if (!ret) {
-		flush_work(&ct->g2h_worker);
+		LNL_FLUSH_WORK(&ct->g2h_worker);
 		if (g2h_fence.done) {
 			xe_gt_warn(gt, "G2H fence %u, action %04x, done\n",
 				   g2h_fence.seqno, action[0]);
-- 
2.43.0



