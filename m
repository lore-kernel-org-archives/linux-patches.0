Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7287383C7C;
	Mon, 23 Mar 2026 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277983; cv=none; b=cBOapOIXZKwyh53U3PE+/vljCrDCYV6/14vmfRhSl704F2G1gIDmTZ/ipzORoX4NtY3HdKsAA0h+GPa8iha9sp3C33WFMHfslMMkoDThBDjoJB1bgo4dh3lk5fxkDjeRP6RgCuUJt+XsnWaFEQsFAkrcWddLaA8VNfQVJ+f87Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277983; c=relaxed/simple;
	bh=1GOrOAt2SbgnrNtv5c6MrpGGJgrbQsyK2PkWm/ODKq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Co4wFCQ18DMJcH2pYCIAunFRL6E1AeweS0+whjB5pQSx8L8VOfeQLRK4A8JNdrIIePF4/6UTpphfKG0w8jwLA3sd3LKKEsRWzCs6z3lWpcSbW88LrA5FWgi3yjXVaq3wTRKF/DxJ5xOj4CF2+IVQl3EMrXZ7mYe+RzCOi5nwwik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HNvkYmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HNvkYmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E68CC4CEF7;
	Mon, 23 Mar 2026 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277983;
	bh=1GOrOAt2SbgnrNtv5c6MrpGGJgrbQsyK2PkWm/ODKq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0HNvkYmPAqSgmxjtPOCzMafU/L9vQAK0oMojsLqpctA2/QKuaidIBFvCYD7CpUfjH
	 Tl6C47Osq5OR3mM1MXBU8eZ0sVxieuafOdYj/wBYl4Wj9eL/D6qePxj0UZ5q8YdqtH
	 pEfMoKHToM6tqLRYMc1gqvVBuGptOn+PI7II13Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yujie Liu <yujie.liu@intel.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/567] drm/sched: Fix kernel-doc warning for drm_sched_job_done()
Date: Mon, 23 Mar 2026 14:41:24 +0100
Message-ID: <20260323134537.877934104@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yujie Liu <yujie.liu@intel.com>

[ Upstream commit 61ded1083b264ff67ca8c2de822c66b6febaf9a8 ]

There is a kernel-doc warning for the scheduler:

Warning: drivers/gpu/drm/scheduler/sched_main.c:367 function parameter 'result' not described in 'drm_sched_job_done'

Fix the warning by describing the undocumented error code.

Fixes: 539f9ee4b52a ("drm/scheduler: properly forward fence errors")
Signed-off-by: Yujie Liu <yujie.liu@intel.com>
[phasta: Flesh out commit message]
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patch.msgid.link/20260227082452.1802922-1-yujie.liu@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 4faa2108c0a73..50716bc5eef63 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -259,6 +259,7 @@ drm_sched_rq_select_entity_fifo(struct drm_sched_rq *rq)
 /**
  * drm_sched_job_done - complete a job
  * @s_job: pointer to the job which is done
+ * @result: 0 on success, -ERRNO on error
  *
  * Finish the job's fence and wake up the worker thread.
  */
-- 
2.51.0



