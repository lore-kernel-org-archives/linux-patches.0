Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C8723236D;
	Mon, 10 Mar 2025 17:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627584; cv=none; b=W+19A+u+7qEP6ljd9vXAGRxUrSA9Xn26vIWwW22qP42MDPXM4jTg/uThGB2CSCgTFnxAmp496rniRqtaTHnDhrH3oF886i5rCkk7BCYJbiniC51psGPNMC4Yz45psBNyzxzZA23Ejxw8nFJF6kPPsbOj2qiEwPU73l4XS1r0/9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627584; c=relaxed/simple;
	bh=hBiyiIZ9KTb5nrNZBeNmLcrJasCKLBTOQrrbN9AixCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifM+Ln4q+a9rCokUTDecOgT3cne4i3JpBjajT+NwHkwcEOmkZmjQ+40c4pem0/7M83eExSNQ1NjdB7OXuV8HRvZjmN+8MTxEILr2D/sGTCA7tDm95nSGd0LfKWWvKmd++yjV7wwtXoipsi/5DRkJxL6rAQAKyj8itkzDOaDqrzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFgPKyvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFgPKyvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2677C4CEE5;
	Mon, 10 Mar 2025 17:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627584;
	bh=hBiyiIZ9KTb5nrNZBeNmLcrJasCKLBTOQrrbN9AixCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFgPKyvMxOeLH7yK8j6L3N0ejE0p+io+KdN2+sbMlWIsYYKZcjjrpe1EBYbmjnINf
	 M8+AQ1qoiXbcE1+1hNaxmKdE0fHzgo3D3CIURs1VQNBShdoz9eymR0EPVEn+TBe8nx
	 BPbX/6m1eIzETYgOarX/+/dQWDlbKa/dFfRdznf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/269] drm/sched: Fix preprocessor guard
Date: Mon, 10 Mar 2025 18:05:31 +0100
Message-ID: <20250310170504.805411917@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c75302ca3427c..f56e77e7f6d02 100644
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



