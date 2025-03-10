Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FCA22B8D0;
	Mon, 10 Mar 2025 17:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626822; cv=none; b=lG7FCUWu3kIBlJavQnp2X8uX/5gwRbzhw7fdVfzBlqr2cT9P1CApBxrz88TNpBL6YGWS2ImvgT4I876AmFc7BLYvRRpDj5P4GXR/FChqJSpZKH2Zkne2rdMK02ly4GgeDrxmWwHgX6ko1sugnNoTDa4Vsqxa/YuDuF84p/iUUZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626822; c=relaxed/simple;
	bh=n/G8vfEsd0TaKXUJWmksRPPggpxZJKmsHa5izp4ISwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccwH36KrMZyNXBY9kJLvf5MYgd30wnp1GrefvbW8/BBFRIxZtXI5iLFrasxLfn4jFieohEpbbyearuLoaGbMJoEbhv5YaLRteERzhrHoLQDcaf6W8ein2VWSfJ93gx8eMfcaw2CLDN3qKfCeJPhanVSTikjA2q5kEmENUmDYDLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfD3jCQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfD3jCQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C712C4CEE5;
	Mon, 10 Mar 2025 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626821;
	bh=n/G8vfEsd0TaKXUJWmksRPPggpxZJKmsHa5izp4ISwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfD3jCQaaR7drai2BheZaWGGyFkiQxvuQb92F3SQtN/D4qIBZZkgMI/8sHVJ0P8a5
	 CQswa7aaTtyzNtoek6DxWKfo49MWmxp0Yf49WxYcxy6VO+Ss5wXUuAjTKkZAbtjRKy
	 h1wKUGlfszHy92DZN3TPRLyrYaBpkB0iQIITwvw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 124/207] drm/sched: Fix preprocessor guard
Date: Mon, 10 Mar 2025 18:05:17 +0100
Message-ID: <20250310170452.734080152@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



