Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D73BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C53EC433EF;
	Tue,  7 Mar 2023 19:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215901;
	bh=nzCVmduNO2XbnJv1Bkkz/5jXF/dbaHjI8XHwH3/qFIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoTrG7G5ZjInsdyCVHkAyuPui17dG/Zyk3PdgAj6pdsWND1YPV4/8Y7+9FaQaeVUC
	 4dz4AvMNH9Np6miOnjrCoIdg0VLLmzgpjCg6KbY6gNo6xPgbZb2vW6ya1q1JM9jn9k
	 R0oy7Cu8dc9BoLnaM8ORN/S9w1O4kh7YHkdfEiLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 411/567] drm: amd: display: Fix memory leakage
Date: Tue,  7 Mar 2023 18:02:27 +0100
Message-Id: <20230307165923.677973779@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[ Upstream commit 6b8701be1f66064ca72733c5f6e13748cdbf8397 ]

This commit fixes memory leakage in dc_construct_ctx() function.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 6c9378208127d..eca882438f6ef 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -771,6 +771,7 @@ static bool dc_construct_ctx(struct dc *dc,
 
 	dc_ctx->perf_trace = dc_perf_trace_create();
 	if (!dc_ctx->perf_trace) {
+		kfree(dc_ctx);
 		ASSERT_CRITICAL(false);
 		return false;
 	}
-- 
2.39.2



