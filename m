Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C222309B0;
	Mon, 10 Mar 2025 18:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630965; cv=none; b=MiONBjnGAYHotWTrgB9vFXvBrDyD3OFdul+rE3Nb/SiN50jhTmtuph8A9lGVFrLi4CNHeobDAGFnayihxy3qS0Ci5J3Kg5V6dKniwhEKvg6SBIXXGE2tOzv7tZqAb/rbBUL9kNiDexdG4wNsNi+1h9py1OblnH99eUiftRfrfxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630965; c=relaxed/simple;
	bh=rNbCDWF0KCo2OeAXqo2Wtwk1TgC3daphuXh0oCLeiG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVGvjRhmoJl8R47hVU+G5ZGBu+wRAs8R6uWvzrrGZ7GmtJDHm4oYyveGPwNKZ9RL5USG8Uw5SHPiaAmPoGbHUaf0vrS/iFVts/cdrdTCpuBz81N/q47bq7JYjyUQyFU032grvu9W8SG9fqCuWNr0eXD7Fv//z7K5L4+jp2T4U20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2W3XCCXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2W3XCCXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDA1C4CEE5;
	Mon, 10 Mar 2025 18:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630964;
	bh=rNbCDWF0KCo2OeAXqo2Wtwk1TgC3daphuXh0oCLeiG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2W3XCCXxlf3VFW3FhQRlstMrks0lIr9F7T52CClTJvvoBr8h9Wa6ABb55JDfWGmdu
	 ShdmpiMKod0wOkyNhy+/2AiZVOT4fRFwQ4i8+unbmi04Xp3K67+Bcw8wUDoo11Mw7V
	 eWsgsmXmtFt8jZkhD9C8W8qVN5rhIS5PanRgObSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 564/620] drm/sched: Fix preprocessor guard
Date: Mon, 10 Mar 2025 18:06:50 +0100
Message-ID: <20250310170607.806795835@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



