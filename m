Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3D01E98EC;
	Tue, 11 Mar 2025 15:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707613; cv=none; b=eYR6li/AGBaF9HTNOKc7+1AM1N6vJ6J65XFhqaCf285rRMOKF3Ztfiw8SMCev2Dt7IKz0hvo9Sx7Gn8RAaji5azJw3mwCJz3T22gY/GN56In+b9fp+gwAxBwiEDSYdrf9eCaQhRwwtl+TmTKfG/qYOk2ugBmVTma5c/MTplnu0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707613; c=relaxed/simple;
	bh=ujAHltZyA3bEaTxVnzTD7fJjL3wXNJ+ro+ndR+2NiC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcQ+PJzybw8W9JoDgyQEmyljU01WwJbViLjssavpSyISPzPCkuNAdTAQmX/oJMC6Xkx9geOHbUXUYruYGqTNMDfRhIOf5+44uEQv9xLWTEXxKx09eBejAGhpf5Ks4yd/bvqvS3VBWWM85igCdZFdETkQulnBYv4KARpOa1vdffg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUHiWu0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUHiWu0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFB8C4CEE9;
	Tue, 11 Mar 2025 15:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707612;
	bh=ujAHltZyA3bEaTxVnzTD7fJjL3wXNJ+ro+ndR+2NiC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUHiWu0wisrUg8F9qLTscPHQm/eSRyCWSfZW+Zvwp8yRvQE2AEvEneeu4lrWIk0e8
	 fuw6UeDRPgC5nmJFuhXhw4rvye8yGTd+RTvpspAQb4eWmNe2YtOw2c10+UqkKIAL7Y
	 c0bPm1zI/ynFJQxMzRAlQy8djEWhorD9n0u3oeeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 417/462] drm/sched: Fix preprocessor guard
Date: Tue, 11 Mar 2025 16:01:23 +0100
Message-ID: <20250311145814.805241226@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

[ Upstream commit 23e0832d6d7be2d3c713f9390c060b6f1c48bf36 ]

When writing the header guard for gpu_scheduler_trace.h, a typo,
apparently, occurred.

Fix the typo and document the scope of the guard.

Fixes: 353da3c520b4 ("drm/amdgpu: add tracepoint for scheduler (v2)")
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250218124149.118002-2-phasta@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/gpu_scheduler_trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/scheduler/gpu_scheduler_trace.h b/drivers/gpu/drm/scheduler/gpu_scheduler_trace.h
index 877ce9b127f16..caa5268c51ef1 100644
--- a/drivers/gpu/drm/scheduler/gpu_scheduler_trace.h
+++ b/drivers/gpu/drm/scheduler/gpu_scheduler_trace.h
@@ -21,7 +21,7 @@
  *
  */
 
-#if !defined(_GPU_SCHED_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#if !defined(_GPU_SCHED_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
 #define _GPU_SCHED_TRACE_H_
 
 #include <linux/stringify.h>
@@ -123,7 +123,7 @@ TRACE_EVENT(drm_sched_job_wait_dep,
 		      __entry->seqno)
 );
 
-#endif
+#endif /* _GPU_SCHED_TRACE_H_ */
 
 /* This part must be outside protection */
 #undef TRACE_INCLUDE_PATH
-- 
2.39.5



