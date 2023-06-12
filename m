Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCD8AD3C
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FE3C433EF;
	Mon, 12 Jun 2023 10:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566210;
	bh=AOC2DmyQtfbXyATOqInCF0MgQDI4Vzw+suWwLoSnuQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1ISqf490X2wVCq1KOr7qZcmAUZEzXmv1YqiipaDZ85RVDk6TCMKUE0bYSsOh86zM
	 8hsCguAU7Js4D44fin4sz+lEl091/cZEmBTgbJkaQs+iRa41twW/30XDGPTkzlGoQW
	 KTj3g3wuvlu5m/xZBTjXzLA7YCPbS7efr/kFki0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/91] drm/i915/selftests: Increase timeout for live_parallel_switch
Date: Mon, 12 Jun 2023 12:26:25 +0200
Message-ID: <20230612101703.594664431@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

[ Upstream commit 373269ae6f90bbbe945abde4c0811a991a27901a ]

With GuC submission, it takes a little bit longer switching contexts
among all available engines simultaneously, when running
live_parallel_switch subtest. Increase the timeout.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5885
Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220622141104.334432-1-matthew.auld@intel.com
Stable-dep-of: 79d0150d2d98 ("drm/i915/selftests: Add some missing error propagation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
index 8eb5050f8cb3e..a1cdb852ecc82 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
@@ -215,7 +215,7 @@ static int __live_parallel_switch1(void *data)
 
 			i915_request_add(rq);
 		}
-		if (i915_request_wait(rq, 0, HZ / 5) < 0)
+		if (i915_request_wait(rq, 0, HZ) < 0)
 			err = -ETIME;
 		i915_request_put(rq);
 		if (err)
-- 
2.39.2



