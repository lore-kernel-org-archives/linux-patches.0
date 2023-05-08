Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD7E168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1E1C4339B;
	Mon,  8 May 2023 11:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543909;
	bh=FB5zIdNKUsbBvvRi0nukRLj+XGzkU2XSMGo4o80cqr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZRH6Jltrx9w79NepjlXYPPs+UGt7HeX9JuTujsUoPFD3tl5a3fMzHpm4UN7ztnfA
	 RKD4lxewehUzrRSUs7mOUm3cXrfrdFNVSaxK3KCsbKpNxdITyhDpPT8Z5/HepPdXic
	 gXRjH5P3hbfq2K74gVHf0wcmrjiAie9mWg1Y12P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 213/694] accel: Link to compute accelerator subsystem intro
Date: Mon,  8 May 2023 11:40:48 +0200
Message-Id: <20230508094439.278092401@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit 6d179f84f274a87da51f24ac3e9427221bbaed51 ]

Commit 2c204f3d53218d ("accel: add dedicated minor for accelerator
devices") adds link to accelerator nodes section of DRM internals doc
(Documentation/gpu/drm-internals.rst), but the target doesn't exist.
Instead, there is only an introduction doc for computer accelerator
subsytem.

Link to that doc until there is documentation of accelerator internals.

Fixes: 2c204f3d53218d ("accel: add dedicated minor for accelerator devices")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_file.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
index 0d1f853092ab8..ecffe24e2b1b0 100644
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -408,7 +408,8 @@ static inline bool drm_is_render_client(const struct drm_file *file_priv)
  * Returns true if this is an open file of the compute acceleration node, i.e.
  * &drm_file.minor of @file_priv is a accel minor.
  *
- * See also the :ref:`section on accel nodes <drm_accel_node>`.
+ * See also :doc:`Introduction to compute accelerators subsystem
+ * </accel/introduction>`.
  */
 static inline bool drm_is_accel_client(const struct drm_file *file_priv)
 {
-- 
2.39.2



