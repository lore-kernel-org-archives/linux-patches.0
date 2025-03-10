Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB905223702;
	Mon, 10 Mar 2025 17:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628537; cv=none; b=uLxlmvRdvu7LBg/wuRTTE6iGdfytL2vxReq2ibeaP7pcLa7PFhVbrbZPrxqCIIlm7mTpoyWPZNcfIQv8eSeGtx4Xo1CtkZ7OSLdAyMonyjnkkMoi7Ce+msAWd36gKNZOJ8PjgQv25fyH4+JFHxbTF9qj7G/dke48651Qa4/C6Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628537; c=relaxed/simple;
	bh=MgzduQdr9YtXFQpgidmUS7xK6wgxBiXVAGhV7bgthFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eh1/Y9aZJNeGtZj/w72lj69R1QI/B5gI5ES1XhdrTgHymPJj08pN9eH5IwG4yAzOO46HxbrEpBcA/v+xDPRAZbWTvh2ZgTtz8XKtbDRc2P160lctd3BVIsvlqQ/ySrigxMKdfFBHn4CDjFePOEu05IW8c9ts/mjYQO1EJ7Laej4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpFRWOQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpFRWOQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63689C4CEEC;
	Mon, 10 Mar 2025 17:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628537;
	bh=MgzduQdr9YtXFQpgidmUS7xK6wgxBiXVAGhV7bgthFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpFRWOQGt045FhfXWWfXpCZIb/XCZrEOXA0giq4ZHVevNHuXyDGX8Hx7qXoXSVqpG
	 O+LTQVMjPtFpKmTog1uyFYmbOLo1UgVpGvxifdSv9NTAlhulX9tLeaYdHHMGYd7YcU
	 MC18PAuAdm+C3pfIe3G9Id/X/fCYtU3V6ZbkBBRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/109] drm/sched: Fix preprocessor guard
Date: Mon, 10 Mar 2025 18:06:34 +0100
Message-ID: <20250310170429.556456996@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3143ecaaff862..f7f10e97ac055 100644
--- a/drivers/gpu/drm/scheduler/gpu_scheduler_trace.h
+++ b/drivers/gpu/drm/scheduler/gpu_scheduler_trace.h
@@ -21,7 +21,7 @@
  *
  */
 
-#if !defined(_GPU_SCHED_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#if !defined(_GPU_SCHED_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
 #define _GPU_SCHED_TRACE_H_
 
 #include <linux/stringify.h>
@@ -106,7 +106,7 @@ TRACE_EVENT(drm_sched_job_wait_dep,
 		      __entry->seqno)
 );
 
-#endif
+#endif /* _GPU_SCHED_TRACE_H_ */
 
 /* This part must be outside protection */
 #undef TRACE_INCLUDE_PATH
-- 
2.39.5



