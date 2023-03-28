Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F021E8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B1AC433D2;
	Tue, 28 Mar 2023 14:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014804;
	bh=O6YQ2xzdJGau1GLnmIdsmIuQ8igWYMJiHmAMOXHzwVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0yMbCaJYnzdwrO36Pg9rZzhKqAS2YKzza3jSZbkCdbjmb0dcMTVZFWuPMQJMXQb6
	 BhrKUT40swsyQpy1nxB8oQaYl6NOn7r9RfUwpOat7jea5hBhQt6jyrCLPtq8DHaTvm
	 Mbd5KAo5BHZcnrvYjoYZ0YeP6sQSre91OV3PeLEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 058/240] drm/i915: Fix format for perf_limit_reasons
Date: Tue, 28 Mar 2023 16:40:21 +0200
Message-Id: <20230328142622.129366648@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit f8d62aa8d24d9883df738e450bfe6be396e11979 ]

Use hex format so that it is easier to decode.

Fixes: fe5979665f64 ("drm/i915/debugfs: Add perf_limit_reasons in debugfs")
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230315022906.2467408-1-vinay.belgaumkar@intel.com
(cherry picked from commit 5e008ba67cb80084e99b40ccd46f9029ae421632)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c b/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c
index 83df4cd5e06cb..80dbbef86b1db 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c
@@ -580,7 +580,7 @@ static bool perf_limit_reasons_eval(void *data)
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(perf_limit_reasons_fops, perf_limit_reasons_get,
-			perf_limit_reasons_clear, "%llu\n");
+			perf_limit_reasons_clear, "0x%llx\n");
 
 void intel_gt_pm_debugfs_register(struct intel_gt *gt, struct dentry *root)
 {
-- 
2.39.2



