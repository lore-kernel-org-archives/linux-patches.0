Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBCF383BA;
	Mon,  1 Apr 2024 15:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987133; cv=none; b=NTgXK3KjSEDraiyncg5w5s7nG+RuLf9PZUKBSI/DN5Cht82XSU6TzwEY/7MX1sD0o7u5F2JrEvNmMRvrI9wTUxzvKDcPKT4kscchMYOiYNZwcnqBfk1rosUNzHMqLRJL7eOK3Ol+o+eOJQO8rN7v/RWoqYLRPTUFZfk5sKsVCVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987133; c=relaxed/simple;
	bh=PtEVayP0ptO0Qj+8RmmKQrnzmJWc+T4gnwAvD67nplE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h6g3FZJJehbaLeWjKFAkCrgsqH0nsGPrbi+nP5dy7LXOVzsIMgd+ztE0/HDe0CO7K6QPwZZd2Tzi0O9ZNLMcarsPwDBZoOh1LKbpHmr2DGJx9du150jNy3PAhB+6lSI3ErBUKjVeaeCVriVaBfX9ai637nMLCtzd4hfCl7gJ7r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxvftmbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxvftmbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03807C433F1;
	Mon,  1 Apr 2024 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987133;
	bh=PtEVayP0ptO0Qj+8RmmKQrnzmJWc+T4gnwAvD67nplE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxvftmbOcLSpPtooGegkyp7NH+SwXln0FCMk6zJiSWbNQZjiz9tQYmsNUPpmXGFwi
	 HouhdueUQy2cSkqLaxYGTx10vTYtBe70p1w6C7Tmu66WqkwzczMXahcoqQY7suYJ1k
	 jhmm4j/ohJMohUOl2rMDZhUG9/ki/8u/LYbfBSNs=
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
Subject: [PATCH 6.8 193/399] drm/i915: Add missing ; to __assign_str() macros in tracepoint code
Date: Mon,  1 Apr 2024 17:42:39 +0200
Message-ID: <20240401152554.943058086@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



