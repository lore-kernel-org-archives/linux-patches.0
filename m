Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683117E
	for <patches@lists.linux.dev>; Sat, 26 Mar 2022 23:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=9eoNsGPRKDQN5hEBg7GTRtq6aujXrI8GzeayPp1jk4Y=; b=tLwgQ5EXzg8YZU4qShcAUON0J9
	1yuz1RaHyKMGRge7whSW4f6rmnOQFm3WMN4WMzqcU/0/airpZ3kGt+uWtD6nJtb3Y2M67JY8Z1BO6
	X0SVj0aG7LJBmGmSVJgvPQ78Wtl+G/XJWPY78GXcjAELtsFD17JV7lDUovZv9T6zX3cRLtuGDw3j+
	L+PbKmztk4VEJKGxx8sb5dFhqbrlYS7cq68r2Pz74nUif1baCTIkWt9ImkLGnXmzl07y4cpYxuhUk
	VXFp7S7mxNbtfep0d/r3/W1Xqw6BHqHVFNAijnfcj3DYulGkeoK9221vHSch/ezxTt/hyKd4tbxcM
	h4QVIQVg==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nYFyL-0051yD-0L; Sat, 26 Mar 2022 23:37:29 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: dri-devel@lists.freedesktop.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	amd-gfx@lists.freedesktop.org,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Subject: [PATCH] drm/amd/display: DCN3.1: don't mark as kernel-doc
Date: Sat, 26 Mar 2022 16:37:26 -0700
Message-Id: <20220326233726.14712-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There is no need for this one static function to be marked as
kernel-doc notation.

Avoid this doc build warning:

warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Enable CRTC

Fixes: 110d3968fe95 ("drm/amd/display: Add DCN3.1 OPTC")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Cc: Christian König <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_optc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-next-20220325.orig/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_optc.c
+++ linux-next-20220325/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_optc.c
@@ -91,8 +91,7 @@ static void optc31_set_odm_combine(struc
 	optc1->opp_count = opp_cnt;
 }
 
-/**
- * Enable CRTC
+/*
  * Enable CRTC - call ASIC Control Object to enable Timing generator.
  */
 static bool optc31_enable_crtc(struct timing_generator *optc)
