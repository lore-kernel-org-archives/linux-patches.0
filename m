Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFA179C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE583C433EF;
	Thu, 12 Jan 2023 14:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533243;
	bh=R1HoLHoN5tft/4CBna2p9xCaoQmUS0fNF46dQF84X+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZpplijvmGPlHBQNhs/t+UpsZHK8cjpMwAW+PaDrllIdKR4yI5hu8PA80VQgVmNhj
	 icFJl0bVRzvzXnForDlnk/W9jlsjcy321V+iDm9OarT8AHHCILf881rRoUFkqtKG0r
	 +Q83tb2gJ+A5fofhld/U19DXoH4dk00bXkPdrkzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirav N Shah <nirav.n.shah@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/783] dmaengine: idxd: Fix crc_val field for completion record
Date: Thu, 12 Jan 2023 14:52:12 +0100
Message-Id: <20230112135543.602718411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 9d9ecc0f4c38..f086c5579006 100644
--- a/include/uapi/linux/idxd.h
+++ b/include/uapi/linux/idxd.h
@@ -188,7 +188,7 @@ struct dsa_completion_record {
 		};
 
 		uint32_t	delta_rec_size;
-		uint32_t	crc_val;
+		uint64_t	crc_val;
 
 		/* DIF check & strip */
 		struct {
-- 
2.35.1



