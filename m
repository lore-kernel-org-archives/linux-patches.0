Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357B627BF8D;
	Tue, 27 May 2025 17:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368241; cv=none; b=PudKVXrjSUjF9qBVPISWDFfmXQ2ze7siXcbS7LlEy5mJbhMviBSwwG8opxyq063mBpgw9sE0hU7mUIoTlziwkPo65lz1pP62+2FdwzOhiDjJEKk46AB1mUA/iVvJKvmPz0rxRdMksbmLgLGrb7z7omwi9UnFWWp1ZchtPlN4Qpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368241; c=relaxed/simple;
	bh=X8ORNSnA0L/jn64lRpTUrROxnzr2WMcfcaNnaFDiWq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7YcebiSk5nqh3wmwf3mgONLZw9FjfqsE2CHn08RpjMK3HJwAixTX4odmYQhnD8uLpSNvzia3Wo5Mpap2oX6iYHpEZ0jZRCuOkWiTa1VV4RtgidnlL3a774qx/DkuI8zW7XiaUaM7bNyfqdJuCr9XD7aofoYtbozKKJpfJcYlTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxPQuu1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxPQuu1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE37C4CEE9;
	Tue, 27 May 2025 17:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368241;
	bh=X8ORNSnA0L/jn64lRpTUrROxnzr2WMcfcaNnaFDiWq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxPQuu1BUZ65yhdTfDSJz9BpxKFLxF5mWJR8cn/Tjg8Ab2ZbLuqn69yovOR9Vn8YO
	 3FJJazjAkJ3g9xyX9Fw37sKEsOf1vtnwNyVg09z5rEXbANxD5r7Mc64XTEv3z0gV3x
	 anFIvGUNIrQCU4JRoeJbf7qDVm0CBjpeTYfNaU+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Wang <zhiw@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 613/783] drm/nouveau: fix the broken marco GSP_MSG_MAX_SIZE
Date: Tue, 27 May 2025 18:26:50 +0200
Message-ID: <20250527162538.110832213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Wang <zhiw@nvidia.com>

[ Upstream commit bbae6680cfe38b033250b483722e60ccd865976f ]

The macro GSP_MSG_MAX_SIZE refers to another macro that doesn't exist.
It represents the max GSP message element size.

Fix the broken marco so it can be used to replace some magic numbers in
the code.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250124182958.2040494-8-zhiw@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index 58502102926b6..bb86b6d4ca49e 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -61,7 +61,7 @@
 extern struct dentry *nouveau_debugfs_root;
 
 #define GSP_MSG_MIN_SIZE GSP_PAGE_SIZE
-#define GSP_MSG_MAX_SIZE GSP_PAGE_MIN_SIZE * 16
+#define GSP_MSG_MAX_SIZE (GSP_MSG_MIN_SIZE * 16)
 
 struct r535_gsp_msg {
 	u8 auth_tag_buffer[16];
-- 
2.39.5



