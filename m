Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602781170E
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C84AC433C9;
	Mon, 21 Aug 2023 19:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647434;
	bh=5YwqM484xbVfflbVO7WGXO5b54wXwEkIDazFCVNBtLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SC+3C6lxUEJFyz5jPEXUtjf52KKeq4Li7riiBnaQUIqE86oTotUNvUSC/GGfvDKfV
	 GgRHKeMBKqKUkzbz3xz6E4UOfSCML1noUbTJcWUEQ+8+CNdu9MxCn+4Fpr7doY52sc
	 rWx20oBoSCrDJifceT42NhXsdmKCQXgw9w3/KlJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	hackyzh002 <hackyzh002@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/194] drm/amdgpu: Fix integer overflow in amdgpu_cs_pass1
Date: Mon, 21 Aug 2023 21:39:52 +0200
Message-ID: <20230821194123.319782320@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: hackyzh002 <hackyzh002@gmail.com>

[ Upstream commit 87c2213e85bd81e4a9a4d0880c256568794ae388 ]

The type of size is unsigned int, if size is 0x40000000, there will
be an integer overflow, size will be zero after size *= sizeof(uint32_t),
will cause uninitialized memory to be referenced later.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: hackyzh002 <hackyzh002@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index fdb53d4394f30..6d3d01c5f0a28 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -185,7 +185,7 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 	uint64_t *chunk_array_user;
 	uint64_t *chunk_array;
 	uint32_t uf_offset = 0;
-	unsigned int size;
+	size_t size;
 	int ret;
 	int i;
 
-- 
2.40.1



