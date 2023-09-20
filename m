Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CFB3B2A9
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D43C433CA;
	Wed, 20 Sep 2023 12:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213129;
	bh=sZl42vvCCq5WZvRzfvdqfMANFDBRM9EiDAiuSMLxRpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ad8H0C7ftr9XNq4GbfRwbcxm13XS3e/4L5vDKnwhRA2yvI3OOsD23Q3M6KY4XG2JK
	 6n977j+eVqWQaE3X0lQfH//ztWBLFCFhdrosqL8BCGmLROF+OCbOoh+XcOR7m/pk+8
	 afhyDYrhBL4+WKHzsUt4AK9bUAqKkQac3GIATTxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 171/367] dma-buf/sync_file: Fix docs syntax
Date: Wed, 20 Sep 2023 13:29:08 +0200
Message-ID: <20230920112903.070732954@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 05d56d8079d510a2994039470f65bea85f0075ee ]

Fixes the warning:

  include/uapi/linux/sync_file.h:77: warning: Function parameter or member 'num_fences' not described in 'sync_file_info'

Fixes: 2d75c88fefb2 ("staging/android: refactor SYNC IOCTLs")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20230724145000.125880-1-robdclark@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/sync_file.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/sync_file.h b/include/uapi/linux/sync_file.h
index ee2dcfb3d6602..d7f7c04a6e0c1 100644
--- a/include/uapi/linux/sync_file.h
+++ b/include/uapi/linux/sync_file.h
@@ -52,7 +52,7 @@ struct sync_fence_info {
  * @name:	name of fence
  * @status:	status of fence. 1: signaled 0:active <0:error
  * @flags:	sync_file_info flags
- * @num_fences	number of fences in the sync_file
+ * @num_fences:	number of fences in the sync_file
  * @pad:	padding for 64-bit alignment, should always be zero
  * @sync_fence_info: pointer to array of structs sync_fence_info with all
  *		 fences in the sync_file
-- 
2.40.1



