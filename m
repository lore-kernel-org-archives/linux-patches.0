Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618767;
	b=ph0DCGXZQZffjH2GrE8cUZT19tqReUQHDJW1FSmdsyB1rfElc1Tt9JqVso3EznKEQoph
	 JpPC6ko46I90jBGSlqOr0RR8zOlnwujYZePRwWqtdSrnqYjqwbrpnp9WjhKiex05eFF2c
	 7wnQU4WpCDVqZ93WNS95bLZhP9crjwPYA5bj72lnUeE6VTqUxlrUBxvkxUQFOJZCXZEWa
	 SOnWrh4soToXowMZQqyA3wROFfhvWnaLe9zhbp8UGRpEZFN5gHh24HZB/MdIPrQFqMRJ4
	 cBwRIKFPS3CcnqjjUkFVQbmkDCQMRugkM0FV6kx27mxvumN4/RQq4rWetoa+SSGHtAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EwlIUoPmNCwTFThxNbAPrOqJLPpVuZGvZPuJZH3sn8k=;
	b=awiCe8lKRh+gyTC6sFobQFpDRG0jblrtDxHT5WwewhGVyqFxm2Uv8wCvgt5AmWsXb+lk
	 mhU/7aQNfWieSaRBNDxaEF8ABrq+MoZdSZ9q+CI5j1K05dVXguVlnxwCaUlRaMgWzwmfo
	 wN4tpk0w1vfkczBapte+vg49rhgJfT+q1M3udc6/YYEbgcl0v3h31i9cGKy8yFJV1Q8Ek
	 owdeylWvxs/ad6jS4YFh+LfHEfi4izu1hyY5e8yE004OVSsR0WfxxHRMwg0F2+jUbusgk
	 IdzHl1k23yiTAsvUTKbfKdVSQvWr41Mj0/CJlcaT6Ktc5rGUtMT25ufu3iGbHxkq0EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YPTIDxEi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C993606A330;
	Wed, 25 Nov 2026 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YPTIDxEi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCCB1F000CA;
	Wed, 25 Nov 2026 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618767;
	bh=EwlIUoPmNCwTFThxNbAPrOqJLPpVuZGvZPuJZH3sn8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPTIDxEiWFEer7icKZJ6AMmPsuy5zE2Iufc8RqwsGFN5U56qGOLpkplSZFIiW9CzW
	 fopTStyjyfKp/T3MXg60VPW8N0cmg7JdJGbPGadsWWOXo6Kr2b6iZbtRJeZYaOTbe/
	 JeSr5ZRwKMwNTcdAtY+ze+yjukf7KGzd+o2FwqLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0383/1005] drm/xe/gt: Disable GT reset worker before engine teardown
Date: Wed, 25 Nov 2026 15:28:41 +0100
Message-ID: <20261125143830.709935842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>

[ Upstream commit 31ac48502b2d2d953249c1cd1bf3d38667049a00 ]

During tear-down process, a reset queued from Guc timeout handler can
still access hwe after hwe is freed. Register a separate devm
action that disables and drains the reset worker, so it runs before
any engine is torn down.

Fixes: 09c452d1171f ("drm/xe/gt: Synchronize GT reset with device unbind")
Signed-off-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Piotr Piórkowski <piotr.piorkowski@intel.com>
Cc: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Assisted-by: LLM
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20261013152417.3189567-8-satyanarayana.k.v.p@intel.com
(cherry picked from commit 861590f69994e41c9ef1b65db8e9ba433f1d1c1c)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index dfdacc0f6de97..57e302604f3dc 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -621,8 +621,21 @@ static int gt_init_with_gt_forcewake(struct xe_gt *gt)
 	return 0;
 }
 
+static void gt_reset_worker_disable(void *arg)
+{
+	struct xe_gt *gt = arg;
+
+	if (disable_work_sync(&gt->reset.worker))
+		/*
+		 * If gt_reset_worker was halted from executing, take care of
+		 * releasing the rpm reference here.
+		 */
+		xe_pm_runtime_put(gt_to_xe(gt));
+}
+
 static int gt_init_with_all_forcewake(struct xe_gt *gt)
 {
+	struct xe_device *xe = gt_to_xe(gt);
 	int err;
 
 	CLASS(xe_force_wake, fw_ref)(gt_to_fw(gt), XE_FORCEWAKE_ALL);
@@ -689,6 +702,11 @@ static int gt_init_with_all_forcewake(struct xe_gt *gt)
 	if (IS_SRIOV_PF(gt_to_xe(gt)))
 		xe_gt_sriov_pf_init_hw(gt);
 
+	/* Last action registered here so devres drains resets before teardown */
+	err = devm_add_action_or_reset(xe->drm.dev, gt_reset_worker_disable, gt);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -697,12 +715,7 @@ static void xe_gt_fini(void *arg)
 	struct xe_gt *gt = arg;
 	int i;
 
-	if (disable_work_sync(&gt->reset.worker))
-		/*
-		 * If gt_reset_worker was halted from executing, take care of
-		 * releasing the rpm reference here.
-		 */
-		xe_pm_runtime_put(gt_to_xe(gt));
+	gt_reset_worker_disable(gt);
 
 	for (i = 0; i < XE_ENGINE_CLASS_MAX; ++i)
 		xe_hw_fence_irq_finish(&gt->fence_irq[i]);
@@ -745,8 +758,10 @@ int xe_gt_init(struct xe_gt *gt)
 	xe_force_wake_init_engines(gt, gt_to_fw(gt));
 
 	err = gt_init_with_all_forcewake(gt);
-	if (err)
+	if (err) {
+		gt_reset_worker_disable(gt);
 		return err;
+	}
 
 	xe_gt_record_user_engines(gt);
 
-- 
2.53.0



