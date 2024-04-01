Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522D3481C6;
	Mon,  1 Apr 2024 16:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989843; cv=none; b=KCOOBjiVayU7Un+dON/RGX8uokRgfoi1XgifwPStuhuqfSfd//HxUvPY7W6gVdmsWoT3JlYcSQLZjNBQ1NLtehzJu03W9HjN6izjW70vQ8GizbH+AiV5aW7XVLaEcmw/g8rUTmeV1Lx4G6sJ4ArDI6vGjCoiZ0jKwS7Yz3ufNkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989843; c=relaxed/simple;
	bh=tyGKDCDdznT/866i74nQa3vkNzldf0WCOcw8T10M5rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXT3gN5kQMkRmUAei8vLeGKg+8n3hxDhOKThS5gnXXuIZRhlkHgh7N7/ukqj8RcGYhw8xzm6O8D1iWtuIvfD2fcMcO0hSJcXcz+rAzR62aWGMOKlDEYcf1aDV6koHOg1/X3qFgfvPU47Ji5QqkqRvWWsAVOfaDZWtRX+n16tRss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxIaDsm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxIaDsm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EB8C433C7;
	Mon,  1 Apr 2024 16:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989843;
	bh=tyGKDCDdznT/866i74nQa3vkNzldf0WCOcw8T10M5rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxIaDsm/Kog0+ogub4lqvXB3nsbTqF81WL7l5tQTgEwL209yECauWP+6ZubcTIn0a
	 32WR8y/XC/pKCb9vch6j+ffJrjsXbz4AVVM4r/d1TTqYgWjMVW4JZVaQQ7jX/J7YBy
	 49dNq6WVnV5QAzhICDeF59iwA0a8L3Q5t7zeNCDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel@ffwll.ch>,
	David Airlie <airlied@gmail.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/396] drm/i915: Add missing ; to __assign_str() macros in tracepoint code
Date: Mon,  1 Apr 2024 17:43:38 +0200
Message-ID: <20240401152552.979585070@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 0df4c388a1e310400a6e90fb10b286e2673756f0 ]

I'm working on improving the __assign_str() and __string() macros to be
more efficient, and removed some unneeded semicolons. This triggered a bug
in the build as some of the __assign_str() macros in intel_display_trace
was missing a terminating semicolon.

Link: https://lore.kernel.org/linux-trace-kernel/20240222133057.2af72a19@gandalf.local.home

Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 2ceea5d88048b ("drm/i915: Print plane name in fbc tracepoints")
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display_trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_trace.h b/drivers/gpu/drm/i915/display/intel_display_trace.h
index 99bdb833591ce..7862e7cefe027 100644
--- a/drivers/gpu/drm/i915/display/intel_display_trace.h
+++ b/drivers/gpu/drm/i915/display/intel_display_trace.h
@@ -411,7 +411,7 @@ TRACE_EVENT(intel_fbc_activate,
 			   struct intel_crtc *crtc = intel_crtc_for_pipe(to_i915(plane->base.dev),
 									 plane->pipe);
 			   __assign_str(dev, __dev_name_kms(plane));
-			   __assign_str(name, plane->base.name)
+			   __assign_str(name, plane->base.name);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -438,7 +438,7 @@ TRACE_EVENT(intel_fbc_deactivate,
 			   struct intel_crtc *crtc = intel_crtc_for_pipe(to_i915(plane->base.dev),
 									 plane->pipe);
 			   __assign_str(dev, __dev_name_kms(plane));
-			   __assign_str(name, plane->base.name)
+			   __assign_str(name, plane->base.name);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -465,7 +465,7 @@ TRACE_EVENT(intel_fbc_nuke,
 			   struct intel_crtc *crtc = intel_crtc_for_pipe(to_i915(plane->base.dev),
 									 plane->pipe);
 			   __assign_str(dev, __dev_name_kms(plane));
-			   __assign_str(name, plane->base.name)
+			   __assign_str(name, plane->base.name);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
-- 
2.43.0



