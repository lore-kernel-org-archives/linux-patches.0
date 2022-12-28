Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28801C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442D0C433EF;
	Wed, 28 Dec 2022 16:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244835;
	bh=2xR+FY0mU6dVHRrzKzpcEePeObLJ26zvawZlZvrFB5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhsmO/rttVHsImDavbK3GQdgzDULCLRxcDTp+MdNdCGRYsqIy5jP65PamWxDIEvdj
	 MxMmWuWja76ZR6b/YRSvIQBlOaqDdTqcmFyjmlriCphwBBQNogc7lUgMUUOxKRe0u2
	 lYcYwaikrI6+Y+h6IsI+7pW0uh+8YMPcUHpXwheE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirav N Shah <nirav.n.shah@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0782/1073] dmaengine: idxd: Fix crc_val field for completion record
Date: Wed, 28 Dec 2022 15:39:30 +0100
Message-Id: <20221228144349.249883089@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit dc901d98b1fe6e52ab81cd3e0879379168e06daa ]

The crc_val in the completion record should be 64 bits and not 32 bits.

Fixes: 4ac823e9cd85 ("dmaengine: idxd: fix delta_rec and crc size field for completion record")
Reported-by: Nirav N Shah <nirav.n.shah@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20221111012715.2031481-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/idxd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/idxd.h b/include/uapi/linux/idxd.h
index 2b9e7feba3f3..1d553bedbdb5 100644
--- a/include/uapi/linux/idxd.h
+++ b/include/uapi/linux/idxd.h
@@ -295,7 +295,7 @@ struct dsa_completion_record {
 		};
 
 		uint32_t	delta_rec_size;
-		uint32_t	crc_val;
+		uint64_t	crc_val;
 
 		/* DIF check & strip */
 		struct {
-- 
2.35.1



