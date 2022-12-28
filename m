Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3A81875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13804C433EF;
	Wed, 28 Dec 2022 15:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242710;
	bh=9cMVz/7RUy1bBNQ+ZXNVi7CT5W2f04dwS8UO0J5cu94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWWKC+cjgsMYKF6weaRHaj/E2svdWmqSAbLTaMV9OnWmlMftvLGg5Fcg1zQOkJgZW
	 riyRGMoGd3pRvbhORnjNwz/cYCeqWcayi6kZOwAusJCViQHloBkyISlFVOZf8w3Pwq
	 dxW9mA5+OKkUCQ9RHGQNKim5WyNMHA1kEVJwyqe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	gehao <gehao@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 636/731] drm/amd/display: prevent memory leak
Date: Wed, 28 Dec 2022 15:42:23 +0100
Message-Id: <20221228144314.949376335@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: gehao <gehao@kylinos.cn>

[ Upstream commit d232afb1f3417ae8194ccf19ad3a8360e70e104e ]

In dce6(0,1,4)_create_resource_pool and dce80_create_resource_pool
the allocated memory should be released if construct pool fails.

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: gehao <gehao@kylinos.cn>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c | 3 +++
 drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
index dcfa0a3efa00..bf72d3f60d7f 100644
--- a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
@@ -1127,6 +1127,7 @@ struct resource_pool *dce60_create_resource_pool(
 	if (dce60_construct(num_virtual_links, dc, pool))
 		return &pool->base;
 
+	kfree(pool);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
@@ -1324,6 +1325,7 @@ struct resource_pool *dce61_create_resource_pool(
 	if (dce61_construct(num_virtual_links, dc, pool))
 		return &pool->base;
 
+	kfree(pool);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
@@ -1517,6 +1519,7 @@ struct resource_pool *dce64_create_resource_pool(
 	if (dce64_construct(num_virtual_links, dc, pool))
 		return &pool->base;
 
+	kfree(pool);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c b/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
index 725d92e40cd3..52d1f9746e8c 100644
--- a/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
@@ -1138,6 +1138,7 @@ struct resource_pool *dce80_create_resource_pool(
 	if (dce80_construct(num_virtual_links, dc, pool))
 		return &pool->base;
 
+	kfree(pool);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
@@ -1337,6 +1338,7 @@ struct resource_pool *dce81_create_resource_pool(
 	if (dce81_construct(num_virtual_links, dc, pool))
 		return &pool->base;
 
+	kfree(pool);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
-- 
2.35.1



